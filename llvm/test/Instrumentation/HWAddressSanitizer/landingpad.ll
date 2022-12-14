; RUN: opt < %s -mtriple aarch64-linux-android29 -passes=hwasan -S | FileCheck %s --check-prefixes=COMMON,LP,ARM
; RUN: opt < %s -mtriple x86_64-linux -hwasan-instrument-landing-pads -passes=hwasan -S | FileCheck %s --check-prefixes=COMMON,LP,X86
; RUN: opt < %s -mtriple aarch64-linux-android30 -passes=hwasan -S | FileCheck %s --check-prefixes=COMMON,NOLP

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-android"

define i32 @f() local_unnamed_addr sanitize_hwaddress personality ptr @__gxx_personality_v0 {
entry:
  invoke void @g()
          to label %return unwind label %lpad

lpad:
  ; COMMON:       landingpad { ptr, i32 }
  ; COMMON-NEXT:    catch ptr null
  %0 = landingpad { ptr, i32 }
          catch ptr null

  ; NOLP-NOT: call void @__hwasan_handle_vfork
  ; LP-NEXT: %[[X:[^ ]*]] = call i64 @llvm.read_register.i64(metadata ![[META:[^ ]*]])
  ; LP-NEXT: call void @__hwasan_handle_vfork(i64 %[[X]])

  %1 = extractvalue { ptr, i32 } %0, 0
  %2 = tail call ptr @__cxa_begin_catch(ptr %1)
  tail call void @__cxa_end_catch()
  br label %return
return:
  %retval.0 = phi i32 [ 1, %lpad ], [ 0, %entry ]
  ret i32 %retval.0
}

declare void @g() local_unnamed_addr

declare i32 @__gxx_personality_v0(...)
declare ptr @__cxa_begin_catch(ptr) local_unnamed_addr
declare void @__cxa_end_catch() local_unnamed_addr

; ARM: ![[META]] = !{!"sp"}
; X86: ![[META]] = !{!"rsp"}
