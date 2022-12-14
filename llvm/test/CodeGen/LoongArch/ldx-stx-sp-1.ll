; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc --mtriple=loongarch64 --mattr=+f < %s | FileCheck %s

;; This should not crash the code generator, but the indexed loads/stores
;; should still be present (the important part is that [f]{ld,st}x shouldn't
;; take an $sp argument).

define i8 @test_load_i(i64 %i) {
; CHECK-LABEL: test_load_i:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi.d $sp, $sp, -16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    addi.d $a1, $sp, 8
; CHECK-NEXT:    ldx.b $a0, $a0, $a1
; CHECK-NEXT:    addi.d $sp, $sp, 16
; CHECK-NEXT:    ret
  %1 = alloca ptr
  %2 = getelementptr inbounds i8, ptr %1, i64 %i
  %3 = load i8, ptr %2
  ret i8 %3
}

define float @test_load_f(i64 %i) {
; CHECK-LABEL: test_load_f:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi.d $sp, $sp, -16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    slli.d $a0, $a0, 2
; CHECK-NEXT:    addi.d $a1, $sp, 8
; CHECK-NEXT:    fldx.s $fa0, $a0, $a1
; CHECK-NEXT:    addi.d $sp, $sp, 16
; CHECK-NEXT:    ret
  %1 = alloca ptr
  %2 = getelementptr inbounds float, ptr %1, i64 %i
  %3 = load float, ptr %2
  ret float %3
}

define void @test_store_i(i64 %i, i8 %v) {
; CHECK-LABEL: test_store_i:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi.d $sp, $sp, -16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    addi.d $a2, $sp, 8
; CHECK-NEXT:    stx.b $a1, $a0, $a2
; CHECK-NEXT:    addi.d $sp, $sp, 16
; CHECK-NEXT:    ret
  %1 = alloca ptr
  %2 = getelementptr inbounds i8, ptr %1, i64 %i
  store i8 %v, ptr %2, align 1
  ret void
}

define void @test_store_f(i64 %i, float %v) {
; CHECK-LABEL: test_store_f:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi.d $sp, $sp, -16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    slli.d $a0, $a0, 2
; CHECK-NEXT:    addi.d $a1, $sp, 8
; CHECK-NEXT:    fstx.s $fa0, $a0, $a1
; CHECK-NEXT:    addi.d $sp, $sp, 16
; CHECK-NEXT:    ret
  %1 = alloca ptr
  %2 = getelementptr inbounds float, ptr %1, i64 %i
  store float %v, ptr %2, align 4
  ret void
}
