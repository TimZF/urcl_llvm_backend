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


// ---------------------------------------------------------------------------//
// Test 64-bit form (x0) and its aliases
// ---------------------------------------------------------------------------//
uqincb  x0
// CHECK-INST: uqincb  x0
// CHECK-ENCODING: [0xe0,0xf7,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f7e0 <unknown>

uqincb  x0, all
// CHECK-INST: uqincb  x0
// CHECK-ENCODING: [0xe0,0xf7,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f7e0 <unknown>

uqincb  x0, all, mul #1
// CHECK-INST: uqincb  x0
// CHECK-ENCODING: [0xe0,0xf7,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f7e0 <unknown>

uqincb  x0, all, mul #16
// CHECK-INST: uqincb  x0, all, mul #16
// CHECK-ENCODING: [0xe0,0xf7,0x3f,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 043ff7e0 <unknown>


// ---------------------------------------------------------------------------//
// Test 32-bit form (w0) and its aliases
// ---------------------------------------------------------------------------//

uqincb  w0
// CHECK-INST: uqincb  w0
// CHECK-ENCODING: [0xe0,0xf7,0x20,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0420f7e0 <unknown>

uqincb  w0, all
// CHECK-INST: uqincb  w0
// CHECK-ENCODING: [0xe0,0xf7,0x20,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0420f7e0 <unknown>

uqincb  w0, all, mul #1
// CHECK-INST: uqincb  w0
// CHECK-ENCODING: [0xe0,0xf7,0x20,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0420f7e0 <unknown>

uqincb  w0, all, mul #16
// CHECK-INST: uqincb  w0, all, mul #16
// CHECK-ENCODING: [0xe0,0xf7,0x2f,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 042ff7e0 <unknown>

uqincb  w0, pow2
// CHECK-INST: uqincb  w0, pow2
// CHECK-ENCODING: [0x00,0xf4,0x20,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0420f400 <unknown>

uqincb  w0, pow2, mul #16
// CHECK-INST: uqincb  w0, pow2, mul #16
// CHECK-ENCODING: [0x00,0xf4,0x2f,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 042ff400 <unknown>


// ---------------------------------------------------------------------------//
// Test all patterns for 64-bit form
// ---------------------------------------------------------------------------//

uqincb  x0, pow2
// CHECK-INST: uqincb  x0, pow2
// CHECK-ENCODING: [0x00,0xf4,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f400 <unknown>

uqincb  x0, vl1
// CHECK-INST: uqincb  x0, vl1
// CHECK-ENCODING: [0x20,0xf4,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f420 <unknown>

uqincb  x0, vl2
// CHECK-INST: uqincb  x0, vl2
// CHECK-ENCODING: [0x40,0xf4,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f440 <unknown>

uqincb  x0, vl3
// CHECK-INST: uqincb  x0, vl3
// CHECK-ENCODING: [0x60,0xf4,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f460 <unknown>

uqincb  x0, vl4
// CHECK-INST: uqincb  x0, vl4
// CHECK-ENCODING: [0x80,0xf4,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f480 <unknown>

uqincb  x0, vl5
// CHECK-INST: uqincb  x0, vl5
// CHECK-ENCODING: [0xa0,0xf4,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f4a0 <unknown>

uqincb  x0, vl6
// CHECK-INST: uqincb  x0, vl6
// CHECK-ENCODING: [0xc0,0xf4,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f4c0 <unknown>

uqincb  x0, vl7
// CHECK-INST: uqincb  x0, vl7
// CHECK-ENCODING: [0xe0,0xf4,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f4e0 <unknown>

uqincb  x0, vl8
// CHECK-INST: uqincb  x0, vl8
// CHECK-ENCODING: [0x00,0xf5,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f500 <unknown>

uqincb  x0, vl16
// CHECK-INST: uqincb  x0, vl16
// CHECK-ENCODING: [0x20,0xf5,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f520 <unknown>

uqincb  x0, vl32
// CHECK-INST: uqincb  x0, vl32
// CHECK-ENCODING: [0x40,0xf5,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f540 <unknown>

uqincb  x0, vl64
// CHECK-INST: uqincb  x0, vl64
// CHECK-ENCODING: [0x60,0xf5,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f560 <unknown>

uqincb  x0, vl128
// CHECK-INST: uqincb  x0, vl128
// CHECK-ENCODING: [0x80,0xf5,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f580 <unknown>

uqincb  x0, vl256
// CHECK-INST: uqincb  x0, vl256
// CHECK-ENCODING: [0xa0,0xf5,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f5a0 <unknown>

uqincb  x0, #14
// CHECK-INST: uqincb  x0, #14
// CHECK-ENCODING: [0xc0,0xf5,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f5c0 <unknown>

uqincb  x0, #15
// CHECK-INST: uqincb  x0, #15
// CHECK-ENCODING: [0xe0,0xf5,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f5e0 <unknown>

uqincb  x0, #16
// CHECK-INST: uqincb  x0, #16
// CHECK-ENCODING: [0x00,0xf6,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f600 <unknown>

uqincb  x0, #17
// CHECK-INST: uqincb  x0, #17
// CHECK-ENCODING: [0x20,0xf6,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f620 <unknown>

uqincb  x0, #18
// CHECK-INST: uqincb  x0, #18
// CHECK-ENCODING: [0x40,0xf6,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f640 <unknown>

uqincb  x0, #19
// CHECK-INST: uqincb  x0, #19
// CHECK-ENCODING: [0x60,0xf6,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f660 <unknown>

uqincb  x0, #20
// CHECK-INST: uqincb  x0, #20
// CHECK-ENCODING: [0x80,0xf6,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f680 <unknown>

uqincb  x0, #21
// CHECK-INST: uqincb  x0, #21
// CHECK-ENCODING: [0xa0,0xf6,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f6a0 <unknown>

uqincb  x0, #22
// CHECK-INST: uqincb  x0, #22
// CHECK-ENCODING: [0xc0,0xf6,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f6c0 <unknown>

uqincb  x0, #23
// CHECK-INST: uqincb  x0, #23
// CHECK-ENCODING: [0xe0,0xf6,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f6e0 <unknown>

uqincb  x0, #24
// CHECK-INST: uqincb  x0, #24
// CHECK-ENCODING: [0x00,0xf7,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f700 <unknown>

uqincb  x0, #25
// CHECK-INST: uqincb  x0, #25
// CHECK-ENCODING: [0x20,0xf7,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f720 <unknown>

uqincb  x0, #26
// CHECK-INST: uqincb  x0, #26
// CHECK-ENCODING: [0x40,0xf7,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f740 <unknown>

uqincb  x0, #27
// CHECK-INST: uqincb  x0, #27
// CHECK-ENCODING: [0x60,0xf7,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f760 <unknown>

uqincb  x0, #28
// CHECK-INST: uqincb  x0, #28
// CHECK-ENCODING: [0x80,0xf7,0x30,0x04]
// CHECK-ERROR: instruction requires: sve or sme
// CHECK-UNKNOWN: 0430f780 <unknown>
