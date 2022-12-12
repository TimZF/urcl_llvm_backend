
#include "URCLMCTargetDesc.h"
#include "URCLInstPrinter.h"
#include "URCLMCAsmInfo.h"
#include "TargetInfo/URCLTargetInfo.h"
#include "llvm/MC/MCELFStreamer.h"
#include "llvm/MC/MCInstrAnalysis.h"
#include "llvm/MC/MCInstPrinter.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/TargetRegistry.h"

using namespace llvm;

#define GET_INSTRINFO_MC_DESC
#include "URCLGenInstrInfo.inc"

#define GET_SUBTARGETINFO_MC_DESC
#include "URCLGenSubtargetInfo.inc"

#define GET_REGINFO_MC_DESC
#include "URCLGenRegisterInfo.inc"

static MCInstrInfo *createURCLMCInstrInfo() {
  MCInstrInfo *X = new MCInstrInfo();
  InitURCLMCInstrInfo(X);
  return X;
}

static MCRegisterInfo *createURCLMCRegisterInfo(const Triple &TT) {
  MCRegisterInfo *X = new MCRegisterInfo();
  return X;
}



static MCSubtargetInfo *
createURCLMCSubtargetInfo(const Triple &TT, StringRef CPU, StringRef FS) {
  if (CPU.empty())
    CPU = "generic";
  return createURCLMCSubtargetInfoImpl(TT, CPU, CPU, FS);
}

static MCInstPrinter *createURCLMCInstPrinter(const Triple &T,
                                               unsigned SyntaxVariant,
                                               const MCAsmInfo &MAI,
                                               const MCInstrInfo &MII,
                                               const MCRegisterInfo &MRI) {
  return new URCLInstPrinter(MAI, MII, MRI);
}

static MCAsmInfo *createURCLMCAsmInfo(const MCRegisterInfo &MRI,
                                       const Triple &TT,
                                       const MCTargetOptions &Options) {
  MCAsmInfo *MAI = new URCLMCAsmInfo(TT);

  unsigned WP = MRI.getDwarfRegNum(URCL::R2, true);
  MCCFIInstruction Inst = MCCFIInstruction::cfiDefCfa(nullptr, WP, 0);
  MAI->addInitialFrameState(Inst);

  return MAI;
}

extern "C" void LLVMInitializeURCLTargetMC() {
  for (Target *T : {&getTheURCLTarget()}) {
    // Register the MC asm info.
    TargetRegistry::RegisterMCAsmInfo(*T, createURCLMCAsmInfo);

    // Register the MC instruction info.
    TargetRegistry::RegisterMCInstrInfo(*T, createURCLMCInstrInfo);

    // Register the MC register info.
    TargetRegistry::RegisterMCRegInfo(*T, createURCLMCRegisterInfo);

    // Register the MC subtarget info.
    TargetRegistry::RegisterMCSubtargetInfo(*T, createURCLMCSubtargetInfo);

    // Register the MCInstPrinter.
    TargetRegistry::RegisterMCInstPrinter(*T, createURCLMCInstPrinter);
  }
}
