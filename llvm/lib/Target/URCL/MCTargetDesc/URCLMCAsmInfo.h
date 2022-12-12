//===-- URCLMCAsmInfo.h - URCL Asm Info ------------------------*- C++ -*--===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the declaration of the URCLMCAsmInfo class.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_URCL_MCTARGETDESC_URCLMCASMINFO_H
#define LLVM_LIB_TARGET_URCL_MCTARGETDESC_URCLMCASMINFO_H

#include "llvm/MC/MCAsmInfoELF.h"

namespace llvm {
  class Triple;

class URCLMCAsmInfo : public MCAsmInfoELF {
  void anchor() override;

public:
  explicit URCLMCAsmInfo(const Triple &TheTriple);
};

} // namespace llvm

#endif // end LLVM_LIB_TARGET_URCL_MCTARGETDESC_URCLMCASMINFO_H