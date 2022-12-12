//=== URCLCallingConv.td - Calling Conventions for URCL --*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
// This describes the calling conventions for URCL architecture.
//===----------------------------------------------------------------------===//

def CC_URCL : CallingConv<[
  CCIfByVal<CCPassByVal<4, 4>>,
  CCIfType<[i1, i8, i16], CCPromoteToType<i32>>,
  CCIfType<[i32], CCAssignToReg<[R2, R3, R4, R5]>>,
  CCIfType<[i32], CCAssignToStack<4, 4>>
]>;


def RetCC_URCL : CallingConv<[
  CCIfType<[i1, i8, i16], CCPromoteToType<i32>>,
  CCIfType<[i32], CCAssignToReg<[R2, R3, R4, R5]>>,
  CCIfType<[i32], CCAssignToStack<4, 4>>
]>;

def URCL_CalleeSavedRegs : CalleeSavedRegs<(add R6, R7, R8, R9, R10)>;