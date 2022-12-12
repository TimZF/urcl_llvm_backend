//===-- URCLRegisterInfo.td - URCL Register defs ---------*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
//  Declarations that describe the RISC-W register file
//===----------------------------------------------------------------------===//

let Namespace = "URCL" in {
class URCLReg<bits<16> Enc, string n, list<string> alt = []> : Register<n> {
  let HWEncoding = Enc;
  let AltNames = alt;
}
} // end Namespace

def R0  : URCLReg<0, "R0", ["zero"]>, DwarfRegNum<[0]>;
def R1  : URCLReg<1, "R1", ["sp"]>, DwarfRegNum<[1]>;
def R2  : URCLReg<2, "R2", ["gp"]>, DwarfRegNum<[2]>;
def R3  : URCLReg<3, "R3", ["tp"]>, DwarfRegNum<[3]>;
def R4  : URCLReg<4, "R4", ["t0"]>, DwarfRegNum<[4]>;
def R5  : URCLReg<5, "R5", ["t1"]>, DwarfRegNum<[5]>;
def R6  : URCLReg<6, "R6", ["t2"]>, DwarfRegNum<[6]>;
def R7  : URCLReg<7, "R7", ["t3"]>, DwarfRegNum<[7]>;
def R8  : URCLReg<8, "R8", ["t4"]>, DwarfRegNum<[8]>;
def R9  : URCLReg<9, "R9", ["t5"]>, DwarfRegNum<[9]>;
def R10 : URCLReg<10,"R10", ["t6"]>, DwarfRegNum<[10]>;

// The order of registers represents the preferred allocation sequence.
// Registers are listed in the order caller-save, callee-save, specials.
def GPR : RegisterClass<"URCL", [i32], 32, (add R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10)>;

def SP : RegisterClass<"URCL", [i32], 32, (add R1)>;