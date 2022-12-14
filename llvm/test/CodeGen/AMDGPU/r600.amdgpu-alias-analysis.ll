; RUN: opt -mtriple=r600-- -passes='default<O3>,aa-eval' -print-all-alias-modref-info -disable-output < %s 2>&1 | FileCheck %s

; CHECK: MayAlias: i8 addrspace(5)* %p, i8 addrspace(999)* %p1
define amdgpu_kernel void @test(ptr addrspace(5) %p, ptr addrspace(999) %p1) {
  load volatile i8, ptr addrspace(5) %p
  load volatile i8, ptr addrspace(999) %p1
  ret void
}
