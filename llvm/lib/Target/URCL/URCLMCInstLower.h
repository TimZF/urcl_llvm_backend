#include "URCL.h"
#include "llvm/CodeGen/AsmPrinter.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/CodeGen/MachineOperand.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"

namespace llvm{
//static MCOperand LowerOperand(const MachineInstr *MI,
//                              const MachineOperand &MO,
//                              AsmPrinter &AP);

//static MCOperand LowerSymbolOperand(const MachineInstr *MI,
//                                    const MachineOperand &MO,
//                                    AsmPrinter &AP);

void LowerURCLMachineInstrToMCInst(const MachineInstr *MI,
                                  MCInst &OutMI,
                                  AsmPrinter &AP);
}