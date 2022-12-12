//===-- URCLAsmPrinter.cpp - URCL LLVM assembly writer ------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains a printer that converts from our internal representation
// of machine-dependent LLVM code to the XAS-format URCL assembly language.
//
//===----------------------------------------------------------------------===//

#define DEBUG_TYPE "asm-printer"
#include "URCL.h"
#include "MCTargetDesc/URCLInstPrinter.h"
#include "URCLInstrInfo.h"
#include "URCLMCInstLower.h"
#include "MCTargetDesc/URCLTargetStreamer.h"
//#include "URCLTargetInfo.h"
#include "TargetInfo/URCLTargetInfo.h"
#include "URCLSubtarget.h"
#include "URCLTargetMachine.h"
#include "llvm/ADT/SmallString.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/CodeGen/AsmPrinter.h"
#include "llvm/CodeGen/MachineConstantPool.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/CodeGen/MachineJumpTableInfo.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/DebugInfo.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Mangler.h"
#include "llvm/IR/Module.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Target/TargetLoweringObjectFile.h"
#include <algorithm>
#include <cctype>
#include <string>
using namespace llvm;

namespace {
class URCLAsmPrinter : public AsmPrinter {

public:
  explicit URCLAsmPrinter(TargetMachine &TM,
                         std::unique_ptr<MCStreamer> Streamer)
      : AsmPrinter(TM, std::move(Streamer)) {}

  virtual StringRef getPassName() const override { return "URCL Assembly Printer"; }

  void emitFunctionEntryLabel() override;
  void emitInstruction(const MachineInstr *MI) override;
  void emitFunctionBodyStart() override;
  void emitFunctionDescriptor() override {};
  void emitStartOfAsmFile(Module &M) override {
    OutStreamer->emitRawText("BITS == 32\n");
    OutStreamer->emitRawText("MINHEAP 128\n");
    OutStreamer->emitRawText("MINSTACK 128\n");
    OutStreamer->emitRawText("MOV R1, SP\n");
    OutStreamer->emitRawText("CALL .main\n");
    OutStreamer->emitRawText("HLT\n");
  };
};
} // end of anonymous namespace


void URCLAsmPrinter::emitFunctionBodyStart() {

}



void URCLAsmPrinter::emitFunctionEntryLabel() {
  std::string strRef = CurrentFnSym->getName().str();
  strRef.insert(0, ".");
  MCSymbol* sym = this->OutContext.getOrCreateSymbol(strRef);
  OutStreamer->emitLabel(sym);
}



void URCLAsmPrinter::emitInstruction(const MachineInstr *MI) {
  MachineBasicBlock::const_instr_iterator I = MI->getIterator();
  MachineBasicBlock::const_instr_iterator E = MI->getParent()->instr_end();
  do {
    MCInst TmpInst;
    LowerURCLMachineInstrToMCInst(&*I, TmpInst, *this);
    EmitToStreamer(*OutStreamer, TmpInst);
  } while ((++I != E) && I->isInsideBundle()); // Delay slot check.
}

// Force static initialization.
extern "C" void LLVMInitializeURCLAsmPrinter() {
  RegisterAsmPrinter<URCLAsmPrinter> X(getTheURCLTarget());
}