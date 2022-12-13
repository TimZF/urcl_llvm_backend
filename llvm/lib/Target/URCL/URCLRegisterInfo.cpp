//===-- URCLRegisterInfo.cpp - URCL Register Information ----------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the URCL implementation of the TargetRegisterInfo class.
//
//===----------------------------------------------------------------------===//

#include "URCLRegisterInfo.h"
#include "URCLSubtarget.h"
#include "llvm/Support/Debug.h"

#define GET_REGINFO_TARGET_DESC
#include "URCLGenRegisterInfo.inc"

#define DEBUG_TYPE "urcl-reginfo"

using namespace llvm;




static void replaceFI(MachineFunction &MF, MachineBasicBlock::iterator II,
                      MachineInstr &MI, const DebugLoc &dl,
                      unsigned FIOperandNum, int Offset, unsigned FramePtr) {


  MI.getOperand(FIOperandNum).ChangeToRegister(FramePtr, false);
  MI.getOperand(FIOperandNum + 1).ChangeToImmediate(Offset);
  return;
}



URCLRegisterInfo::URCLRegisterInfo()
  : URCLGenRegisterInfo(URCL::R1, /*DwarfFlavour*/0, /*EHFlavor*/0,
                         /*PC*/0) {}

const MCPhysReg *
URCLRegisterInfo::getCalleeSavedRegs(const MachineFunction *MF) const {
  return URCL_CalleeSavedRegs_SaveList;
}

const TargetRegisterClass *URCLRegisterInfo::intRegClass(unsigned Size) const {
  return &URCL::GPRRegClass;
}

const uint32_t*
URCLRegisterInfo::getRTCallPreservedMask(CallingConv::ID CC) const {
  return URCL_CalleeSavedRegs_RegMask;
}


const uint32_t *
URCLRegisterInfo::getCallPreservedMask(const MachineFunction &MF,
                                        CallingConv::ID) const {
  return URCL_CalleeSavedRegs_RegMask;
}

BitVector URCLRegisterInfo::getReservedRegs(const MachineFunction &MF) const {
  BitVector Reserved(getNumRegs());

  Reserved.set(URCL::R0); // zero
  Reserved.set(URCL::R1); // sp
  Reserved.set(URCL::R2); //// gp
  Reserved.set(URCL::R3); //// tp

  return Reserved;
}

bool URCLRegisterInfo::eliminateFrameIndex(MachineBasicBlock::iterator II,
                                           int SPAdj,
                                           unsigned FIOperandNum,
                                           RegScavenger *RS) const {
  assert(SPAdj == 0 && "Unexpected");

  MachineInstr &MI = *II;
  DebugLoc dl = MI.getDebugLoc();
  int FrameIndex = MI.getOperand(FIOperandNum).getIndex();
  MachineFunction &MF = *MI.getParent()->getParent();
  //const URCLSubtarget &Subtarget = MF.getSubtarget<URCLSubtarget>();
  const URCLFrameLowering *TFI = getFrameLowering(MF);

  Register FrameReg;
  int Offset;
  Offset = TFI->getFrameIndexReference(MF, FrameIndex, FrameReg).getFixed();

  Offset += MI.getOperand(FIOperandNum + 1).getImm();


  replaceFI(MF, II, MI, dl, FIOperandNum, Offset, FrameReg);
  // replaceFI never removes II
  return false;
}

bool
URCLRegisterInfo::requiresRegisterScavenging(const MachineFunction &MF) const {
  return true;
}

bool
URCLRegisterInfo::requiresFrameIndexScavenging(
                                            const MachineFunction &MF) const {
  return true;
}

bool
URCLRegisterInfo::requiresFrameIndexReplacementScavenging(
                                            const MachineFunction &MF) const {
  return true;
}

bool
URCLRegisterInfo::trackLivenessAfterRegAlloc(const MachineFunction &MF) const {
  return true;
}

Register URCLRegisterInfo::getFrameRegister(const MachineFunction &MF) const {
  return URCL::R1;
}


bool URCLRegisterInfo::useFPForScavengingIndex(const MachineFunction &MF) const {
  return true;
}



