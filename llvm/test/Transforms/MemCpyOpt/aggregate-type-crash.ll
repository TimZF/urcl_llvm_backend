; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=memcpyopt -S -o - < %s -verify-memoryssa | FileCheck %s

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.14.0"

%my_struct = type { i8, i32 }

; Function Attrs: inaccessiblemem_or_argmemonly
declare noalias ptr @my_malloc(ptr) #0

define void @my_func(ptr %0) {
; CHECK-LABEL: @my_func(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP1:%.*]] = load [[MY_STRUCT:%.*]], ptr [[TMP0:%.*]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = call ptr @my_malloc(ptr [[TMP0]])
; CHECK-NEXT:    store [[MY_STRUCT]] [[TMP1]], ptr [[TMP2]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %1 = load %my_struct, ptr %0
  %2 = call ptr @my_malloc(ptr %0)
  store %my_struct %1, ptr %2
  ret void
}

attributes #0 = { inaccessiblemem_or_argmemonly }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 10, i32 14]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{!"Apple LLVM version 10.0.1 (clang-1001.0.46.4)"}
