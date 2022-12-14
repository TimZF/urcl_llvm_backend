; RUN: llc < %s -mtriple=s390x-linux-gnu | FileCheck %s

; CHECK-LABEL: @test_stack_guard
; CHECK: ear [[REG1:%r[1-9][0-9]?]], %a0
; CHECK: sllg [[REG1]], [[REG1]], 32
; CHECK: ear [[REG1]], %a1
; CHECK: lg [[REG1]], 40([[REG1]])
; CHECK: stg [[REG1]], {{[0-9]*}}(%r15)
; CHECK: brasl %r14, foo3@PLT
; CHECK: ear [[REG2:%r[1-9][0-9]?]], %a0
; CHECK: sllg [[REG2]], [[REG2]], 32
; CHECK: ear [[REG2]], %a1
; CHECK: lg [[REG2]], 40([[REG2]])
; CHECK: cg [[REG2]], {{[0-9]*}}(%r15)

define i32 @test_stack_guard() #0 {
entry:
  %a1 = alloca [256 x i32], align 4
  call void @llvm.lifetime.start.p0(i64 1024, ptr %a1)
  call void @foo3(ptr %a1)
  call void @llvm.lifetime.end.p0(i64 1024, ptr %a1)
  ret i32 0
}

; Function Attrs: nounwind
declare void @llvm.lifetime.start.p0(i64, ptr nocapture)

declare void @foo3(ptr)

; Function Attrs: nounwind
declare void @llvm.lifetime.end.p0(i64, ptr nocapture)

attributes #0 = { sspstrong }
