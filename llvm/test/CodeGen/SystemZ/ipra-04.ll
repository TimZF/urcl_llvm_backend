; Test that the updated regmask on the call to @fun1 preserves %r14 and
; %15. @fun1 will save and restore these registers since it contains a call.
;
; RUN: llc -mtriple=s390x-linux-gnu -mcpu=z13 -enable-ipra -print-regmask-num-regs=-1 \
; RUN:   -debug-only=ip-regalloc 2>&1 < %s | FileCheck --check-prefix=DBG %s
; REQUIRES: asserts
;
; DBG: fun1 function optimized for not having CSR
; DBG: Call Instruction After Register Usage Info Propagation :
; DBG-NEXT: CallBRASL @fun1{{.*}} $r14d $r15d

declare dso_local fastcc signext i32 @foo(ptr, i32 signext) unnamed_addr

define internal fastcc void @fun1(ptr %arg, ptr nocapture %arg1) unnamed_addr #0 {
bb:
  %tmp = load i16, ptr undef, align 2
  %tmp2 = shl i16 %tmp, 4
  %tmp3 = tail call fastcc signext i32 @foo(ptr nonnull %arg, i32 signext 5)
  %tmp4 = or i16 0, %tmp2
  %tmp5 = or i16 %tmp4, 0
  store i16 %tmp5, ptr undef, align 2
  %tmp6 = getelementptr inbounds i16, ptr %arg, i64 5
  %tmp7 = load i16, ptr %tmp6, align 2
  store i16 %tmp7, ptr %arg1, align 2
  ret void
}

define fastcc void @fun0(ptr nocapture readonly %arg, ptr nocapture %arg1, i32 signext %arg2) unnamed_addr {
bb:
  %a = alloca i8, i64 undef
  call fastcc void @fun1(ptr nonnull undef, ptr %arg1)
  ret void
}

attributes #0 = { norecurse nounwind "frame-pointer"="none" }
