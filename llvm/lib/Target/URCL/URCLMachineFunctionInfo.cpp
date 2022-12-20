//===-- URCLMachineFunctionInfo.cpp - URCL Machine Function Info --------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "URCLMachineFunctionInfo.h"

using namespace llvm;

void URCLMachineFunctionInfo::anchor() { }

MachineFunctionInfo *URCLMachineFunctionInfo::clone(
    BumpPtrAllocator &Allocator, MachineFunction &DestMF,
    const DenseMap<MachineBasicBlock *, MachineBasicBlock *> &Src2DstMBB)
    const {
  return DestMF.cloneInfo<URCLMachineFunctionInfo>(*this);
}
