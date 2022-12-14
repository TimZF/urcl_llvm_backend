; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; Test to make sure that a new block is inserted if we
; have more than 2 predecessors for the block we're going to sink to.
; RUN: opt -mldst-motion -S < %s | FileCheck %s --check-prefix=CHECK-NO
; RUN: opt -debug-pass-manager -aa-pipeline=basic-aa -passes='require<memdep>,mldst-motion' -S < %s 2>&1 | FileCheck %s --check-prefixes=CHECK-NO,CHECK-INV-NO
; RUN: opt -debug-pass-manager -aa-pipeline=basic-aa -passes='require<memdep>,mldst-motion<split-footer-bb>' -S < %s 2>&1 | FileCheck %s --check-prefixes=CHECK-YES,CHECK-INV-YES
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

; When passing split-footer-bb to MLSM, it invalidates CFG analyses
; CHECK-INV-NO: Running pass: MergedLoadStoreMotionPass
; CHECK-INV-NO-NOT: Invalidating analysis: DominatorTreeAnalysis
; CHECK-INV-YES: Running pass: MergedLoadStoreMotionPass
; CHECK-INV-YES: Invalidating analysis: DominatorTreeAnalysis

; Function Attrs: nounwind uwtable
define dso_local void @st_sink_split_bb(ptr nocapture %arg, ptr nocapture %arg1, i1 zeroext %arg2, i1 zeroext %arg3) local_unnamed_addr {
; CHECK-NO-LABEL: @st_sink_split_bb(
; CHECK-NO-NEXT:  bb:
; CHECK-NO-NEXT:    br i1 [[ARG2:%.*]], label [[BB4:%.*]], label [[BB5:%.*]]
; CHECK-NO:       bb4:
; CHECK-NO-NEXT:    store i32 1, ptr [[ARG:%.*]], align 4
; CHECK-NO-NEXT:    br label [[BB9:%.*]]
; CHECK-NO:       bb5:
; CHECK-NO-NEXT:    br i1 [[ARG3:%.*]], label [[BB6:%.*]], label [[BB7:%.*]]
; CHECK-NO:       bb6:
; CHECK-NO-NEXT:    store i32 2, ptr [[ARG]], align 4
; CHECK-NO-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i32, ptr [[ARG1:%.*]], i64 1
; CHECK-NO-NEXT:    store i32 3, ptr [[TMP1]], align 4
; CHECK-NO-NEXT:    [[TMP:%.*]] = getelementptr inbounds i32, ptr [[ARG1]], i64 2
; CHECK-NO-NEXT:    store i32 3, ptr [[TMP]], align 4
; CHECK-NO-NEXT:    br label [[BB9]]
; CHECK-NO:       bb7:
; CHECK-NO-NEXT:    store i32 3, ptr [[ARG]], align 4
; CHECK-NO-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, ptr [[ARG1]], i64 1
; CHECK-NO-NEXT:    store i32 3, ptr [[TMP2]], align 4
; CHECK-NO-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i32, ptr [[ARG1]], i64 2
; CHECK-NO-NEXT:    store i32 3, ptr [[TMP8]], align 4
; CHECK-NO-NEXT:    br label [[BB9]]
; CHECK-NO:       bb9:
; CHECK-NO-NEXT:    ret void
;
; CHECK-YES-LABEL: @st_sink_split_bb(
; CHECK-YES-NEXT:  bb:
; CHECK-YES-NEXT:    br i1 [[ARG2:%.*]], label [[BB4:%.*]], label [[BB5:%.*]]
; CHECK-YES:       bb4:
; CHECK-YES-NEXT:    store i32 1, ptr [[ARG:%.*]], align 4
; CHECK-YES-NEXT:    br label [[BB9:%.*]]
; CHECK-YES:       bb5:
; CHECK-YES-NEXT:    br i1 [[ARG3:%.*]], label [[BB6:%.*]], label [[BB7:%.*]]
; CHECK-YES:       bb6:
; CHECK-YES-NEXT:    store i32 2, ptr [[ARG]], align 4
; CHECK-YES-NEXT:    br label [[BB9_SINK_SPLIT:%.*]]
; CHECK-YES:       bb7:
; CHECK-YES-NEXT:    store i32 3, ptr [[ARG]], align 4
; CHECK-YES-NEXT:    br label [[BB9_SINK_SPLIT]]
; CHECK-YES:       bb9.sink.split:
; CHECK-YES-NEXT:    [[TMP0:%.*]] = getelementptr inbounds i32, ptr [[ARG1:%.*]], i64 1
; CHECK-YES-NEXT:    store i32 3, ptr [[TMP0]], align 4
; CHECK-YES-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i32, ptr [[ARG1]], i64 2
; CHECK-YES-NEXT:    store i32 3, ptr [[TMP1]], align 4
; CHECK-YES-NEXT:    br label [[BB9]]
; CHECK-YES:       bb9:
; CHECK-YES-NEXT:    ret void
;
bb:
  br i1 %arg2, label %bb4, label %bb5

bb4:                                              ; preds = %bb
  store i32 1, ptr %arg, align 4
  br label %bb9

bb5:                                              ; preds = %bb
  br i1 %arg3, label %bb6, label %bb7

bb6:                                              ; preds = %bb5
  store i32 2, ptr %arg, align 4
  %tmp1 = getelementptr inbounds i32, ptr %arg1, i64 1
  store i32 3, ptr %tmp1, align 4
  %tmp = getelementptr inbounds i32, ptr %arg1, i64 2
  store i32 3, ptr %tmp, align 4
  br label %bb9

bb7:                                              ; preds = %bb5
  store i32 3, ptr %arg, align 4
  %tmp2 = getelementptr inbounds i32, ptr %arg1, i64 1
  store i32 3, ptr %tmp2, align 4
  %tmp8 = getelementptr inbounds i32, ptr %arg1, i64 2
  store i32 3, ptr %tmp8, align 4
  br label %bb9


bb9:                                              ; preds = %bb7, %bb6, %bb4
  ret void
}
