//===-- URCLISelLowering.h - URCL DAG Lowering Interface ------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines the interfaces that URCL uses to lower LLVM code into a
// selection DAG.
//
//===----------------------------------------------------------------------===//

#ifndef URCLISELLOWERING_H
#define URCLISELLOWERING_H

#include "URCL.h"
#include "llvm/CodeGen/SelectionDAG.h"
#include "llvm/CodeGen/TargetLowering.h"
//#include "llvm/Target/TargetLowering.h"

namespace llvm {

// Forward delcarations
class URCLSubtarget;
class URCLTargetMachine;

namespace URCLISD {
enum NodeType {
  // Start the numbering where the builtin ops and target ops leave off.
  FIRST_NUMBER = ISD::BUILTIN_OP_END,
  RET_FLAG,
  LOAD_SYM,
  SELECT_ICC,
  COND_TEST,
  BR_CC,
  TAIL_CALL,
  CALL
};
}

//===--------------------------------------------------------------------===//
// TargetLowering Implementation
//===--------------------------------------------------------------------===//
class URCLTargetLowering : public TargetLowering {
public:
  explicit URCLTargetLowering(const TargetMachine &TM, const URCLSubtarget &STI);

  /// LowerOperation - Provide custom lowering hooks for some operations.
  virtual SDValue LowerOperation(SDValue Op, SelectionDAG &DAG) const override;

  /// getTargetNodeName - This method returns the name of a target specific
  //  DAG node.
  virtual const char *getTargetNodeName(unsigned Opcode) const override;

private:
  const URCLSubtarget &Subtarget;

  SDValue
    LowerFormalArguments(SDValue Chain, CallingConv::ID CallConv, bool isVarArg,
                         const SmallVectorImpl<ISD::InputArg> &Ins,
                         const SDLoc &dl, SelectionDAG &DAG,
                         SmallVectorImpl<SDValue> &InVals) const override;

  SDValue
      LowerCall(TargetLowering::CallLoweringInfo &CLI,
                SmallVectorImpl<SDValue> &InVals) const override;

  SDValue LowerReturn(SDValue Chain, CallingConv::ID CallConv, bool isVarArg,
                        const SmallVectorImpl<ISD::OutputArg> &Outs,
                        const SmallVectorImpl<SDValue> &OutVals,
                        const SDLoc &dl, SelectionDAG &DAG) const override;

  SDValue LowerCallResult(SDValue Chain, SDValue InGlue,
                          CallingConv::ID CallConv, bool isVarArg,
                          const SmallVectorImpl<ISD::InputArg> &Ins, SDLoc dl,
                          SelectionDAG &DAG,
                          SmallVectorImpl<SDValue> &InVals) const;

  bool CanLowerReturn(CallingConv::ID CallConv, MachineFunction &MF,
                        bool isVarArg,
                        const SmallVectorImpl<ISD::OutputArg> &Outs,
                        LLVMContext &Context) const override;

  // LowerGlobalAddress - Emit a constant load to the global address.
  //SDValue LowerTruncateStore(SDValue Op, SelectionDAG &DAG) const;
  //SDValue LowerAnyExtLoad(SDValue Op, SelectionDAG &DAG) const;
  SDValue LowerGlobalAddress(SDValue Op, SelectionDAG &DAG) const;
  SDValue LowerFRAMEADDR(SDValue Op, SelectionDAG &DAG) const;
  SDValue LowerBR_CC(SDValue Op, SelectionDAG &DAG) const;
  SDValue LowerSELECT_CC(SDValue Op, SelectionDAG &DAG,
                              const URCLTargetLowering &TLI) const;
  MachineBasicBlock *
      expandSelectCC(MachineInstr &MI, MachineBasicBlock *BB,
                                    unsigned BROpcode) const;
  MachineBasicBlock *
    EmitInstrWithCustomInserter(MachineInstr &MI,
                                MachineBasicBlock *MBB) const override;
};
}

#endif // URCLISELLOWERING_H
