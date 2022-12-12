add_llvm_component_group(URCL)

set(LLVM_TARGET_DEFINITIONS URCL.td)

tablegen(LLVM URCLGenMCPseudoLowering.inc -gen-pseudo-lowering)
tablegen(LLVM URCLGenAsmWriter.inc -gen-asm-writer)
tablegen(LLVM URCLGenCallingConv.inc -gen-callingconv)
tablegen(LLVM URCLGenDAGISel.inc -gen-dag-isel)
tablegen(LLVM URCLGenInstrInfo.inc -gen-instr-info)
tablegen(LLVM URCLGenCodeEmitter.inc -gen-emitter)
tablegen(LLVM URCLGenMCCodeEmitter.inc -gen-emitter)
tablegen(LLVM URCLGenRegisterInfo.inc -gen-register-info)
tablegen(LLVM URCLGenSubtargetInfo.inc -gen-subtarget)

add_public_tablegen_target(URCLCommonTableGen)

add_llvm_target(URCLCodeGen
  URCLAsmPrinter.cpp
  URCLFrameLowering.cpp
  URCLInstrInfo.cpp
  URCLISelLowering.cpp
  URCLRegisterInfo.cpp
  URCLSubtarget.cpp
  URCLTargetObjectFile.cpp
  URCLISelDAGToDAG.cpp
  URCLTargetMachine.cpp
  URCLMCInstLower.cpp

  LINK_COMPONENTS
  AsmPrinter
  CodeGen
  Core
  MC
  SelectionDAG
  URCLDesc
  URCLInfo
  Support
  Target

  ADD_TO_COMPONENT
  URCL
)

add_subdirectory(TargetInfo)
add_subdirectory(MCTargetDesc)