; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --check-globals
; RUN: opt -S -passes=globalopt < %s | FileCheck %s

%type = type { { i8** } }

@g = internal global %type zeroinitializer
@g2 = external global i8*

@llvm.global_ctors = appending global [1 x { i32, void ()*, i8* }] [{ i32, void ()*, i8* } { i32 65535, void ()* @ctor, i8* null }]

;.
; CHECK: @[[G:[a-zA-Z0-9_$"\\.-]+]] = internal global [[TYPE:%.*]] { { i8** } { i8** @g2 } }
; CHECK: @[[G2:[a-zA-Z0-9_$"\\.-]+]] = external global i8*
; CHECK: @[[LLVM_GLOBAL_CTORS:[a-zA-Z0-9_$"\\.-]+]] = appending global [0 x { i32, void ()*, i8* }] zeroinitializer
;.
define internal void @ctor() {
  store i64 0, i64* bitcast (%type* @g to i64*), align 8
  store i8** @g2, i8*** getelementptr inbounds (%type, %type* @g, i64 0, i32 0, i32 0), align 8
  ret void
}

define %type* @test() {
; CHECK-LABEL: @test(
; CHECK-NEXT:    ret %type* @g
;
  ret %type* @g
}
