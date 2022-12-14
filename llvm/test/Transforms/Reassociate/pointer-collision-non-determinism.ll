; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -run-twice -passes=reassociate %s -S -o - | FileCheck %s
; RUN: opt -run-twice -passes=reassociate %s -S -o - | FileCheck %s

; The PairMap[NumBinaryOps] used by the Reassociate pass used to have Value
; *pointers as keys and no handling for values being removed. In some cases (in
; practice very rarely, but in this particular test - well over 50% of the time)
; a newly created Value would happen to get allocated at the same memory
; address, effectively "replacing" the key in the map.
;
; Test that that doesn't happen anymore and the pass is deterministic.
;
; The failure rate of this test (at least, on my 8 core iMac), when ran in the
; context of other unit tests executed | specifically, I was trying
;
;   ./bin/llvm-lit -v ../test/Transforms/Reassociate
;
; is as follows:
;
; # of RUN lines repeated | just -run-twice | -run-twice and CHECK lines
; ------------------------+-----------------+---------------------------
;  1                      |             30% |          <didn't measure>
;  2                      |             55% |          95%
;  3                      |             55% |          <didn't measure>
;
; hence the specific shape of this test. The IR itself comes from a real-world
; code, successfully bugpointed.

define float @test(float %arg) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP:%.*]] = fmul fast float [[ARG:%.*]], 0x3FE99999A0000000
; CHECK-NEXT:    [[TMP110:%.*]] = fsub fast float 1.000000e+00, [[TMP]]
; CHECK-NEXT:    [[TMP2:%.*]] = fmul fast float [[ARG]], 0x3FE99999A0000000
; CHECK-NEXT:    [[TMP311:%.*]] = fsub fast float 1.000000e+00, [[TMP2]]
; CHECK-NEXT:    [[REASS_MUL160:%.*]] = fmul fast float [[TMP110]], [[ARG]]
; CHECK-NEXT:    [[TMP4:%.*]] = fmul fast float [[REASS_MUL160]], [[TMP311]]
; CHECK-NEXT:    [[TMP5:%.*]] = fadd fast float [[TMP4]], [[ARG]]
; CHECK-NEXT:    [[TMP6:%.*]] = fmul fast float [[TMP5]], [[ARG]]
; CHECK-NEXT:    [[TMP7:%.*]] = fadd fast float [[TMP6]], [[ARG]]
; CHECK-NEXT:    [[TMP8:%.*]] = fmul fast float [[TMP7]], [[ARG]]
; CHECK-NEXT:    [[TMP9:%.*]] = fadd fast float [[TMP8]], [[ARG]]
; CHECK-NEXT:    [[TMP10:%.*]] = fmul fast float [[TMP9]], [[ARG]]
; CHECK-NEXT:    [[TMP11:%.*]] = fadd fast float [[TMP10]], [[ARG]]
; CHECK-NEXT:    [[TMP12:%.*]] = fmul fast float [[TMP11]], [[ARG]]
; CHECK-NEXT:    [[TMP13:%.*]] = fadd fast float [[TMP12]], [[ARG]]
; CHECK-NEXT:    [[TMP14:%.*]] = fmul fast float [[TMP13]], [[ARG]]
; CHECK-NEXT:    [[TMP15:%.*]] = fadd fast float [[TMP14]], [[ARG]]
; CHECK-NEXT:    [[TMP16:%.*]] = fmul fast float [[TMP15]], [[ARG]]
; CHECK-NEXT:    [[TMP17:%.*]] = fadd fast float [[TMP16]], [[ARG]]
; CHECK-NEXT:    [[TMP18:%.*]] = fmul fast float [[TMP17]], [[ARG]]
; CHECK-NEXT:    [[TMP19:%.*]] = fadd fast float [[TMP18]], [[ARG]]
; CHECK-NEXT:    [[TMP20:%.*]] = fmul fast float [[TMP19]], [[ARG]]
; CHECK-NEXT:    [[TMP21:%.*]] = fadd fast float [[TMP20]], [[ARG]]
; CHECK-NEXT:    [[TMP22:%.*]] = fmul fast float [[TMP21]], [[ARG]]
; CHECK-NEXT:    [[TMP23:%.*]] = fadd fast float [[TMP22]], [[ARG]]
; CHECK-NEXT:    [[REASS_MUL166:%.*]] = fmul fast float [[ARG]], [[ARG]]
; CHECK-NEXT:    [[TMP24:%.*]] = fmul fast float [[REASS_MUL166]], [[TMP23]]
; CHECK-NEXT:    [[TMP25:%.*]] = fadd fast float [[TMP24]], [[ARG]]
; CHECK-NEXT:    [[TMP26:%.*]] = fmul fast float [[TMP25]], [[ARG]]
; CHECK-NEXT:    [[TMP27:%.*]] = fadd fast float [[TMP26]], [[ARG]]
; CHECK-NEXT:    [[TMP29:%.*]] = fmul fast float [[ARG]], [[ARG]]
; CHECK-NEXT:    [[TMP31:%.*]] = fmul fast float [[TMP29]], 0x3FEA2E8B80000000
; CHECK-NEXT:    [[TMP33:%.*]] = fmul fast float [[TMP31]], [[TMP27]]
; CHECK-NEXT:    [[TMP34:%.*]] = fadd fast float [[TMP33]], [[ARG]]
; CHECK-NEXT:    ret float [[TMP34]]
;
entry:
  %tmp = fmul fast float %arg, 0xBFE99999A0000000
  %tmp1 = fadd fast float %tmp, 1.000000e+00
  %tmp2 = fmul fast float %arg, 0xBFE99999A0000000
  %tmp3 = fadd fast float %tmp2, 1.000000e+00
  %reass.mul156 = fmul fast float %arg, %tmp1
  %reass.mul160 = fmul fast float %arg, %tmp1
  %tmp4 = fmul fast float %reass.mul160, %tmp3
  %tmp5 = fadd fast float %arg, %tmp4
  %tmp6 = fmul fast float %tmp5, %arg
  %tmp7 = fadd fast float %tmp6, %arg
  %tmp8 = fmul fast float %tmp7, %arg
  %tmp9 = fadd fast float %arg, %tmp8
  %tmp10 = fmul fast float %tmp9, %arg
  %tmp11 = fadd fast float %tmp10, %arg
  %tmp12 = fmul fast float %tmp11, %arg
  %tmp13 = fadd fast float %tmp12, %arg
  %tmp14 = fmul fast float %tmp13, %arg
  %tmp15 = fadd fast float %arg, %tmp14
  %tmp16 = fmul fast float %tmp15, %arg
  %tmp17 = fadd fast float %tmp16, %arg
  %tmp18 = fmul fast float %tmp17, %arg
  %tmp19 = fadd fast float %tmp18, %arg
  %tmp20 = fmul fast float %tmp19, %arg
  %tmp21 = fadd fast float %tmp20, %arg
  %tmp22 = fmul fast float %tmp21, %arg
  %tmp23 = fadd fast float %tmp22, %arg
  %reass.mul166 = fmul fast float %arg, %tmp23
  %tmp24 = fmul fast float %reass.mul166, %arg
  %tmp25 = fadd fast float %arg, %tmp24
  %tmp26 = fmul fast float %arg, %tmp25
  %tmp27 = fadd fast float %tmp26, %arg
  %tmp28 = fmul fast float %arg, %tmp27
  %tmp29 = fmul fast float %tmp28, %arg
  %tmp31 = fmul fast float %tmp29, 0x3FED1745C0000000
  %tmp33 = fmul fast float %tmp31, 0x3FECCCCCC0000000
  %tmp34 = fadd fast float %arg, %tmp33
  ret float %tmp34
}

