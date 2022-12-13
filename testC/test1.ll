; ModuleID = '../testC/test1.cpp'
source_filename = "../testC/test1.cpp"
target datalayout = "e-m:e-p:32:32-i1:32-i8:32-i16:32-i32:32-i64:64-a:32-n32-S32"
target triple = "urcl"

%struct.Vec2 = type { i32, i32 }

$_ZN4Vec2plERKS_ = comdat any

@__const.main.a = private unnamed_addr constant %struct.Vec2 { i32 1, i32 2 }, align 4
@__const.main.b = private unnamed_addr constant %struct.Vec2 { i32 2, i32 3 }, align 4

; Function Attrs: mustprogress noinline norecurse optnone
define dso_local noundef i32 @main() #0 {
entry:
  %retval = alloca i32, align 4
  %a = alloca %struct.Vec2, align 4
  %b = alloca %struct.Vec2, align 4
  %c = alloca %struct.Vec2, align 4
  store i32 0, ptr %retval, align 4
  call void @llvm.memcpy.p0.p0.i32(ptr align 4 %a, ptr align 4 @__const.main.a, i32 8, i1 false)
  call void @llvm.memcpy.p0.p0.i32(ptr align 4 %b, ptr align 4 @__const.main.b, i32 8, i1 false)
  call void @_ZN4Vec2plERKS_(ptr sret(%struct.Vec2) align 4 %c, ptr noundef nonnull align 4 dereferenceable(8) %a, ptr noundef nonnull align 4 dereferenceable(8) %b)
  %x = getelementptr inbounds %struct.Vec2, ptr %c, i32 0, i32 0
  %0 = load i32, ptr %x, align 4
  %y = getelementptr inbounds %struct.Vec2, ptr %c, i32 0, i32 1
  %1 = load i32, ptr %y, align 4
  %add = add nsw i32 %0, %1
  ret i32 %add
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i32(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i32, i1 immarg) #1

; Function Attrs: mustprogress noinline nounwind optnone
define linkonce_odr dso_local void @_ZN4Vec2plERKS_(ptr noalias sret(%struct.Vec2) align 4 %agg.result, ptr noundef nonnull align 4 dereferenceable(8) %this, ptr noundef nonnull align 4 dereferenceable(8) %rhs) #2 comdat align 2 {
entry:
  %this.addr = alloca ptr, align 4
  %rhs.addr = alloca ptr, align 4
  store ptr %this, ptr %this.addr, align 4
  store ptr %rhs, ptr %rhs.addr, align 4
  %this1 = load ptr, ptr %this.addr, align 4
  %x = getelementptr inbounds %struct.Vec2, ptr %agg.result, i32 0, i32 0
  %x2 = getelementptr inbounds %struct.Vec2, ptr %this1, i32 0, i32 0
  %0 = load i32, ptr %x2, align 4
  %1 = load ptr, ptr %rhs.addr, align 4
  %x3 = getelementptr inbounds %struct.Vec2, ptr %1, i32 0, i32 0
  %2 = load i32, ptr %x3, align 4
  %add = add nsw i32 %0, %2
  store i32 %add, ptr %x, align 4
  %y = getelementptr inbounds %struct.Vec2, ptr %agg.result, i32 0, i32 1
  %y4 = getelementptr inbounds %struct.Vec2, ptr %this1, i32 0, i32 1
  %3 = load i32, ptr %y4, align 4
  %4 = load ptr, ptr %rhs.addr, align 4
  %y5 = getelementptr inbounds %struct.Vec2, ptr %4, i32 0, i32 1
  %5 = load i32, ptr %y5, align 4
  %add6 = add nsw i32 %3, %5
  store i32 %add6, ptr %y, align 4
  ret void
}

attributes #0 = { mustprogress noinline norecurse optnone "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { mustprogress noinline nounwind optnone "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"frame-pointer", i32 2}
!2 = !{!"clang version 16.0.0 (git@github.com:TimZF/urcl_llvm_backend.git feff2f66c91727b1e3a792e18db0bf54fdbb447a)"}
