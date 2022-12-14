; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-flatten -verify-scev -S < %s | FileCheck %s
;
define void @sum_2d(ptr %p) {
; CHECK-LABEL: @sum_2d(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[FLATTEN_TRIPCOUNT:%.*]] = mul i16 1, 1
; CHECK-NEXT:    br label [[OUTER:%.*]]
; CHECK:       outer:
; CHECK-NEXT:    [[SUM_04:%.*]] = phi i16 [ 0, [[ENTRY:%.*]] ], [ [[DOTLCSSA:%.*]], [[OUTER_LATCH:%.*]] ]
; CHECK-NEXT:    [[OUTER_IV:%.*]] = phi i16 [ 0, [[ENTRY]] ], [ [[OUTER_IV_NEXT:%.*]], [[OUTER_LATCH]] ]
; CHECK-NEXT:    br label [[INNER:%.*]]
; CHECK:       inner:
; CHECK-NEXT:    [[SUM_12:%.*]] = phi i16 [ [[SUM_04]], [[OUTER]] ]
; CHECK-NEXT:    [[INNER_IV:%.*]] = phi i16 [ 0, [[OUTER]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = load i16, ptr [[P:%.*]], align 1
; CHECK-NEXT:    [[INNER_IV_NEXT:%.*]] = add nsw i16 [[INNER_IV]], 1
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i16 [[INNER_IV]], 0
; CHECK-NEXT:    br label [[OUTER_LATCH]]
; CHECK:       outer.latch:
; CHECK-NEXT:    [[DOTLCSSA]] = phi i16 [ [[TMP0]], [[INNER]] ]
; CHECK-NEXT:    [[OUTER_IV_NEXT]] = add nsw i16 [[OUTER_IV]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i16 [[OUTER_IV_NEXT]], [[FLATTEN_TRIPCOUNT]]
; CHECK-NEXT:    br i1 [[CMP]], label [[OUTER]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %outer

outer:                                         ; preds = %outer.latch, %entry
  %sum.04 = phi i16 [ 0, %entry ], [ %0, %outer.latch ]
  %outer.iv = phi i16 [ 0, %entry ], [ %outer.iv.next, %outer.latch ]
  br label %inner

inner:                                        ; preds = %inner, %outer
  %sum.12 = phi i16 [ %sum.04, %outer ], [ %0, %inner ]
  %inner.iv = phi i16 [ 0, %outer ], [ %inner.iv.next, %inner ]
  %0 = load i16, ptr %p, align 1
  %inner.iv.next = add nsw i16 %inner.iv, 1
  %cmp2 = icmp slt i16 %inner.iv, 0
  br i1 %cmp2, label %inner, label %outer.latch

outer.latch:                                         ; preds = %inner
  %outer.iv.next = add nsw i16 %outer.iv, 1
  %cmp = icmp slt i16 %outer.iv.next, 0
  br i1 %cmp, label %outer, label %exit

exit:                                         ; preds = %outer.latch
  ret void
}
