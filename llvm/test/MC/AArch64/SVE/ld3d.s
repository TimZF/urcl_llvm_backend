// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sve < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sme < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: not llvm-mc -triple=aarch64 -show-encoding < %s 2>&1 \
// RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:        | llvm-objdump --no-print-imm-hex -d --mattr=+sve - | FileCheck %s --check-prefix=CHECK-INST
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:   | llvm-objdump --no-print-imm-hex -d --mattr=-sve - | FileCheck %s --check-prefix=CHECK-UNKNOWN

ld3d    { z0.d, z1.d, z2.d }, p0/z, [x0, x0, lsl #3]
// CHECK-INST: ld3d    { z0.d - z2.d }, p0/z, [x0, x0, lsl #3]
// CHECK-ENCODING: [0x00,0xc0,0xc0,0xa5]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: a5c0c000 <unknown>

ld3d    { z5.d, z6.d, z7.d }, p3/z, [x17, x16, lsl #3]
// CHECK-INST: ld3d    { z5.d - z7.d }, p3/z, [x17, x16, lsl #3]
// CHECK-ENCODING: [0x25,0xce,0xd0,0xa5]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: a5d0ce25 <unknown>

ld3d    { z0.d, z1.d, z2.d }, p0/z, [x0]
// CHECK-INST: ld3d    { z0.d - z2.d }, p0/z, [x0]
// CHECK-ENCODING: [0x00,0xe0,0xc0,0xa5]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: a5c0e000 <unknown>

ld3d    { z23.d, z24.d, z25.d }, p3/z, [x13, #-24, mul vl]
// CHECK-INST: ld3d    { z23.d - z25.d }, p3/z, [x13, #-24, mul vl]
// CHECK-ENCODING: [0xb7,0xed,0xc8,0xa5]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: a5c8edb7 <unknown>

ld3d    { z21.d, z22.d, z23.d }, p5/z, [x10, #15, mul vl]
// CHECK-INST: ld3d    { z21.d - z23.d }, p5/z, [x10, #15, mul vl]
// CHECK-ENCODING: [0x55,0xf5,0xc5,0xa5]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: a5c5f555 <unknown>
