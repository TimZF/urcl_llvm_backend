; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-gnu-linux < %s | FileCheck %s -check-prefix=CHECK

@var_char = external thread_local local_unnamed_addr global i8, align 1
@var_short = external thread_local local_unnamed_addr global i16, align 2
@var_int = external thread_local local_unnamed_addr global i32, align 4
@var_long_long = external thread_local local_unnamed_addr global i64, align 8

define dso_local zeroext i8 @test_char_one() {
; CHECK-LABEL: test_char_one:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis 3, 2, var_char@got@tprel@ha
; CHECK-NEXT:    ld 3, var_char@got@tprel@l(3)
; CHECK-NEXT:    lbzx 3, 3, var_char@tls
; CHECK-NEXT:    blr
entry:
  %0 = load i8, ptr @var_char, align 1, !tbaa !4
  ret i8 %0
}

define dso_local void @test_char_two(i32 signext %a) {
; CHECK-LABEL: test_char_two:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis 4, 2, var_char@got@tprel@ha
; CHECK-NEXT:    ld 4, var_char@got@tprel@l(4)
; CHECK-NEXT:    stbx 3, 4, var_char@tls
; CHECK-NEXT:    blr
entry:
  %conv = trunc i32 %a to i8
  store i8 %conv, ptr @var_char, align 1, !tbaa !4
  ret void
}

define dso_local zeroext i8 @test_char_three(i8 zeroext %a) {
; CHECK-LABEL: test_char_three:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis 4, 2, var_char@got@tprel@ha
; CHECK-NEXT:    ld 4, var_char@got@tprel@l(4)
; CHECK-NEXT:    lbzx 5, 4, var_char@tls
; CHECK-NEXT:    add 5, 5, 3
; CHECK-NEXT:    clrldi 3, 5, 56
; CHECK-NEXT:    stbx 5, 4, var_char@tls
; CHECK-NEXT:    blr
entry:
  %0 = load i8, ptr @var_char, align 1, !tbaa !4
  %add = add i8 %0, %a
  store i8 %add, ptr @var_char, align 1, !tbaa !4
  ret i8 %add
}

define dso_local signext i16 @test_short_one() {
; CHECK-LABEL: test_short_one:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis 3, 2, var_short@got@tprel@ha
; CHECK-NEXT:    ld 3, var_short@got@tprel@l(3)
; CHECK-NEXT:    lhzx 3, 3, var_short@tls
; CHECK-NEXT:    blr
entry:
  %0 = load i16, ptr @var_short, align 2, !tbaa !7
  ret i16 %0
}

define dso_local void @test_short_two(i32 signext %a) {
; CHECK-LABEL: test_short_two:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis 4, 2, var_short@got@tprel@ha
; CHECK-NEXT:    ld 4, var_short@got@tprel@l(4)
; CHECK-NEXT:    sthx 3, 4, var_short@tls
; CHECK-NEXT:    blr
entry:
  %conv = trunc i32 %a to i16
  store i16 %conv, ptr @var_short, align 2, !tbaa !7
  ret void
}

define dso_local signext i16 @test_short_three(i16 signext %a) {
; CHECK-LABEL: test_short_three:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis 4, 2, var_short@got@tprel@ha
; CHECK-NEXT:    ld 4, var_short@got@tprel@l(4)
; CHECK-NEXT:    lhzx 5, 4, var_short@tls
; CHECK-NEXT:    add 5, 5, 3
; CHECK-NEXT:    extsh 3, 5
; CHECK-NEXT:    sthx 5, 4, var_short@tls
; CHECK-NEXT:    blr
entry:
  %0 = load i16, ptr @var_short, align 2, !tbaa !7
  %add = add i16 %0, %a
  store i16 %add, ptr @var_short, align 2, !tbaa !7
  ret i16 %add
}

define dso_local signext i32 @test_int_one() {
; CHECK-LABEL: test_int_one:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis 3, 2, var_int@got@tprel@ha
; CHECK-NEXT:    ld 3, var_int@got@tprel@l(3)
; CHECK-NEXT:    lwzx 3, 3, var_int@tls
; CHECK-NEXT:    blr
entry:
  %0 = load i32, ptr @var_int, align 4, !tbaa !9
  ret i32 %0
}

define dso_local void @test_int_two(i32 signext %a) {
; CHECK-LABEL: test_int_two:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis 4, 2, var_int@got@tprel@ha
; CHECK-NEXT:    ld 4, var_int@got@tprel@l(4)
; CHECK-NEXT:    stwx 3, 4, var_int@tls
; CHECK-NEXT:    blr
entry:
  store i32 %a, ptr @var_int, align 4, !tbaa !9
  ret void
}

define dso_local signext i32 @test_int_three(i32 signext %a) {
; CHECK-LABEL: test_int_three:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis 4, 2, var_int@got@tprel@ha
; CHECK-NEXT:    ld 4, var_int@got@tprel@l(4)
; CHECK-NEXT:    lwzx 5, 4, var_int@tls
; CHECK-NEXT:    add 5, 5, 3
; CHECK-NEXT:    extsw 3, 5
; CHECK-NEXT:    stwx 5, 4, var_int@tls
; CHECK-NEXT:    blr
entry:
  %0 = load i32, ptr @var_int, align 4, !tbaa !9
  %add = add nsw i32 %0, %a
  store i32 %add, ptr @var_int, align 4, !tbaa !9
  ret i32 %add
}

define dso_local i64 @test_longlong_one() {
; CHECK-LABEL: test_longlong_one:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis 3, 2, var_long_long@got@tprel@ha
; CHECK-NEXT:    ld 3, var_long_long@got@tprel@l(3)
; CHECK-NEXT:    ldx 3, 3, var_long_long@tls
; CHECK-NEXT:    blr
entry:
  %0 = load i64, ptr @var_long_long, align 8, !tbaa !11
  ret i64 %0
}

define dso_local void @test_longlong_two(i32 signext %a) {
; CHECK-LABEL: test_longlong_two:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis 4, 2, var_long_long@got@tprel@ha
; CHECK-NEXT:    ld 4, var_long_long@got@tprel@l(4)
; CHECK-NEXT:    stdx 3, 4, var_long_long@tls
; CHECK-NEXT:    blr
entry:
  %conv = sext i32 %a to i64
  store i64 %conv, ptr @var_long_long, align 8, !tbaa !11
  ret void
}

define dso_local i64 @test_longlong_three(i64 %a) {
; CHECK-LABEL: test_longlong_three:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis 4, 2, var_long_long@got@tprel@ha
; CHECK-NEXT:    ld 4, var_long_long@got@tprel@l(4)
; CHECK-NEXT:    ldx 5, 4, var_long_long@tls
; CHECK-NEXT:    add 3, 5, 3
; CHECK-NEXT:    stdx 3, 4, var_long_long@tls
; CHECK-NEXT:    blr
entry:
  %0 = load i64, ptr @var_long_long, align 8, !tbaa !11
  %add = add nsw i64 %0, %a
  store i64 %add, ptr @var_long_long, align 8, !tbaa !11
  ret i64 %add
}

!llvm.module.flags = !{!0, !1, !2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 1}
!2 = !{i32 7, !"PIE Level", i32 1}
!4 = !{!5, !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = !{!8, !8, i64 0}
!8 = !{!"short", !5, i64 0}
!9 = !{!10, !10, i64 0}
!10 = !{!"int", !5, i64 0}
!11 = !{!12, !12, i64 0}
!12 = !{!"long long", !5, i64 0}
