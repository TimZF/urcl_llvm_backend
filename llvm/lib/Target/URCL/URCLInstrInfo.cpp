//===-- URCLInstrInfo.cpp - URCL Instruction Information ----------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the URCL implementation of the TargetInstrInfo class.
//
//===----------------------------------------------------------------------===//

#include "URCLInstrInfo.h"

#include "URCLTargetMachine.h"
#include "URCLMachineFunction.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/Debug.h"
#include "llvm/MC/TargetRegistry.h"

using namespace llvm;

#define DEBUG_TYPE "URCL-instrinfo"

#define GET_INSTRINFO_CTOR_DTOR
#include "URCLGenInstrInfo.inc"

URCLInstrInfo::URCLInstrInfo(const URCLSubtarget &STI)
    : URCLGenInstrInfo(URCL::ADJCALLSTACKDOWN, URCL::ADJCALLSTACKUP),
      RI(),
      Subtarget(STI)
{
}



void URCLInstrInfo::copyPhysReg(MachineBasicBlock &MBB,
                                 MachineBasicBlock::iterator I,
                                 const DebugLoc &DL, MCRegister DestReg,
                                 MCRegister SrcReg, bool KillSrc) const {

  if (URCL::GPRRegClass.contains(DestReg, SrcReg)){
    //BuildMI(MBB, I, DL, get(URCL::ORrr), DestReg).addReg(SrcReg, getKillRegState(KillSrc)).addImm(0);
    //BuildMI(MBB, I, DL, get(URCL::ORrr), DestReg).addReg(SrcReg, getKillRegState(KillSrc)).addReg(URCL::R0);
    BuildMI(MBB, I, DL, get(URCL::MOVrr), DestReg).addReg(SrcReg, getKillRegState(KillSrc));
  } else{
    llvm_unreachable("Impossible reg-to-reg copy");
  }

}

void URCLInstrInfo::storeRegToStackSlot(MachineBasicBlock &MBB,
                                 MachineBasicBlock::iterator I,
                                 Register SrcReg, bool isKill, int FI,
                                 const TargetRegisterClass *RC,
                                 const TargetRegisterInfo *TRI) const{
  DebugLoc DL;
  if (I != MBB.end()) DL = I->getDebugLoc();

  MachineFunction *MF = MBB.getParent();
  const MachineFrameInfo &MFI = MF->getFrameInfo();
  MachineMemOperand *MMO = MF->getMachineMemOperand(
      MachinePointerInfo::getFixedStack(*MF, FI), MachineMemOperand::MOStore,
      MFI.getObjectSize(FI), MFI.getObjectAlign(FI));

  if (RC == &URCL::GPRRegClass){
    //BuildMI(MBB, I, DL, get(URCL::StoreRI)).addFrameIndex(FI).addImm(0)
    //  .addReg(SrcReg, getKillRegState(isKill)).addMemOperand(MMO);
    BuildMI(MBB, I, DL, get(URCL::StoreRI))
                                            .addFrameIndex(FI).addImm(0).addReg(SrcReg, getKillRegState(isKill))
                                            .addMemOperand(MMO);
  }
  else{
    llvm_unreachable("Can't store this register to stack slot");
  }
}

void URCLInstrInfo::
loadRegFromStackSlot(MachineBasicBlock &MBB, MachineBasicBlock::iterator I,
                     Register DestReg, int FI,
                     const TargetRegisterClass *RC,
                     const TargetRegisterInfo *TRI) const {
  DebugLoc DL;
  if (I != MBB.end()) DL = I->getDebugLoc();

  MachineFunction *MF = MBB.getParent();
  const MachineFrameInfo &MFI = MF->getFrameInfo();
  MachineMemOperand *MMO = MF->getMachineMemOperand(
      MachinePointerInfo::getFixedStack(*MF, FI), MachineMemOperand::MOLoad,
      MFI.getObjectSize(FI), MFI.getObjectAlign(FI));

  if (RC == &URCL::GPRRegClass)
    BuildMI(MBB, I, DL, get(URCL::LoadRI), DestReg).addFrameIndex(FI).addImm(0).addMemOperand(MMO);
  else{
    llvm_unreachable("Can't load this register from stack slot");
  }

}