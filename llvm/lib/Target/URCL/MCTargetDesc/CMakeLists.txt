add_llvm_component_library(LLVMURCLDesc
  URCLMCAsmInfo.cpp
  URCLMCTargetDesc.cpp
  URCLInstPrinter.cpp
  URCLTargetStreamer.cpp

  LINK_COMPONENTS
  MC
  URCLInfo
  Support

  ADD_TO_COMPONENT
  URCL
)