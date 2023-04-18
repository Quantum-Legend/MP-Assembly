SECTION .data
    msg db 10,10,'---Menu for Non-overlapped Block Transfer---',10
    msg_len equ $-msg

    blk_bfrmsg db 10,'Block contents before transfer::'
    blk_bfrmsg_len equ $-blk_bfrmsg

    blk_afrmsg db 10,'Block contents after transfer::'
    blk_afrmsg_len equ $-blk_afrmsg

    position db 10,'Enter position overlap:'
    pos_len equ $-position

    srcblk db 01H,02H,03H,04H,05H,00H,00H,00H,00H,00H
    cnt equ 05

    spacechar db 20H
    ifmsg db 10,10
    newline db 10

SECTION .bss
    optionbuff resb 02
    dispbuff resw 02
    pos resb 00

    %MACRO DISP 2
        MOV rax,01
        MOV rdi,02
        MOV rsi,%1
        MOV rdx,%2
        SYSCALL
    %ENDMACRO

    %MACRO ACCEPT 2
        MOV rax,0
        MOV rdi,0
        MOV rsi,%1
        MOV rdx,%2
        SYSCALL
    %ENDMACRO

SECTION .text
    global _start
    _start:
        DISP blk_bfrmsg, blk_bfrmsg_len
        CALL dispblk_proc
        DISP newline,1
        DISP position,pos_len
        ACCEPT optionbuff,02
        CALL packnum_proc
        CALL blkxferwo_proc
        DISP blk_afrmsg, blk_afrmsg_len
        CALL dispblk_proc
        DISP newline,1

        ext:
            MOV rax,60
            MOV rbx,0
            SYSCALL

        dispblk_proc:
            MOV rsi,srcblk
            MOV rcx,cnt
            ADD rcx,[pos]
            rdisp:
                PUSH rcx
                MOV bl,[rsi]
                PUSH rsi
                CALL disp8_proc
                POP rsi
                INC rsi
                PUSH rsi
                DISP spacechar,1
                POP rsi
                POP rcx
            LOOP rdisp
        RET

        blkxferwo_proc:
            MOV rsi,srcblk+4
            MOV rdi,rsi
            ADD rdi,[pos]
            MOV rcx,cnt
            blkup1:
                MOV al,[rsi]
                MOV [rdi],al
                DEC rsi
                DEC rdi
            LOOP blkup1
        RET

        disp8_proc:
            MOV cl,2
            MOV rdi,dispbuff
            dup1:
                ROL bl,4
                MOV dl,bl
                AND dl,0fH
                CMP dl,09H
                JBE dskip
                ADD dl,07H
            dskip:
                ADD dl,30H
                MOV [rdi],dl
                INC rdi
            LOOP dup1

            DISP dispbuff,2
        RET

        packnum_proc:
            MOV rsi,optionbuff
            MOV bl,[rsi]
            CMP bl,39H
            JBE skip1
            SUB bl,07H
            skip1:
                SUB bl,30H
                MOV [pos],bl
        RET
