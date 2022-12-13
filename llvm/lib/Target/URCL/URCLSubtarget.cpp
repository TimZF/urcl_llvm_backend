//===-- URCLSubtarget.cpp - URCL Subtarget Information --------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements the URCL specific subclass of TargetSubtargetInfo.
//
//===----------------------------------------------------------------------===//

#include "URCL.h"
#include "URCLSubtarget.h"
#include "URCLMachineFunction.h"
#include "URCLRegisterInfo.h"
#include "URCLTargetMachine.h"
#include "llvm/IR/Attributes.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/MC/TargetRegistry.h"

using namespace llvm;

#define DEBUG_TYPE "urcl-subtarget"

#define GET_SUBTARGETINFO_TARGET_DESC
#define GET_SUBTARGETINFO_CTOR
#include "URCLGenSubtargetInfo.inc"

URCLSubtarget::URCLSubtarget(const Triple &TT, StringRef CPU,
                                StringRef FS,
                               const TargetMachine &TM)
    : URCLGenSubtargetInfo(TT, CPU, CPU, FS),
      TargetTriple(TT),
      InstrInfo(initializeSubtargetDependencies(TT, CPU, CPU, TM)),
      TLInfo(TM, *this),
      TSInfo(),
      FrameLowering(*this)
      { }


URCLSubtarget &
URCLSubtarget::initializeSubtargetDependencies(const Triple &TT, StringRef CPU,
                                                StringRef FS,
                                                const TargetMachine &TM) {
  //UseSoftFloat = true;
  if (CPU.empty())
    CPU = "generic";

  // Parse features string.
  ParseSubtargetFeatures(CPU, CPU, FS);

  return *this;
}