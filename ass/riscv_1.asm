main:
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        addi    s0,sp,48
        li      a5,33554432
        addi    a5,a5,4
        li      a4,868
        sw      a4,0(a5)
        li      a5,65536
        sw      zero,0(a5)
.L14:
        li      a5,65536
        sw      zero,0(a5)
        li      a5,65536
        lw      a5,0(a5)
        mv      a0,a5
        call    send_message
        sw      zero,-20(s0)
        j       .L2
.L3:
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L2:
        lw      a4,-20(s0)
        li      a5,598016
        addi    a5,a5,1983
        ble     a4,a5,.L3
        sw      zero,-24(s0)
        j       .L4
.L5:
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L4:
        lw      a4,-24(s0)
        li      a5,598016
        addi    a5,a5,1983
        ble     a4,a5,.L5
        sw      zero,-28(s0)
        j       .L6
.L7:
        lw      a5,-28(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
.L6:
        lw      a4,-28(s0)
        li      a5,598016
        addi    a5,a5,1983
        ble     a4,a5,.L7
        li      a5,65536
        li      a4,15
        sw      a4,0(a5)
        li      a5,65536
        lw      a5,0(a5)
        mv      a0,a5
        call    send_message
        sw      zero,-32(s0)
        j       .L8
.L9:
        lw      a5,-32(s0)
        addi    a5,a5,1
        sw      a5,-32(s0)
.L8:
        lw      a4,-32(s0)
        li      a5,598016
        addi    a5,a5,1983
        ble     a4,a5,.L9
        sw      zero,-36(s0)
        j       .L10
.L11:
        lw      a5,-36(s0)
        addi    a5,a5,1
        sw      a5,-36(s0)
.L10:
        lw      a4,-36(s0)
        li      a5,598016
        addi    a5,a5,1983
        ble     a4,a5,.L11
        sw      zero,-40(s0)
        j       .L12
.L13:
        lw      a5,-40(s0)
        addi    a5,a5,1
        sw      a5,-40(s0)
.L12:
        lw      a4,-40(s0)
        li      a5,598016
        addi    a5,a5,1983
        ble     a4,a5,.L13
        j       .L14
send_message:
        addi    sp,sp,-32
        sw      s0,28(sp)
        addi    s0,sp,32
        sw      a0,-20(s0)
        li      a5,83886080
        lw      a4,-20(s0)
        slli    a4,a4,1
        sw      a4,0(a5)
        lw      a5,-20(s0)
        ori     a5,a5,1
        sw      a5,-20(s0)
        nop
        lw      s0,28(sp)
        addi    sp,sp,32
        jr      ra
read_message:
        addi    sp,sp,-16
        sw      s0,12(sp)
        addi    s0,sp,16
        li      a5,67108864
        lw      a4,0(a5)
        li      a5,65536
        srli    a4,a4,1
        sw      a4,0(a5)
        nop
        lw      s0,12(sp)
        addi    sp,sp,16
        jr      ra
putchar:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        mv      a5,a0
        sb      a5,-17(s0)
        lbu     a4,-17(s0)
        li      a5,10
        bne     a4,a5,.L18
        li      a0,13
        call    putchar
.L18:
        li      a5,33554432
        addi    a5,a5,8
        lbu     a4,-17(s0)
        sw      a4,0(a5)
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
print:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      a0,-20(s0)
        j       .L20
.L21:
        lw      a5,-20(s0)
        addi    a4,a5,1
        sw      a4,-20(s0)
        lbu     a5,0(a5)
        mv      a0,a5
        call    putchar
.L20:
        lw      a5,-20(s0)
        lbu     a5,0(a5)
        bne     a5,zero,.L21
        nop
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra