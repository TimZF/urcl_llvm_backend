//===-- URCLMCAsmInfo.cpp - URCL Asm Properties -------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the declarations of the URCLMCAsmInfo properties.
//
//===----------------------------------------------------------------------===//

#include "URCLMCAsmInfo.h"

#include "llvm/ADT/Triple.h"

using namespace llvm;

void URCLMCAsmInfo::anchor() { }

URCLMCAsmInfo::URCLMCAsmInfo(const Triple &TheTriple) {

  IsLittleEndian = false;
  HasFunctionAlignment        = false;
  HasDotTypeDotSizeDirective  = false;
  HasIdentDirective           = false;
  SupportsDebugInformation    = false;
  UsesDwarfFileAndLocDirectives = false;
  HasSingleParameterDotFile   = false;
  HasFourStringsDotFile       = false;

  Data8bitsDirective          = nullptr;
  Data16bitsDirective         = nullptr;
  Data32bitsDirective         = "\tdw\t";
  Data64bitsDirective         = "\tqw\t";

  PrivateGlobalPrefix         = ".G";
  PrivateLabelPrefix          = ".L";

  LabelSuffix                 = "";

  CommentString               = "//";

  ZeroDirective               = "\t.zero\t";

  UseAssignmentForEHBegin     = true;

  ExceptionsType              = ExceptionHandling::None;//TODO was dwarf but idk
  DwarfRegNumForCFI           = false;
}