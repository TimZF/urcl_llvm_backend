// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sve2 < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sme < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: not llvm-mc -triple=aarch64 -show-encoding < %s 2>&1 \
// RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve2 < %s \
// RUN:        | llvm-objdump -d --mattr=+sve2 - | FileCheck %s --check-prefix=CHECK-INST
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve2 < %s \
// RUN:   | llvm-objdump -d --mattr=-sve2 - | FileCheck %s --check-prefix=CHECK-UNKNOWN

eorbt z0.b, z1.b, z31.b
// CHECK-INST: eorbt z0.b, z1.b, z31.b
// CHECK-ENCODING: [0x20,0x90,0x1f,0x45]
// CHECK-ERROR: instruction requires: sve2 or sme
// CHECK-UNKNOWN: 451f9020 <unknown>

eorbt z0.h, z1.h, z31.h
// CHECK-INST: eorbt z0.h, z1.h, z31.h
// CHECK-ENCODING: [0x20,0x90,0x5f,0x45]
// CHECK-ERROR: instruction requires: sve2 or sme
// CHECK-UNKNOWN: 455f9020 <unknown>

eorbt z0.s, z1.s, z31.s
// CHECK-INST: eorbt z0.s, z1.s, z31.s
// CHECK-ENCODING: [0x20,0x90,0x9f,0x45]
// CHECK-ERROR: instruction requires: sve2 or sme
// CHECK-UNKNOWN: 459f9020 <unknown>

eorbt z0.d, z1.d, z31.d
// CHECK-INST: eorbt z0.d, z1.d, z31.d
// CHECK-ENCODING: [0x20,0x90,0xdf,0x45]
// CHECK-ERROR: instruction requires: sve2 or sme
// CHECK-UNKNOWN: 45df9020 <unknown>


// --------------------------------------------------------------------------//
// Test compatibility with MOVPRFX instruction.

movprfx z0, z7
// CHECK-INST: movprfx	z0, z7
// CHECK-ENCODING: [0xe0,0xbc,0x20,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0420bce0 <unknown>

eorbt z0.d, z1.d, z31.d
// CHECK-INST: eorbt z0.d, z1.d, z31.d
// CHECK-ENCODING: [0x20,0x90,0xdf,0x45]
// CHECK-ERROR: instruction requires: sve2 or sme
// CHECK-UNKNOWN: 45df9020 <unknown>
