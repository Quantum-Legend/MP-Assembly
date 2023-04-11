SECTION .data
    ncnt db 0
    pcnt db 0
    array: dw 80H,-4CH,3FH
    len equ 3


    msg1: db 'positive numbers are: '
    len1 equ $-msg1
    msg2: db 0xA,'negative numbers are: '
    len2 equ $-msg2
    msg3: db 0xA
    len3 equ $-msg3

SECTION .bss
    buff resb 02

SECTION .text
    GLOBAL _start
    _start:
        MOV rsi,array
        MOV rcx,03

        A1:
            BT word[rsi],15
            JNC A
            INC byte[ncnt]
            JMP skip

        A:
            INC byte[pcnt]

        skip:
            INC rsi
            INC rsi
            LOOP A1

        MOV rax,1
        MOV rdi,1
        MOV rsi,msg1
        MOV rdx,len1
        SYSCALL

        MOV bl,[pcnt]
        MOV rdi,buff
        MOV rcx,02

        CALL display

        MOV rax,1
        MOV rdi,1
        MOV rsi,msg2
        MOV rdx,len2
        SYSCALL

        MOV bl,[ncnt]
        MOV rdi,buff
        MOV rcx,02

        CALL display

        MOV rax,1
        MOV rdi,1
        MOV rsi,msg3
        MOV rdx,len3
        SYSCALL

        MOV rax,60
        MOV rdi,0
        SYSCALL

        display:
            ROL bl,4
            MOV al,bl
            AND al,0FH
            CMP al,09
            JBE B
            ADD al,07H

        B:
            ADD al,30H
            MOV [rdi],al
            INC rdi
            LOOP display

        MOV rax,1
        MOV rdi,1
        MOV rsi,buff
        MOV rdx,02
        SYSCALL

        RET
