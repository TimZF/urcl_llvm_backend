; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=slp-vectorizer -S -mtriple=i386-pc-linux | FileCheck %s

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-pc-linux"

; Function Attrs: nounwind
define i32 @_Z16adjustFixupValueyj(i64 %Value, i32 %Kind) {
; CHECK-LABEL: @_Z16adjustFixupValueyj(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[EXTRACT_T:%.*]] = trunc i64 [[VALUE:%.*]] to i32
; CHECK-NEXT:    [[EXTRACT:%.*]] = lshr i64 [[VALUE]], 12
; CHECK-NEXT:    [[EXTRACT_T6:%.*]] = trunc i64 [[EXTRACT]] to i32
; CHECK-NEXT:    switch i32 [[KIND:%.*]], label [[SW_DEFAULT:%.*]] [
; CHECK-NEXT:    i32 0, label [[RETURN:%.*]]
; CHECK-NEXT:    i32 1, label [[RETURN]]
; CHECK-NEXT:    i32 129, label [[SW_BB1:%.*]]
; CHECK-NEXT:    i32 130, label [[SW_BB2:%.*]]
; CHECK-NEXT:    ]
; CHECK:       sw.default:
; CHECK-NEXT:    call void @_Z25llvm_unreachable_internalv()
; CHECK-NEXT:    unreachable
; CHECK:       sw.bb1:
; CHECK-NEXT:    [[SHR:%.*]] = lshr i64 [[VALUE]], 16
; CHECK-NEXT:    [[EXTRACT_T5:%.*]] = trunc i64 [[SHR]] to i32
; CHECK-NEXT:    [[EXTRACT7:%.*]] = lshr i64 [[VALUE]], 28
; CHECK-NEXT:    [[EXTRACT_T8:%.*]] = trunc i64 [[EXTRACT7]] to i32
; CHECK-NEXT:    br label [[SW_BB2]]
; CHECK:       sw.bb2:
; CHECK-NEXT:    [[VALUE_ADDR_0_OFF0:%.*]] = phi i32 [ [[EXTRACT_T]], [[ENTRY:%.*]] ], [ [[EXTRACT_T5]], [[SW_BB1]] ]
; CHECK-NEXT:    [[VALUE_ADDR_0_OFF12:%.*]] = phi i32 [ [[EXTRACT_T6]], [[ENTRY]] ], [ [[EXTRACT_T8]], [[SW_BB1]] ]
; CHECK-NEXT:    [[CONV6:%.*]] = and i32 [[VALUE_ADDR_0_OFF0]], 4095
; CHECK-NEXT:    [[CONV4:%.*]] = shl i32 [[VALUE_ADDR_0_OFF12]], 16
; CHECK-NEXT:    [[SHL:%.*]] = and i32 [[CONV4]], 983040
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[SHL]], [[CONV6]]
; CHECK-NEXT:    [[OR11:%.*]] = or i32 [[OR]], 8388608
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       return:
; CHECK-NEXT:    [[RETVAL_0:%.*]] = phi i32 [ [[OR11]], [[SW_BB2]] ], [ [[EXTRACT_T]], [[ENTRY]] ], [ [[EXTRACT_T]], [[ENTRY]] ]
; CHECK-NEXT:    ret i32 [[RETVAL_0]]
;
entry:
  %extract.t = trunc i64 %Value to i32
  %extract = lshr i64 %Value, 12
  %extract.t6 = trunc i64 %extract to i32
  switch i32 %Kind, label %sw.default [
  i32 0, label %return
  i32 1, label %return
  i32 129, label %sw.bb1
  i32 130, label %sw.bb2
  ]

sw.default:                                       ; preds = %entry
  call void @_Z25llvm_unreachable_internalv()
  unreachable

sw.bb1:                                           ; preds = %entry
  %shr = lshr i64 %Value, 16
  %extract.t5 = trunc i64 %shr to i32
  %extract7 = lshr i64 %Value, 28
  %extract.t8 = trunc i64 %extract7 to i32
  br label %sw.bb2

sw.bb2:                                           ; preds = %sw.bb1, %entry
  %Value.addr.0.off0 = phi i32 [ %extract.t, %entry ], [ %extract.t5, %sw.bb1 ]
  %Value.addr.0.off12 = phi i32 [ %extract.t6, %entry ], [ %extract.t8, %sw.bb1 ]
  %conv6 = and i32 %Value.addr.0.off0, 4095
  %conv4 = shl i32 %Value.addr.0.off12, 16
  %shl = and i32 %conv4, 983040
  %or = or i32 %shl, %conv6
  %or11 = or i32 %or, 8388608
  br label %return

return:                                           ; preds = %sw.bb2, %entry, %entry
  %retval.0 = phi i32 [ %or11, %sw.bb2 ], [ %extract.t, %entry ], [ %extract.t, %entry ]
  ret i32 %retval.0
}

; Function Attrs: noreturn
declare void @_Z25llvm_unreachable_internalv()

