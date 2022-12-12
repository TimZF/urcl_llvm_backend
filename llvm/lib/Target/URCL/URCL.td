//=== URCL.td - Describe the URCL Target Machine ---------*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// Top tablegen file that pulls in code from the LLVM framework along with
// code specific to this target.
//
//===----------------------------------------------------------------------===//

include "llvm/Target/Target.td"

//===----------------------------------------------------------------------===//
// Calling Conv, Instruction Descriptions, Register information, etc
//===----------------------------------------------------------------------===//

//include "URCLSchedule.td"
include "URCLRegisterInfo.td"
include "URCLCallingConv.td"
include "URCLInstrInfo.td"

def URCLInstrInfo : InstrInfo;

//===----------------------------------------------------------------------===//
// URCL processors supported
//===----------------------------------------------------------------------===//

def : ProcessorModel<"generic",  NoSchedModel, []>;

//===----------------------------------------------------------------------===//
// URCL Target declaration
//===----------------------------------------------------------------------===//

def URCL : Target {
  let InstructionSet = URCLInstrInfo;
}