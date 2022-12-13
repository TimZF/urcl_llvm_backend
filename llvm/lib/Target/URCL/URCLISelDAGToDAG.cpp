//===-- URCLISelDAGToDAG.cpp - A Dag to Dag Inst Selector for URCL ------===//
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

#include "URCLISelDAGToDAG.h"
#include "URCLSubtarget.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/SelectionDAGISel.h"
#include "llvm/Support/Debug.h"

using namespace llvm;

#define DEBUG_TYPE "URCL-isel"

bool URCLDAGToDAGISel::runOnMachineFunction(MachineFunction &MF) {
  Subtarget = &static_cast<const URCLSubtarget &>(MF.getSubtarget());
  return SelectionDAGISel::runOnMachineFunction(MF);
}

void URCLDAGToDAGISel::Select(SDNode *Node) {
  unsigned Opcode = Node->getOpcode();

  // If we have a custom node, we already have selected!
  if (Node->isMachineOpcode()) {
    LLVM_DEBUG(dbgs() << "Skipping machine opcode: "<< Opcode << "\n");
    LLVM_DEBUG(dbgs() << "Machine== "; Node->dump(CurDAG); errs() << "\n");
    Node->setNodeId(-1);
    return;
  }

  if (Node->isTargetOpcode()){
    LLVM_DEBUG(dbgs() << "Trying to convert target opcode: "<< Opcode << "\n");
    LLVM_DEBUG(dbgs() << "Target== "; Node->dump(CurDAG); errs() << "\n");
    //return;
  }

  LLVM_DEBUG(dbgs() << "Selecting== "; Node->dump(CurDAG); dbgs() << "\n");
  // Select the default instruction
  SelectCode(Node);
}

bool URCLDAGToDAGISel::SelectADDRri(SDValue Addr,
                                     SDValue &Base, SDValue &Offset) {
  if (FrameIndexSDNode *FIN = dyn_cast<FrameIndexSDNode>(Addr)) {
    Base = CurDAG->getTargetFrameIndex(
        FIN->getIndex(), TLI->getPointerTy(CurDAG->getDataLayout()));
    Offset = CurDAG->getTargetConstant(0, SDLoc(Addr), MVT::i32);
    return true;
  }
  if (Addr.getOpcode() == ISD::TargetExternalSymbol ||
      Addr.getOpcode() == ISD::TargetGlobalAddress ||
      Addr.getOpcode() == ISD::TargetGlobalTLSAddress)
    return false;  // direct calls.

  if (Addr.getOpcode() == ISD::ADD) {
    if (ConstantSDNode *CN = dyn_cast<ConstantSDNode>(Addr.getOperand(1))) {
    if (FrameIndexSDNode *FIN =
            dyn_cast<FrameIndexSDNode>(Addr.getOperand(0))) {
        // Constant offset from frame ref.
        Base = CurDAG->getTargetFrameIndex(
            FIN->getIndex(), TLI->getPointerTy(CurDAG->getDataLayout()));
      } else {
        Base = Addr.getOperand(0);
      }
      Offset = CurDAG->getTargetConstant(CN->getZExtValue(), SDLoc(Addr),
                                         MVT::i32);
      return true;
    }
  }
  Base = Addr;
  Offset = CurDAG->getTargetConstant(0, SDLoc(Addr), MVT::i32);
  return true;
}


bool URCLDAGToDAGISel::SelectADDRrr(SDValue Addr, SDValue &R1, SDValue &R2){
  if (Addr.getOpcode() == ISD::FrameIndex) return false;
  if (Addr.getOpcode() == ISD::TargetExternalSymbol ||
      Addr.getOpcode() == ISD::TargetGlobalAddress ||
      Addr.getOpcode() == ISD::TargetGlobalTLSAddress)
    return false;  // direct calls.

  if (Addr.getOpcode() == ISD::ADD) {
    R1 = Addr.getOperand(0);
    R2 = Addr.getOperand(1);
    return true;
  }

  R1 = Addr;
  R2 = CurDAG->getRegister(URCL::R0, TLI->getPointerTy(CurDAG->getDataLayout()));
  return true;
}