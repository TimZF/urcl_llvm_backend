; RUN: opt < %s -passes=instcombine -S

; Make sure that we don't crash when optimizing the vectors of pointers.

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"

%struct.hoge = type { ptr, ptr, ptr, ptr }

define void @widget(ptr nocapture %arg, i1 %c1, i1 %c2, i1 %c3, i1 %c4, i1 %c5) {
bb:
  br i1 %c1, label %bb1, label %bb17

bb1:                                              ; preds = %bb
  br i1 %c2, label %bb2, label %bb3

bb2:                                              ; preds = %bb1
  br label %bb17

bb3:                                              ; preds = %bb1
  %tmp5 = load <2 x ptr>, ptr %arg, align 8
  %tmp6 = ptrtoint <2 x ptr> %tmp5 to <2 x i64>
  %tmp7 = sub <2 x i64> zeroinitializer, %tmp6
  %tmp8 = ashr exact <2 x i64> %tmp7, <i64 3, i64 3>
  %tmp9 = extractelement <2 x i64> %tmp8, i32 0
  %tmp10 = add nsw i64 0, %tmp9
  br i1 %c5, label %bb11, label %bb12

bb11:                                             ; preds = %bb3
  br label %bb13

bb12:                                             ; preds = %bb3
  br label %bb13

bb13:                                             ; preds = %bb12, %bb11
  br i1 %c3, label %bb16, label %bb14

bb14:                                             ; preds = %bb13
  br i1 %c4, label %bb16, label %bb15

bb15:                                             ; preds = %bb14
  br label %bb16

bb16:                                             ; preds = %bb15, %bb14, %bb13
  unreachable

bb17:                                             ; preds = %bb2, %bb
  ret void
}
