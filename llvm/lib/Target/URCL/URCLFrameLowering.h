//===-- URCLFrameLowering.h - Define frame lowering for URCL ----*- C++ -*-===//
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

#ifndef LLVM_LIB_TARGET_URCL_URCLFRAMELOWERING_H
#define LLVM_LIB_TARGET_URCL_URCLFRAMELOWERING_H

#include "llvm/CodeGen/TargetFrameLowering.h"

namespace llvm {
  class URCLSubtarget;

class URCLFrameLowering : public TargetFrameLowering {
protected:
  const URCLSubtarget &STI;

public:
  explicit URCLFrameLowering(const URCLSubtarget &STI)
    : TargetFrameLowering(TargetFrameLowering::StackGrowsDown,
                          /*StackAlignment*/Align(4),
                          /*LocalAreaOffset*/0,
                          /*TransAl*/Align(4)),
      STI(STI) {}

  void emitPrologue(MachineFunction &MF, MachineBasicBlock &MBB) const override;
  void emitEpilogue(MachineFunction &MF, MachineBasicBlock &MBB) const override;
  uint64_t computeStackSize(MachineFunction &MF) const;

  bool hasReservedCallFrame(const MachineFunction &MF) const override;
  MachineBasicBlock::iterator
  eliminateCallFramePseudoInstr(MachineFunction &MF, MachineBasicBlock &MBB,
                                MachineBasicBlock::iterator I) const override;

  void determineCalleeSaves(MachineFunction &MF, BitVector &SavedRegs,
                            RegScavenger *RS) const override;

  StackOffset getFrameIndexReference(const MachineFunction &MF, int FI, Register &FrameReg) const override;
  bool hasFP(const MachineFunction &MF) const override;
};
} // end llvm namespace

#endif // end LLVM_LIB_TARGET_URCL_URCLFRAMELOWERING_H