//===-- URCLTargetInfo.cpp - URCL Target Implementation -----------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "TargetInfo/URCLTargetInfo.h"
#include "llvm/MC/TargetRegistry.h"

using namespace llvm;

Target &llvm::getTheURCLTarget() {
  static Target TheURCLTarget;
  return TheURCLTarget;
}

extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeURCLTargetInfo() {
  RegisterTarget<Triple::urcl> X(getTheURCLTarget(), "urcl",
                                  "32-bit URCL", "URCL");
}