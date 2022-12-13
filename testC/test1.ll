; ModuleID = '../testC/test1.cpp'
source_filename = "../testC/test1.cpp"
target datalayout = "e-m:e-p:32:32-i1:32-i8:32-i16:32-i32:32-i64:64-a:32-n32-S32"
target triple = "urcl"

%struct.Vec2 = type { i32, i32 }

@__const.main.a = private unnamed_addr constant %struct.Vec2 { i32 1, i32 2 }, align 4

; Function Attrs: mustprogress noinline norecurse nounwind optnone
define dso_local noundef i32 @main() #0 {
entry:
  %retval = alloca i32, align 4
  %a = alloca %struct.Vec2, align 4
  store i32 0, ptr %retval, align 4
  call void @llvm.memcpy.p0.p0.i32(ptr align 4 %a, ptr align 4 @__const.main.a, i32 8, i1 false)
  %y = getelementptr inbounds %struct.Vec2, ptr %a, i32 0, i32 1
  %0 = load i32, ptr %y, align 4
  ret i32 %0
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i32(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i32, i1 immarg) #1

attributes #0 = { mustprogress noinline norecurse nounwind optnone "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"frame-pointer", i32 2}
!2 = !{!"clang version 16.0.0 (git@github.com:TimZF/urcl_llvm_backend.git 015151dd5cc77e69c84289d936503e6ca0269edc)"}
