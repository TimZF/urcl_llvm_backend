//=== URCLInstrFormats.td - URCL Instruction Formats -----*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//



class Inst<dag outs, dag ins, string asmstr, list<dag> pattern>
    : Instruction {
  field bits<128> Inst;
  //field bits<128> SoftFail = 0;

  let Size = 16;
  bits<6> Opcode = 0;
  let Inst{5-0} = Opcode;

  let Namespace = "URCL";

  dag OutOperandList = outs;
  dag InOperandList = ins;
  let AsmString = asmstr;
  let Pattern = pattern;

}

// Pseudo instructions
class PseudoInst<dag outs, dag ins, string asmstr = "", list<dag> pattern>
: Inst<outs, ins, asmstr, pattern>, Sched<[]>
{
  let isPseudo = 1;
  let isCodeGenOnly = 1;
}


class Instr3<bits<6> opcode, dag outs, dag ins, string asmstr, list<dag> pattern>
: Inst<outs, ins, asmstr, pattern>
{
  bits<32> a1;
  bits<32> a2;
  bits<32> a3;

  let Inst{127-96} = a3;
  let Inst{95-64} = a2;
  let Inst{63-32} = a1;
  let Opcode = opcode;
}

class Instr2<bits<6> opcode, dag outs, dag ins, string asmstr, list<dag> pattern>
: Inst<outs, ins, asmstr, pattern>
{
  bits<32> a1;
  bits<32> a2;

  let Inst{127-96} = 0 ;
  let Inst{95-64} = a2;
  let Inst{63-32} = a1;
  let Opcode = opcode;
}

class Instr1<bits<6> opcode, dag outs, dag ins, string asmstr, list<dag> pattern>
: Inst<outs, ins, asmstr, pattern>
{
  bits<32> a1;

  let Inst{127-96} = 0 ;
  let Inst{95-64} = 0;
  let Inst{63-32} = a1;
  let Opcode = opcode;
}

class Instr0<bits<6> opcode, dag outs, dag ins, string asmstr, list<dag> pattern>
: Inst<outs, ins, asmstr, pattern>
{
  let Inst{127-96} = 0 ;
  let Inst{95-64} = 0;
  let Inst{63-32} = 0;
  let Opcode = opcode;
}


