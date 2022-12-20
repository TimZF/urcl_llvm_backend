//===-- URCLFrameLowering.cpp - URCL Frame Information ------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the URCLTargetFrameLowering class.
//
//===----------------------------------------------------------------------===//

#include "URCLFrameLowering.h"
#include "URCLSubtarget.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "URCLMachineFunctionInfo.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/RegisterScavenging.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/MathExtras.h"

using namespace llvm;

// hasFP - Return true if the specified function should have a dedicated frame
// pointer register.  This is true if the function has variable sized allocas,
// if it needs dynamic stack realignment, if frame pointer elimination is
// disabled, or if the frame address is taken.
bool URCLFrameLowering::hasFP(const MachineFunction &MF) const {
  return false;
}

MachineBasicBlock::iterator URCLFrameLowering::eliminateCallFramePseudoInstr(
                                        MachineFunction &MF,
                                        MachineBasicBlock &MBB,
                                        MachineBasicBlock::iterator I) const {
  return MBB.erase(I);
}


uint64_t URCLFrameLowering::computeStackSize(MachineFunction &MF) const {
  MachineFrameInfo* MFI = &MF.getFrameInfo();
  uint64_t StackSize = MFI->getStackSize();
  unsigned StackAlign = getStackAlignment();
  if (StackAlign > 0) {
    StackSize = alignTo(StackSize, StackAlign);
  }
  return StackSize;
}

void URCLFrameLowering::emitPrologue(MachineFunction &MF,
                                     MachineBasicBlock &MBB) const {
  const TargetInstrInfo &TII = *MF.getSubtarget().getInstrInfo();
  MachineBasicBlock::iterator MBBI = MBB.begin();
  DebugLoc dl = MBBI != MBB.end() ? MBBI->getDebugLoc() : DebugLoc();
  uint64_t StackSize = computeStackSize(MF);
  if (!StackSize) {
    return;
  }

  // Adjust the stack pointer.
  unsigned StackReg = URCL::R1;
  BuildMI(MBB, MBBI, dl, TII.get(URCL::SUBRI), StackReg)
      .addReg(StackReg)
      .addImm(StackSize)
      .setMIFlag(MachineInstr::FrameSetup);
}

void URCLFrameLowering::emitEpilogue(MachineFunction &MF,
                                     MachineBasicBlock &MBB) const {
  // Compute the stack size, to determine if we need an epilogue at all.
  const TargetInstrInfo &TII = *MF.getSubtarget().getInstrInfo();
  MachineBasicBlock::iterator MBBI = MBB.getLastNonDebugInstr();
  DebugLoc dl = MBBI->getDebugLoc();
  uint64_t StackSize = computeStackSize(MF);
  if (!StackSize) {
    return;
  }

  // Restore the stack pointer to what it was at the beginning of the function.
  unsigned StackReg = URCL::R1;
  BuildMI(MBB, MBBI, dl, TII.get(URCL::ADDRI), StackReg)
      .addReg(StackReg)
      .addImm(StackSize)
      .setMIFlag(MachineInstr::FrameSetup);
}

bool
URCLFrameLowering::hasReservedCallFrame(const MachineFunction &MF) const {
  return true;
}

// This method is called immediately before PrologEpilogInserter scans the
// physical registers used to determine what callee saved registers should be
// spilled. This method is optional.
void URCLFrameLowering::determineCalleeSaves(MachineFunction &MF,
                                              BitVector &SavedRegs,
                                              RegScavenger *RS) const {
  TargetFrameLowering::determineCalleeSaves(MF, SavedRegs, RS);
}



StackOffset
URCLFrameLowering::getFrameIndexReference(const MachineFunction &MF, int FI,
                                           Register &FrameReg) const {
  const URCLSubtarget &Subtarget = MF.getSubtarget<URCLSubtarget>();
  const MachineFrameInfo &MFI = MF.getFrameInfo();
  const URCLRegisterInfo *RegInfo = Subtarget.getRegisterInfo();
  const URCLMachineFunctionInfo *FuncInfo = MF.getInfo<URCLMachineFunctionInfo>();
  bool isFixed = MFI.isFixedObjectIndex(FI);

  // Addressable stack objects are accessed using neg. offsets from
  // %fp, or positive offsets from %sp.
  bool UseFP;

  // URCL uses FP-based references in general, even when "hasFP" is
  // false. That function is rather a misnomer, because %fp is
  // actually always available, unless isLeafProc.
  if (FuncInfo->isLeafProc()) {
    // If there's a leaf proc, all offsets need to be %sp-based,
    // because we haven't caused %fp to actually point to our frame.
    UseFP = false;
  } else if (isFixed) {
    // Otherwise, argument access should always use %fp.
    UseFP = true;
  } else if (RegInfo->hasStackRealignment(MF)) {
    // If there is dynamic stack realignment, all local object
    // references need to be via %sp, to take account of the
    // re-alignment.
    UseFP = false;
  } else {
    // Finally, default to using %fp.
    UseFP = true;
  }

  int64_t FrameOffset = MF.getFrameInfo().getObjectOffset(FI);

  if (UseFP) {
    FrameReg = RegInfo->getFrameRegister(MF);
    return StackOffset::getFixed(FrameOffset);
  } else {
    FrameReg = URCL::R1; // %sp
    return StackOffset::getFixed(FrameOffset + MF.getFrameInfo().getStackSize());
  }
}