//=== URCL.h - Top-level interface for URCL representation ----*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the entry points for global functions defined in
// the LLVM URCL backend.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_URCL_URCL_H
#define LLVM_LIB_TARGET_URCL_URCL_H

#include "MCTargetDesc/URCLMCTargetDesc.h"
#include "llvm/Target/TargetMachine.h"

namespace llvm {
  class FunctionPass;
    namespace URCL{
      enum CondCodes {
      ICC_A   =  8   ,  // Always
      ICC_N   =  0   ,  // Never
      ICC_NE  =  9   ,  // Not Equal
      ICC_E   =  1   ,  // Equal
      ICC_G   = 10   ,  // Greater
      ICC_LE  =  2   ,  // Less or Equal
      ICC_GE  = 11   ,  // Greater or Equal
      ICC_L   =  3   ,  // Less
      ICC_GU  = 12   ,  // Greater Unsigned
      ICC_LEU =  4   ,  // Less or Equal Unsigned
      ICC_CC  = 13   ,  // Carry Clear/Great or Equal Unsigned
      ICC_CS  =  5   ,  // Carry Set/Less Unsigned
      ICC_POS = 14   ,  // Positive
      ICC_NEG =  6   ,  // Negative
      ICC_VC  = 15   ,  // Overflow Clear
      ICC_VS  =  7   ,  // Overflow Set
      };


    }

  inline static const char *URCLCondCodeToString(URCL::CondCodes CC) {
    switch (CC) {
        case URCL::ICC_A:   return "JMP";
        case URCL::ICC_N:   return "IDK";
        case URCL::ICC_NE:  return "BNE";
        case URCL::ICC_E:   return "BEQ";
        case URCL::ICC_G:   return "SBRG";
        case URCL::ICC_LE:  return "SBLE";
        case URCL::ICC_GE:  return "SBGE";
        case URCL::ICC_L:   return "SBRL";
        case URCL::ICC_GU:  return "BRG";
        case URCL::ICC_LEU: return "BLE";
        case URCL::ICC_CC:  return "BGE";
        case URCL::ICC_CS:  return "BRL";
        case URCL::ICC_POS: return "BRP";
        case URCL::ICC_NEG: return "BRN";
        case URCL::ICC_VC:  return "BNC";
        case URCL::ICC_VS:  return "BRC";
    };
    llvm_unreachable("URCL.h failed to encode condition");
  }
} // end namespace llvm;

#endif // end LLVM_LIB_TARGET_URCL_URCL_H