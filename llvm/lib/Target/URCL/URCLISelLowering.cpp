//===-- URCLISelLowering.cpp - URCL DAG Lowering Implementation ---------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements the URCLTargetLowering class.
//
//===----------------------------------------------------------------------===//

#include "URCLISelLowering.h"
#include "URCL.h"
#include "URCLMachineFunctionInfo.h"
#include "URCLSubtarget.h"
#include "URCLTargetMachine.h"
#include "llvm/CodeGen/CallingConvLower.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineJumpTableInfo.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/SelectionDAGISel.h"
#include "llvm/CodeGen/TargetLoweringObjectFileImpl.h"
#include "llvm/CodeGen/ValueTypes.h"
#include "llvm/IR/CallingConv.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalAlias.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/CodeGen/SelectionDAGNodes.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;
#define DEBUG_TYPE "URCL-isel-lowering"



// Look at LHS/RHS/CC and see if they are a lowered setcc instruction.  If so
// set LHS/RHS and SPCC to the LHS/RHS of the setcc and SPCC to the condition.
static void LookThroughSetCC(SDValue &LHS, SDValue &RHS,
                             ISD::CondCode CC, unsigned &SPCC) {
  if (isNullConstant(RHS) && CC == ISD::SETNE &&
      (LHS.getOpcode() == URCLISD::SELECT_ICC &&
        LHS.getOperand(3).getOpcode() == URCLISD::COND_TEST) &&
      isOneConstant(LHS.getOperand(0)) && isNullConstant(LHS.getOperand(1))) {
    SDValue CMPCC = LHS.getOperand(3);
    SPCC = cast<ConstantSDNode>(LHS.getOperand(2))->getZExtValue();
    LHS = CMPCC.getOperand(0);
    RHS = CMPCC.getOperand(1);
  }
}







const char *URCLTargetLowering::getTargetNodeName(unsigned Opcode) const {
  switch (Opcode) {
  default:
    return NULL;
  case URCLISD::RET_FLAG: return "URCLISD::RET_FLAG";
  case URCLISD::BR_CC:    return "URCLISD::BR_CC";
  case URCLISD::CALL:     return "URCLISD::CALL";
  case URCLISD::LOAD_SYM:  return "URCLISD::LOAD_SYM";
  case URCLISD::SELECT_ICC: return "URCLISD::SELECT_ICC";
  case URCLISD::COND_TEST: return "URCLISD::COND_TEST";
  }
}

URCLTargetLowering::URCLTargetLowering(const TargetMachine &URCLTM, const URCLSubtarget &STI)
    : TargetLowering(URCLTM), Subtarget(STI) {
  // Set up the register classes.
  addRegisterClass(MVT::i32, &URCL::GPRRegClass);
  computeRegisterProperties(Subtarget.getRegisterInfo());

  setStackPointerRegisterToSaveRestore(URCL::R1);

  setSchedulingPreference(Sched::Source);
  setBooleanContents(ZeroOrNegativeOneBooleanContent);

  //avoid them for now
  setMinimumJumpTableEntries(100);

  setLoadExtAction(ISD::SEXTLOAD, MVT::i32, MVT::i16, Expand);
  setLoadExtAction(ISD::SEXTLOAD, MVT::i32, MVT::i8, Expand);
  setLoadExtAction(ISD::SEXTLOAD, MVT::i32, MVT::i1, Expand);
  setOperationAction(ISD::SIGN_EXTEND_INREG, MVT::i16, Expand);
  setOperationAction(ISD::SIGN_EXTEND_INREG, MVT::i8 , Expand);
  setOperationAction(ISD::SIGN_EXTEND_INREG, MVT::i1 , Expand);

  setOperationAction(ISD::BRCOND, MVT::Other, Expand);
  setOperationAction(ISD::SELECT, MVT::i32, Expand);
  setOperationAction(ISD::SETCC, MVT::i32, Expand);

  setOperationAction(ISD::SELECT_CC, MVT::i32, Custom);

  MVT PtrVT = MVT::getIntegerVT(URCLTM.getPointerSizeInBits(0));

  setOperationAction(ISD::GlobalAddress, PtrVT, Custom);
  setOperationAction(ISD::GlobalTLSAddress, PtrVT, Custom);
  setOperationAction(ISD::ConstantPool, PtrVT, Custom);
  setOperationAction(ISD::BlockAddress, PtrVT, Custom);
  setOperationAction(ISD::FRAMEADDR, MVT::i32, Custom);
  setOperationAction(ISD::BR_CC, MVT::i32, Custom);

  setOperationAction(ISD::DYNAMIC_STACKALLOC, MVT::i32, Custom);
  // VASTART needs to be custom lowered to use the VarArgsFrameIndex.
  setOperationAction(ISD::VASTART           , MVT::Other, Custom);
  // VAARG needs to be lowered to not do unaligned accesses for doubles.
  setOperationAction(ISD::VAARG             , MVT::Other, Custom);
}

SDValue URCLTargetLowering::LowerOperation(SDValue Op, SelectionDAG &DAG) const {
  switch (Op.getOpcode()) {
  default:
    llvm_unreachable("Unimplemented operand");
  case ISD::BR_CC:
    return LowerBR_CC(Op, DAG);
  case ISD::SELECT_CC:
    return LowerSELECT_CC(Op, DAG, *this);
  case ISD::GlobalAddress:
    return LowerGlobalAddress(Op, DAG);
  case ISD::FRAMEADDR:
    return LowerFRAMEADDR(Op, DAG);
  //case ISD::STORE:
  //  return LowerTruncateStore(Op, DAG);

  }
}


static SDValue getFRAMEADDR(uint64_t depth, SDValue Op, SelectionDAG &DAG, bool AlwaysFlush = false) {
  MachineFrameInfo &MFI = DAG.getMachineFunction().getFrameInfo();
  MFI.setFrameAddressIsTaken(true);

  EVT VT = Op.getValueType();
  SDLoc dl(Op);
  unsigned FrameReg = URCL::R1;

  SDValue FrameAddr;
  SDValue Chain;

  assert(!(depth || AlwaysFlush));
  Chain = DAG.getEntryNode();
  //Chain = (depth || AlwaysFlush) ? getFLUSHW(Op, DAG) : DAG.getEntryNode();

  FrameAddr = DAG.getCopyFromReg(Chain, dl, FrameReg, VT);

  unsigned Offset = 56;

  while (depth--) {
    SDValue Ptr = DAG.getNode(ISD::ADD, dl, VT, FrameAddr, DAG.getIntPtrConstant(Offset, dl));
    FrameAddr = DAG.getLoad(VT, dl, Chain, Ptr, MachinePointerInfo());
  }
  return FrameAddr;
}




SDValue URCLTargetLowering::LowerFRAMEADDR(SDValue Op, SelectionDAG &DAG) const {
  uint64_t depth = Op.getConstantOperandVal(0);

  return getFRAMEADDR(depth, Op, DAG);
}

SDValue URCLTargetLowering::LowerBR_CC(SDValue Op, SelectionDAG &DAG) const {
  SDValue Chain = Op.getOperand(0);
  SDValue Cond = Op.getOperand(1);
  ISD::CondCode SetCCOpcode = cast<CondCodeSDNode>(Cond)->get();
  SDValue LHS = Op.getOperand(2);
  SDValue RHS = Op.getOperand(3);
  SDValue Dest = Op.getOperand(4);
  SDLoc DL(Op);


  URCL::CondCodes CC;
  switch (SetCCOpcode){
    case ISD::SETLT:
      CC = URCL::CondCodes::ICC_L;
      break;
    default:
      LLVM_DEBUG(dbgs() << "Did not implement condition: " << SetCCOpcode << "\n");
      llvm_unreachable("Unimplemented condition");
  }

  SDValue TargetCC = DAG.getConstant(CC, DL, MVT::i32);
  SDValue condResult;
   if (LHS.getValueType().isInteger()) {
      condResult = DAG.getNode(URCLISD::COND_TEST, DL, MVT::Glue, LHS, RHS, TargetCC);
  }else{
    llvm_unreachable("only do integers right now");
  }
  return DAG.getNode(URCLISD::BR_CC, DL, Op.getValueType(), Chain, Dest,
                     condResult);
}



SDValue URCLTargetLowering::LowerSELECT_CC(SDValue Op, SelectionDAG &DAG,
                              const URCLTargetLowering &TLI) const {
  SDValue LHS = Op.getOperand(0);
  SDValue RHS = Op.getOperand(1);
  SDValue TrueVal = Op.getOperand(2);
  SDValue FalseVal = Op.getOperand(3);
  ISD::CondCode SetCCOpcode = cast<CondCodeSDNode>(Op.getOperand(4))->get();
  SDLoc dl(Op);
  unsigned Opc, SPCC = ~0U;

  // If this is a select_cc of a "setcc", and if the setcc got lowered into
  // an CMP[IF]CC/SELECT_[IF]CC pair, find the original compared values.
  LookThroughSetCC(LHS, RHS, SetCCOpcode, SPCC);

  URCL::CondCodes CC;
  switch (SetCCOpcode){
    case ISD::SETLT:
      CC = URCL::CondCodes::ICC_L;
      break;
    default:
      LLVM_DEBUG(dbgs() << "Did not implement condition: " << SetCCOpcode << "\n");
      llvm_unreachable("Unimplemented condition");
  }


  SDValue TargetCC = DAG.getConstant(CC, dl, MVT::i32);
  SDValue condResult;
  if (LHS.getValueType().isInteger()) {
    condResult = DAG.getNode(URCLISD::COND_TEST, dl, MVT::Glue, LHS, RHS, TargetCC);
    Opc = URCLISD::SELECT_ICC;
  }else{
    llvm_unreachable("only do integers right now");
  }
  return DAG.getNode(Opc, dl, TrueVal.getValueType(), TrueVal, FalseVal, condResult);
}




SDValue URCLTargetLowering::LowerGlobalAddress(SDValue addr, SelectionDAG& DAG) const
{
  SDLoc DL(addr);
  EVT VT = getPointerTy(DAG.getDataLayout());

  const GlobalAddressSDNode *GA = dyn_cast<GlobalAddressSDNode>(addr);
  SDValue global_addr = DAG.getTargetGlobalAddress(GA->getGlobal(),
                                      DL,
                                      GA->getValueType(0),
                                      0);
  //SDValue offset = DAG.getConstant(GA->getOffset(), DL, VT);
  //SDValue GlobalBase = DAG.getRegister(URCL::R0, VT);//DAG.getNode(SPISD::GLOBAL_BASE_REG, DL, VT);
  //SDValue AbsAddr = DAG.getNode(ISD::ADD, DL, VT, GlobalBase, global_addr);

  //MachineFrameInfo &MFI = DAG.getMachineFunction().getFrameInfo();
  //return DAG.getLoad(VT, DL, DAG.getEntryNode(), AbsAddr, MachinePointerInfo::getGOT(DAG.getMachineFunction()));


  SDValue chain = DAG.getEntryNode();
  SDValue Ptr = DAG.getNode(ISD::ADD, DL, VT, global_addr, DAG.getIntPtrConstant(GA->getOffset(), DL));
  //SDValue val = DAG.getLoad(VT, DL, chain, Ptr, MachinePointerInfo());
  return Ptr;
}

//===----------------------------------------------------------------------===//
//                      Calling Convention Implementation
//===----------------------------------------------------------------------===//

#include "URCLGenCallingConv.inc"

//===----------------------------------------------------------------------===//
//                  Call Calling Convention Implementation
//===----------------------------------------------------------------------===//

static unsigned toCallerWindow(unsigned Reg) {
  return Reg;
}

static bool hasReturnsTwiceAttr(SelectionDAG &DAG, SDValue Callee,
                                const CallBase *Call) {
  if (Call)
    return Call->hasFnAttr(Attribute::ReturnsTwice);

  const Function *CalleeFn = nullptr;
  if (GlobalAddressSDNode *G = dyn_cast<GlobalAddressSDNode>(Callee)) {
    CalleeFn = dyn_cast<Function>(G->getGlobal());
  } else if (ExternalSymbolSDNode *E =
             dyn_cast<ExternalSymbolSDNode>(Callee)) {
    const Function &Fn = DAG.getMachineFunction().getFunction();
    const Module *M = Fn.getParent();
    const char *CalleeName = E->getSymbol();
    CalleeFn = M->getFunction(CalleeName);
  }

  if (!CalleeFn)
    return false;
  return CalleeFn->hasFnAttribute(Attribute::ReturnsTwice);
}

/// URCL call implementation
SDValue URCLTargetLowering::LowerCall(TargetLowering::CallLoweringInfo &CLI,
                                     SmallVectorImpl<SDValue> &InVals) const {
  SelectionDAG &DAG                     = CLI.DAG;
  SDLoc &dl                             = CLI.DL;
  SmallVectorImpl<ISD::OutputArg> &Outs = CLI.Outs;
  SmallVectorImpl<SDValue> &OutVals     = CLI.OutVals;
  SmallVectorImpl<ISD::InputArg> &Ins   = CLI.Ins;
  SDValue Chain                         = CLI.Chain;
  SDValue Callee                        = CLI.Callee;
  bool &isTailCall                      = CLI.IsTailCall;
  CallingConv::ID CallConv              = CLI.CallConv;
  bool isVarArg                         = CLI.IsVarArg;

  // Analyze operands of the call, assigning locations to each operand.
  SmallVector<CCValAssign, 16> ArgLocs;
  CCState CCInfo(CallConv, isVarArg, DAG.getMachineFunction(), ArgLocs,
                 *DAG.getContext());
  CCInfo.AnalyzeCallOperands(Outs, CC_URCL);

  isTailCall = false;//isTailCall && IsEligibleForTailCallOptimization(CCInfo, CLI, DAG.getMachineFunction());

  // Get the size of the outgoing arguments stack URCLace requirement.
  unsigned ArgsSize = CCInfo.getNextStackOffset();

  // Keep stack frames 8-byte aligned.
  ArgsSize = (ArgsSize+7) & ~7;

  MachineFrameInfo &MFI = DAG.getMachineFunction().getFrameInfo();

  // Create local copies for byval args.
  SmallVector<SDValue, 8> ByValArgs;
  for (unsigned i = 0,  e = Outs.size(); i != e; ++i) {
    ISD::ArgFlagsTy Flags = Outs[i].Flags;
    if (!Flags.isByVal())
      continue;

    SDValue Arg = OutVals[i];
    unsigned Size = Flags.getByValSize();
    Align Alignment = Flags.getNonZeroByValAlign();

    if (Size > 0U) {
      int FI = MFI.CreateStackObject(Size, Alignment, false);
      SDValue FIPtr = DAG.getFrameIndex(FI, getPointerTy(DAG.getDataLayout()));
      SDValue SizeNode = DAG.getConstant(Size, dl, MVT::i32);

      Chain = DAG.getMemcpy(Chain, dl, FIPtr, Arg, SizeNode, Alignment,
                            false,        // isVolatile,
                            (Size <= 32), // AlwaysInline if size <= 32,
                            false,        // isTailCall
                            MachinePointerInfo(), MachinePointerInfo());
      ByValArgs.push_back(FIPtr);
    }
    else {
      SDValue nullVal;
      ByValArgs.push_back(nullVal);
    }
  }

  assert(!isTailCall || ArgsSize == 0);

  if (!isTailCall)
    Chain = DAG.getCALLSEQ_START(Chain, ArgsSize, 0, dl);

  SmallVector<std::pair<unsigned, SDValue>, 8> RegsToPass;
  SmallVector<SDValue, 8> MemOpChains;

  const unsigned StackOffset = 92;
  bool hasStructRetAttr = false;
  unsigned SRetArgSize = 0;
  // Walk the register/memloc assignments, inserting copies/loads.
  for (unsigned i = 0, realArgIdx = 0, byvalArgIdx = 0, e = ArgLocs.size();
       i != e;
       ++i, ++realArgIdx) {
    CCValAssign &VA = ArgLocs[i];
    SDValue Arg = OutVals[realArgIdx];

    ISD::ArgFlagsTy Flags = Outs[realArgIdx].Flags;

    // Use local copy if it is a byval arg.
    if (Flags.isByVal()) {
      Arg = ByValArgs[byvalArgIdx++];
      if (!Arg) {
        continue;
      }
    }

    // Promote the value if needed.
    switch (VA.getLocInfo()) {
    default: llvm_unreachable("Unknown loc info!");
    case CCValAssign::Full: break;
    case CCValAssign::SExt:
      Arg = DAG.getNode(ISD::SIGN_EXTEND, dl, VA.getLocVT(), Arg);
      break;
    case CCValAssign::ZExt:
      Arg = DAG.getNode(ISD::ZERO_EXTEND, dl, VA.getLocVT(), Arg);
      break;
    case CCValAssign::AExt:
      Arg = DAG.getNode(ISD::ANY_EXTEND, dl, VA.getLocVT(), Arg);
      break;
    case CCValAssign::BCvt:
      Arg = DAG.getNode(ISD::BITCAST, dl, VA.getLocVT(), Arg);
      break;
    }

    if (Flags.isSRet()) {
      //assert(VA.needsCustom());

      if (isTailCall)
        continue;

      // store SRet argument in %SP+64
      SDValue StackPtr = DAG.getRegister(URCL::R1, MVT::i32);
      SDValue PtrOff = DAG.getIntPtrConstant(64, dl);
      PtrOff = DAG.getNode(ISD::ADD, dl, MVT::i32, StackPtr, PtrOff);
      MemOpChains.push_back(
          DAG.getStore(Chain, dl, Arg, PtrOff, MachinePointerInfo()));
      hasStructRetAttr = true;
      // sret only allowed on first argument
      assert(Outs[realArgIdx].OrigArgIndex == 0);
      SRetArgSize =
          DAG.getDataLayout().getTypeAllocSize(CLI.getArgs()[0].IndirectType);
      continue;
    }

    // Arguments that can be passed on register must be kept at
    // RegsToPass vector
    if (VA.isRegLoc()) {
      RegsToPass.push_back(std::make_pair(VA.getLocReg(), Arg));
      continue;
    }

    assert(VA.isMemLoc());

    // Create a store off the stack pointer for this argument.
    SDValue StackPtr = DAG.getRegister(URCL::R1, MVT::i32);
    SDValue PtrOff = DAG.getIntPtrConstant(VA.getLocMemOffset() + StackOffset,
                                           dl);

    PtrOff = DAG.getNode(ISD::ADD, dl, MVT::i32, StackPtr, PtrOff);

    MemOpChains.push_back(
        DAG.getStore(Chain, dl, Arg, PtrOff, MachinePointerInfo()));
  }


  // Emit all stores, make sure the occur before any copies into physregs.
  if (!MemOpChains.empty())
    Chain = DAG.getNode(ISD::TokenFactor, dl, MVT::Other, MemOpChains);

  // Build a sequence of copy-to-reg nodes chained together with token
  // chain and flag operands which copy the outgoing args into registers.
  // The InFlag in necessary since all emitted instructions must be
  // stuck together.
  SDValue InFlag;
  for (unsigned i = 0, e = RegsToPass.size(); i != e; ++i) {
    Register Reg = RegsToPass[i].first;
    if (!isTailCall)
      Reg = toCallerWindow(Reg);
    Chain = DAG.getCopyToReg(Chain, dl, Reg, RegsToPass[i].second, InFlag);
    InFlag = Chain.getValue(1);
  }

  bool hasReturnsTwice = hasReturnsTwiceAttr(DAG, Callee, CLI.CB);
  if (GlobalAddressSDNode *G = dyn_cast<GlobalAddressSDNode>(Callee))
    Callee = DAG.getTargetGlobalAddress(G->getGlobal(), dl, MVT::i32, 0);
  else if (ExternalSymbolSDNode *E = dyn_cast<ExternalSymbolSDNode>(Callee))
    Callee = DAG.getTargetExternalSymbol(E->getSymbol(), MVT::i32);

  // Returns a chain & a flag for retval copy to use
  SDVTList NodeTys = DAG.getVTList(MVT::Other, MVT::Glue);
  SmallVector<SDValue, 8> Ops;
  Ops.push_back(Chain);
  Ops.push_back(Callee);
  if (hasStructRetAttr)
    Ops.push_back(DAG.getTargetConstant(SRetArgSize, dl, MVT::i32));
  for (unsigned i = 0, e = RegsToPass.size(); i != e; ++i) {
    Register Reg = RegsToPass[i].first;
    if (!isTailCall)
      Reg = toCallerWindow(Reg);
    Ops.push_back(DAG.getRegister(Reg, RegsToPass[i].second.getValueType()));
  }

  // Add a register mask operand representing the call-preserved registers.
  const URCLRegisterInfo *TRI = Subtarget.getRegisterInfo();
  const uint32_t *Mask =
      ((hasReturnsTwice)
           ? TRI->getRTCallPreservedMask(CallConv)
           : TRI->getCallPreservedMask(DAG.getMachineFunction(), CallConv));
  assert(Mask && "Missing call preserved mask for calling convention");
  Ops.push_back(DAG.getRegisterMask(Mask));

  if (InFlag.getNode())
    Ops.push_back(InFlag);

  if (isTailCall) {
    DAG.getMachineFunction().getFrameInfo().setHasTailCall();
    return DAG.getNode(URCLISD::TAIL_CALL, dl, MVT::Other, Ops);
  }

  Chain = DAG.getNode(URCLISD::CALL, dl, NodeTys, Ops);
  InFlag = Chain.getValue(1);

  Chain = DAG.getCALLSEQ_END(Chain, ArgsSize, 0, InFlag, dl);
  InFlag = Chain.getValue(1);

  // Assign locations to each value returned by this call.
  SmallVector<CCValAssign, 16> RVLocs;
  CCState RVInfo(CallConv, isVarArg, DAG.getMachineFunction(), RVLocs,
                 *DAG.getContext());

  RVInfo.AnalyzeCallResult(Ins, RetCC_URCL);

  // Copy all of the result registers out of their URCLecified physreg.
  for (unsigned i = 0; i != RVLocs.size(); ++i) {
    assert(RVLocs[i].isRegLoc() && "Can only return in registers!");
      Chain =
          DAG.getCopyFromReg(Chain, dl, toCallerWindow(RVLocs[i].getLocReg()),
                             RVLocs[i].getValVT(), InFlag)
              .getValue(1);
      InFlag = Chain.getValue(2);
      InVals.push_back(Chain.getValue(0));
  }

  return Chain;
}

SDValue URCLTargetLowering::LowerCallResult(
    SDValue Chain, SDValue InGlue, CallingConv::ID CallConv, bool isVarArg,
    const SmallVectorImpl<ISD::InputArg> &Ins, SDLoc dl, SelectionDAG &DAG,
    SmallVectorImpl<SDValue> &InVals) const {
  assert(!isVarArg && "Unsupported");

  // Assign locations to each value returned by this call.
  SmallVector<CCValAssign, 16> RVLocs;
  CCState CCInfo(CallConv, isVarArg, DAG.getMachineFunction(), RVLocs,
                 *DAG.getContext());

  CCInfo.AnalyzeCallResult(Ins, RetCC_URCL);

  // Copy all of the result registers out of their URCLecified physreg.
  for (auto &Loc : RVLocs) {
    Chain = DAG.getCopyFromReg(Chain, dl, Loc.getLocReg(), Loc.getValVT(),
                               InGlue).getValue(1);
    InGlue = Chain.getValue(2);
    InVals.push_back(Chain.getValue(0));
  }

  return Chain;
}

//===----------------------------------------------------------------------===//
//             Formal Arguments Calling Convention Implementation
//===----------------------------------------------------------------------===//

/// URCL formal arguments implementation
SDValue URCLTargetLowering::LowerFormalArguments(SDValue Chain, CallingConv::ID CallConv, bool isVarArg,
                         const SmallVectorImpl<ISD::InputArg> &Ins,
                         const SDLoc &dl, SelectionDAG &DAG,
                         SmallVectorImpl<SDValue> &InVals) const {
  MachineFunction &MF = DAG.getMachineFunction();
  MachineRegisterInfo &RegInfo = MF.getRegInfo();
  //URCLFunctionInfo *FuncInfo = MF.getInfo<URCLFunctionInfo>();

  // Assign locations to all of the incoming arguments.
  SmallVector<CCValAssign, 16> ArgLocs;
  CCState CCInfo(CallConv, isVarArg, DAG.getMachineFunction(), ArgLocs,
                 *DAG.getContext());
  CCInfo.AnalyzeFormalArguments(Ins, CC_URCL);

  const unsigned StackOffset = 92;

  unsigned InIdx = 0;
  for (unsigned i = 0, e = ArgLocs.size(); i != e; ++i, ++InIdx) {
    CCValAssign &VA = ArgLocs[i];

    if (Ins[InIdx].Flags.isSRet()) {
      if (InIdx != 0)
        report_fatal_error("URCL only supports sret on the first parameter");
      // Get SRet from [%fp+64].
      int FrameIdx = MF.getFrameInfo().CreateFixedObject(4, 64, true);
      SDValue FIPtr = DAG.getFrameIndex(FrameIdx, MVT::i32);
      SDValue Arg =
          DAG.getLoad(MVT::i32, dl, Chain, FIPtr, MachinePointerInfo());
      InVals.push_back(Arg);
      continue;
    }

    if (VA.isRegLoc()) {
      Register VReg = RegInfo.createVirtualRegister(&URCL::GPRRegClass);
      MF.getRegInfo().addLiveIn(VA.getLocReg(), VReg);
      SDValue Arg = DAG.getCopyFromReg(Chain, dl, VReg, MVT::i32);
      InVals.push_back(Arg);
      continue;
    }

    assert(VA.isMemLoc());

    unsigned Offset = VA.getLocMemOffset()+StackOffset;
    auto PtrVT = getPointerTy(DAG.getDataLayout());

    int FI = MF.getFrameInfo().CreateFixedObject(4,
                                                 Offset,
                                                 true);
    SDValue FIPtr = DAG.getFrameIndex(FI, PtrVT);
    SDValue Load ;
    if (VA.getValVT() == MVT::i32 || VA.getValVT() == MVT::f32) {
      Load = DAG.getLoad(VA.getValVT(), dl, Chain, FIPtr, MachinePointerInfo());
    } else {
      // We shouldn't see any other value types here.
      llvm_unreachable("Unexpected ValVT encountered in frame lowering.");
    }
    InVals.push_back(Load);
  }

  if (MF.getFunction().hasStructRetAttr()) {
    // Copy the SRet Argument to SRetReturnReg.
    URCLMachineFunctionInfo *SFI = MF.getInfo<URCLMachineFunctionInfo>();
    Register Reg = SFI->getSRetReturnReg();
    if (!Reg) {
      Reg = MF.getRegInfo().createVirtualRegister(&URCL::GPRRegClass);
      SFI->setSRetReturnReg(Reg);
    }
    SDValue Copy = DAG.getCopyToReg(DAG.getEntryNode(), dl, Reg, InVals[0]);
    Chain = DAG.getNode(ISD::TokenFactor, dl, MVT::Other, Copy, Chain);
  }

  // Store remaining ArgRegs to the stack if this is a varargs function.
  if (isVarArg) {
    static const MCPhysReg ArgRegs[] = {
      URCL::R2, URCL::R3, URCL::R4, URCL::R5
    };
    unsigned NumAllocated = CCInfo.getFirstUnallocated(ArgRegs);
    const MCPhysReg *CurArgReg = ArgRegs+NumAllocated, *ArgRegEnd = ArgRegs+6;
    unsigned ArgOffset = CCInfo.getNextStackOffset();
    if (NumAllocated == 6)
      ArgOffset += StackOffset;
    else {
      assert(!ArgOffset);
      ArgOffset = 68+4*NumAllocated;
    }

    // Remember the vararg offset for the va_start implementation.
    //TODO va args
    //FuncInfo->setVarArgsFrameOffset(ArgOffset);

    std::vector<SDValue> OutChains;

    for (; CurArgReg != ArgRegEnd; ++CurArgReg) {
      Register VReg = RegInfo.createVirtualRegister(&URCL::GPRRegClass);
      MF.getRegInfo().addLiveIn(*CurArgReg, VReg);
      SDValue Arg = DAG.getCopyFromReg(DAG.getRoot(), dl, VReg, MVT::i32);

      int FrameIdx = MF.getFrameInfo().CreateFixedObject(4, ArgOffset,
                                                         true);
      SDValue FIPtr = DAG.getFrameIndex(FrameIdx, MVT::i32);

      OutChains.push_back(
          DAG.getStore(DAG.getRoot(), dl, Arg, FIPtr, MachinePointerInfo()));
      ArgOffset += 4;
    }

    if (!OutChains.empty()) {
      OutChains.push_back(Chain);
      Chain = DAG.getNode(ISD::TokenFactor, dl, MVT::Other, OutChains);
    }
  }

  return Chain;
}

//===----------------------------------------------------------------------===//
//               Return Value Calling Convention Implementation
//===----------------------------------------------------------------------===//

bool URCLTargetLowering::CanLowerReturn(
    CallingConv::ID CallConv, MachineFunction &MF, bool isVarArg,
    const SmallVectorImpl<ISD::OutputArg> &Outs, LLVMContext &Context) const {
  SmallVector<CCValAssign, 16> RVLocs;
  CCState CCInfo(CallConv, isVarArg, MF, RVLocs, Context);
  if (!CCInfo.CheckReturn(Outs, RetCC_URCL)) {
    return false;
  }
  if (CCInfo.getNextStackOffset() != 0 && isVarArg) {
    return false;
  }
  return true;
}

SDValue URCLTargetLowering::LowerReturn(SDValue Chain, CallingConv::ID CallConv, bool isVarArg,
                        const SmallVectorImpl<ISD::OutputArg> &Outs,
                        const SmallVectorImpl<SDValue> &OutVals,
                        const SDLoc &dl, SelectionDAG &DAG) const {
  if (isVarArg) {
    report_fatal_error("VarArg not supported");
  }

  // CCValAssign - represent the assignment of
  // the return value to a location
  SmallVector<CCValAssign, 16> RVLocs;

  // CCState - Info about the registers and stack slot.
  CCState CCInfo(CallConv, isVarArg, DAG.getMachineFunction(), RVLocs,
                 *DAG.getContext());

  CCInfo.AnalyzeReturn(Outs, RetCC_URCL);

  SDValue Flag;
  SmallVector<SDValue, 4> RetOps(1, Chain);

  // Copy the result values into the output registers.
  for (unsigned i = 0, e = RVLocs.size(); i < e; ++i) {
    CCValAssign &VA = RVLocs[i];
    assert(VA.isRegLoc() && "Can only return in registers!");

    Chain = DAG.getCopyToReg(Chain, dl, VA.getLocReg(), OutVals[i], Flag);

    Flag = Chain.getValue(1);
    RetOps.push_back(DAG.getRegister(VA.getLocReg(), VA.getLocVT()));
  }

  RetOps[0] = Chain; // Update chain.

  // Add the flag if we have it.
  if (Flag.getNode()) {
    RetOps.push_back(Flag);
  }

  return DAG.getNode(URCLISD::RET_FLAG, dl, MVT::Other, RetOps);
}







MachineBasicBlock *
URCLTargetLowering::EmitInstrWithCustomInserter(MachineInstr &MI,
                                                 MachineBasicBlock *BB) const {
  switch (MI.getOpcode()) {
  default: llvm_unreachable("Unknown Instruction with custom inserter!");
  case URCL::SELECT_LESS_IntRRRI:
    return expandSelectCC(MI, BB, URCL::BRLRI);
  }
}



MachineBasicBlock *
URCLTargetLowering::expandSelectCC(MachineInstr &MI, MachineBasicBlock *BB,
                                    unsigned BROpcode) const {
  const TargetInstrInfo &TII = *Subtarget.getInstrInfo();
  DebugLoc dl = MI.getDebugLoc();
  //GPR:$dst;      $T, $F, $a1, $a2
  MachineOperand lhs = MI.getOperand(3);
  MachineOperand rhs = MI.getOperand(4);
  //unsigned CC = (URCL::CondCodes)MI.getOperand(4).getImm();

  // To "insert" a SELECT_CC instruction, we actually have to insert the
  // triangle control-flow pattern. The incoming instruction knows the
  // destination vreg to set, the condition code register to branch on, the
  // true/false values to select between, and the condition code for the branch.
  //
  // We produce the following control flow:
  //     ThisMBB
  //     |  \
  //     |  IfFalseMBB
  //     | /
  //    SinkMBB
  const BasicBlock *LLVM_BB = BB->getBasicBlock();
  MachineFunction::iterator It = ++BB->getIterator();

  MachineBasicBlock *ThisMBB = BB;
  MachineFunction *F = BB->getParent();
  MachineBasicBlock *IfFalseMBB = F->CreateMachineBasicBlock(LLVM_BB);
  MachineBasicBlock *SinkMBB = F->CreateMachineBasicBlock(LLVM_BB);
  F->insert(It, IfFalseMBB);
  F->insert(It, SinkMBB);

  // Transfer the remainder of ThisMBB and its successor edges to SinkMBB.
  SinkMBB->splice(SinkMBB->begin(), ThisMBB,
                  std::next(MachineBasicBlock::iterator(MI)), ThisMBB->end());
  SinkMBB->transferSuccessorsAndUpdatePHIs(ThisMBB);

  // Set the new successors for ThisMBB.
  ThisMBB->addSuccessor(IfFalseMBB);
  ThisMBB->addSuccessor(SinkMBB);


  BuildMI(ThisMBB, dl, TII.get(BROpcode))
    .addMBB(SinkMBB)
    .add(lhs)
    .add(rhs);
  //LLVM_DEBUG(dbgs() << "HERE");

  // IfFalseMBB just falls through to SinkMBB.
  IfFalseMBB->addSuccessor(SinkMBB);

  // %Result = phi [ %TrueValue, ThisMBB ], [ %FalseValue, IfFalseMBB ]
  BuildMI(*SinkMBB, SinkMBB->begin(), dl, TII.get(URCL::PHI),
          MI.getOperand(0).getReg())
      .addReg(MI.getOperand(1).getReg())
      .addMBB(ThisMBB)
      .addReg(MI.getOperand(2).getReg())
      .addMBB(IfFalseMBB);


  MI.eraseFromParent(); // The pseudo instruction is gone now.
  return SinkMBB;
}