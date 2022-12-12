//===---- URCLISelDAGToDAG.h - A Dag to Dag Inst Selector for URCL ------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines an instruction selector for the URCL target.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_URCL_URCLISELDAGTODAG_H
#define LLVM_LIB_TARGET_URCL_URCLISELDAGTODAG_H

#include "URCLSubtarget.h"
#include "URCLTargetMachine.h"
#include "llvm/CodeGen/MachineFunction.h"

namespace llvm {
class URCLDAGToDAGISel : public SelectionDAGISel {
public:
  explicit URCLDAGToDAGISel(URCLTargetMachine &TM, CodeGenOpt::Level OL)
      : SelectionDAGISel(TM, OL), Subtarget(nullptr) {}

  // Pass Name
  StringRef getPassName() const override {
    return "URCL DAG->DAG Pattern Instruction Selection";
  }

  bool runOnMachineFunction(MachineFunction &MF) override;

  bool SelectADDRrr(SDValue N, SDValue &R1, SDValue &R2);
  bool SelectADDRri(SDValue N, SDValue &Base, SDValue &Offset);

  void Select(SDNode *Node) override;

#include "URCLGenDAGISel.inc"

private:
  const URCLSubtarget *Subtarget;
};



}



#endif // end LLVM_LIB_TARGET_URCL_URCLISELDAGTODAG_H