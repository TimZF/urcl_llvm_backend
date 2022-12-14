; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -force-streaming-compatible-sve < %s | FileCheck %s


target triple = "aarch64-unknown-linux-gnu"

;
; DUP (integer)
;

define <4 x i8> @splat_v4i8(i8 %a) #0 {
; CHECK-LABEL: splat_v4i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    strh w0, [sp, #14]
; CHECK-NEXT:    strh w0, [sp, #12]
; CHECK-NEXT:    strh w0, [sp, #10]
; CHECK-NEXT:    strh w0, [sp, #8]
; CHECK-NEXT:    ldr d0, [sp, #8]
; CHECK-NEXT:    add sp, sp, #16
; CHECK-NEXT:    ret
  %insert = insertelement <4 x i8> undef, i8 %a, i64 0
  %splat = shufflevector <4 x i8> %insert, <4 x i8> undef, <4 x i32> zeroinitializer
  ret <4 x i8> %splat
}

define <8 x i8> @splat_v8i8(i8 %a) #0 {
; CHECK-LABEL: splat_v8i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    strb w0, [sp, #15]
; CHECK-NEXT:    strb w0, [sp, #14]
; CHECK-NEXT:    strb w0, [sp, #13]
; CHECK-NEXT:    strb w0, [sp, #12]
; CHECK-NEXT:    strb w0, [sp, #11]
; CHECK-NEXT:    strb w0, [sp, #10]
; CHECK-NEXT:    strb w0, [sp, #9]
; CHECK-NEXT:    strb w0, [sp, #8]
; CHECK-NEXT:    ldr d0, [sp, #8]
; CHECK-NEXT:    add sp, sp, #16
; CHECK-NEXT:    ret
  %insert = insertelement <8 x i8> undef, i8 %a, i64 0
  %splat = shufflevector <8 x i8> %insert, <8 x i8> undef, <8 x i32> zeroinitializer
  ret <8 x i8> %splat
}

define <16 x i8> @splat_v16i8(i8 %a) #0 {
; CHECK-LABEL: splat_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    strb w0, [sp, #15]
; CHECK-NEXT:    strb w0, [sp, #14]
; CHECK-NEXT:    strb w0, [sp, #13]
; CHECK-NEXT:    strb w0, [sp, #12]
; CHECK-NEXT:    strb w0, [sp, #11]
; CHECK-NEXT:    strb w0, [sp, #10]
; CHECK-NEXT:    strb w0, [sp, #9]
; CHECK-NEXT:    strb w0, [sp, #8]
; CHECK-NEXT:    strb w0, [sp, #7]
; CHECK-NEXT:    strb w0, [sp, #6]
; CHECK-NEXT:    strb w0, [sp, #5]
; CHECK-NEXT:    strb w0, [sp, #4]
; CHECK-NEXT:    strb w0, [sp, #3]
; CHECK-NEXT:    strb w0, [sp, #2]
; CHECK-NEXT:    strb w0, [sp, #1]
; CHECK-NEXT:    strb w0, [sp]
; CHECK-NEXT:    ldr q0, [sp], #16
; CHECK-NEXT:    ret
  %insert = insertelement <16 x i8> undef, i8 %a, i64 0
  %splat = shufflevector <16 x i8> %insert, <16 x i8> undef, <16 x i32> zeroinitializer
  ret <16 x i8> %splat
}

define void @splat_v32i8(i8 %a, <32 x i8>* %b) #0 {
; CHECK-LABEL: splat_v32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    strb w0, [sp, #15]
; CHECK-NEXT:    strb w0, [sp, #14]
; CHECK-NEXT:    strb w0, [sp, #13]
; CHECK-NEXT:    strb w0, [sp, #12]
; CHECK-NEXT:    strb w0, [sp, #11]
; CHECK-NEXT:    strb w0, [sp, #10]
; CHECK-NEXT:    strb w0, [sp, #9]
; CHECK-NEXT:    strb w0, [sp, #8]
; CHECK-NEXT:    strb w0, [sp, #7]
; CHECK-NEXT:    strb w0, [sp, #6]
; CHECK-NEXT:    strb w0, [sp, #5]
; CHECK-NEXT:    strb w0, [sp, #4]
; CHECK-NEXT:    strb w0, [sp, #3]
; CHECK-NEXT:    strb w0, [sp, #2]
; CHECK-NEXT:    strb w0, [sp, #1]
; CHECK-NEXT:    strb w0, [sp]
; CHECK-NEXT:    ldr q0, [sp]
; CHECK-NEXT:    stp q0, q0, [x1]
; CHECK-NEXT:    add sp, sp, #16
; CHECK-NEXT:    ret
  %insert = insertelement <32 x i8> undef, i8 %a, i64 0
  %splat = shufflevector <32 x i8> %insert, <32 x i8> undef, <32 x i32> zeroinitializer
  store <32 x i8> %splat, <32 x i8>* %b
  ret void
}

define <2 x i16> @splat_v2i16(i16 %a) #0 {
; CHECK-LABEL: splat_v2i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    stp w0, w0, [sp, #8]
; CHECK-NEXT:    ldr d0, [sp, #8]
; CHECK-NEXT:    add sp, sp, #16
; CHECK-NEXT:    ret
  %insert = insertelement <2 x i16> undef, i16 %a, i64 0
  %splat = shufflevector <2 x i16> %insert, <2 x i16> undef, <2 x i32> zeroinitializer
  ret <2 x i16> %splat
}

define <4 x i16> @splat_v4i16(i16 %a) #0 {
; CHECK-LABEL: splat_v4i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    strh w0, [sp, #14]
; CHECK-NEXT:    strh w0, [sp, #12]
; CHECK-NEXT:    strh w0, [sp, #10]
; CHECK-NEXT:    strh w0, [sp, #8]
; CHECK-NEXT:    ldr d0, [sp, #8]
; CHECK-NEXT:    add sp, sp, #16
; CHECK-NEXT:    ret
  %insert = insertelement <4 x i16> undef, i16 %a, i64 0
  %splat = shufflevector <4 x i16> %insert, <4 x i16> undef, <4 x i32> zeroinitializer
  ret <4 x i16> %splat
}

define <8 x i16> @splat_v8i16(i16 %a) #0 {
; CHECK-LABEL: splat_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    strh w0, [sp, #14]
; CHECK-NEXT:    strh w0, [sp, #12]
; CHECK-NEXT:    strh w0, [sp, #10]
; CHECK-NEXT:    strh w0, [sp, #8]
; CHECK-NEXT:    strh w0, [sp, #6]
; CHECK-NEXT:    strh w0, [sp, #4]
; CHECK-NEXT:    strh w0, [sp, #2]
; CHECK-NEXT:    strh w0, [sp]
; CHECK-NEXT:    ldr q0, [sp], #16
; CHECK-NEXT:    ret
  %insert = insertelement <8 x i16> undef, i16 %a, i64 0
  %splat = shufflevector <8 x i16> %insert, <8 x i16> undef, <8 x i32> zeroinitializer
  ret <8 x i16> %splat
}

define void @splat_v16i16(i16 %a, <16 x i16>* %b) #0 {
; CHECK-LABEL: splat_v16i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    strh w0, [sp, #14]
; CHECK-NEXT:    strh w0, [sp, #12]
; CHECK-NEXT:    strh w0, [sp, #10]
; CHECK-NEXT:    strh w0, [sp, #8]
; CHECK-NEXT:    strh w0, [sp, #6]
; CHECK-NEXT:    strh w0, [sp, #4]
; CHECK-NEXT:    strh w0, [sp, #2]
; CHECK-NEXT:    strh w0, [sp]
; CHECK-NEXT:    ldr q0, [sp]
; CHECK-NEXT:    stp q0, q0, [x1]
; CHECK-NEXT:    add sp, sp, #16
; CHECK-NEXT:    ret
  %insert = insertelement <16 x i16> undef, i16 %a, i64 0
  %splat = shufflevector <16 x i16> %insert, <16 x i16> undef, <16 x i32> zeroinitializer
  store <16 x i16> %splat, <16 x i16>* %b
  ret void
}

define <2 x i32> @splat_v2i32(i32 %a) #0 {
; CHECK-LABEL: splat_v2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    stp w0, w0, [sp, #8]
; CHECK-NEXT:    ldr d0, [sp, #8]
; CHECK-NEXT:    add sp, sp, #16
; CHECK-NEXT:    ret
  %insert = insertelement <2 x i32> undef, i32 %a, i64 0
  %splat = shufflevector <2 x i32> %insert, <2 x i32> undef, <2 x i32> zeroinitializer
  ret <2 x i32> %splat
}

define <4 x i32> @splat_v4i32(i32 %a) #0 {
; CHECK-LABEL: splat_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    stp w0, w0, [sp, #8]
; CHECK-NEXT:    stp w0, w0, [sp]
; CHECK-NEXT:    ldr q0, [sp], #16
; CHECK-NEXT:    ret
  %insert = insertelement <4 x i32> undef, i32 %a, i64 0
  %splat = shufflevector <4 x i32> %insert, <4 x i32> undef, <4 x i32> zeroinitializer
  ret <4 x i32> %splat
}

define void @splat_v8i32(i32 %a, <8 x i32>* %b) #0 {
; CHECK-LABEL: splat_v8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    stp w0, w0, [sp, #8]
; CHECK-NEXT:    stp w0, w0, [sp]
; CHECK-NEXT:    ldr q0, [sp]
; CHECK-NEXT:    stp q0, q0, [x1]
; CHECK-NEXT:    add sp, sp, #16
; CHECK-NEXT:    ret
  %insert = insertelement <8 x i32> undef, i32 %a, i64 0
  %splat = shufflevector <8 x i32> %insert, <8 x i32> undef, <8 x i32> zeroinitializer
  store <8 x i32> %splat, <8 x i32>* %b
  ret void
}

define <1 x i64> @splat_v1i64(i64 %a) #0 {
; CHECK-LABEL: splat_v1i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmov d0, x0
; CHECK-NEXT:    ret
  %insert = insertelement <1 x i64> undef, i64 %a, i64 0
  %splat = shufflevector <1 x i64> %insert, <1 x i64> undef, <1 x i32> zeroinitializer
  ret <1 x i64> %splat
}

define <2 x i64> @splat_v2i64(i64 %a) #0 {
; CHECK-LABEL: splat_v2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x0, x0, [sp, #-16]!
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    ldr q0, [sp], #16
; CHECK-NEXT:    ret
  %insert = insertelement <2 x i64> undef, i64 %a, i64 0
  %splat = shufflevector <2 x i64> %insert, <2 x i64> undef, <2 x i32> zeroinitializer
  ret <2 x i64> %splat
}

define void @splat_v4i64(i64 %a, <4 x i64>* %b) #0 {
; CHECK-LABEL: splat_v4i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x0, x0, [sp, #-16]!
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    ldr q0, [sp]
; CHECK-NEXT:    stp q0, q0, [x1]
; CHECK-NEXT:    add sp, sp, #16
; CHECK-NEXT:    ret
  %insert = insertelement <4 x i64> undef, i64 %a, i64 0
  %splat = shufflevector <4 x i64> %insert, <4 x i64> undef, <4 x i32> zeroinitializer
  store <4 x i64> %splat, <4 x i64>* %b
  ret void
}

;
; DUP (floating-point)
;

define <2 x half> @splat_v2f16(half %a) #0 {
; CHECK-LABEL: splat_v2f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    str h0, [sp, #10]
; CHECK-NEXT:    str h0, [sp, #8]
; CHECK-NEXT:    ldr d0, [sp, #8]
; CHECK-NEXT:    add sp, sp, #16
; CHECK-NEXT:    ret
  %insert = insertelement <2 x half> undef, half %a, i64 0
  %splat = shufflevector <2 x half> %insert, <2 x half> undef, <2 x i32> zeroinitializer
  ret <2 x half> %splat
}

define <4 x half> @splat_v4f16(half %a) #0 {
; CHECK-LABEL: splat_v4f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    str h0, [sp, #14]
; CHECK-NEXT:    str h0, [sp, #12]
; CHECK-NEXT:    str h0, [sp, #10]
; CHECK-NEXT:    str h0, [sp, #8]
; CHECK-NEXT:    ldr d0, [sp, #8]
; CHECK-NEXT:    add sp, sp, #16
; CHECK-NEXT:    ret
  %insert = insertelement <4 x half> undef, half %a, i64 0
  %splat = shufflevector <4 x half> %insert, <4 x half> undef, <4 x i32> zeroinitializer
  ret <4 x half> %splat
}

define <8 x half> @splat_v8f16(half %a) #0 {
; CHECK-LABEL: splat_v8f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    str h0, [sp, #14]
; CHECK-NEXT:    str h0, [sp, #12]
; CHECK-NEXT:    str h0, [sp, #10]
; CHECK-NEXT:    str h0, [sp, #8]
; CHECK-NEXT:    str h0, [sp, #6]
; CHECK-NEXT:    str h0, [sp, #4]
; CHECK-NEXT:    str h0, [sp, #2]
; CHECK-NEXT:    str h0, [sp]
; CHECK-NEXT:    ldr q0, [sp], #16
; CHECK-NEXT:    ret
  %insert = insertelement <8 x half> undef, half %a, i64 0
  %splat = shufflevector <8 x half> %insert, <8 x half> undef, <8 x i32> zeroinitializer
  ret <8 x half> %splat
}

define void @splat_v16f16(half %a, <16 x half>* %b) #0 {
; CHECK-LABEL: splat_v16f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    str h0, [sp, #14]
; CHECK-NEXT:    str h0, [sp, #12]
; CHECK-NEXT:    str h0, [sp, #10]
; CHECK-NEXT:    str h0, [sp, #8]
; CHECK-NEXT:    str h0, [sp, #6]
; CHECK-NEXT:    str h0, [sp, #4]
; CHECK-NEXT:    str h0, [sp, #2]
; CHECK-NEXT:    str h0, [sp]
; CHECK-NEXT:    ldr q0, [sp]
; CHECK-NEXT:    stp q0, q0, [x0]
; CHECK-NEXT:    add sp, sp, #16
; CHECK-NEXT:    ret
  %insert = insertelement <16 x half> undef, half %a, i64 0
  %splat = shufflevector <16 x half> %insert, <16 x half> undef, <16 x i32> zeroinitializer
  store <16 x half> %splat, <16 x half>* %b
  ret void
}

define <2 x float> @splat_v2f32(float %a, <2 x float> %op2) #0 {
; CHECK-LABEL: splat_v2f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    stp s0, s0, [sp, #8]
; CHECK-NEXT:    ldr d0, [sp, #8]
; CHECK-NEXT:    add sp, sp, #16
; CHECK-NEXT:    ret
  %insert = insertelement <2 x float> undef, float %a, i64 0
  %splat = shufflevector <2 x float> %insert, <2 x float> undef, <2 x i32> zeroinitializer
  ret <2 x float> %splat
}

define <4 x float> @splat_v4f32(float %a, <4 x float> %op2) #0 {
; CHECK-LABEL: splat_v4f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    stp s0, s0, [sp, #8]
; CHECK-NEXT:    stp s0, s0, [sp]
; CHECK-NEXT:    ldr q0, [sp], #16
; CHECK-NEXT:    ret
  %insert = insertelement <4 x float> undef, float %a, i64 0
  %splat = shufflevector <4 x float> %insert, <4 x float> undef, <4 x i32> zeroinitializer
  ret <4 x float> %splat
}

define void @splat_v8f32(float %a, <8 x float>* %b) #0 {
; CHECK-LABEL: splat_v8f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    stp s0, s0, [sp, #8]
; CHECK-NEXT:    stp s0, s0, [sp]
; CHECK-NEXT:    ldr q0, [sp]
; CHECK-NEXT:    stp q0, q0, [x0]
; CHECK-NEXT:    add sp, sp, #16
; CHECK-NEXT:    ret
  %insert = insertelement <8 x float> undef, float %a, i64 0
  %splat = shufflevector <8 x float> %insert, <8 x float> undef, <8 x i32> zeroinitializer
  store <8 x float> %splat, <8 x float>* %b
  ret void
}

define <1 x double> @splat_v1f64(double %a, <1 x double> %op2) #0 {
; CHECK-LABEL: splat_v1f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %insert = insertelement <1 x double> undef, double %a, i64 0
  %splat = shufflevector <1 x double> %insert, <1 x double> undef, <1 x i32> zeroinitializer
  ret <1 x double> %splat
}

define <2 x double> @splat_v2f64(double %a, <2 x double> %op2) #0 {
; CHECK-LABEL: splat_v2f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp d0, d0, [sp, #-16]!
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    ldr q0, [sp], #16
; CHECK-NEXT:    ret
  %insert = insertelement <2 x double> undef, double %a, i64 0
  %splat = shufflevector <2 x double> %insert, <2 x double> undef, <2 x i32> zeroinitializer
  ret <2 x double> %splat
}

define void @splat_v4f64(double %a, <4 x double>* %b) #0 {
; CHECK-LABEL: splat_v4f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp d0, d0, [sp, #-16]!
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    ldr q0, [sp]
; CHECK-NEXT:    stp q0, q0, [x0]
; CHECK-NEXT:    add sp, sp, #16
; CHECK-NEXT:    ret
  %insert = insertelement <4 x double> undef, double %a, i64 0
  %splat = shufflevector <4 x double> %insert, <4 x double> undef, <4 x i32> zeroinitializer
  store <4 x double> %splat, <4 x double>* %b
  ret void
}

;
; DUP (integer immediate)
;

define void @splat_imm_v32i8(<32 x i8>* %a) #0 {
; CHECK-LABEL: splat_imm_v32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI24_0
; CHECK-NEXT:    ldr q0, [x8, :lo12:.LCPI24_0]
; CHECK-NEXT:    stp q0, q0, [x0]
; CHECK-NEXT:    ret
  %insert = insertelement <32 x i8> undef, i8 1, i64 0
  %splat = shufflevector <32 x i8> %insert, <32 x i8> undef, <32 x i32> zeroinitializer
  store <32 x i8> %splat, <32 x i8>* %a
  ret void
}

define void @splat_imm_v16i16(<16 x i16>* %a) #0 {
; CHECK-LABEL: splat_imm_v16i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI25_0
; CHECK-NEXT:    ldr q0, [x8, :lo12:.LCPI25_0]
; CHECK-NEXT:    stp q0, q0, [x0]
; CHECK-NEXT:    ret
  %insert = insertelement <16 x i16> undef, i16 2, i64 0
  %splat = shufflevector <16 x i16> %insert, <16 x i16> undef, <16 x i32> zeroinitializer
  store <16 x i16> %splat, <16 x i16>* %a
  ret void
}

define void @splat_imm_v8i32(<8 x i32>* %a) #0 {
; CHECK-LABEL: splat_imm_v8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI26_0
; CHECK-NEXT:    ldr q0, [x8, :lo12:.LCPI26_0]
; CHECK-NEXT:    stp q0, q0, [x0]
; CHECK-NEXT:    ret
  %insert = insertelement <8 x i32> undef, i32 3, i64 0
  %splat = shufflevector <8 x i32> %insert, <8 x i32> undef, <8 x i32> zeroinitializer
  store <8 x i32> %splat, <8 x i32>* %a
  ret void
}

define void @splat_imm_v4i64(<4 x i64>* %a) #0 {
; CHECK-LABEL: splat_imm_v4i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI27_0
; CHECK-NEXT:    ldr q0, [x8, :lo12:.LCPI27_0]
; CHECK-NEXT:    stp q0, q0, [x0]
; CHECK-NEXT:    ret
  %insert = insertelement <4 x i64> undef, i64 4, i64 0
  %splat = shufflevector <4 x i64> %insert, <4 x i64> undef, <4 x i32> zeroinitializer
  store <4 x i64> %splat, <4 x i64>* %a
  ret void
}

;
; DUP (floating-point immediate)
;

define void @splat_imm_v16f16(<16 x half>* %a) #0 {
; CHECK-LABEL: splat_imm_v16f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI28_0
; CHECK-NEXT:    ldr q0, [x8, :lo12:.LCPI28_0]
; CHECK-NEXT:    stp q0, q0, [x0]
; CHECK-NEXT:    ret
  %insert = insertelement <16 x half> undef, half 5.0, i64 0
  %splat = shufflevector <16 x half> %insert, <16 x half> undef, <16 x i32> zeroinitializer
  store <16 x half> %splat, <16 x half>* %a
  ret void
}

define void @splat_imm_v8f32(<8 x float>* %a) #0 {
; CHECK-LABEL: splat_imm_v8f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI29_0
; CHECK-NEXT:    ldr q0, [x8, :lo12:.LCPI29_0]
; CHECK-NEXT:    stp q0, q0, [x0]
; CHECK-NEXT:    ret
  %insert = insertelement <8 x float> undef, float 6.0, i64 0
  %splat = shufflevector <8 x float> %insert, <8 x float> undef, <8 x i32> zeroinitializer
  store <8 x float> %splat, <8 x float>* %a
  ret void
}

define void @splat_imm_v4f64(<4 x double>* %a) #0 {
; CHECK-LABEL: splat_imm_v4f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI30_0
; CHECK-NEXT:    ldr q0, [x8, :lo12:.LCPI30_0]
; CHECK-NEXT:    stp q0, q0, [x0]
; CHECK-NEXT:    ret
  %insert = insertelement <4 x double> undef, double 7.0, i64 0
  %splat = shufflevector <4 x double> %insert, <4 x double> undef, <4 x i32> zeroinitializer
  store <4 x double> %splat, <4 x double>* %a
  ret void
}

attributes #0 = { "target-features"="+sve" }
