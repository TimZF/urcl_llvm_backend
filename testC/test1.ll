; ModuleID = '../testC/test1.cpp'
source_filename = "../testC/test1.cpp"
target datalayout = "e-m:e-p:32:32-i1:32-i8:32-i16:32-i32:32-i64:64-a:32-n32-S32"
target triple = "urcl"

; Function Attrs: mustprogress noinline nounwind optnone
define dso_local noundef i32 @_Z6myFuncii(i32 noundef %a, i32 noundef %b) #0 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  store i32 %a, ptr %a.addr, align 4
  store i32 %b, ptr %b.addr, align 4
  %0 = load i32, ptr %a.addr, align 4
  %1 = load i32, ptr %b.addr, align 4
  %add = add nsw i32 %0, %1
  ret i32 %add
}

; Function Attrs: mustprogress noinline norecurse nounwind optnone
define dso_local noundef i32 @main() #1 {
entry:
  %retval = alloca i32, align 4
  %a = alloca [2 x i32], align 4
  store i32 0, ptr %retval, align 4
  %arrayinit.begin = getelementptr inbounds [2 x i32], ptr %a, i32 0, i32 0
  %call = call noundef i32 @_Z6myFuncii(i32 noundef 32, i32 noundef 5)
  store i32 %call, ptr %arrayinit.begin, align 4
  %arrayinit.element = getelementptr inbounds i32, ptr %arrayinit.begin, i32 1
  store i32 64, ptr %arrayinit.element, align 4
  ret i32 0
}

attributes #0 = { mustprogress noinline nounwind optnone "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress noinline norecurse nounwind optnone "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"frame-pointer", i32 2}
!2 = !{!"clang version 16.0.0 (git@github.com:TimZF/urcl_llvm_backend.git 36e954145c0cfba0089228dfb9104e522079e68a)"}
