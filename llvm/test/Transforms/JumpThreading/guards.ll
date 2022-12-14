; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=jump-threading,dce < %s | FileCheck %s

declare void @llvm.experimental.guard(i1, ...)

declare i32 @f1()
declare i32 @f2()

define i32 @branch_implies_guard(i32 %a) {
; CHECK-LABEL: @branch_implies_guard(
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i32 [[A:%.*]], 10
; CHECK-NEXT:    br i1 [[COND]], label [[T1_SPLIT:%.*]], label [[F1_SPLIT:%.*]]
; CHECK:       T1.split:
; CHECK-NEXT:    [[V1:%.*]] = call i32 @f1()
; CHECK-NEXT:    [[RETVAL3:%.*]] = add i32 [[V1]], 10
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       F1.split:
; CHECK-NEXT:    [[V2:%.*]] = call i32 @f2()
; CHECK-NEXT:    [[RETVAL1:%.*]] = add i32 [[V2]], 10
; CHECK-NEXT:    [[CONDGUARD2:%.*]] = icmp slt i32 [[A]], 20
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[CONDGUARD2]]) [ "deopt"() ]
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       Merge:
; CHECK-NEXT:    [[TMP1:%.*]] = phi i32 [ [[RETVAL3]], [[T1_SPLIT]] ], [ [[RETVAL1]], [[F1_SPLIT]] ]
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cond = icmp slt i32 %a, 10
  br i1 %cond, label %T1, label %F1

T1:
  %v1 = call i32 @f1()
  br label %Merge

F1:
  %v2 = call i32 @f2()
  br label %Merge

Merge:
  %retPhi = phi i32 [ %v1, %T1 ], [ %v2, %F1 ]
  %retVal = add i32 %retPhi, 10
  %condGuard = icmp slt i32 %a, 20
  call void(i1, ...) @llvm.experimental.guard(i1 %condGuard) [ "deopt"() ]
  ret i32 %retVal
}

define i32 @not_branch_implies_guard(i32 %a) {
; CHECK-LABEL: @not_branch_implies_guard(
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i32 [[A:%.*]], 20
; CHECK-NEXT:    br i1 [[COND]], label [[T1_SPLIT:%.*]], label [[F1_SPLIT:%.*]]
; CHECK:       T1.split:
; CHECK-NEXT:    [[V1:%.*]] = call i32 @f1()
; CHECK-NEXT:    [[RETVAL1:%.*]] = add i32 [[V1]], 10
; CHECK-NEXT:    [[CONDGUARD2:%.*]] = icmp sgt i32 [[A]], 10
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[CONDGUARD2]]) [ "deopt"() ]
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       F1.split:
; CHECK-NEXT:    [[V2:%.*]] = call i32 @f2()
; CHECK-NEXT:    [[RETVAL3:%.*]] = add i32 [[V2]], 10
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       Merge:
; CHECK-NEXT:    [[TMP1:%.*]] = phi i32 [ [[RETVAL3]], [[F1_SPLIT]] ], [ [[RETVAL1]], [[T1_SPLIT]] ]
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %cond = icmp slt i32 %a, 20
  br i1 %cond, label %T1, label %F1

T1:
  %v1 = call i32 @f1()
  br label %Merge

F1:
  %v2 = call i32 @f2()
  br label %Merge

Merge:
  %retPhi = phi i32 [ %v1, %T1 ], [ %v2, %F1 ]
  %retVal = add i32 %retPhi, 10
  %condGuard = icmp sgt i32 %a, 10
  call void(i1, ...) @llvm.experimental.guard(i1 %condGuard) [ "deopt"() ]
  ret i32 %retVal
}

define i32 @branch_overlaps_guard(i32 %a) {
; CHECK-LABEL: @branch_overlaps_guard(
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i32 [[A:%.*]], 20
; CHECK-NEXT:    br i1 [[COND]], label [[T1:%.*]], label [[F1:%.*]]
; CHECK:       T1:
; CHECK-NEXT:    [[V1:%.*]] = call i32 @f1()
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       F1:
; CHECK-NEXT:    [[V2:%.*]] = call i32 @f2()
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       Merge:
; CHECK-NEXT:    [[RETPHI:%.*]] = phi i32 [ [[V1]], [[T1]] ], [ [[V2]], [[F1]] ]
; CHECK-NEXT:    [[RETVAL:%.*]] = add i32 [[RETPHI]], 10
; CHECK-NEXT:    [[CONDGUARD:%.*]] = icmp slt i32 [[A]], 10
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[CONDGUARD]]) [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[RETVAL]]
;
  %cond = icmp slt i32 %a, 20
  br i1 %cond, label %T1, label %F1

T1:
  %v1 = call i32 @f1()
  br label %Merge

F1:
  %v2 = call i32 @f2()
  br label %Merge

Merge:
  %retPhi = phi i32 [ %v1, %T1 ], [ %v2, %F1 ]
  %retVal = add i32 %retPhi, 10
  %condGuard = icmp slt i32 %a, 10
  call void(i1, ...) @llvm.experimental.guard(i1 %condGuard) [ "deopt"() ]
  ret i32 %retVal
}

define i32 @branch_doesnt_overlap_guard(i32 %a) {
; CHECK-LABEL: @branch_doesnt_overlap_guard(
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i32 [[A:%.*]], 10
; CHECK-NEXT:    br i1 [[COND]], label [[T1:%.*]], label [[F1:%.*]]
; CHECK:       T1:
; CHECK-NEXT:    [[V1:%.*]] = call i32 @f1()
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       F1:
; CHECK-NEXT:    [[V2:%.*]] = call i32 @f2()
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       Merge:
; CHECK-NEXT:    [[RETPHI:%.*]] = phi i32 [ [[V1]], [[T1]] ], [ [[V2]], [[F1]] ]
; CHECK-NEXT:    [[RETVAL:%.*]] = add i32 [[RETPHI]], 10
; CHECK-NEXT:    [[CONDGUARD:%.*]] = icmp sgt i32 [[A]], 20
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[CONDGUARD]]) [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[RETVAL]]
;
  %cond = icmp slt i32 %a, 10
  br i1 %cond, label %T1, label %F1

T1:
  %v1 = call i32 @f1()
  br label %Merge

F1:
  %v2 = call i32 @f2()
  br label %Merge

Merge:
  %retPhi = phi i32 [ %v1, %T1 ], [ %v2, %F1 ]
  %retVal = add i32 %retPhi, 10
  %condGuard = icmp sgt i32 %a, 20
  call void(i1, ...) @llvm.experimental.guard(i1 %condGuard) [ "deopt"() ]
  ret i32 %retVal
}

define i32 @not_a_diamond1(i32 %a, i1 %cond1) {
; CHECK-LABEL: @not_a_diamond1(
; CHECK-NEXT:    br i1 [[COND1:%.*]], label [[PRED:%.*]], label [[EXIT:%.*]]
; CHECK:       Pred:
; CHECK-NEXT:    switch i32 [[A:%.*]], label [[EXIT]] [
; CHECK-NEXT:    i32 10, label [[MERGE:%.*]]
; CHECK-NEXT:    i32 20, label [[MERGE]]
; CHECK-NEXT:    ]
; CHECK:       Merge:
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[COND1]]) [ "deopt"() ]
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       Exit:
; CHECK-NEXT:    ret i32 [[A]]
;
  br i1 %cond1, label %Pred, label %Exit

Pred:
  switch i32 %a, label %Exit [
  i32 10, label %Merge
  i32 20, label %Merge
  ]

Merge:
  call void(i1, ...) @llvm.experimental.guard(i1 %cond1) [ "deopt"() ]
  br label %Exit

Exit:
  ret i32 %a
}

define void @not_a_diamond2(i32 %a, i1 %cond1) {
; CHECK-LABEL: @not_a_diamond2(
; CHECK-NEXT:  Pred:
; CHECK-NEXT:    switch i32 [[A:%.*]], label [[EXIT:%.*]] [
; CHECK-NEXT:    i32 10, label [[MERGE:%.*]]
; CHECK-NEXT:    i32 20, label [[MERGE]]
; CHECK-NEXT:    ]
; CHECK:       Merge:
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[COND1:%.*]]) [ "deopt"() ]
; CHECK-NEXT:    ret void
; CHECK:       Exit:
; CHECK-NEXT:    ret void
;
  br label %Parent

Merge:
  call void(i1, ...) @llvm.experimental.guard(i1 %cond1)[ "deopt"() ]
  ret void

Pred:
  switch i32 %a, label %Exit [
  i32 10, label %Merge
  i32 20, label %Merge
  ]

Parent:
  br label %Pred

Exit:
  ret void
}

declare void @never_called(i1)

; LVI uses guard to identify value of %c2 in branch as true, we cannot replace that
; guard with guard(true & c1).
define void @dont_fold_guard(ptr %addr, i32 %i, i32 %length) {
; CHECK-LABEL: @dont_fold_guard(
; CHECK-NEXT:  BB1:
; CHECK-NEXT:    [[C1:%.*]] = icmp ult i32 [[I:%.*]], [[LENGTH:%.*]]
; CHECK-NEXT:    [[C2:%.*]] = icmp eq i32 [[I]], 0
; CHECK-NEXT:    [[WIDE_CHK:%.*]] = and i1 [[C1]], [[C2]]
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[WIDE_CHK]]) [ "deopt"() ]
; CHECK-NEXT:    call void @never_called(i1 true)
; CHECK-NEXT:    ret void
;
  %c1 = icmp ult i32 %i, %length
  %c2 = icmp eq i32 %i, 0
  %wide.chk = and i1 %c1, %c2
  call void(i1, ...) @llvm.experimental.guard(i1 %wide.chk) [ "deopt"() ]
  br i1 %c2, label %BB1, label %BB2

BB1:
  call void @never_called(i1 %c2)
  ret void

BB2:
  ret void
}

declare void @dummy(i1) nounwind willreturn
; same as dont_fold_guard1 but there's a use immediately after guard and before
; branch. We can fold that use.
define void @dont_fold_guard2(ptr %addr, i32 %i, i32 %length) {
; CHECK-LABEL: @dont_fold_guard2(
; CHECK-NEXT:  BB1:
; CHECK-NEXT:    [[C1:%.*]] = icmp ult i32 [[I:%.*]], [[LENGTH:%.*]]
; CHECK-NEXT:    [[C2:%.*]] = icmp eq i32 [[I]], 0
; CHECK-NEXT:    [[WIDE_CHK:%.*]] = and i1 [[C1]], [[C2]]
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[WIDE_CHK]]) [ "deopt"() ]
; CHECK-NEXT:    call void @dummy(i1 true)
; CHECK-NEXT:    call void @never_called(i1 true)
; CHECK-NEXT:    ret void
;
  %c1 = icmp ult i32 %i, %length
  %c2 = icmp eq i32 %i, 0
  %wide.chk = and i1 %c1, %c2
  call void(i1, ...) @llvm.experimental.guard(i1 %wide.chk) [ "deopt"() ]
  call void @dummy(i1 %c2)
  br i1 %c2, label %BB1, label %BB2

BB1:
  call void @never_called(i1 %c2)
  ret void

BB2:
  ret void
}

; same as dont_fold_guard1 but condition %cmp is not an instruction.
; We cannot fold the guard under any circumstance.
; FIXME: We can merge unreachableBB2 into not_zero.
define void @dont_fold_guard3(ptr %addr, i1 %cmp, i32 %i, i32 %length) {
; CHECK-LABEL: @dont_fold_guard3(
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[CMP:%.*]]) [ "deopt"() ]
; CHECK-NEXT:    br i1 [[CMP]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       BB1:
; CHECK-NEXT:    call void @never_called(i1 [[CMP]])
; CHECK-NEXT:    ret void
; CHECK:       BB2:
; CHECK-NEXT:    ret void
;
  call void(i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  br i1 %cmp, label %BB1, label %BB2

BB1:
  call void @never_called(i1 %cmp)
  ret void

BB2:
  ret void
}

declare void @f(i1)
; Same as dont_fold_guard1 but use switch instead of branch.
; triggers source code `ProcessThreadableEdges`.
define void @dont_fold_guard4(i1 %cmp1, i32 %i) nounwind {
; CHECK-LABEL: @dont_fold_guard4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[CMP1:%.*]], label [[L2:%.*]], label [[L3:%.*]]
; CHECK:       L2:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[I:%.*]], 0
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[CMP]]) [ "deopt"() ]
; CHECK-NEXT:    call void @dummy(i1 true)
; CHECK-NEXT:    call void @f(i1 true)
; CHECK-NEXT:    ret void
; CHECK:       L3:
; CHECK-NEXT:    ret void
;
entry:
  br i1 %cmp1, label %L0, label %L3
L0:
  %cmp = icmp eq i32 %i, 0
  call void(i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  call void @dummy(i1 %cmp)
  switch i1 %cmp, label %L3 [
  i1 false, label %L1
  i1 true, label %L2
  ]

L1:
  ret void
L2:
  call void @f(i1 %cmp)
  ret void
L3:
  ret void
}

; Make sure that we don't PRE a non-speculable load across a guard.
define void @unsafe_pre_across_guard(ptr %p, i1 %load.is.valid) {
; CHECK-LABEL: @unsafe_pre_across_guard(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[LOAD_IS_VALID:%.*]]) [ "deopt"() ]
; CHECK-NEXT:    [[LOADED:%.*]] = load i8, ptr [[P:%.*]], align 1
; CHECK-NEXT:    [[CONTINUE:%.*]] = icmp eq i8 [[LOADED]], 0
; CHECK-NEXT:    br i1 [[CONTINUE]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:                                             ; preds = %loop, %entry
  call void (i1, ...) @llvm.experimental.guard(i1 %load.is.valid) [ "deopt"() ]
  %loaded = load i8, ptr %p
  %continue = icmp eq i8 %loaded, 0
  br i1 %continue, label %exit, label %loop

exit:                                             ; preds = %loop
  ret void
}

; Make sure that we can safely PRE a speculable load across a guard.
define void @safe_pre_across_guard(ptr noalias nocapture readonly dereferenceable(8) %p, i1 %load.is.valid) nofree nosync {
; CHECK-LABEL: @safe_pre_across_guard(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LOADED_PR:%.*]] = load i8, ptr [[P:%.*]], align 1
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[LOADED:%.*]] = phi i8 [ [[LOADED]], [[LOOP]] ], [ [[LOADED_PR]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[LOAD_IS_VALID:%.*]]) [ "deopt"() ]
; CHECK-NEXT:    [[CONTINUE:%.*]] = icmp eq i8 [[LOADED]], 0
; CHECK-NEXT:    br i1 [[CONTINUE]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;

entry:
  br label %loop

loop:                                             ; preds = %loop, %entry
  call void (i1, ...) @llvm.experimental.guard(i1 %load.is.valid) [ "deopt"() ]
  %loaded = load i8, ptr %p
  %continue = icmp eq i8 %loaded, 0
  br i1 %continue, label %exit, label %loop

exit:                                             ; preds = %loop
  ret void
}

; Make sure that we don't PRE a non-speculable load across a call which may
; alias with the load.
define void @unsafe_pre_across_call(ptr %p) {
; CHECK-LABEL: @unsafe_pre_across_call(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[TMP0:%.*]] = call i32 @f1()
; CHECK-NEXT:    [[LOADED:%.*]] = load i8, ptr [[P:%.*]], align 1
; CHECK-NEXT:    [[CONTINUE:%.*]] = icmp eq i8 [[LOADED]], 0
; CHECK-NEXT:    br i1 [[CONTINUE]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:                                             ; preds = %loop, %entry
  call i32 @f1()
  %loaded = load i8, ptr %p
  %continue = icmp eq i8 %loaded, 0
  br i1 %continue, label %exit, label %loop

exit:                                             ; preds = %loop
  ret void
}

; Make sure that we can safely PRE a speculable load across a call.
define void @safe_pre_across_call(ptr noalias nocapture readonly dereferenceable(8) %p) nofree nosync {
; CHECK-LABEL: @safe_pre_across_call(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LOADED_PR:%.*]] = load i8, ptr [[P:%.*]], align 1
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[LOADED:%.*]] = phi i8 [ [[LOADED]], [[LOOP]] ], [ [[LOADED_PR]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = call i32 @f1()
; CHECK-NEXT:    [[CONTINUE:%.*]] = icmp eq i8 [[LOADED]], 0
; CHECK-NEXT:    br i1 [[CONTINUE]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;

entry:
  br label %loop

loop:                                             ; preds = %loop, %entry
  call i32 @f1()
  %loaded = load i8, ptr %p
  %continue = icmp eq i8 %loaded, 0
  br i1 %continue, label %exit, label %loop

exit:                                             ; preds = %loop
  ret void
}
