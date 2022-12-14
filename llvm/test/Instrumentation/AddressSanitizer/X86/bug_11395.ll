; RUN: opt < %s -passes=asan -S | llc -o /dev/null
; The bug manifests as a reg alloc failure:
; error: ran out of registers during register allocation
; ModuleID = 'z.o'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-unknown-linux-gnu"

%struct.DSPContext = type { ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, [6 x ptr], [6 x ptr], [6 x ptr], [6 x ptr], [6 x ptr], [6 x ptr], [6 x ptr], [6 x ptr], [6 x ptr], [6 x ptr], [6 x ptr], [6 x ptr], [6 x ptr], [6 x ptr], [6 x ptr], [6 x ptr], [6 x ptr], [6 x ptr], [6 x ptr], [6 x ptr], ptr, [4 x [4 x ptr]], [4 x [4 x ptr]], [4 x [4 x ptr]], [4 x [4 x ptr]], [2 x ptr], [11 x ptr], [11 x ptr], [2 x [16 x ptr]], [2 x [16 x ptr]], [2 x [16 x ptr]], [2 x [16 x ptr]], [8 x ptr], [3 x ptr], [3 x ptr], [3 x ptr], [3 x ptr], [4 x [16 x ptr]], [4 x [16 x ptr]], [4 x [16 x ptr]], [4 x [16 x ptr]], [10 x ptr], [10 x ptr], [2 x [16 x ptr]], [2 x [16 x ptr]], ptr, ptr, ptr, ptr, ptr, [2 x [4 x ptr]], ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, [2 x ptr], [2 x ptr], ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, [64 x i8], i32, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, [4 x ptr], ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, [16 x ptr], [16 x ptr], [12 x ptr], ptr, ptr, ptr, ptr, [4 x [16 x ptr]], [4 x [16 x ptr]], [4 x [16 x ptr]], [4 x [16 x ptr]], [3 x ptr], [3 x ptr] }
%struct.slice_buffer_s = type opaque
%struct.AVCodecContext = type { ptr, i32, i32, i32, i32, i32, ptr, i32, %struct.AVRational, i32, i32, i32, i32, i32, ptr, i32, i32, i32, i32, i32, i32, i32, float, float, i32, i32, i32, i32, float, i32, i32, i32, ptr, ptr, i32, ptr, i32, i32, i32, i32, i32, i32, i32, i32, i32, ptr, [32 x i8], i32, i32, i32, i32, i32, i32, i32, float, i32, ptr, ptr, i32, i32, i32, i32, ptr, ptr, float, float, i32, ptr, i32, ptr, i32, i32, i32, float, float, float, float, i32, float, float, float, float, float, i32, i32, ptr, i32, i32, i32, i32, %struct.AVRational, ptr, i32, i32, [4 x i64], i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, ptr, i32, i32, i32, i32, i32, i32, ptr, i32, i32, i32, i32, i32, i32, ptr, ptr, i32, i32, i32, i32, ptr, i32, ptr, i32, i32, i32, i32, i32, i32, i32, ptr, ptr, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, float, i32, i32, i32, i32, i32, i32, i32, i32, float, i32, i32, i32, i32, i32, i32, float, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i64, i32, float, i64, i32, i64, i64, float, float, ptr, i32, ptr, i32, i32, i32, i32, i32, ptr, i32, i32, i32, i32, i32, i32, ptr, float, float, float, float, i32, i32, i32, float, float, float, i32, i32, i32, i32, [4 x i32], ptr, i32, i32, i32, i32 }
%struct.AVClass = type { ptr, ptr, ptr }
%struct.AVOption = type opaque
%struct.AVRational = type { i32, i32 }
%struct.AVFrame = type { [4 x ptr], [4 x i32], [4 x ptr], i32, i32, i64, i32, i32, i32, i32, i32, ptr, i32, ptr, [2 x ptr], ptr, i8, ptr, [4 x i64], i32, i32, i32, i32, i32, ptr, i32, i32, ptr, [2 x ptr], i64, ptr }
%struct.AVPanScan = type { i32, i32, i32, [3 x [2 x i16]] }
%struct.AVCodec = type { ptr, i32, i32, i32, ptr, ptr, ptr, ptr, i32, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr }
%struct.AVPacket = type { i64, i64, ptr, i32, i32, i32, i32, ptr, ptr, i64, i64 }
%struct.RcOverride = type { i32, i32, i32, float }
%struct.AVPaletteControl = type { i32, [256 x i32] }
%struct.AVHWAccel = type { ptr, i32, i32, i32, i32, ptr, ptr, ptr, ptr, i32 }

@firtable = internal unnamed_addr constant [9 x ptr] [ptr @ff_mlp_firorder_0, ptr @ff_mlp_firorder_1, ptr @ff_mlp_firorder_2, ptr @ff_mlp_firorder_3, ptr @ff_mlp_firorder_4, ptr @ff_mlp_firorder_5, ptr @ff_mlp_firorder_6, ptr @ff_mlp_firorder_7, ptr @ff_mlp_firorder_8], align 4
@iirtable = internal unnamed_addr constant [5 x ptr] [ptr @ff_mlp_iirorder_0, ptr @ff_mlp_iirorder_1, ptr @ff_mlp_iirorder_2, ptr @ff_mlp_iirorder_3, ptr @ff_mlp_iirorder_4], align 4
@ff_mlp_iirorder_0 = external global i8
@ff_mlp_iirorder_1 = external global i8
@ff_mlp_iirorder_2 = external global i8
@ff_mlp_iirorder_3 = external global i8
@ff_mlp_iirorder_4 = external global i8
@ff_mlp_firorder_0 = external global i8
@ff_mlp_firorder_1 = external global i8
@ff_mlp_firorder_2 = external global i8
@ff_mlp_firorder_3 = external global i8
@ff_mlp_firorder_4 = external global i8
@ff_mlp_firorder_5 = external global i8
@ff_mlp_firorder_6 = external global i8
@ff_mlp_firorder_7 = external global i8
@ff_mlp_firorder_8 = external global i8

define void @ff_mlp_init_x86(ptr nocapture %c, ptr nocapture %avctx) nounwind sanitize_address {
entry:
  %mlp_filter_channel = getelementptr inbounds %struct.DSPContext, ptr %c, i32 0, i32 131
  store ptr @mlp_filter_channel_x86, ptr %mlp_filter_channel, align 4, !tbaa !0
  ret void
}

define internal void @mlp_filter_channel_x86(ptr %state, ptr %coeff, i32 %firorder, i32 %iirorder, i32 %filter_shift, i32 %mask, i32 %blocksize, ptr %sample_buffer) nounwind sanitize_address {
entry:
  %filter_shift.addr = alloca i32, align 4
  %mask.addr = alloca i32, align 4
  %blocksize.addr = alloca i32, align 4
  %firjump = alloca ptr, align 4
  %iirjump = alloca ptr, align 4
  store i32 %filter_shift, ptr %filter_shift.addr, align 4, !tbaa !3
  store i32 %mask, ptr %mask.addr, align 4, !tbaa !3
  %arrayidx = getelementptr inbounds [9 x ptr], ptr @firtable, i32 0, i32 %firorder
  %0 = load ptr, ptr %arrayidx, align 4, !tbaa !0
  store ptr %0, ptr %firjump, align 4, !tbaa !0
  %arrayidx1 = getelementptr inbounds [5 x ptr], ptr @iirtable, i32 0, i32 %iirorder
  %1 = load ptr, ptr %arrayidx1, align 4, !tbaa !0
  store ptr %1, ptr %iirjump, align 4, !tbaa !0
  %sub = sub nsw i32 0, %blocksize
  store i32 %sub, ptr %blocksize.addr, align 4, !tbaa !3
  %2 = call { ptr, ptr, ptr } asm sideeffect "1:                           \0A\09xor           %esi, %esi\0A\09xor           %ecx, %ecx\0A\09jmp  *$5                     \0A\09ff_mlp_firorder_8:            \0A\09mov   0x1c+0($0), %eax\0A\09imull 0x1c+0($1)       \0A\09add                %eax , %esi\0A\09adc                %edx , %ecx\0A\09ff_mlp_firorder_7:            \0A\09mov   0x18+0($0), %eax\0A\09imull 0x18+0($1)       \0A\09add                %eax , %esi\0A\09adc                %edx , %ecx\0A\09ff_mlp_firorder_6:            \0A\09mov   0x14+0($0), %eax\0A\09imull 0x14+0($1)       \0A\09add                %eax , %esi\0A\09adc                %edx , %ecx\0A\09ff_mlp_firorder_5:            \0A\09mov   0x10+0($0), %eax\0A\09imull 0x10+0($1)       \0A\09add                %eax , %esi\0A\09adc                %edx , %ecx\0A\09ff_mlp_firorder_4:            \0A\09mov   0x0c+0($0), %eax\0A\09imull 0x0c+0($1)       \0A\09add                %eax , %esi\0A\09adc                %edx , %ecx\0A\09ff_mlp_firorder_3:            \0A\09mov   0x08+0($0), %eax\0A\09imull 0x08+0($1)       \0A\09add                %eax , %esi\0A\09adc                %edx , %ecx\0A\09ff_mlp_firorder_2:            \0A\09mov   0x04+0($0), %eax\0A\09imull 0x04+0($1)       \0A\09add                %eax , %esi\0A\09adc                %edx , %ecx\0A\09ff_mlp_firorder_1:            \0A\09mov   0x00+0($0), %eax\0A\09imull 0x00+0($1)       \0A\09add                %eax , %esi\0A\09adc                %edx , %ecx\0A\09ff_mlp_firorder_0:\0A\09jmp  *$6                     \0A\09ff_mlp_iirorder_4:            \0A\09mov   0x0c+4*(8 + (40 * 4))($0), %eax\0A\09imull 0x0c+4* 8($1)       \0A\09add                %eax , %esi\0A\09adc                %edx , %ecx\0A\09ff_mlp_iirorder_3:            \0A\09mov   0x08+4*(8 + (40 * 4))($0), %eax\0A\09imull 0x08+4* 8($1)       \0A\09add                %eax , %esi\0A\09adc                %edx , %ecx\0A\09ff_mlp_iirorder_2:            \0A\09mov   0x04+4*(8 + (40 * 4))($0), %eax\0A\09imull 0x04+4* 8($1)       \0A\09add                %eax , %esi\0A\09adc                %edx , %ecx\0A\09ff_mlp_iirorder_1:            \0A\09mov   0x00+4*(8 + (40 * 4))($0), %eax\0A\09imull 0x00+4* 8($1)       \0A\09add                %eax , %esi\0A\09adc                %edx , %ecx\0A\09ff_mlp_iirorder_0:\0A\09mov           %ecx, %edx\0A\09mov           %esi, %eax\0A\09movzbl        $7   , %ecx\0A\09shrd    %cl, %edx, %eax\0A\09mov  %eax  ,%edx      \0A\09add  ($2)      ,%eax     \0A\09and   $4       ,%eax     \0A\09sub   $$4       ,  $0         \0A\09mov  %eax, ($0)        \0A\09mov  %eax, ($2)        \0A\09add $$4* 8    ,  $2         \0A\09sub  %edx   ,%eax     \0A\09mov  %eax,4*(8 + (40 * 4))($0)  \0A\09incl              $3         \0A\09js 1b                        \0A\09", "=r,=r,=r,=*m,*m,*m,*m,*m,0,1,2,*m,~{eax},~{edx},~{esi},~{ecx},~{dirflag},~{fpsr},~{flags}"(ptr elementtype(i32) %blocksize.addr, ptr elementtype(i32) %mask.addr, ptr elementtype(ptr) %firjump, ptr elementtype(ptr) %iirjump, ptr elementtype(i32) %filter_shift.addr, ptr %state, ptr %coeff, ptr %sample_buffer, ptr elementtype(i32) %blocksize.addr) nounwind, !srcloc !4
  ret void
}

!0 = !{!5, !5, i64 0}
!1 = !{!"omnipotent char", !2}
!2 = !{!"Simple C/C++ TBAA"}
!3 = !{!6, !6, i64 0}
!4 = !{i32 156132, i32 156164, i32 156205, i32 156238, i32 156282, i32 156332, i32 156370, i32 156408, i32 156447, i32 156486, i32 156536, i32 156574, i32 156612, i32 156651, i32 156690, i32 156740, i32 156778, i32 156816, i32 156855, i32 156894, i32 156944, i32 156982, i32 157020, i32 157059, i32 157098, i32 157148, i32 157186, i32 157224, i32 157263, i32 157302, i32 157352, i32 157390, i32 157428, i32 157467, i32 157506, i32 157556, i32 157594, i32 157632, i32 157671, i32 157710, i32 157760, i32 157798, i32 157836, i32 157875, i32 157914, i32 157952, i32 157996, i32 158046, i32 158099, i32 158140, i32 158179, i32 158218, i32 158268, i32 158321, i32 158362, i32 158401, i32 158440, i32 158490, i32 158543, i32 158584, i32 158623, i32 158662, i32 158712, i32 158765, i32 158806, i32 158845, i32 158884, i32 158922, i32 158963, i32 158996, i32 159029, i32 159062, i32 159109, i32 159154, i32 159199, i32 159243, i32 159286, i32 159329, i32 159375, i32 159422, i32 159478, i32 159522, i32 159566}
!5 = !{!"any pointer", !1}
!6 = !{!"int", !1}
