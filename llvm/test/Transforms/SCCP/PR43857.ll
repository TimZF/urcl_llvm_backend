; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -passes=ipsccp | FileCheck %s

%struct.wobble = type { i32 }
%struct.zot = type { %struct.wobble, %struct.wobble, %struct.wobble }

declare dso_local fastcc float @bar(ptr noalias, <8 x i32>) unnamed_addr

define %struct.zot @widget(<8 x i32> %arg) local_unnamed_addr {
; CHECK-LABEL: @widget(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    ret [[STRUCT_ZOT:%.*]] undef
;
bb:
  ret %struct.zot undef
}

define void @baz(<8 x i32> %arg) local_unnamed_addr {
; CHECK-LABEL: @baz(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP:%.*]] = call [[STRUCT_ZOT:%.*]] @widget(<8 x i32> [[ARG:%.*]])
; CHECK-NEXT:    [[TMP1:%.*]] = extractvalue [[STRUCT_ZOT]] undef, 0, 0
; CHECK-NEXT:    ret void
;
bb:
  %tmp = call %struct.zot @widget(<8 x i32> %arg)
  %tmp1 = extractvalue %struct.zot %tmp, 0, 0
  ret void
}
