.data
.LC0:
        .string "\n\r"
.text
main:
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        addi    s0,sp,48
        li      a5,33554432
        addi    a5,a5,4
        li      a4,868
        sw      a4,0(a5)
        li      a5,98304
        sw      zero,0(a5)
        li      a5,98304
        addi    a5,a5,4
        sw      zero,0(a5)
        li      a5,98304
        addi    a5,a5,8
        sw      zero,0(a5)
        li      a5,98304
        addi    a5,a5,12
        sw      zero,0(a5)
        li      a5,98304
        addi    a5,a5,16
        sw      zero,0(a5)
        li      a5,98304
        addi    a5,a5,20
        sw      zero,0(a5)
        li      a5,98304
        addi    a5,a5,24
        sw      zero,0(a5)
        li      a5,98304
        addi    a5,a5,28
        sw      zero,0(a5)
.L12:
        sw      zero,-20(s0)
        j       .L2
.L3:
        li      a0,1
        call    print_dec
        li      a1,0
        li      a0,12
        call    set_pixel
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L2:
        lw      a4,-20(s0)
        li      a5,19
        ble     a4,a5,.L3
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        sw      zero,-24(s0)
        j       .L4
.L5:
        li      a0,1
        call    print_dec
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        call    write_gpio
        li      a0,1
        call    print_dec
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        call    read_gpio
        li      a0,1
        call    print_dec
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        li      a5,98304
        addi    a5,a5,256
        lw      a5,0(a5)
        mv      a0,a5
        call    print_dec
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L4:
        lw      a4,-24(s0)
        li      a5,19
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
        j       .L12
set_pixel:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        mv      a5,a0
        mv      a4,a1
        sh      a5,-18(s0)
        mv      a5,a4
        sh      a5,-20(s0)
        li      a5,35782656
        sw      zero,0(a5)
        li      a0,1
        call    print_dec
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        lhu     a4,-20(s0)
        lhu     a5,-18(s0)
        mv      a1,a4
        mv      a0,a5
        call    Write_message_SETPX
        li      a5,35782656
        lw      a4,0(a5)
        li      a5,35782656
        ori     a4,a4,2
        sw      a4,0(a5)
        li      a0,1
        call    print_dec
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        nop
.L14:
        li      a5,35782656
        lw      a5,0(a5)
        andi    a5,a5,1
        beq     a5,zero,.L14
        li      a5,35782656
        lw      a4,0(a5)
        li      a5,35782656
        andi    a4,a4,-3
        sw      a4,0(a5)
        li      a0,1
        call    print_dec
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        nop
.L15:
        li      a5,35782656
        lw      a5,0(a5)
        andi    a4,a5,1
        li      a5,1
        beq     a4,a5,.L15
        nop
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
write_gpio:
        addi    sp,sp,-16
        sw      ra,12(sp)
        sw      s0,8(sp)
        addi    s0,sp,16
        li      a5,35651584
        sw      zero,0(a5)
        li      a0,2
        call    print_dec
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        call    Write_message
        li      a5,35651584
        lw      a4,0(a5)
        li      a5,35651584
        ori     a4,a4,2
        sw      a4,0(a5)
        nop
.L17:
        li      a5,35651584
        lw      a5,0(a5)
        andi    a5,a5,1
        beq     a5,zero,.L17
        li      a0,2
        call    print_dec
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        li      a5,35651584
        lw      a4,0(a5)
        li      a5,35651584
        andi    a4,a4,-3
        sw      a4,0(a5)
        nop
.L18:
        li      a5,35651584
        lw      a5,0(a5)
        andi    a4,a5,1
        li      a5,1
        beq     a4,a5,.L18
        li      a0,2
        call    print_dec
        li      a0,2
        call    print_dec
        li      a0,2
        call    print_dec
        li      a0,2
        call    print_dec
        li      a0,2
        call    print_dec
        li      a0,2
        call    print_dec
        li      a0,2
        call    print_dec
        li      a0,2
        call    print_dec
        li      a0,2
        call    print_dec
        li      a0,2
        call    print_dec
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        nop
        lw      ra,12(sp)
        lw      s0,8(sp)
        addi    sp,sp,16
        jr      ra
read_gpio:
        addi    sp,sp,-16
        sw      ra,12(sp)
        sw      s0,8(sp)
        addi    s0,sp,16
        nop
.L20:
        li      a5,34603008
        lw      a5,0(a5)
        andi    a5,a5,2
        beq     a5,zero,.L20
        li      a0,3
        call    print_dec
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        call    Read_message
        li      a5,34603008
        lw      a4,0(a5)
        li      a5,34603008
        ori     a4,a4,1
        sw      a4,0(a5)
        nop
.L21:
        li      a5,34603008
        lw      a5,0(a5)
        andi    a4,a5,2
        li      a5,1
        beq     a4,a5,.L21
        li      a0,3
        call    print_dec
        li      a0,3
        call    print_dec
        li      a0,3
        call    print_dec
        li      a0,3
        call    print_dec
        li      a0,3
        call    print_dec
        li      a0,3
        call    print_dec
        li      a0,3
        call    print_dec
        li      a0,3
        call    print_dec
        li      a0,3
        call    print_dec
        li      a0,3
        call    print_dec
        li      a5,34603008
        lw      a4,0(a5)
        li      a5,34603008
        andi    a4,a4,-2
        sw      a4,0(a5)
        nop
        lw      ra,12(sp)
        lw      s0,8(sp)
        addi    sp,sp,16
        jr      ra
setPixel:
        addi    sp,sp,-32
        sw      s0,28(sp)
        addi    s0,sp,32
        sw      a0,-20(s0)
        li      a5,98304
        addi    a5,a5,516
        lw      a4,0(a5)
        li      a5,-33554432
        and     a4,a4,a5
        lw      a5,-20(s0)
        slli    a5,a5,16
        or      a3,a4,a5
        li      a5,98304
        addi    a5,a5,516
        lw      a4,0(a5)
        li      a5,98304
        addi    a5,a5,516
        or      a4,a3,a4
        sw      a4,0(a5)
        nop
        lw      s0,28(sp)
        addi    sp,sp,32
        jr      ra
setXdest:
        addi    sp,sp,-32
        sw      s0,28(sp)
        addi    s0,sp,32
        sw      a0,-20(s0)
        li      a5,98304
        addi    a5,a5,516
        lw      a4,0(a5)
        li      a5,-65536
        and     a4,a4,a5
        lw      a5,-20(s0)
        slli    a5,a5,8
        or      a3,a4,a5
        li      a5,98304
        addi    a5,a5,516
        lw      a4,0(a5)
        li      a5,98304
        addi    a5,a5,516
        or      a4,a3,a4
        sw      a4,0(a5)
        nop
        lw      s0,28(sp)
        addi    sp,sp,32
        jr      ra
setYdest:
        addi    sp,sp,-32
        sw      s0,28(sp)
        addi    s0,sp,32
        sw      a0,-20(s0)
        li      a5,98304
        addi    a5,a5,516
        lw      a5,0(a5)
        andi    a4,a5,-256
        lw      a5,-20(s0)
        or      a3,a4,a5
        li      a5,98304
        addi    a5,a5,516
        lw      a4,0(a5)
        li      a5,98304
        addi    a5,a5,516
        or      a4,a3,a4
        sw      a4,0(a5)
        nop
        lw      s0,28(sp)
        addi    sp,sp,32
        jr      ra
setStep:
        addi    sp,sp,-32
        sw      s0,28(sp)
        addi    s0,sp,32
        sw      a0,-20(s0)
        li      a5,98304
        addi    a5,a5,512
        lw      a5,0(a5)
        lw      a5,-20(s0)
        slli    a3,a5,27
        li      a5,98304
        addi    a5,a5,512
        lw      a4,0(a5)
        li      a5,98304
        addi    a5,a5,512
        or      a4,a3,a4
        sw      a4,0(a5)
        nop
        lw      s0,28(sp)
        addi    sp,sp,32
        jr      ra
setFrame:
        addi    sp,sp,-32
        sw      s0,28(sp)
        addi    s0,sp,32
        sw      a0,-20(s0)
        li      a5,98304
        addi    a5,a5,512
        lw      a4,0(a5)
        li      a5,-134217728
        and     a4,a4,a5
        lw      a5,-20(s0)
        slli    a5,a5,19
        or      a3,a4,a5
        li      a5,98304
        addi    a5,a5,512
        lw      a4,0(a5)
        li      a5,98304
        addi    a5,a5,512
        or      a4,a3,a4
        sw      a4,0(a5)
        nop
        lw      s0,28(sp)
        addi    sp,sp,32
        jr      ra
setXorig:
        addi    sp,sp,-32
        sw      s0,28(sp)
        addi    s0,sp,32
        sw      a0,-20(s0)
        li      a5,98304
        addi    a5,a5,512
        lw      a4,0(a5)
        li      a5,-524288
        and     a4,a4,a5
        lw      a5,-20(s0)
        slli    a5,a5,11
        or      a3,a4,a5
        li      a5,98304
        addi    a5,a5,512
        lw      a4,0(a5)
        li      a5,98304
        addi    a5,a5,512
        or      a4,a3,a4
        sw      a4,0(a5)
        nop
        lw      s0,28(sp)
        addi    sp,sp,32
        jr      ra
setYorig:
        addi    sp,sp,-32
        sw      s0,28(sp)
        addi    s0,sp,32
        sw      a0,-20(s0)
        li      a5,98304
        addi    a5,a5,512
        lw      a5,0(a5)
        andi    a4,a5,-2048
        lw      a5,-20(s0)
        slli    a5,a5,3
        or      a3,a4,a5
        li      a5,98304
        addi    a5,a5,512
        lw      a4,0(a5)
        li      a5,98304
        addi    a5,a5,512
        or      a4,a3,a4
        sw      a4,0(a5)
        nop
        lw      s0,28(sp)
        addi    sp,sp,32
        jr      ra
setFb:
        addi    sp,sp,-32
        sw      s0,28(sp)
        addi    s0,sp,32
        sw      a0,-20(s0)
        li      a5,98304
        addi    a5,a5,512
        lw      a5,0(a5)
        andi    a4,a5,-8
        lw      a5,-20(s0)
        slli    a5,a5,2
        or      a3,a4,a5
        li      a5,98304
        addi    a5,a5,512
        lw      a4,0(a5)
        li      a5,98304
        addi    a5,a5,512
        or      a4,a3,a4
        sw      a4,0(a5)
        nop
        lw      s0,28(sp)
        addi    sp,sp,32
        jr      ra
readPixel:
        addi    sp,sp,-16
        sw      s0,12(sp)
        addi    s0,sp,16
        li      a5,34668544
        lw      a5,0(a5)
        srli    a4,a5,16
        li      a5,98304
        addi    a5,a5,256
        andi    a4,a4,511
        sw      a4,0(a5)
        nop
        lw      s0,12(sp)
        addi    sp,sp,16
        jr      ra
readXdest:
        addi    sp,sp,-16
        sw      s0,12(sp)
        addi    s0,sp,16
        li      a5,34668544
        lw      a5,0(a5)
        srli    a4,a5,8
        li      a5,98304
        addi    a5,a5,260
        andi    a4,a4,255
        sw      a4,0(a5)
        nop
        lw      s0,12(sp)
        addi    sp,sp,16
        jr      ra
readYdest:
        addi    sp,sp,-16
        sw      s0,12(sp)
        addi    s0,sp,16
        li      a5,34668544
        lw      a4,0(a5)
        li      a5,98304
        addi    a5,a5,264
        andi    a4,a4,255
        sw      a4,0(a5)
        nop
        lw      s0,12(sp)
        addi    sp,sp,16
        jr      ra
readStep:
        addi    sp,sp,-16
        sw      s0,12(sp)
        addi    s0,sp,16
        li      a5,34603008
        lw      a5,0(a5)
        srli    a4,a5,27
        li      a5,98304
        addi    a5,a5,268
        andi    a4,a4,31
        sw      a4,0(a5)
        nop
        lw      s0,12(sp)
        addi    sp,sp,16
        jr      ra
readFrame:
        addi    sp,sp,-16
        sw      s0,12(sp)
        addi    s0,sp,16
        li      a5,34603008
        lw      a5,0(a5)
        srli    a4,a5,19
        li      a5,98304
        addi    a5,a5,272
        andi    a4,a4,255
        sw      a4,0(a5)
        nop
        lw      s0,12(sp)
        addi    sp,sp,16
        jr      ra
readXorig:
        addi    sp,sp,-16
        sw      s0,12(sp)
        addi    s0,sp,16
        li      a5,34603008
        lw      a5,0(a5)
        srli    a4,a5,11
        li      a5,98304
        addi    a5,a5,276
        andi    a4,a4,255
        sw      a4,0(a5)
        nop
        lw      s0,12(sp)
        addi    sp,sp,16
        jr      ra
readYorig:
        addi    sp,sp,-16
        sw      s0,12(sp)
        addi    s0,sp,16
        li      a5,34603008
        lw      a5,0(a5)
        srli    a4,a5,3
        li      a5,98304
        addi    a5,a5,280
        andi    a4,a4,255
        sw      a4,0(a5)
        nop
        lw      s0,12(sp)
        addi    sp,sp,16
        jr      ra
readFb:
        addi    sp,sp,-16
        sw      s0,12(sp)
        addi    s0,sp,16
        li      a5,34603008
        lw      a5,0(a5)
        srli    a4,a5,2
        li      a5,98304
        addi    a5,a5,284
        andi    a4,a4,1
        sw      a4,0(a5)
        nop
        lw      s0,12(sp)
        addi    sp,sp,16
        jr      ra
readReq:
        addi    sp,sp,-16
        sw      s0,12(sp)
        addi    s0,sp,16
        li      a5,34603008
        lw      a5,0(a5)
        srli    a4,a5,1
        li      a5,98304
        addi    a5,a5,288
        andi    a4,a4,1
        sw      a4,0(a5)
        nop
        lw      s0,12(sp)
        addi    sp,sp,16
        jr      ra
readAck:
        addi    sp,sp,-16
        sw      s0,12(sp)
        addi    s0,sp,16
        li      a5,34603008
        lw      a4,0(a5)
        li      a5,98304
        addi    a5,a5,292
        andi    a4,a4,1
        sw      a4,0(a5)
        nop
        lw      s0,12(sp)
        addi    sp,sp,16
        jr      ra
Write_message:
        addi    sp,sp,-16
        sw      ra,12(sp)
        sw      s0,8(sp)
        addi    s0,sp,16
        li      a5,35651584
        sw      zero,0(a5)
        li      a5,35717120
        sw      zero,0(a5)
        li      a5,98304
        addi    a5,a5,516
        sw      zero,0(a5)
        li      a5,98304
        addi    a5,a5,512
        sw      zero,0(a5)
        li      a5,98304
        lw      a5,0(a5)
        mv      a0,a5
        call    setPixel
        li      a5,98304
        addi    a5,a5,8
        lw      a5,0(a5)
        mv      a0,a5
        call    setYdest
        li      a5,98304
        addi    a5,a5,4
        lw      a5,0(a5)
        mv      a0,a5
        call    setXdest
        li      a5,98304
        addi    a5,a5,12
        lw      a5,0(a5)
        mv      a0,a5
        call    setFrame
        li      a5,98304
        addi    a5,a5,16
        lw      a5,0(a5)
        mv      a0,a5
        call    setStep
        li      a5,98304
        addi    a5,a5,20
        lw      a5,0(a5)
        mv      a0,a5
        call    setXorig
        li      a5,98304
        addi    a5,a5,24
        lw      a5,0(a5)
        mv      a0,a5
        call    setYorig
        li      a5,98304
        addi    a5,a5,28
        lw      a5,0(a5)
        mv      a0,a5
        call    setFb
        li      a5,98304
        addi    a4,a5,516
        li      a5,35717120
        lw      a4,0(a4)
        sw      a4,0(a5)
        li      a5,98304
        addi    a4,a5,512
        li      a5,35651584
        lw      a4,0(a4)
        sw      a4,0(a5)
        nop
        lw      ra,12(sp)
        lw      s0,8(sp)
        addi    sp,sp,16
        jr      ra
setPM_pixel:
        addi    sp,sp,-32
        sw      s0,28(sp)
        addi    s0,sp,32
        mv      a5,a0
        sh      a5,-18(s0)
        li      a5,35782656
        lw      a4,0(a5)
        li      a5,-67108864
        addi    a5,a5,1023
        and     a4,a4,a5
        lhu     a5,-18(s0)
        slli    a5,a5,11
        or      a3,a4,a5
        li      a5,35782656
        lw      a4,0(a5)
        li      a5,35782656
        or      a4,a3,a4
        sw      a4,0(a5)
        nop
        lw      s0,28(sp)
        addi    sp,sp,32
        jr      ra
setPM_Address:
        addi    sp,sp,-32
        sw      s0,28(sp)
        addi    s0,sp,32
        mv      a5,a0
        sh      a5,-18(s0)
        li      a5,35782656
        lw      a5,0(a5)
        andi    a4,a5,-1023
        lhu     a5,-18(s0)
        slli    a5,a5,2
        or      a3,a4,a5
        li      a5,35782656
        lw      a4,0(a5)
        li      a5,35782656
        or      a4,a3,a4
        sw      a4,0(a5)
        nop
        lw      s0,28(sp)
        addi    sp,sp,32
        jr      ra
Write_message_SETPX:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        mv      a5,a0
        mv      a4,a1
        sh      a5,-18(s0)
        mv      a5,a4
        sh      a5,-20(s0)
        lhu     a5,-18(s0)
        mv      a0,a5
        call    setPM_pixel
        lhu     a5,-20(s0)
        mv      a0,a5
        call    setPM_Address
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
Read_message:
        addi    sp,sp,-16
        sw      ra,12(sp)
        sw      s0,8(sp)
        addi    s0,sp,16
        call    readPixel
        call    readXdest
        call    readYdest
        call    readStep
        call    readFrame
        call    readXorig
        call    readYorig
        call    readFb
        nop
        lw      ra,12(sp)
        lw      s0,8(sp)
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
        bne     a4,a5,.L46
        li      a0,13
        call    putchar
.L46:
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
        j       .L48
.L49:
        lw      a5,-20(s0)
        addi    a4,a5,1
        sw      a4,-20(s0)
        lbu     a5,0(a5)
        mv      a0,a5
        call    putchar
.L48:
        lw      a5,-20(s0)
        lbu     a5,0(a5)
        bne     a5,zero,.L49
        nop
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
print_dec:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      a0,-20(s0)
        lw      a4,-20(s0)
        li      a5,899
        bleu    a4,a5,.L51
        li      a0,57
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-900
        sw      a5,-20(s0)
        j       .L52
.L51:
        lw      a4,-20(s0)
        li      a5,799
        bleu    a4,a5,.L53
        li      a0,56
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-800
        sw      a5,-20(s0)
        j       .L52
.L53:
        lw      a4,-20(s0)
        li      a5,699
        bleu    a4,a5,.L54
        li      a0,55
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-700
        sw      a5,-20(s0)
        j       .L52
.L54:
        lw      a4,-20(s0)
        li      a5,599
        bleu    a4,a5,.L55
        li      a0,54
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-600
        sw      a5,-20(s0)
        j       .L52
.L55:
        lw      a4,-20(s0)
        li      a5,499
        bleu    a4,a5,.L56
        li      a0,53
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-500
        sw      a5,-20(s0)
        j       .L52
.L56:
        lw      a4,-20(s0)
        li      a5,399
        bleu    a4,a5,.L57
        li      a0,52
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-400
        sw      a5,-20(s0)
        j       .L52
.L57:
        lw      a4,-20(s0)
        li      a5,299
        bleu    a4,a5,.L58
        li      a0,51
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-300
        sw      a5,-20(s0)
        j       .L52
.L58:
        lw      a4,-20(s0)
        li      a5,199
        bleu    a4,a5,.L59
        li      a0,50
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-200
        sw      a5,-20(s0)
        j       .L52
.L59:
        lw      a4,-20(s0)
        li      a5,99
        bleu    a4,a5,.L52
        li      a0,49
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-100
        sw      a5,-20(s0)
.L52:
        lw      a4,-20(s0)
        li      a5,89
        bleu    a4,a5,.L60
        li      a0,57
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-90
        sw      a5,-20(s0)
        j       .L61
.L60:
        lw      a4,-20(s0)
        li      a5,79
        bleu    a4,a5,.L62
        li      a0,56
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-80
        sw      a5,-20(s0)
        j       .L61
.L62:
        lw      a4,-20(s0)
        li      a5,69
        bleu    a4,a5,.L63
        li      a0,55
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-70
        sw      a5,-20(s0)
        j       .L61
.L63:
        lw      a4,-20(s0)
        li      a5,59
        bleu    a4,a5,.L64
        li      a0,54
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-60
        sw      a5,-20(s0)
        j       .L61
.L64:
        lw      a4,-20(s0)
        li      a5,49
        bleu    a4,a5,.L65
        li      a0,53
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-50
        sw      a5,-20(s0)
        j       .L61
.L65:
        lw      a4,-20(s0)
        li      a5,39
        bleu    a4,a5,.L66
        li      a0,52
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-40
        sw      a5,-20(s0)
        j       .L61
.L66:
        lw      a4,-20(s0)
        li      a5,29
        bleu    a4,a5,.L67
        li      a0,51
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-30
        sw      a5,-20(s0)
        j       .L61
.L67:
        lw      a4,-20(s0)
        li      a5,19
        bleu    a4,a5,.L68
        li      a0,50
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-20
        sw      a5,-20(s0)
        j       .L61
.L68:
        lw      a4,-20(s0)
        li      a5,9
        bleu    a4,a5,.L61
        li      a0,49
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-10
        sw      a5,-20(s0)
.L61:
        lw      a4,-20(s0)
        li      a5,8
        bleu    a4,a5,.L69
        li      a0,57
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-9
        sw      a5,-20(s0)
        j       .L79
.L69:
        lw      a4,-20(s0)
        li      a5,7
        bleu    a4,a5,.L71
        li      a0,56
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-8
        sw      a5,-20(s0)
        j       .L79
.L71:
        lw      a4,-20(s0)
        li      a5,6
        bleu    a4,a5,.L72
        li      a0,55
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-7
        sw      a5,-20(s0)
        j       .L79
.L72:
        lw      a4,-20(s0)
        li      a5,5
        bleu    a4,a5,.L73
        li      a0,54
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-6
        sw      a5,-20(s0)
        j       .L79
.L73:
        lw      a4,-20(s0)
        li      a5,4
        bleu    a4,a5,.L74
        li      a0,53
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-5
        sw      a5,-20(s0)
        j       .L79
.L74:
        lw      a4,-20(s0)
        li      a5,3
        bleu    a4,a5,.L75
        li      a0,52
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-4
        sw      a5,-20(s0)
        j       .L79
.L75:
        lw      a4,-20(s0)
        li      a5,2
        bleu    a4,a5,.L76
        li      a0,51
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-3
        sw      a5,-20(s0)
        j       .L79
.L76:
        lw      a4,-20(s0)
        li      a5,1
        bleu    a4,a5,.L77
        li      a0,50
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-2
        sw      a5,-20(s0)
        j       .L79
.L77:
        lw      a5,-20(s0)
        beq     a5,zero,.L78
        li      a0,49
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-1
        sw      a5,-20(s0)
        j       .L79
.L78:
        li      a0,48
        call    putchar
.L79:
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra