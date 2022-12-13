//===-- URCLInstPrinter.cpp - Convert URCL MCInst to assembly syntax ----===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This class prints an URCL MCInst to a .s file.
//
//===----------------------------------------------------------------------===//

#include "URCLInstPrinter.h"

#include "URCLInstrInfo.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
using namespace llvm;

#define DEBUG_TYPE "urcl-isel"

#define PRINT_ALIAS_INSTR
#include "URCLGenAsmWriter.inc"


void URCLInstPrinter::printRegName(raw_ostream &OS, unsigned RegNo) const
{
  OS << StringRef(getRegisterName(RegNo));
}

void URCLInstPrinter::printInst(const MCInst *MI, uint64_t Address,
                                 StringRef Annot,
                                 const MCSubtargetInfo &STI,
                                 raw_ostream &O) {
  if (!printAliasInstr(MI, Address, O))
    printInstruction(MI, Address, O);
  printAnnotation(O, Annot);
}
void URCLInstPrinter::printOperand(const MCInst *MI, int opNum,
                                    raw_ostream &O) {
  const MCOperand &MO = MI->getOperand (opNum);

  if (MO.isReg()) {
    printRegName(O, MO.getReg());
    return ;
  }

  if (MO.isImm()) {
      O << (int)MO.getImm();
      return ;
  }

  if(MO.isExpr()){
    MO.getExpr()->print(O, &MAI);
    return ;
  }

  printf("Unkwn Operand SymRef:%d, DFPImm:%d, Inst:%d, SFPImm:%d, Reg:%d, Imm:%d, VALID: %d",
          MO.isBareSymbolRef(), MO.isDFPImm(), MO.isInst(), MO.isSFPImm(), MO.isReg(), MO.isImm(), MO.isValid());
  assert(false && "Unknown operand kind in printOperand");
}


void URCLInstPrinter::printMemOperand(const MCInst *MI, int opNum,
                                       raw_ostream &O, const char *Modifier) {
  printOperand(MI, opNum, O);
  O << ", ";
  printOperand(MI, opNum + 1, O);
}


void URCLInstPrinter::printCCOperand(const MCInst *MI, int opNum, raw_ostream &O) {
  int CC = (int)MI->getOperand(opNum).getImm();
  if (CC > 16) {
    llvm_unreachable("FIXME: Implement other");
  }
  O << URCLCondCodeToString((URCL::CondCodes)CC);
}