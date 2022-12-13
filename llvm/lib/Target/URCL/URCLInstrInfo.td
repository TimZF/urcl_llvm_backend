//== URCLInstrInfo.td - Target Description for URCL Target -*- tablegen -*-=//
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


//  These are target-independent nodes, but have target-specific formats.
def SDT_SPCallSeqStart : SDCallSeqStart<[ SDTCisVT<0, i32>,
                                          SDTCisVT<1, i32> ]>;
def SDT_SPCallSeqEnd   : SDCallSeqEnd<[ SDTCisVT<0, i32>,
                                        SDTCisVT<1, i32> ]>;

// These are target-independent nodes, but have target-specific formats.
def callseq_start : SDNode<"ISD::CALLSEQ_START", SDT_SPCallSeqStart,
                           [SDNPHasChain, SDNPOutGlue]>;
def callseq_end   : SDNode<"ISD::CALLSEQ_END",   SDT_SPCallSeqEnd,
                           [SDNPHasChain, SDNPOptInGlue, SDNPOutGlue]>;

include "URCLInstrFormats.td"

let Defs = [R1], Uses = [R1] in {
def ADJCALLSTACKDOWN : PseudoInst<(outs), (ins i32imm:$amt1, i32imm:$amt2),
                               "!ADJCALLSTACKDOWN $amt1, $amt2",
                               [(callseq_start timm:$amt1, timm:$amt2)]>;
def ADJCALLSTACKUP : PseudoInst<(outs), (ins i32imm:$amt1, i32imm:$amt2),
                            "!ADJCALLSTACKUP $amt1",
                            [(callseq_end timm:$amt1, timm:$amt2)]>;
}


def ADDRrr : ComplexPattern<iPTR, 2, "SelectADDRrr", [], []>;
def ADDRri : ComplexPattern<iPTR, 2, "SelectADDRri", [frameindex], []>;
def memRI : Operand<iPTR> {
  let MIOperandInfo = (ops GPR:$a1, i32imm:$a2);
  let PrintMethod = "printMemOperand";
}
def memRR : Operand<iPTR> {
  let MIOperandInfo = (ops GPR:$a1, GPR:$a2);
  let PrintMethod = "printMemOperand";
}


multiclass TernaryOp<string OpcStr, SDPatternOperator OpNode> {
  def RR  : Instr3<0b000000,
                 (outs GPR:$a1), (ins GPR:$a2, GPR:$a3),
                 !strconcat(OpcStr, " $a1, $a2, $a3"),
                 [(set i32:$a1, (OpNode i32:$a2, i32:$a3))]
                 >;
  def RI  : Instr3<0b000000,
                 (outs GPR:$a1), (ins GPR:$a2, i32imm:$a3),
                 !strconcat(OpcStr, " $a1, $a2, $a3"),
                 [(set i32:$a1, (OpNode i32:$a2, imm:$a3))]
                 >;
  def II  : Instr3<0b000000,
                 (outs GPR:$a1), (ins i32imm:$a2, i32imm:$a3),
                 !strconcat(OpcStr, " $a1, $a2, $a3"),
                 [(set i32:$a1, (OpNode imm:$a2, imm:$a3))]
                 >;
}
let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in{
    let isMoveImm = 1 in{
      def IMMr  : Instr2<0b000000, (outs GPR:$a1), (ins i32imm:$a2),
                          "IMM $a1, $a2", [(set i32:$a1, imm:$a2)]>;
    }

    defm ADD   : TernaryOp<"ADD", add>;
    defm SUB   : TernaryOp<"SUB", sub>;
    defm MUL   : TernaryOp<"MUL", mul>;
    defm OR    : TernaryOp<"OR",  or>;
    defm AND   : TernaryOp<"AND", and>;
    defm SRL   : TernaryOp<"BSR", srl>;
    defm SRA   : TernaryOp<"BSS", sra>;
    defm SHL   : TernaryOp<"BSL", shl>;
}

//def IMMri  : Instr3<0b000000, (outs GPR:$a1), (ins (memRI $a2, $a3):$addr),
//                          "ADD $a1, $addr", [(set i32:$a1, ADDRri:$addr)]>;

let isMoveReg = 1 in{
    def MOVrr  : Instr2<0b000000, (outs GPR:$a1), (ins GPR:$a2),
                              "MOV $a1, $a2", []>;
}



multiclass Store<SDPatternOperator OpNode> {
  def RR  : Instr3<0b000000,
                 (outs), (ins  (memRR $a2, $a3):$addr, GPR:$a1),
                 "LSTR $addr, $a1",
                 [(OpNode i32:$a1, ADDRrr:$addr)]
                 >;
  def RI  : Instr3<0b000000,
                 (outs), (ins (memRI $a2, $a3):$addr, GPR:$a1),
                 "LSTR $addr, $a1",
                 [(OpNode i32:$a1, ADDRri:$addr)]
                 >;
}
multiclass Load<SDPatternOperator OpNode> {
  def RR  : Instr3<0b000000,
                 (outs GPR:$a1), (ins (memRR $a2, $a3):$addr),
                 "LLOD $a1, $addr",
                 [(set i32:$a1, (OpNode ADDRrr:$addr))]
                 >;
  def RI  : Instr3<0b000000,
                 (outs GPR:$a1), (ins (memRI $a2, $a3):$addr),
                 "LLOD $a1, $addr",
                 [(set i32:$a1, (OpNode ADDRri:$addr))]
                 >;
}



defm StoreB   : Store<truncstorei8>;
defm StoreH   : Store<truncstorei16>;
defm Store    : Store<store>;

defm LoadUB : Load<zextloadi8>;
defm LoadUH : Load<zextloadi16>;
defm LoadAB : Load<extloadi8>;
defm LoadAH : Load<extloadi16>;
defm Load   : Load<load>;



def brtarget : Operand<OtherVT>;

def SDT_URCLBrCC    : SDTypeProfile<0,  2,
                      [SDTCisVT<0, OtherVT>, SDTCisVT<1, i32>]>;
def SDT_URCLCondTest: SDTypeProfile<1,  3,
                      [SDTCisVT<0, i32>, SDTCisSameAs<1, 2>, SDTCisVT<3, i32>]>;

def URCLBrCC        : SDNode<"URCLISD::BR_CC", SDT_URCLBrCC,
                              [SDNPHasChain, SDNPOutGlue]>;
def URCLCondTest    : SDNode<"URCLISD::COND_TEST", SDT_URCLCondTest,
                              [SDNPInGlue]>;

let isBranch = 1, isTerminator = 1 in {
  def BRLRI : Instr2<0b000000, (outs), (ins brtarget:$a1, GPR:$a2, i32imm:$a3),
                    "BRL $a1, $a2, $a3",
                    [(URCLBrCC bb:$a1, (URCLCondTest i32:$a2, i32:$a3, 3))]>;

  def BRLII : Instr2<0b000000, (outs), (ins brtarget:$a1, i32imm:$a2, i32imm:$a3),
                    "BRL $a1, $a2, $a3",
                    [(URCLBrCC bb:$a1, (URCLCondTest i32:$a2, i32:$a3, 3))]>;
  def JMP : Instr1<0b000000, (outs), (ins brtarget:$a1), "JMP $a1", [(br bb:$a1)]>;
}






//SELECT_CC for conditional selecting
//gets expanded to a branch
def SDTURCLselectcc : SDTypeProfile<1, 3, [SDTCisSameAs<0, 1>, SDTCisSameAs<1, 2>, SDTCisVT<3, i32>]>;
def URCLselecticc : SDNode<"URCLISD::SELECT_ICC", SDTURCLselectcc, [SDNPOutGlue]>;

let usesCustomInserter = 1 in {
  def SELECT_LESS_IntRRRI
   : PseudoInst<(outs GPR:$dst), (ins GPR:$T, GPR:$F, GPR:$a1, i32imm:$a2),
            "; SELECT_CC_Int PSEUDO!",
            [(set i32:$dst, (URCLselecticc i32:$T, i32:$F, (URCLCondTest i32:$a1, imm:$a2, 3)))]>;
}




def SDT_urclCall    : SDTypeProfile<0, -1, [SDTCisPtrTy<0>]>;
def urcl_call
    : SDNode<"URCLISD::CALL", SDT_urclCall,
             [ SDNPHasChain, SDNPOptInGlue, SDNPOutGlue, SDNPVariadic ]>;
let hasSideEffects = 0, mayLoad = 0, mayStore = 0, Defs = [R1], Uses = [R1] in {
    let isCall = 1 in
        def CALL : Instr1<0b000000, (outs), (ins GPR:$a1), "CAL $a1", [(urcl_call i32:$a1)]>;
}


def URCLRetFlag    : SDNode<"URCLISD::RET_FLAG", SDTNone,
                           [SDNPHasChain, SDNPOptInGlue, SDNPVariadic]>;
let isTerminator = 1, isReturn = 1, isBarrier = 1, Defs = [R1], Uses = [R1]  in {
  def RET : Instr0<0b000000, (outs), (ins variable_ops),  "RET",  [(URCLRetFlag)]>;
}
