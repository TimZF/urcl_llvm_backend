; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=instcombine < %s | FileCheck %s

; OSS Fuzz: https://bugs.chromium.org/p/oss-fuzz/issues/detail?id=15217
define i64 @fuzz15217(i1 %cond, ptr %Ptr, i64 %Val) {
; CHECK-LABEL: @fuzz15217(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[END:%.*]], label [[TWO:%.*]]
; CHECK:       two:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    ret i64 poison
;
entry:
  br i1 %cond, label %end, label %two

two:
  br label %end

end:
  %tmp869.0 = phi i128 [ 0, %entry ], [ 18446744073709551616, %two ]
  %tmp29 = lshr i128 %tmp869.0, 64
  %B1 = lshr i128 %tmp29, 170141183460469231731687303715884105727
  %tmp30 = trunc i128 %B1 to i64
  ret i64 %tmp30
}
