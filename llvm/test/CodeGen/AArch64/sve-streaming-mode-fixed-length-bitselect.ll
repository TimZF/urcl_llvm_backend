; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -force-streaming-compatible-sve < %s | FileCheck %s

target triple = "aarch64"

;
; NOTE: SVE lowering for the BSP pseudoinst is not currently implemented, so we
;       don't currently expect the code below to lower to BSL/BIT/BIF. Once
;       this is implemented, this test will be fleshed out.
;

define <8 x i32> @fixed_bitselect_v8i32(ptr %pre_cond_ptr, ptr %left_ptr, ptr %right_ptr) #0 {
; CHECK-LABEL: fixed_bitselect_v8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI0_0
; CHECK-NEXT:    ldp q1, q0, [x0]
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI0_0]
; CHECK-NEXT:    adrp x8, .LCPI0_1
; CHECK-NEXT:    ldp q3, q4, [x1]
; CHECK-NEXT:    sub z6.s, z2.s, z1.s
; CHECK-NEXT:    sub z2.s, z2.s, z0.s
; CHECK-NEXT:    and z3.d, z6.d, z3.d
; CHECK-NEXT:    ldp q7, q16, [x2]
; CHECK-NEXT:    and z2.d, z2.d, z4.d
; CHECK-NEXT:    ldr q5, [x8, :lo12:.LCPI0_1]
; CHECK-NEXT:    add z1.s, z1.s, z5.s
; CHECK-NEXT:    add z0.s, z0.s, z5.s
; CHECK-NEXT:    and z4.d, z0.d, z16.d
; CHECK-NEXT:    and z0.d, z1.d, z7.d
; CHECK-NEXT:    orr z0.d, z0.d, z3.d
; CHECK-NEXT:    orr z1.d, z4.d, z2.d
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    // kill: def $q1 killed $q1 killed $z1
; CHECK-NEXT:    ret
  %pre_cond = load <8 x i32>, ptr %pre_cond_ptr
  %left = load <8 x i32>, ptr %left_ptr
  %right = load <8 x i32>, ptr %right_ptr

  %neg_cond = sub <8 x i32> zeroinitializer, %pre_cond
  %min_cond = add <8 x i32> %pre_cond, <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>
  %left_bits_0 = and <8 x i32> %neg_cond, %left
  %right_bits_0 = and <8 x i32> %min_cond, %right
  %bsl0000 = or <8 x i32> %right_bits_0, %left_bits_0
  ret <8 x i32> %bsl0000
}

attributes #0 = { "target-features"="+sve" }
