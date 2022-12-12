add_llvm_component_library(LLVMURCLInfo
  URCLTargetInfo.cpp

  LINK_COMPONENTS
  #MC
  Support

  ADD_TO_COMPONENT
  URCL
  )
