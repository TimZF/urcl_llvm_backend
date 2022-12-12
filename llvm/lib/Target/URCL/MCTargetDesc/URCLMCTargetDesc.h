//===-- URCLMCTargetDesc.h - URCL Target Descriptions ---------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file provides URCL specific target descriptions.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_URCL_MCTARGETDESC_URCLMCTARGETDESC_H
#define LLVM_LIB_TARGET_URCL_MCTARGETDESC_URCLMCTARGETDESC_H

// Defines symbolic names for URCL registers. This defines a mapping from
// register name to register number.
#define GET_REGINFO_ENUM
#include "URCLGenRegisterInfo.inc"

// Defines symbolic names for the URCL instructions.
#define GET_INSTRINFO_ENUM
#include "URCLGenInstrInfo.inc"

#define GET_SUBTARGETINFO_ENUM
#include "URCLGenSubtargetInfo.inc"

#endif // end LLVM_LIB_TARGET_URCL_MCTARGETDESC_URCLMCTARGETDESC_H