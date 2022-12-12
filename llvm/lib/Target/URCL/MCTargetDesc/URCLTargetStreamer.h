//===-- URCLTargetStreamer.h - URCL Target Streamer ----------*- C++ -*--===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_URCL_MCTARGETDESC_URCLTARGETSTREAMER_H
#define LLVM_LIB_TARGET_URCL_MCTARGETDESC_URCLTARGETSTREAMER_H

#include "llvm/MC/MCELFStreamer.h"
#include "llvm/MC/MCStreamer.h"

namespace llvm {

class formatted_raw_ostream;

class URCLTargetStreamer : public MCTargetStreamer {
  virtual void anchor();

public:
  URCLTargetStreamer(MCStreamer &S);
  /// Emit ".register <reg>, #ignore".
  virtual void emitURCLRegisterIgnore(unsigned reg){};
  /// Emit ".register <reg>, #scratch".
  virtual void emitURCLRegisterScratch(unsigned reg){};
};

// This part is for ascii assembly output
class URCLTargetAsmStreamer : public URCLTargetStreamer {
  formatted_raw_ostream &OS;

public:
  URCLTargetAsmStreamer(MCStreamer &S, formatted_raw_ostream &OS);
  void emitURCLRegisterIgnore(unsigned reg) override;
  void emitURCLRegisterScratch(unsigned reg) override;
};

// This part is for ELF object output
class URCLTargetELFStreamer : public URCLTargetStreamer {
public:
  URCLTargetELFStreamer(MCStreamer &S);
  MCELFStreamer &getStreamer();
  void emitURCLRegisterIgnore(unsigned reg) override {}
  void emitURCLRegisterScratch(unsigned reg) override {}
};
} // end namespace llvm

#endif
