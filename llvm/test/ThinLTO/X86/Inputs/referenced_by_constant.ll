
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.11.0"

define void @referencedbyglobal() {
    ret void
}

define internal void @localreferencedbyglobal() {
    ret void
}

@someglobal = internal unnamed_addr constant ptr @referencedbyglobal
@someglobal2 = internal unnamed_addr constant ptr @localreferencedbyglobal
@ptr = global ptr null
@ptr2 = global ptr null

define  void @bar() #0 align 2 {
  store ptr @someglobal , ptr @ptr, align 8
  store ptr @someglobal2 , ptr @ptr2, align 8
  ret void
}
