//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// UNSUPPORTED: c++03, c++11, c++14
// XFAIL: use_system_cxx_lib && target={{.+}}-apple-macosx10.{{9|10|11|12|13|14|15}}
// XFAIL: use_system_cxx_lib && target={{.+}}-apple-macosx{{11.0|12.0}}

// <memory_resource>

// class unsynchronized_pool_resource

#include <memory_resource>
#include <cassert>

int main(int, char**) {
  std::pmr::memory_resource* expected = std::pmr::null_memory_resource();
  std::pmr::set_default_resource(expected);
  {
    std::pmr::pool_options opts{0, 0};
    std::pmr::unsynchronized_pool_resource r1;
    std::pmr::unsynchronized_pool_resource r2(opts);
    assert(r1.upstream_resource() == expected);
    assert(r2.upstream_resource() == expected);
  }

  expected = std::pmr::new_delete_resource();
  std::pmr::set_default_resource(expected);
  {
    std::pmr::pool_options opts{1024, 2048};
    std::pmr::unsynchronized_pool_resource r1;
    std::pmr::unsynchronized_pool_resource r2(opts);
    assert(r1.upstream_resource() == expected);
    assert(r2.upstream_resource() == expected);
  }

  return 0;
}
