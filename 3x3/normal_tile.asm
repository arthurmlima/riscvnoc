.data
.LC0:
        .string "|"
.LC1:
        .string " "
.LC2:
        .string "  "
.LC3:
        .string "   "
.LC4:
        .string "\r\n"
.LC5:
        .string "\r\n\n\r"
.text
main:
        addi    sp,sp,-16
        sw      ra,12(sp)
        sw      s0,8(sp)
        addi    s0,sp,16
        li      a5,33554432
        addi    a5,a5,4
        li      a4,868
        sw      a4,0(a5)
        li      a4,36765696
        li      a5,98304
        addi    a5,a5,1028
        lw      a4,0(a4)
        sw      a4,0(a5)
        li      a4,36765696
        li      a5,98304
        addi    a5,a5,1028
        lw      a4,0(a4)
        sw      a4,0(a5)
        li      a5,36765696
        addi    a4,a5,36
        li      a5,98304
        addi    a5,a5,1032
        lw      a4,0(a4)
        sw      a4,0(a5)
        li      a5,36765696
        addi    a4,a5,32
        li      a5,98304
        addi    a5,a5,1036
        lw      a4,0(a4)
        sw      a4,0(a5)
        li      a5,36765696
        addi    a4,a5,28
        li      a5,98304
        addi    a5,a5,1048
        lw      a4,0(a4)
        sw      a4,0(a5)
        li      a5,36765696
        addi    a4,a5,24
        li      a5,98304
        addi    a5,a5,1052
        lw      a4,0(a4)
        sw      a4,0(a5)
        li      a5,36765696
        addi    a4,a5,12
        li      a5,98304
        addi    a5,a5,1040
        lw      a4,0(a4)
        sw      a4,0(a5)
        li      a5,36765696
        addi    a4,a5,8
        li      a5,98304
        addi    a5,a5,1044
        lw      a4,0(a4)
        sw      a4,0(a5)
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
        lui     a5,%hi(.LC3)
        addi    a0,a5,%lo(.LC3)
        call    print
        lui     a5,%hi(.LC4)
        addi    a0,a5,%lo(.LC4)
        call    print
        lui     a5,%hi(.LC5)
        addi    a0,a5,%lo(.LC5)
        call    print
        call    core_init
.L2:
        j       .L2
core_init:
        addi    sp,sp,-16
        sw      ra,12(sp)
        sw      s0,8(sp)
        addi    s0,sp,16
        li      a5,98304
        addi    a5,a5,1052
        lw      a4,0(a5)
        li      a5,1
        bne     a4,a5,.L4
        li      a5,98304
        addi    a5,a5,1048
        lw      a4,0(a5)
        li      a5,1
        bne     a4,a5,.L5
        call    distribute_image_from_zynq
        call    wait_for_checkmsg
        call    get_image
        j       .L7
.L5:
        call    get_first_image_recv
        j       .L7
.L4:
        call    get_first_image_recv
.L7:
        nop
        lw      ra,12(sp)
        lw      s0,8(sp)
        addi    sp,sp,16
        jr      ra
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
.L9:
        li      a5,35782656
        lw      a5,0(a5)
        andi    a5,a5,1
        beq     a5,zero,.L9
        li      a5,35782656
        lw      a4,0(a5)
        li      a5,35782656
        andi    a4,a4,-3
        sw      a4,0(a5)
        nop
.L10:
        li      a5,35782656
        lw      a5,0(a5)
        andi    a4,a5,1
        li      a5,1
        beq     a4,a5,.L10
        li      a5,35782656
        sw      zero,0(a5)
        li      a5,35848192
        sw      zero,0(a5)
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
.L17:
        li      a5,35651584
        lw      a5,0(a5)
        andi    a5,a5,1
        beq     a5,zero,.L17
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
        li      a5,65536
        addi    a5,a5,-1
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
.L28:
        li      a5,34603008
        lw      a5,0(a5)
        andi    a5,a5,2
        beq     a5,zero,.L28
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
.L29:
        li      a5,34603008
        lw      a5,0(a5)
        andi    a4,a5,2
        li      a5,1
        beq     a4,a5,.L29
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
        srli    a3,a5,16
        li      a5,98304
        addi    a5,a5,256
        li      a4,65536
        addi    a4,a4,-1
        and     a4,a3,a4
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
        bne     a4,a5,.L41
        li      a0,13
        call    putchart
.L41:
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
        j       .L43
.L44:
        lw      a5,-20(s0)
        addi    a4,a5,1
        sw      a4,-20(s0)
        lbu     a5,0(a5)
        mv      a0,a5
        call    putchart
.L43:
        lw      a5,-20(s0)
        lbu     a5,0(a5)
        bne     a5,zero,.L44
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
        bleu    a4,a5,.L46
        li      a0,57
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-900
        sw      a5,-20(s0)
        j       .L47
.L46:
        lw      a4,-20(s0)
        li      a5,799
        bleu    a4,a5,.L48
        li      a0,56
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-800
        sw      a5,-20(s0)
        j       .L47
.L48:
        lw      a4,-20(s0)
        li      a5,699
        bleu    a4,a5,.L49
        li      a0,55
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-700
        sw      a5,-20(s0)
        j       .L47
.L49:
        lw      a4,-20(s0)
        li      a5,599
        bleu    a4,a5,.L50
        li      a0,54
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-600
        sw      a5,-20(s0)
        j       .L47
.L50:
        lw      a4,-20(s0)
        li      a5,499
        bleu    a4,a5,.L51
        li      a0,53
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-500
        sw      a5,-20(s0)
        j       .L47
.L51:
        lw      a4,-20(s0)
        li      a5,399
        bleu    a4,a5,.L52
        li      a0,52
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-400
        sw      a5,-20(s0)
        j       .L47
.L52:
        lw      a4,-20(s0)
        li      a5,299
        bleu    a4,a5,.L53
        li      a0,51
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-300
        sw      a5,-20(s0)
        j       .L47
.L53:
        lw      a4,-20(s0)
        li      a5,199
        bleu    a4,a5,.L54
        li      a0,50
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-200
        sw      a5,-20(s0)
        j       .L47
.L54:
        lw      a4,-20(s0)
        li      a5,99
        bleu    a4,a5,.L55
        li      a0,49
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-100
        sw      a5,-20(s0)
        j       .L47
.L55:
        li      a0,48
        call    putchart
.L47:
        lw      a4,-20(s0)
        li      a5,89
        bleu    a4,a5,.L56
        li      a0,57
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-90
        sw      a5,-20(s0)
        j       .L57
.L56:
        lw      a4,-20(s0)
        li      a5,79
        bleu    a4,a5,.L58
        li      a0,56
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-80
        sw      a5,-20(s0)
        j       .L57
.L58:
        lw      a4,-20(s0)
        li      a5,69
        bleu    a4,a5,.L59
        li      a0,55
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-70
        sw      a5,-20(s0)
        j       .L57
.L59:
        lw      a4,-20(s0)
        li      a5,59
        bleu    a4,a5,.L60
        li      a0,54
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-60
        sw      a5,-20(s0)
        j       .L57
.L60:
        lw      a4,-20(s0)
        li      a5,49
        bleu    a4,a5,.L61
        li      a0,53
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-50
        sw      a5,-20(s0)
        j       .L57
.L61:
        lw      a4,-20(s0)
        li      a5,39
        bleu    a4,a5,.L62
        li      a0,52
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-40
        sw      a5,-20(s0)
        j       .L57
.L62:
        lw      a4,-20(s0)
        li      a5,29
        bleu    a4,a5,.L63
        li      a0,51
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-30
        sw      a5,-20(s0)
        j       .L57
.L63:
        lw      a4,-20(s0)
        li      a5,19
        bleu    a4,a5,.L64
        li      a0,50
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-20
        sw      a5,-20(s0)
        j       .L57
.L64:
        lw      a4,-20(s0)
        li      a5,9
        bleu    a4,a5,.L65
        li      a0,49
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-10
        sw      a5,-20(s0)
        j       .L57
.L65:
        li      a0,48
        call    putchart
.L57:
        lw      a4,-20(s0)
        li      a5,8
        bleu    a4,a5,.L66
        li      a0,57
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-9
        sw      a5,-20(s0)
        j       .L76
.L66:
        lw      a4,-20(s0)
        li      a5,7
        bleu    a4,a5,.L68
        li      a0,56
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-8
        sw      a5,-20(s0)
        j       .L76
.L68:
        lw      a4,-20(s0)
        li      a5,6
        bleu    a4,a5,.L69
        li      a0,55
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-7
        sw      a5,-20(s0)
        j       .L76
.L69:
        lw      a4,-20(s0)
        li      a5,5
        bleu    a4,a5,.L70
        li      a0,54
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-6
        sw      a5,-20(s0)
        j       .L76
.L70:
        lw      a4,-20(s0)
        li      a5,4
        bleu    a4,a5,.L71
        li      a0,53
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-5
        sw      a5,-20(s0)
        j       .L76
.L71:
        lw      a4,-20(s0)
        li      a5,3
        bleu    a4,a5,.L72
        li      a0,52
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-4
        sw      a5,-20(s0)
        j       .L76
.L72:
        lw      a4,-20(s0)
        li      a5,2
        bleu    a4,a5,.L73
        li      a0,51
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-3
        sw      a5,-20(s0)
        j       .L76
.L73:
        lw      a4,-20(s0)
        li      a5,1
        bleu    a4,a5,.L74
        li      a0,50
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-2
        sw      a5,-20(s0)
        j       .L76
.L74:
        lw      a5,-20(s0)
        beq     a5,zero,.L75
        li      a0,49
        call    putchart
        lw      a5,-20(s0)
        addi    a5,a5,-1
        sw      a5,-20(s0)
        j       .L76
.L75:
        li      a0,48
        call    putchart
.L76:
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
teste_com_entre_risc_mestre:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      zero,-24(s0)
        j       .L78
.L81:
        sw      zero,-28(s0)
        j       .L79
.L80:
        lw      a4,-24(s0)
        mv      a5,a4
        slli    a5,a5,2
        add     a5,a5,a4
        slli    a5,a5,2
        mv      a4,a5
        lw      a5,-28(s0)
        add     a5,a4,a5
        sw      a5,-20(s0)
        lw      a0,-20(s0)
        li      a5,36765696
        addi    a5,a5,32
        lw      a4,0(a5)
        li      a5,36765696
        addi    a5,a5,36
        lw      a5,0(a5)
        li      a7,1
        mv      a6,a5
        mv      a5,a4
        li      a4,0
        li      a3,0
        li      a2,10
        li      a1,0
        call    write_gpio
        call    read_gpio
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
        lui     a5,%hi(.LC3)
        addi    a0,a5,%lo(.LC3)
        call    print
        lw      a5,-28(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
.L79:
        li      a5,36765696
        lw      a4,0(a5)
        lw      a5,-28(s0)
        bgtu    a4,a5,.L80
        lui     a5,%hi(.LC5)
        addi    a0,a5,%lo(.LC5)
        call    print
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L78:
        li      a5,36765696
        addi    a5,a5,4
        lw      a4,0(a5)
        lw      a5,-24(s0)
        bgtu    a4,a5,.L81
        nop
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
teste_com_entre_risc_escravo:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        li      a5,36765696
        addi    a5,a5,36
        lw      a5,0(a5)
        sw      a5,-20(s0)
        j       .L83
.L86:
        li      a5,36765696
        addi    a5,a5,32
        lw      a5,0(a5)
        sw      a5,-24(s0)
        j       .L84
.L85:
        call    read_gpio
        li      a5,98304
        addi    a5,a5,256
        lw      a0,0(a5)
        li      a5,36765696
        addi    a5,a5,32
        lw      a4,0(a5)
        li      a5,36765696
        addi    a5,a5,36
        lw      a5,0(a5)
        li      a7,1
        mv      a6,a5
        mv      a5,a4
        li      a4,0
        li      a3,0
        li      a2,0
        li      a1,0
        call    write_gpio
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L84:
        li      a5,36765696
        lw      a4,0(a5)
        lw      a5,-24(s0)
        bgtu    a4,a5,.L85
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L83:
        li      a5,36765696
        addi    a5,a5,4
        lw      a4,0(a5)
        lw      a5,-20(s0)
        bgtu    a4,a5,.L86
        nop
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
set_local_image:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        li      a5,98304
        addi    a5,a5,1032
        lw      a5,0(a5)
        sw      a5,-24(s0)
        j       .L88
.L91:
        li      a5,98304
        addi    a5,a5,1036
        lw      a5,0(a5)
        sw      a5,-28(s0)
        j       .L89
.L90:
        lw      a4,-24(s0)
        mv      a5,a4
        slli    a5,a5,4
        sub     a5,a5,a4
        slli    a5,a5,1
        mv      a4,a5
        lw      a5,-28(s0)
        add     a5,a4,a5
        sw      a5,-20(s0)
        lw      a5,-20(s0)
        mv      a0,a5
        call    print_dec
        lw      a5,-28(s0)
        mv      a0,a5
        call    print_dec
        lw      a5,-24(s0)
        mv      a0,a5
        call    print_dec
        lw      a5,-20(s0)
        mv      a0,a5
        lw      a5,-28(s0)
        mv      a1,a5
        lw      a5,-24(s0)
        li      a4,0
        li      a3,0
        mv      a2,a5
        call    set_pixel
        lw      a5,-28(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
.L89:
        li      a5,98304
        addi    a5,a5,1044
        lw      a4,0(a5)
        li      a5,98304
        addi    a5,a5,1036
        lw      a5,0(a5)
        add     a5,a4,a5
        lw      a4,-28(s0)
        bgtu    a5,a4,.L90
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L88:
        li      a5,98304
        addi    a5,a5,1040
        lw      a4,0(a5)
        li      a5,98304
        addi    a5,a5,1032
        lw      a5,0(a5)
        add     a5,a4,a5
        lw      a4,-24(s0)
        bgtu    a5,a4,.L91
        nop
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
get_local_image:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        li      a5,98304
        addi    a5,a5,1032
        lw      a5,0(a5)
        sw      a5,-28(s0)
        j       .L93
.L96:
        li      a5,98304
        addi    a5,a5,1036
        lw      a5,0(a5)
        sw      a5,-20(s0)
        j       .L94
.L95:
        lw      a1,-20(s0)
        lw      a5,-28(s0)
        mv      a2,a5
        li      a5,36765696
        addi    a5,a5,32
        lw      a4,0(a5)
        li      a5,36765696
        addi    a5,a5,36
        lw      a5,0(a5)
        li      a7,0
        mv      a6,a5
        mv      a5,a4
        li      a4,0
        li      a3,0
        li      a0,0
        call    write_gpio
        call    read_gpio
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
        lui     a5,%hi(.LC2)
        addi    a0,a5,%lo(.LC2)
        call    print
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L94:
        li      a5,36765696
        addi    a5,a5,8
        lw      a4,0(a5)
        li      a5,98304
        addi    a5,a5,1036
        lw      a5,0(a5)
        add     a4,a4,a5
        lw      a5,-20(s0)
        bgtu    a4,a5,.L95
        lui     a5,%hi(.LC5)
        addi    a0,a5,%lo(.LC5)
        call    print
        lw      a5,-28(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
.L93:
        li      a5,98304
        addi    a5,a5,1040
        lw      a4,0(a5)
        li      a5,98304
        addi    a5,a5,1032
        lw      a5,0(a5)
        add     a5,a4,a5
        lw      a4,-28(s0)
        bgtu    a5,a4,.L96
        nop
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
get_image:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      zero,-24(s0)
        j       .L98
.L101:
        sw      zero,-28(s0)
        j       .L99
.L100:
        lw      a1,-28(s0)
        lw      a2,-24(s0)
        li      a5,36765696
        addi    a5,a5,32
        lw      a4,0(a5)
        li      a5,36765696
        addi    a5,a5,36
        lw      a5,0(a5)
        li      a7,0
        mv      a6,a5
        mv      a5,a4
        li      a4,0
        li      a3,0
        li      a0,0
        call    write_gpio
        call    read_gpio
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
        lui     a5,%hi(.LC2)
        addi    a0,a5,%lo(.LC2)
        call    print
        lw      a5,-28(s0)
        addi    a5,a5,1
        sw      a5,-28(s0)
.L99:
        lw      a4,-28(s0)
        li      a5,29
        bleu    a4,a5,.L100
        lui     a5,%hi(.LC5)
        addi    a0,a5,%lo(.LC5)
        call    print
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L98:
        lw      a4,-24(s0)
        li      a5,29
        bleu    a4,a5,.L101
        nop
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
get_external_image:
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        addi    s0,sp,48
        mv      a5,a0
        mv      a4,a1
        sb      a5,-33(s0)
        mv      a5,a4
        sb      a5,-34(s0)
        lbu     a4,-34(s0)
        li      a5,36765696
        addi    a5,a5,12
        lw      a5,0(a5)
        mul     a5,a4,a5
        sw      a5,-20(s0)
        j       .L103
.L106:
        lbu     a4,-33(s0)
        li      a5,36765696
        addi    a5,a5,8
        lw      a5,0(a5)
        mul     a5,a4,a5
        sw      a5,-24(s0)
        j       .L104
.L105:
        lw      a1,-24(s0)
        lw      a2,-20(s0)
        li      a5,36765696
        addi    a5,a5,32
        lw      a4,0(a5)
        li      a5,36765696
        addi    a5,a5,36
        lw      a5,0(a5)
        li      a7,0
        mv      a6,a5
        mv      a5,a4
        li      a4,0
        li      a3,0
        li      a0,0
        call    write_gpio
        call    read_gpio
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
        lui     a5,%hi(.LC2)
        addi    a0,a5,%lo(.LC2)
        call    print
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L104:
        lbu     a5,-33(s0)
        addi    a5,a5,1
        mv      a4,a5
        li      a5,36765696
        addi    a5,a5,8
        lw      a5,0(a5)
        mul     a4,a4,a5
        lw      a5,-24(s0)
        bgtu    a4,a5,.L105
        lui     a5,%hi(.LC5)
        addi    a0,a5,%lo(.LC5)
        call    print
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L103:
        lbu     a5,-34(s0)
        addi    a5,a5,1
        mv      a4,a5
        li      a5,36765696
        addi    a5,a5,12
        lw      a5,0(a5)
        mul     a4,a4,a5
        lw      a5,-20(s0)
        bgtu    a4,a5,.L106
        nop
        nop
        lw      ra,44(sp)
        lw      s0,40(sp)
        addi    sp,sp,48
        jr      ra
get_external_image_noprint:
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        addi    s0,sp,48
        mv      a5,a0
        mv      a4,a1
        sb      a5,-33(s0)
        mv      a5,a4
        sb      a5,-34(s0)
        lbu     a4,-34(s0)
        li      a5,36765696
        addi    a5,a5,12
        lw      a5,0(a5)
        mul     a5,a4,a5
        sw      a5,-20(s0)
        j       .L108
.L111:
        lbu     a4,-33(s0)
        li      a5,36765696
        addi    a5,a5,8
        lw      a5,0(a5)
        mul     a5,a4,a5
        sw      a5,-24(s0)
        j       .L109
.L110:
        lw      a1,-24(s0)
        lw      a2,-20(s0)
        li      a5,36765696
        addi    a5,a5,32
        lw      a4,0(a5)
        li      a5,36765696
        addi    a5,a5,36
        lw      a5,0(a5)
        li      a7,0
        mv      a6,a5
        mv      a5,a4
        li      a4,0
        li      a3,0
        li      a0,0
        call    write_gpio
        call    read_gpio
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L109:
        lbu     a5,-33(s0)
        addi    a5,a5,1
        mv      a4,a5
        li      a5,36765696
        addi    a5,a5,8
        lw      a5,0(a5)
        mul     a4,a4,a5
        lw      a5,-24(s0)
        bgtu    a4,a5,.L110
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L108:
        lbu     a5,-34(s0)
        addi    a5,a5,1
        mv      a4,a5
        li      a5,36765696
        addi    a5,a5,12
        lw      a5,0(a5)
        mul     a4,a4,a5
        lw      a5,-20(s0)
        bgtu    a4,a5,.L111
        nop
        nop
        lw      ra,44(sp)
        lw      s0,40(sp)
        addi    sp,sp,48
        jr      ra
teste_local_image:
        addi    sp,sp,-16
        sw      ra,12(sp)
        sw      s0,8(sp)
        addi    s0,sp,16
        call    set_local_image
        call    get_local_image
        nop
        lw      ra,12(sp)
        lw      s0,8(sp)
        addi    sp,sp,16
        jr      ra
teste_leitura_imagem:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      zero,-20(s0)
        j       .L114
.L117:
        sw      zero,-24(s0)
        j       .L115
.L116:
        lw      a5,-20(s0)
        andi    a5,a5,0xff
        lw      a4,-24(s0)
        andi    a4,a4,0xff
        mv      a1,a4
        mv      a0,a5
        call    get_external_image
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L115:
        li      a5,36765696
        addi    a5,a5,20
        lw      a4,0(a5)
        lw      a5,-24(s0)
        bgtu    a4,a5,.L116
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L114:
        li      a5,36765696
        addi    a5,a5,16
        lw      a4,0(a5)
        lw      a5,-20(s0)
        bgtu    a4,a5,.L117
        nop
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
delay:
        addi    sp,sp,-32
        sw      s0,28(sp)
        addi    s0,sp,32
        li      a5,0
        li      a6,0
        sw      a5,-24(s0)
        sw      a6,-20(s0)
        j       .L119
.L120:
        lw      a4,-24(s0)
        lw      a5,-20(s0)
        li      a0,1
        li      a1,0
        add     a2,a4,a0
        mv      a6,a2
        sltu    a6,a6,a4
        add     a3,a5,a1
        add     a5,a6,a3
        mv      a3,a5
        mv      a4,a2
        mv      a5,a3
        sw      a4,-24(s0)
        sw      a5,-20(s0)
.L119:
        lw      a4,-24(s0)
        lw      a5,-20(s0)
        mv      a3,a5
        bne     a3,zero,.L122
        mv      a3,a5
        bne     a3,zero,.L120
        li      a5,20480
        addi    a5,a5,-481
        bleu    a4,a5,.L120
.L122:
        nop
        lw      s0,28(sp)
        addi    sp,sp,32
        jr      ra
teste_parameters:
        addi    sp,sp,-16
        sw      ra,12(sp)
        sw      s0,8(sp)
        addi    s0,sp,16
        li      a5,36765696
        lw      a5,0(a5)
        mv      a0,a5
        call    print_dec
        lui     a5,%hi(.LC5)
        addi    a0,a5,%lo(.LC5)
        call    print
        li      a5,36765696
        addi    a5,a5,4
        lw      a5,0(a5)
        mv      a0,a5
        call    print_dec
        lui     a5,%hi(.LC5)
        addi    a0,a5,%lo(.LC5)
        call    print
        li      a5,36765696
        addi    a5,a5,8
        lw      a5,0(a5)
        mv      a0,a5
        call    print_dec
        lui     a5,%hi(.LC5)
        addi    a0,a5,%lo(.LC5)
        call    print
        li      a5,36765696
        addi    a5,a5,12
        lw      a5,0(a5)
        mv      a0,a5
        call    print_dec
        lui     a5,%hi(.LC5)
        addi    a0,a5,%lo(.LC5)
        call    print
        li      a5,36765696
        addi    a5,a5,16
        lw      a5,0(a5)
        mv      a0,a5
        call    print_dec
        lui     a5,%hi(.LC5)
        addi    a0,a5,%lo(.LC5)
        call    print
        li      a5,36765696
        addi    a5,a5,20
        lw      a5,0(a5)
        mv      a0,a5
        call    print_dec
        lui     a5,%hi(.LC5)
        addi    a0,a5,%lo(.LC5)
        call    print
        li      a5,36765696
        addi    a5,a5,24
        lw      a5,0(a5)
        mv      a0,a5
        call    print_dec
        lui     a5,%hi(.LC5)
        addi    a0,a5,%lo(.LC5)
        call    print
        li      a5,36765696
        addi    a5,a5,28
        lw      a5,0(a5)
        mv      a0,a5
        call    print_dec
        lui     a5,%hi(.LC5)
        addi    a0,a5,%lo(.LC5)
        call    print
        li      a5,36765696
        addi    a5,a5,32
        lw      a5,0(a5)
        mv      a0,a5
        call    print_dec
        lui     a5,%hi(.LC5)
        addi    a0,a5,%lo(.LC5)
        call    print
        li      a5,36765696
        addi    a5,a5,36
        lw      a5,0(a5)
        mv      a0,a5
        call    print_dec
        lui     a5,%hi(.LC5)
        addi    a0,a5,%lo(.LC5)
        call    print
        nop
        lw      ra,12(sp)
        lw      s0,8(sp)
        addi    sp,sp,16
        jr      ra
distribute_image_from_zynq:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      zero,-20(s0)
        j       .L125
.L130:
        nop
.L126:
        li      a5,36700160
        addi    a5,a5,12
        lw      a5,0(a5)
        beq     a5,zero,.L126
        li      a5,36700160
        addi    a5,a5,4
        lw      a4,0(a5)
        li      a5,36700160
        addi    a5,a5,8
        lw      a5,0(a5)
        mv      a1,a5
        mv      a0,a4
        call    check_local_pixel
        mv      a5,a0
        beq     a5,zero,.L127
        li      a5,36700160
        lw      a0,0(a5)
        li      a5,36700160
        addi    a5,a5,4
        lw      a1,0(a5)
        li      a5,36700160
        addi    a5,a5,8
        lw      a5,0(a5)
        li      a4,0
        li      a3,0
        mv      a2,a5
        call    set_pixel
        li      a5,36700160
        addi    a5,a5,4
        lw      a4,0(a5)
        li      a5,36700160
        addi    a5,a5,8
        lw      a5,0(a5)
        mv      a1,a5
        mv      a0,a4
        call    check_last_pixel
        mv      a5,a0
        beq     a5,zero,.L128
        li      a5,36700160
        addi    a5,a5,24
        li      a4,1
        sw      a4,0(a5)
        j       .L128
.L127:
        li      a5,36700160
        lw      a0,0(a5)
        li      a5,36700160
        addi    a5,a5,4
        lw      a1,0(a5)
        li      a5,36700160
        addi    a5,a5,8
        lw      a2,0(a5)
        li      a5,36700160
        addi    a5,a5,4
        lw      a4,0(a5)
        li      a5,36700160
        addi    a5,a5,8
        lw      a5,0(a5)
        li      a7,1
        mv      a6,a5
        mv      a5,a4
        li      a4,0
        li      a3,0
        call    write_gpio
.L128:
        lui     a5,%hi(.LC4)
        addi    a0,a5,%lo(.LC4)
        call    print
        li      a5,36700160
        addi    a5,a5,16
        li      a4,1
        sw      a4,0(a5)
        nop
.L129:
        li      a5,36700160
        addi    a5,a5,12
        lw      a4,0(a5)
        li      a5,1
        beq     a4,a5,.L129
        li      a5,36700160
        addi    a5,a5,16
        sw      zero,0(a5)
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L125:
        lw      a4,-20(s0)
        li      a5,900
        bne     a4,a5,.L130
        nop
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
check_last_pixel:
        addi    sp,sp,-32
        sw      s0,28(sp)
        addi    s0,sp,32
        sw      a0,-20(s0)
        sw      a1,-24(s0)
        li      a5,98304
        addi    a5,a5,1032
        lw      a4,0(a5)
        li      a5,98304
        addi    a5,a5,1040
        lw      a5,0(a5)
        add     a5,a4,a5
        addi    a5,a5,-1
        lw      a4,-24(s0)
        bne     a4,a5,.L132
        li      a5,98304
        addi    a5,a5,1036
        lw      a4,0(a5)
        li      a5,98304
        addi    a5,a5,1044
        lw      a5,0(a5)
        add     a5,a4,a5
        addi    a5,a5,-1
        lw      a4,-20(s0)
        bne     a4,a5,.L132
        li      a5,1
        j       .L133
.L132:
        li      a5,0
.L133:
        mv      a0,a5
        lw      s0,28(sp)
        addi    sp,sp,32
        jr      ra
check_local_pixel:
        addi    sp,sp,-32
        sw      s0,28(sp)
        addi    s0,sp,32
        sw      a0,-20(s0)
        sw      a1,-24(s0)
        li      a5,98304
        addi    a5,a5,1036
        lw      a5,0(a5)
        lw      a4,-20(s0)
        sltu    a5,a4,a5
        xori    a5,a5,1
        andi    a4,a5,0xff
        li      a5,98304
        addi    a5,a5,1036
        lw      a3,0(a5)
        li      a5,98304
        addi    a5,a5,1044
        lw      a5,0(a5)
        add     a5,a3,a5
        lw      a3,-20(s0)
        sltu    a5,a3,a5
        andi    a5,a5,0xff
        and     a5,a4,a5
        andi    a5,a5,0xff
        beq     a5,zero,.L135
        li      a5,98304
        addi    a5,a5,1032
        lw      a5,0(a5)
        lw      a4,-24(s0)
        sltu    a5,a4,a5
        xori    a5,a5,1
        andi    a4,a5,0xff
        li      a5,98304
        addi    a5,a5,1032
        lw      a3,0(a5)
        li      a5,98304
        addi    a5,a5,1040
        lw      a5,0(a5)
        add     a5,a3,a5
        lw      a3,-24(s0)
        sltu    a5,a3,a5
        andi    a5,a5,0xff
        and     a5,a4,a5
        andi    a5,a5,0xff
        beq     a5,zero,.L135
        li      a5,1
        j       .L136
.L135:
        li      a5,0
.L136:
        mv      a0,a5
        lw      s0,28(sp)
        addi    sp,sp,32
        jr      ra
wait_for_checkmsg:
        addi    sp,sp,-16
        sw      s0,12(sp)
        addi    s0,sp,16
        j       .L138
.L139:
        nop
.L138:
        li      a5,36700160
        addi    a5,a5,20
        lw      a5,0(a5)
        andi    a4,a5,511
        li      a5,511
        bne     a4,a5,.L139
        nop
        nop
        lw      s0,12(sp)
        addi    sp,sp,16
        jr      ra
get_first_image_recv:
        addi    sp,sp,-16
        sw      ra,12(sp)
        sw      s0,8(sp)
        addi    s0,sp,16
        call    get_and_set_local_image_from_zynq_recv
        call    send_transfer_finished_notice_recv
        nop
        lw      ra,12(sp)
        lw      s0,8(sp)
        addi    sp,sp,16
        jr      ra
send_transfer_finished_notice_recv:
        addi    sp,sp,-16
        sw      s0,12(sp)
        addi    s0,sp,16
        li      a5,36700160
        addi    a5,a5,24
        li      a4,1
        sw      a4,0(a5)
        nop
        lw      s0,12(sp)
        addi    sp,sp,16
        jr      ra
get_and_set_local_image_from_zynq_recv:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      zero,-20(s0)
        j       .L143
.L146:
        sw      zero,-24(s0)
        j       .L144
.L145:
        call    get_and_set_local_pixel_from_zynq_recv
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L144:
        li      a5,98304
        addi    a5,a5,1044
        lw      a4,0(a5)
        lw      a5,-24(s0)
        bgtu    a4,a5,.L145
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L143:
        li      a5,98304
        addi    a5,a5,1040
        lw      a4,0(a5)
        lw      a5,-20(s0)
        bgtu    a4,a5,.L146
        nop
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
get_and_set_local_pixel_from_zynq_recv:
        addi    sp,sp,-16
        sw      ra,12(sp)
        sw      s0,8(sp)
        addi    s0,sp,16
        call    read_gpio
        li      a5,98304
        addi    a5,a5,256
        lw      a0,0(a5)
        li      a5,98304
        addi    a5,a5,260
        lw      a1,0(a5)
        li      a5,98304
        addi    a5,a5,264
        lw      a5,0(a5)
        li      a4,0
        li      a3,0
        mv      a2,a5
        call    set_pixel
        nop
        lw      ra,12(sp)
        lw      s0,8(sp)
        addi    sp,sp,16
        jr      ra
delay2:
        addi    sp,sp,-48
        sw      s0,44(sp)
        addi    s0,sp,48
        mv      a5,a0
        sh      a5,-34(s0)
        sh      zero,-18(s0)
        j       .L149
.L150:
        nop
        lhu     a5,-18(s0)
        slli    a5,a5,16
        srli    a5,a5,16
        addi    a5,a5,1
        slli    a5,a5,16
        srli    a5,a5,16
        sh      a5,-18(s0)
.L149:
        lhu     a5,-18(s0)
        slli    a5,a5,16
        srli    a5,a5,16
        lhu     a4,-34(s0)
        bgtu    a4,a5,.L150
        nop
        nop
        lw      s0,44(sp)
        addi    sp,sp,48
        jr      ra