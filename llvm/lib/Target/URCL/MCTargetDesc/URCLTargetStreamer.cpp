//===-- URCLTargetStreamer.cpp - URCL Target Streamer Methods -----------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file provides URCL specific target streamer methods.
//
//===----------------------------------------------------------------------===//

#include "URCLTargetStreamer.h"
#include "URCLInstPrinter.h"
#include "llvm/Support/FormattedStream.h"

using namespace llvm;

// pin vtable to this file
URCLTargetStreamer::URCLTargetStreamer(MCStreamer &S) : MCTargetStreamer(S) {}

void URCLTargetStreamer::anchor() {}

URCLTargetAsmStreamer::URCLTargetAsmStreamer(MCStreamer &S,
                                               formatted_raw_ostream &OS)
    : URCLTargetStreamer(S), OS(OS) {}

void URCLTargetAsmStreamer::emitURCLRegisterIgnore(unsigned reg) {
  OS << "\t.register "
     << StringRef(URCLInstPrinter::getRegisterName(reg))
     << ", #ignore\n";
}

void URCLTargetAsmStreamer::emitURCLRegisterScratch(unsigned reg) {
  OS << "\t.register "
     << StringRef(URCLInstPrinter::getRegisterName(reg))
     << ", #scratch\n";
}

URCLTargetELFStreamer::URCLTargetELFStreamer(MCStreamer &S)
    : URCLTargetStreamer(S) {}

MCELFStreamer &URCLTargetELFStreamer::getStreamer() {
  return static_cast<MCELFStreamer &>(Streamer);
}
