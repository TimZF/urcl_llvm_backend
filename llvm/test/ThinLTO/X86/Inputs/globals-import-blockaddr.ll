target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@label_addr = internal constant [1 x ptr] [ptr blockaddress(@bar, %lb)], align 8

; Function Attrs: noinline norecurse nounwind optnone uwtable
define dso_local ptr @foo() {
  ret ptr @label_addr
}

; Function Attrs: noinline norecurse nounwind optnone uwtable
define dso_local ptr @bar() {
  br label %lb

lb:
  ret ptr @label_addr
}
