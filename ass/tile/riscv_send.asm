.data
p:
        .word   98304
.LC0:
        .string " "
.LC1:
        .string "   "
.LC2:
        .string "|"
.LC3:
        .string "\r\n\n\r"
.text
main:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        li      a5,33554432
        addi    a5,a5,4
        li      a4,868
        sw      a4,0(a5)
        call    set_image
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        lui     a5,%hi(.LC1)
        addi    a0,a5,%lo(.LC1)
        call    print
        lui     a5,%hi(.LC2)
        addi    a0,a5,%lo(.LC2)
        call    print
        lui     a5,%hi(.LC1)
        addi    a0,a5,%lo(.LC1)
        call    print
        lui     a5,%hi(.LC3)
        addi    a0,a5,%lo(.LC3)
        call    print
        sw      zero,-20(s0)
        j       .L2
.L5:
        sw      zero,-24(s0)
        j       .L3
.L4:
        lw      a1,-24(s0)
        lw      a2,-20(s0)
        li      a7,0
        li      a6,0
        li      a5,0
        li      a4,0
        li      a3,0
        li      a0,0
        call    write_gpio
        call    read_gpio
        lui     a5,%hi(.LC2)
        addi    a0,a5,%lo(.LC2)
        call    print
        li      a5,98304
        addi    a5,a5,256
        lw      a5,0(a5)
        mv      a0,a5
        call    print_dec
        lui     a5,%hi(.LC2)
        addi    a0,a5,%lo(.LC2)
        call    print
        lui     a5,%hi(.LC1)
        addi    a0,a5,%lo(.LC1)
        call    print
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L3:
        lw      a4,-24(s0)
        li      a5,9
        bleu    a4,a5,.L4
        lui     a5,%hi(.LC3)
        addi    a0,a5,%lo(.LC3)
        call    print
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L2:
        lw      a4,-20(s0)
        li      a5,9
        bleu    a4,a5,.L5
.L6:
        j       .L6
set_pixel:
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        addi    s0,sp,48
        sw      a0,-20(s0)
        sw      a1,-24(s0)
        sw      a2,-28(s0)
        sw      a3,-32(s0)
        sw      a4,-36(s0)
        li      a5,35782656
        sw      zero,0(a5)
        li      a5,35848192
        sw      zero,0(a5)
        lw      a0,-20(s0)
        call    set_pm_pixel
        lw      a0,-24(s0)
        call    set_pm_x_dest
        lw      a0,-28(s0)
        call    set_pm_y_dest
        lw      a0,-32(s0)
        call    set_pm_step
        lw      a0,-36(s0)
        call    set_pm_frame
        li      a5,35782656
        lw      a4,0(a5)
        li      a5,35782656
        ori     a4,a4,2
        sw      a4,0(a5)
        nop
.L8:
        li      a5,35782656
        lw      a5,0(a5)
        andi    a5,a5,1
        beq     a5,zero,.L8
        li      a5,35782656
        lw      a4,0(a5)
        li      a5,35782656
        andi    a4,a4,-3
        sw      a4,0(a5)
        nop
.L9:
        li      a5,35782656
        lw      a5,0(a5)
        andi    a4,a5,1
        li      a5,1
        beq     a4,a5,.L9
        nop
        nop
        lw      ra,44(sp)
        lw      s0,40(sp)
        addi    sp,sp,48
        jr      ra
set_pm_pixel:
        addi    sp,sp,-32
        sw      s0,28(sp)
        addi    s0,sp,32
        sw      a0,-20(s0)
        li      a5,35848192
        lw      a4,0(a5)
        li      a5,-65536
        and     a4,a4,a5
        lw      a5,-20(s0)
        or      a3,a4,a5
        li      a5,35848192
        lw      a4,0(a5)
        li      a5,35848192
        or      a4,a3,a4
        sw      a4,0(a5)
        nop
        lw      s0,28(sp)
        addi    sp,sp,32
        jr      ra
set_pm_x_dest:
        addi    sp,sp,-32
        sw      s0,28(sp)
        addi    s0,sp,32
        sw      a0,-20(s0)
        li      a5,35782656
        lw      a4,0(a5)
        li      a5,-2139095040
        addi    a5,a5,-1
        and     a4,a4,a5
        lw      a5,-20(s0)
        slli    a5,a5,23
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
set_pm_y_dest:
        addi    sp,sp,-32
        sw      s0,28(sp)
        addi    s0,sp,32
        sw      a0,-20(s0)
        li      a5,35782656
        lw      a4,0(a5)
        li      a5,-8355840
        addi    a5,a5,-1
        and     a4,a4,a5
        lw      a5,-20(s0)
        slli    a5,a5,15
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
set_pm_step:
        addi    sp,sp,-32
        sw      s0,28(sp)
        addi    s0,sp,32
        sw      a0,-20(s0)
        li      a5,35782656
        lw      a4,0(a5)
        li      a5,-32768
        addi    a5,a5,1023
        and     a4,a4,a5
        lw      a5,-20(s0)
        slli    a5,a5,10
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
set_pm_frame:
        addi    sp,sp,-32
        sw      s0,28(sp)
        addi    s0,sp,32
        sw      a0,-20(s0)
        li      a5,35782656
        lw      a5,0(a5)
        andi    a4,a5,-1021
        lw      a5,-20(s0)
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
write_gpio:
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        addi    s0,sp,48
        sw      a0,-20(s0)
        sw      a1,-24(s0)
        sw      a2,-28(s0)
        sw      a3,-32(s0)
        sw      a4,-36(s0)
        sw      a5,-40(s0)
        sw      a6,-44(s0)
        sw      a7,-48(s0)
        li      a5,35651584
        sw      zero,0(a5)
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
        lw      a0,-20(s0)
        call    setPixel
        lw      a0,-24(s0)
        call    setXdest
        lw      a0,-28(s0)
        call    setYdest
        lw      a0,-32(s0)
        call    setFrame
        lw      a0,-36(s0)
        call    setStep
        lw      a0,-40(s0)
        call    setXorig
        lw      a0,-44(s0)
        call    setYorig
        lw      a0,-48(s0)
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
        li      a5,35651584
        lw      a4,0(a5)
        li      a5,35651584
        ori     a4,a4,2
        sw      a4,0(a5)
        nop
.L16:
        li      a5,35651584
        lw      a5,0(a5)
        andi    a5,a5,1
        beq     a5,zero,.L16
        li      a5,35651584
        lw      a4,0(a5)
        li      a5,35651584
        andi    a4,a4,-3
        sw      a4,0(a5)
        nop
.L17:
        li      a5,35651584
        lw      a5,0(a5)
        andi    a4,a5,1
        li      a5,1
        beq     a4,a5,.L17
        nop
        nop
        lw      ra,44(sp)
        lw      s0,40(sp)
        addi    sp,sp,48
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
read_gpio:
        addi    sp,sp,-16
        sw      ra,12(sp)
        sw      s0,8(sp)
        addi    s0,sp,16
        nop
.L27:
        li      a5,34603008
        lw      a5,0(a5)
        andi    a5,a5,2
        beq     a5,zero,.L27
        call    readPixel
        call    readXdest
        call    readYdest
        call    readStep
        call    readFrame
        call    readXorig
        call    readYorig
        call    readFb
        li      a5,34603008
        lw      a4,0(a5)
        li      a5,34603008
        ori     a4,a4,1
        sw      a4,0(a5)
        nop
.L28:
        li      a5,34603008
        lw      a5,0(a5)
        andi    a4,a5,2
        li      a5,1
        beq     a4,a5,.L28
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
putchart:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        mv      a5,a0
        sb      a5,-17(s0)
        lbu     a4,-17(s0)
        li      a5,10
        bne     a4,a5,.L40
        li      a0,13
        call    putchart
.L40:
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
        j       .L42
.L43:
        lw      a5,-20(s0)
        addi    a4,a5,1
        sw      a4,-20(s0)
        lbu     a5,0(a5)
        mv      a0,a5
        call    putchart
.L42:
        lw      a5,-20(s0)
        lbu     a5,0(a5)
        bne     a5,zero,.L43
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
        bleu    a4,a5,.L45
        li      a0,57
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-900
        sw      a5,-20(s0)
        j       .L46
.L45:
        lw      a4,-20(s0)
        li      a5,799
        bleu    a4,a5,.L47
        li      a0,56
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-800
        sw      a5,-20(s0)
        j       .L46
.L47:
        lw      a4,-20(s0)
        li      a5,699
        bleu    a4,a5,.L48
        li      a0,55
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-700
        sw      a5,-20(s0)
        j       .L46
.L48:
        lw      a4,-20(s0)
        li      a5,599
        bleu    a4,a5,.L49
        li      a0,54
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-600
        sw      a5,-20(s0)
        j       .L46
.L49:
        lw      a4,-20(s0)
        li      a5,499
        bleu    a4,a5,.L50
        li      a0,53
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-500
        sw      a5,-20(s0)
        j       .L46
.L50:
        lw      a4,-20(s0)
        li      a5,399
        bleu    a4,a5,.L51
        li      a0,52
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-400
        sw      a5,-20(s0)
        j       .L46
.L51:
        lw      a4,-20(s0)
        li      a5,299
        bleu    a4,a5,.L52
        li      a0,51
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-300
        sw      a5,-20(s0)
        j       .L46
.L52:
        lw      a4,-20(s0)
        li      a5,199
        bleu    a4,a5,.L53
        li      a0,50
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-200
        sw      a5,-20(s0)
        j       .L46
.L53:
        lw      a4,-20(s0)
        li      a5,99
        bleu    a4,a5,.L54
        li      a0,49
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-100
        sw      a5,-20(s0)
        j       .L46
.L54:
        li      a0,48
        call    putchart
.L46:
        lw      a4,-20(s0)
        li      a5,89
        bleu    a4,a5,.L55
        li      a0,57
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-90
        sw      a5,-20(s0)
        j       .L56
.L55:
        lw      a4,-20(s0)
        li      a5,79
        bleu    a4,a5,.L57
        li      a0,56
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-80
        sw      a5,-20(s0)
        j       .L56
.L57:
        lw      a4,-20(s0)
        li      a5,69
        bleu    a4,a5,.L58
        li      a0,55
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-70
        sw      a5,-20(s0)
        j       .L56
.L58:
        lw      a4,-20(s0)
        li      a5,59
        bleu    a4,a5,.L59
        li      a0,54
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-60
        sw      a5,-20(s0)
        j       .L56
.L59:
        lw      a4,-20(s0)
        li      a5,49
        bleu    a4,a5,.L60
        li      a0,53
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-50
        sw      a5,-20(s0)
        j       .L56
.L60:
        lw      a4,-20(s0)
        li      a5,39
        bleu    a4,a5,.L61
        li      a0,52
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-40
        sw      a5,-20(s0)
        j       .L56
.L61:
        lw      a4,-20(s0)
        li      a5,29
        bleu    a4,a5,.L62
        li      a0,51
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-30
        sw      a5,-20(s0)
        j       .L56
.L62:
        lw      a4,-20(s0)
        li      a5,19
        bleu    a4,a5,.L63
        li      a0,50
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-20
        sw      a5,-20(s0)
        j       .L56
.L63:
        lw      a4,-20(s0)
        li      a5,9
        bleu    a4,a5,.L64
        li      a0,49
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-10
        sw      a5,-20(s0)
        j       .L56
.L64:
        li      a0,48
        call    putchart
.L56:
        lw      a4,-20(s0)
        li      a5,8
        bleu    a4,a5,.L65
        li      a0,57
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-9
        sw      a5,-20(s0)
        j       .L75
.L65:
        lw      a4,-20(s0)
        li      a5,7
        bleu    a4,a5,.L67
        li      a0,56
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-8
        sw      a5,-20(s0)
        j       .L75
.L67:
        lw      a4,-20(s0)
        li      a5,6
        bleu    a4,a5,.L68
        li      a0,55
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-7
        sw      a5,-20(s0)
        j       .L75
.L68:
        lw      a4,-20(s0)
        li      a5,5
        bleu    a4,a5,.L69
        li      a0,54
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-6
        sw      a5,-20(s0)
        j       .L75
.L69:
        lw      a4,-20(s0)
        li      a5,4
        bleu    a4,a5,.L70
        li      a0,53
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-5
        sw      a5,-20(s0)
        j       .L75
.L70:
        lw      a4,-20(s0)
        li      a5,3
        bleu    a4,a5,.L71
        li      a0,52
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-4
        sw      a5,-20(s0)
        j       .L75
.L71:
        lw      a4,-20(s0)
        li      a5,2
        bleu    a4,a5,.L72
        li      a0,51
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-3
        sw      a5,-20(s0)
        j       .L75
.L72:
        lw      a4,-20(s0)
        li      a5,1
        bleu    a4,a5,.L73
        li      a0,50
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-2
        sw      a5,-20(s0)
        j       .L75
.L73:
        lw      a5,-20(s0)
        beq     a5,zero,.L74
        li      a0,49
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-1
        sw      a5,-20(s0)
        j       .L75
.L74:
        li      a0,48
        call    putchart
.L75:
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
set_image:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      zero,-24(s0)
        j       .L77
.L80:
        sw      zero,-28(s0)
        j       .L78
.L79:
        lw      a4,-24(s0)
        mv      a5,a4
        slli    a5,a5,2
        add     a5,a5,a4
        slli    a5,a5,2
        mv      a4,a5
        lw      a5,-28(s0)
        add     a5,a4,a5
        sw      a5,-20(s0)
        lw      a5,-20(s0)
        lw      a1,-28(s0)
        lw      a2,-24(s0)
        li      a4,0
        li      a3,0
        mv      a0,a5
        call    set_pixel
        lw      a5,-28(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
.L78:
        lw      a4,-28(s0)
        li      a5,9
        bleu    a4,a5,.L79
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L77:
        lw      a4,-24(s0)
        li      a5,9
        bleu    a4,a5,.L80
        nop
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra