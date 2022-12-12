//=== URCLMachineFunctionInfo.h - Private data used for URCL ----*- C++ -*-=//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file declares the URCL specific subclass of MachineFunctionInfo.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_URCL_URCLMACHINEFUNCTION_H
#define LLVM_LIB_TARGET_URCL_URCLMACHINEFUNCTION_H

#include "llvm/CodeGen/MachineFunction.h"

namespace llvm {

/// URCLFunctionInfo - This class is derived from MachineFunction private
/// URCL target-specific information for each MachineFunction.
class URCLFunctionInfo : public MachineFunctionInfo {
private:
  MachineFunction &MF;
  Register sret;

public:
  URCLFunctionInfo(MachineFunction &MF) : MF(MF) {}
  void setSRetReturnReg(Register reg){sret = reg;};
  Register getSRetReturnReg(){return sret;};
};

} // end of namespace llvm

#endif // end LLVM_LIB_TARGET_URCL_URCLMACHINEFUNCTION_H