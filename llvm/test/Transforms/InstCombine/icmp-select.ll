; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=instcombine < %s | FileCheck %s

declare void @use(i8)
declare void @use.i1(i1)
declare i8 @llvm.umin.i8(i8, i8)

define i1 @icmp_select_const(i8 %x, i8 %y) {
; CHECK-LABEL: @icmp_select_const(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[X:%.*]], 0
; CHECK-NEXT:    [[CMP21:%.*]] = icmp eq i8 [[Y:%.*]], 0
; CHECK-NEXT:    [[CMP2:%.*]] = select i1 [[CMP1]], i1 true, i1 [[CMP21]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp eq i8 %x, 0
  %sel = select i1 %cmp1, i8 0, i8 %y
  %cmp2 = icmp eq i8 %sel, 0
  ret i1 %cmp2
}

define i1 @icmp_select_var(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @icmp_select_var(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[X:%.*]], 0
; CHECK-NEXT:    [[CMP21:%.*]] = icmp eq i8 [[Y:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[CMP2:%.*]] = select i1 [[CMP1]], i1 true, i1 [[CMP21]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp eq i8 %x, 0
  %sel = select i1 %cmp1, i8 %z, i8 %y
  %cmp2 = icmp eq i8 %sel, %z
  ret i1 %cmp2
}

define i1 @icmp_select_var_commuted(i8 %x, i8 %y, i8 %_z) {
; CHECK-LABEL: @icmp_select_var_commuted(
; CHECK-NEXT:    [[Z:%.*]] = udiv i8 42, [[_Z:%.*]]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[X:%.*]], 0
; CHECK-NEXT:    [[CMP21:%.*]] = icmp eq i8 [[Z]], [[Y:%.*]]
; CHECK-NEXT:    [[CMP2:%.*]] = select i1 [[CMP1]], i1 true, i1 [[CMP21]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %z = udiv i8 42, %_z ; thwart complexity-based canonicalization
  %cmp1 = icmp eq i8 %x, 0
  %sel = select i1 %cmp1, i8 %z, i8 %y
  %cmp2 = icmp eq i8 %z, %sel
  ret i1 %cmp2
}

define i1 @icmp_select_var_select(i8 %x, i8 %y, i1 %c) {
; CHECK-LABEL: @icmp_select_var_select(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[X:%.*]], 0
; CHECK-NEXT:    [[CMP212:%.*]] = icmp eq i8 [[X]], [[Y:%.*]]
; CHECK-NEXT:    [[NOT_C:%.*]] = xor i1 [[C:%.*]], true
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[CMP1]], i1 true, i1 [[NOT_C]]
; CHECK-NEXT:    [[CMP2:%.*]] = select i1 [[TMP1]], i1 true, i1 [[CMP212]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %z = select i1 %c, i8 %x, i8 %y
  %cmp1 = icmp eq i8 %x, 0
  %sel = select i1 %cmp1, i8 %z, i8 %y
  %cmp2 = icmp eq i8 %z, %sel
  ret i1 %cmp2
}

define i1 @icmp_select_var_both_fold(i8 %x, i8 %y, i8 %_z) {
; CHECK-LABEL: @icmp_select_var_both_fold(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[X:%.*]], 0
; CHECK-NEXT:    ret i1 [[CMP1]]
;
  %z = or i8 %_z, 1
  %cmp1 = icmp eq i8 %x, 0
  %sel = select i1 %cmp1, i8 %z, i8 2
  %cmp2 = icmp eq i8 %sel, %z
  ret i1 %cmp2
}

define i1 @icmp_select_var_extra_use(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @icmp_select_var_extra_use(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[X:%.*]], 0
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[CMP1]], i8 [[Z:%.*]], i8 [[Y:%.*]]
; CHECK-NEXT:    call void @use(i8 [[SEL]])
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i8 [[SEL]], [[Z]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp eq i8 %x, 0
  %sel = select i1 %cmp1, i8 %z, i8 %y
  call void @use(i8 %sel)
  %cmp2 = icmp eq i8 %sel, %z
  ret i1 %cmp2
}

define i1 @icmp_select_var_both_fold_extra_use(i8 %x, i8 %y, i8 %_z) {
; CHECK-LABEL: @icmp_select_var_both_fold_extra_use(
; CHECK-NEXT:    [[Z:%.*]] = or i8 [[_Z:%.*]], 1
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[X:%.*]], 0
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[CMP1]], i8 [[Z]], i8 2
; CHECK-NEXT:    call void @use(i8 [[SEL]])
; CHECK-NEXT:    ret i1 [[CMP1]]
;
  %z = or i8 %_z, 1
  %cmp1 = icmp eq i8 %x, 0
  %sel = select i1 %cmp1, i8 %z, i8 2
  call void @use(i8 %sel)
  %cmp2 = icmp eq i8 %sel, %z
  ret i1 %cmp2
}

define i1 @icmp_select_var_pred_ne(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @icmp_select_var_pred_ne(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i8 [[X:%.*]], 0
; CHECK-NEXT:    [[CMP21:%.*]] = icmp ne i8 [[Y:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[CMP2:%.*]] = select i1 [[CMP1]], i1 [[CMP21]], i1 false
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp eq i8 %x, 0
  %sel = select i1 %cmp1, i8 %z, i8 %y
  %cmp2 = icmp ne i8 %sel, %z
  ret i1 %cmp2
}

define i1 @icmp_select_var_pred_ult(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @icmp_select_var_pred_ult(
; CHECK-NEXT:    [[Z1:%.*]] = add nuw i8 [[Z:%.*]], 2
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[X:%.*]], 0
; CHECK-NEXT:    [[CMP21:%.*]] = icmp ugt i8 [[Z1]], [[Y:%.*]]
; CHECK-NEXT:    [[CMP2:%.*]] = select i1 [[CMP1]], i1 true, i1 [[CMP21]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %z1 = add nuw i8 %z, 2
  %cmp1 = icmp eq i8 %x, 0
  %sel = select i1 %cmp1, i8 %z, i8 %y
  %cmp2 = icmp ult i8 %sel, %z1
  ret i1 %cmp2
}

define i1 @icmp_select_var_pred_uge(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @icmp_select_var_pred_uge(
; CHECK-NEXT:    [[Z1:%.*]] = add nuw i8 [[Z:%.*]], 2
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i8 [[X:%.*]], 0
; CHECK-NEXT:    [[CMP21:%.*]] = icmp ule i8 [[Z1]], [[Y:%.*]]
; CHECK-NEXT:    [[CMP2:%.*]] = select i1 [[CMP1]], i1 [[CMP21]], i1 false
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %z1 = add nuw i8 %z, 2
  %cmp1 = icmp eq i8 %x, 0
  %sel = select i1 %cmp1, i8 %z, i8 %y
  %cmp2 = icmp uge i8 %sel, %z1
  ret i1 %cmp2
}

define i1 @icmp_select_var_pred_uge_commuted(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @icmp_select_var_pred_uge_commuted(
; CHECK-NEXT:    [[Z1:%.*]] = add nuw i8 [[Z:%.*]], 2
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[X:%.*]], 0
; CHECK-NEXT:    [[CMP21:%.*]] = icmp uge i8 [[Z1]], [[Y:%.*]]
; CHECK-NEXT:    [[CMP2:%.*]] = select i1 [[CMP1]], i1 true, i1 [[CMP21]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %z1 = add nuw i8 %z, 2
  %cmp1 = icmp eq i8 %x, 0
  %sel = select i1 %cmp1, i8 %z, i8 %y
  %cmp2 = icmp uge i8 %z1, %sel
  ret i1 %cmp2
}

define i1 @icmp_select_implied_cond(i8 %x, i8 %y) {
; CHECK-LABEL: @icmp_select_implied_cond(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[X:%.*]], 0
; CHECK-NEXT:    [[CMP21:%.*]] = icmp eq i8 [[Y:%.*]], [[X]]
; CHECK-NEXT:    [[CMP2:%.*]] = select i1 [[CMP1]], i1 true, i1 [[CMP21]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp eq i8 %x, 0
  %sel = select i1 %cmp1, i8 0, i8 %y
  %cmp2 = icmp eq i8 %sel, %x
  ret i1 %cmp2
}

define i1 @icmp_select_implied_cond_ne(i8 %x, i8 %y) {
; CHECK-LABEL: @icmp_select_implied_cond_ne(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i8 [[X:%.*]], 0
; CHECK-NEXT:    [[CMP21:%.*]] = icmp ne i8 [[Y:%.*]], [[X]]
; CHECK-NEXT:    [[CMP2:%.*]] = select i1 [[CMP1]], i1 [[CMP21]], i1 false
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp eq i8 %x, 0
  %sel = select i1 %cmp1, i8 0, i8 %y
  %cmp2 = icmp ne i8 %sel, %x
  ret i1 %cmp2
}

define i1 @icmp_select_implied_cond_swapped_select(i8 %x, i8 %y) {
; CHECK-LABEL: @icmp_select_implied_cond_swapped_select(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[X:%.*]], 0
; CHECK-NEXT:    [[CMP21:%.*]] = icmp eq i8 [[Y:%.*]], 0
; CHECK-NEXT:    [[CMP2:%.*]] = select i1 [[CMP1]], i1 [[CMP21]], i1 false
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp eq i8 %x, 0
  %sel = select i1 %cmp1, i8 %y, i8 0
  %cmp2 = icmp eq i8 %sel, %x
  ret i1 %cmp2
}

define i1 @icmp_select_implied_cond_swapped_select_with_inv_cond(i8 %x, i8 %y) {
; CHECK-LABEL: @icmp_select_implied_cond_swapped_select_with_inv_cond(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i8 [[X:%.*]], 0
; CHECK-NEXT:    call void @use.i1(i1 [[CMP1]])
; CHECK-NEXT:    [[CMP21:%.*]] = icmp eq i8 [[Y:%.*]], [[X]]
; CHECK-NEXT:    [[NOT_CMP1:%.*]] = xor i1 [[CMP1]], true
; CHECK-NEXT:    [[CMP2:%.*]] = select i1 [[NOT_CMP1]], i1 true, i1 [[CMP21]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp ne i8 %x, 0
  call void @use.i1(i1 %cmp1)
  %sel = select i1 %cmp1, i8 %y, i8 0
  %cmp2 = icmp eq i8 %sel, %x
  ret i1 %cmp2
}

define i1 @icmp_select_implied_cond_relational(i8 %x, i8 %y) {
; CHECK-LABEL: @icmp_select_implied_cond_relational(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ugt i8 [[X:%.*]], 10
; CHECK-NEXT:    [[CMP21:%.*]] = icmp ult i8 [[Y:%.*]], [[X]]
; CHECK-NEXT:    [[CMP2:%.*]] = select i1 [[CMP1]], i1 true, i1 [[CMP21]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp ugt i8 %x, 10
  %sel = select i1 %cmp1, i8 10, i8 %y
  %cmp2 = icmp ult i8 %sel, %x
  ret i1 %cmp2
}

define i1 @icmp_select_implied_cond_relational_off_by_one(i8 %x, i8 %y) {
; CHECK-LABEL: @icmp_select_implied_cond_relational_off_by_one(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ugt i8 [[X:%.*]], 10
; CHECK-NEXT:    call void @use.i1(i1 [[CMP1]])
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[CMP1]], i8 11, i8 [[Y:%.*]]
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ult i8 [[SEL]], [[X]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp ugt i8 %x, 10
  call void @use.i1(i1 %cmp1)
  %sel = select i1 %cmp1, i8 11, i8 %y
  %cmp2 = icmp ult i8 %sel, %x
  ret i1 %cmp2
}

define i1 @umin_seq_comparison(i8 %x, i8 %y) {
; CHECK-LABEL: @umin_seq_comparison(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 [[X:%.*]], 0
; CHECK-NEXT:    [[CMP21:%.*]] = icmp ule i8 [[X]], [[Y:%.*]]
; CHECK-NEXT:    [[CMP2:%.*]] = select i1 [[CMP1]], i1 true, i1 [[CMP21]]
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %min = call i8 @llvm.umin.i8(i8 %x, i8 %y)
  %cmp1 = icmp eq i8 %x, 0
  %sel = select i1 %cmp1, i8 0, i8 %min
  %cmp2 = icmp eq i8 %sel, %x
  ret i1 %cmp2
}
