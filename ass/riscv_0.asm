.data
.LC0:
        .string "\n"
        
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
        li      a5,65536
        sw      zero,0(a5)
.L2:
        call    read_message
        li      a5,65536
        lw      a5,0(a5)
        mv      a0,a5
        call    print_dec
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    print
        li      a4,65536
        li      a5,50331648
        lw      a4,0(a4)
        sw      a4,0(a5)
        j       .L2
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
        bne     a4,a5,.L6
        li      a0,13
        call    putchar
.L6:
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
        j       .L8
.L9:
        lw      a5,-20(s0)
        addi    a4,a5,1
        sw      a4,-20(s0)
        lbu     a5,0(a5)
        mv      a0,a5
        call    putchar
.L8:
        lw      a5,-20(s0)
        lbu     a5,0(a5)
        bne     a5,zero,.L9
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
        bleu    a4,a5,.L11
        li      a0,57
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-900
        sw      a5,-20(s0)
        j       .L12
.L11:
        lw      a4,-20(s0)
        li      a5,799
        bleu    a4,a5,.L13
        li      a0,56
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-800
        sw      a5,-20(s0)
        j       .L12
.L13:
        lw      a4,-20(s0)
        li      a5,699
        bleu    a4,a5,.L14
        li      a0,55
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-700
        sw      a5,-20(s0)
        j       .L12
.L14:
        lw      a4,-20(s0)
        li      a5,599
        bleu    a4,a5,.L15
        li      a0,54
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-600
        sw      a5,-20(s0)
        j       .L12
.L15:
        lw      a4,-20(s0)
        li      a5,499
        bleu    a4,a5,.L16
        li      a0,53
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-500
        sw      a5,-20(s0)
        j       .L12
.L16:
        lw      a4,-20(s0)
        li      a5,399
        bleu    a4,a5,.L17
        li      a0,52
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-400
        sw      a5,-20(s0)
        j       .L12
.L17:
        lw      a4,-20(s0)
        li      a5,299
        bleu    a4,a5,.L18
        li      a0,51
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-300
        sw      a5,-20(s0)
        j       .L12
.L18:
        lw      a4,-20(s0)
        li      a5,199
        bleu    a4,a5,.L19
        li      a0,50
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-200
        sw      a5,-20(s0)
        j       .L12
.L19:
        lw      a4,-20(s0)
        li      a5,99
        bleu    a4,a5,.L12
        li      a0,49
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-100
        sw      a5,-20(s0)
.L12:
        lw      a4,-20(s0)
        li      a5,89
        bleu    a4,a5,.L20
        li      a0,57
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-90
        sw      a5,-20(s0)
        j       .L21
.L20:
        lw      a4,-20(s0)
        li      a5,79
        bleu    a4,a5,.L22
        li      a0,56
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-80
        sw      a5,-20(s0)
        j       .L21
.L22:
        lw      a4,-20(s0)
        li      a5,69
        bleu    a4,a5,.L23
        li      a0,55
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-70
        sw      a5,-20(s0)
        j       .L21
.L23:
        lw      a4,-20(s0)
        li      a5,59
        bleu    a4,a5,.L24
        li      a0,54
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-60
        sw      a5,-20(s0)
        j       .L21
.L24:
        lw      a4,-20(s0)
        li      a5,49
        bleu    a4,a5,.L25
        li      a0,53
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-50
        sw      a5,-20(s0)
        j       .L21
.L25:
        lw      a4,-20(s0)
        li      a5,39
        bleu    a4,a5,.L26
        li      a0,52
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-40
        sw      a5,-20(s0)
        j       .L21
.L26:
        lw      a4,-20(s0)
        li      a5,29
        bleu    a4,a5,.L27
        li      a0,51
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-30
        sw      a5,-20(s0)
        j       .L21
.L27:
        lw      a4,-20(s0)
        li      a5,19
        bleu    a4,a5,.L28
        li      a0,50
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-20
        sw      a5,-20(s0)
        j       .L21
.L28:
        lw      a4,-20(s0)
        li      a5,9
        bleu    a4,a5,.L21
        li      a0,49
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-10
        sw      a5,-20(s0)
.L21:
        lw      a4,-20(s0)
        li      a5,8
        bleu    a4,a5,.L29
        li      a0,57
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-9
        sw      a5,-20(s0)
        j       .L39
.L29:
        lw      a4,-20(s0)
        li      a5,7
        bleu    a4,a5,.L31
        li      a0,56
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-8
        sw      a5,-20(s0)
        j       .L39
.L31:
        lw      a4,-20(s0)
        li      a5,6
        bleu    a4,a5,.L32
        li      a0,55
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-7
        sw      a5,-20(s0)
        j       .L39
.L32:
        lw      a4,-20(s0)
        li      a5,5
        bleu    a4,a5,.L33
        li      a0,54
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-6
        sw      a5,-20(s0)
        j       .L39
.L33:
        lw      a4,-20(s0)
        li      a5,4
        bleu    a4,a5,.L34
        li      a0,53
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-5
        sw      a5,-20(s0)
        j       .L39
.L34:
        lw      a4,-20(s0)
        li      a5,3
        bleu    a4,a5,.L35
        li      a0,52
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-4
        sw      a5,-20(s0)
        j       .L39
.L35:
        lw      a4,-20(s0)
        li      a5,2
        bleu    a4,a5,.L36
        li      a0,51
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-3
        sw      a5,-20(s0)
        j       .L39
.L36:
        lw      a4,-20(s0)
        li      a5,1
        bleu    a4,a5,.L37
        li      a0,50
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-2
        sw      a5,-20(s0)
        j       .L39
.L37:
        lw      a5,-20(s0)
        beq     a5,zero,.L38
        li      a0,49
        call    putchar
        lw      a5,-20(s0)
        addi    a5,a5,-1
        sw      a5,-20(s0)
        j       .L39
.L38:
        li      a0,48
        call    putchar
.L39:
        nop
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra