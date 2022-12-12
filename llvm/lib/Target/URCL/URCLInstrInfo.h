//===-- URCLInstrInfo.h - URCL Instruction Information ----------*- C++ -*-===//
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

#ifndef LLVM_LIB_TARGET_URCL_URCLINSTRINFO_H
#define LLVM_LIB_TARGET_URCL_URCLINSTRINFO_H

#include "URCL.h"
#include "URCLRegisterInfo.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/TargetInstrInfo.h"

#define GET_INSTRINFO_HEADER
#include "URCLGenInstrInfo.inc"

namespace llvm {

class URCLInstrInfo : public URCLGenInstrInfo {
public:
  explicit URCLInstrInfo(const URCLSubtarget &STI);


  const URCLRegisterInfo &getRegisterInfo() const { return RI; }

protected:
  const URCLRegisterInfo RI;
  const URCLSubtarget &Subtarget;
  void copyPhysReg(MachineBasicBlock &MBB,
                           MachineBasicBlock::iterator MI, const DebugLoc &DL,
                           MCRegister DestReg, MCRegister SrcReg,
                           bool KillSrc) const override;
  void storeRegToStackSlot(MachineBasicBlock &MBB,
                           MachineBasicBlock::iterator MBBI,
                           Register SrcReg, bool isKill, int FrameIndex,
                           const TargetRegisterClass *RC,
                           const TargetRegisterInfo *TRI) const override;

  void loadRegFromStackSlot(MachineBasicBlock &MBB,
                            MachineBasicBlock::iterator MBBI,
                            Register DestReg, int FrameIndex,
                            const TargetRegisterClass *RC,
                            const TargetRegisterInfo *TRI) const override;
};
}

#endif // end LLVM_LIB_TARGET_URCL_URCLINSTRINFO_H