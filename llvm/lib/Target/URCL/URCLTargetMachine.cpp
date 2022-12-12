//===-- URCLTargetMachine.cpp - Define TargetMachine for URCL -------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// Implements the info about URCL target spec.
//
//===----------------------------------------------------------------------===//

#include "URCLTargetMachine.h"
#include "URCLISelDAGToDAG.h"
#include "URCLSubtarget.h"
#include "URCLTargetObjectFile.h"
#include "TargetInfo/URCLTargetInfo.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/CodeGen/TargetPassConfig.h"
#include "llvm/MC/TargetRegistry.h"

using namespace llvm;

extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeURCLTarget() {
  // Register the target.
  //- Little endian Target Machine
  RegisterTargetMachine<URCLTargetMachine> X(getTheURCLTarget());
}

static std::string computeDataLayout() {
  std::string Ret = "";

  // Little endian
  Ret += "e";
  Ret += "-m:e";
  Ret += "-p:32:32";
  Ret += "-i1:32";
  Ret += "-i8:32";
  Ret += "-i16:32";
  Ret += "-i32:32";
  Ret += "-i64:64";
  Ret += "-a:32";
  Ret += "-n32";
  Ret += "-S32";

  return Ret;
}

static Reloc::Model getEffectiveRelocModel(Optional<CodeModel::Model> CM,
                                           Optional<Reloc::Model> RM) {
  if (!RM.has_value())
    return Reloc::Static;
  return *RM;
}

URCLTargetMachine::URCLTargetMachine(const Target &T, const Triple &TT,
                                       StringRef CPU, StringRef FS,
                                       const TargetOptions &Options,
                                       Optional<Reloc::Model> RM,
                                       Optional<CodeModel::Model> CM,
                                       CodeGenOpt::Level OL,
                                       bool JIT)
    : LLVMTargetMachine(T, computeDataLayout(), TT, CPU, FS, Options,
                        getEffectiveRelocModel(CM, RM),
                        getEffectiveCodeModel(CM, CodeModel::Medium), OL),
      TLOF(std::make_unique<URCLTargetObjectFile>()) {
  // initAsmInfo will display features by llc -march=riscw on 3.7
  initAsmInfo();
}

const URCLSubtarget *
URCLTargetMachine::getSubtargetImpl(const Function &F) const {
  Attribute CPUAttr = F.getFnAttribute("target-cpu");
  Attribute FSAttr = F.getFnAttribute("target-features");

  std::string CPU = !CPUAttr.hasAttribute(Attribute::None)
                        ? CPUAttr.getValueAsString().str()
                        : TargetCPU;
  std::string FS = !FSAttr.hasAttribute(Attribute::None)
                       ? FSAttr.getValueAsString().str()
                       : TargetFS;

  auto &I = SubtargetMap[CPU + FS];
  if (!I) {
    // This needs to be done before we create a new subtarget since any
    // creation will depend on the TM and the code generation flags on the
    // function that reside in TargetOptions.
    resetTargetOptions(F);
    I = std::make_unique<URCLSubtarget>(TargetTriple, CPU, FS, *this);
  }
  return I.get();
}

namespace {
class URCLPassConfig : public TargetPassConfig {
public:
  URCLPassConfig(URCLTargetMachine &TM, PassManagerBase &PM)
    : TargetPassConfig(TM, PM) {}

  URCLTargetMachine &getURCLTargetMachine() const {
    return getTM<URCLTargetMachine>();
  }

  bool addInstSelector() override;
  void addPreEmitPass() override;
};
}

TargetPassConfig *URCLTargetMachine::createPassConfig(PassManagerBase &PM) {
  return new URCLPassConfig(*this, PM);
}

// Install an instruction selector pass using
// the ISelDag to gen URCL code.
bool URCLPassConfig::addInstSelector() {
  addPass(new URCLDAGToDAGISel(getURCLTargetMachine(), getOptLevel()));
  return false;
}

// Implemented by targets that want to run passes immediately before
// machine code is emitted. return true if -print-machineinstrs should
// print out the code after the passes.
void URCLPassConfig::addPreEmitPass() {
}