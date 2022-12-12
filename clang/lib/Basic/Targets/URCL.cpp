//===--- URCL.cpp - Implement URCL target feature support ---------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements URCLTargetInfo objects.
//
//===----------------------------------------------------------------------===//

#include "URCL.h"
#include "clang/Basic/MacroBuilder.h"
#include "llvm/ADT/StringSwitch.h"

using namespace clang;
using namespace clang::targets;

const char *const URCLTargetInfo::GCCRegNames[] = {
  // Integer registers
  "R0",  "R1",  "R2",  "R3",  "R4",  "R5",  "R6",  "R7",
  "R8",  "R9",  "R10"
};

const TargetInfo::GCCRegAlias GCCRegAliases[] = {
  {{"zero"}, "R0"}, {{"sp"}, "R1"},   {{"t1"}, "R2"},    {{"t2"}, "R3"},
  {{"t3"}, "R4"},   {{"t4"}, "R5"},   {{"t5"}, "R6"},    {{"t6"}, "R7"},
  {{"t7"}, "R8"},   {{"t8"}, "R9"},   {{"t9"}, "R10"}};

ArrayRef<const char *> URCLTargetInfo::getGCCRegNames() const {
  return llvm::makeArrayRef(GCCRegNames);
}

ArrayRef<TargetInfo::GCCRegAlias> URCLTargetInfo::getGCCRegAliases() const {
  return llvm::makeArrayRef(GCCRegAliases);
}

void URCLTargetInfo::getTargetDefines(const LangOptions &Opts,
                                       MacroBuilder &Builder) const {
  // Define the __URCL__ macro when building for this target
  Builder.defineMacro("__URCL__");
}