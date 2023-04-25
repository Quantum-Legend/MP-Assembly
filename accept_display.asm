SECTION .data
    msg1 db 10,'Enter 5 64-bit numbers: ',10
    msg1_len equ $-msg1
    msg2 db 10,'Entered 5 64-bit numbers are: ',10
    msg2_len equ $-msg2

SECTION .bss
    array resd 200
    counter resb 1

SECTION .text
    global _start
    _start:
        disp_msg1:
            MOV rax,1
            MOV rdi,1
            MOV rsi,msg1
            MOV rdx,msg1_len
            SYSCALL

        accept_nos:
            MOV byte[counter],05
            MOV rbx,00
            loop1:
                MOV rax,0
                MOV rdi,0
                MOV rsi,array
                ADD rsi,rbx
                MOV rdx,17
                SYSCALL
                ADD rbx,17
                DEC byte[counter]
            JNZ loop1

        disp_msg2:
            MOV rax,1
            MOV rdi,1
            MOV rsi,msg2
            MOV rdx,msg2_len
            SYSCALL
        
        disp_nos:
            MOV byte[counter],05
            MOV rbx,00
            loop2:
                MOV rax,1
                MOV rdi,1
                MOV rsi,array
                ADD rsi,rbx
                MOV rdx,17
                SYSCALL
                ADD rbx,17
                DEC byte[counter]
            JNZ loop2

        exit:
            MOV rax,60
            MOV rdi,0
            SYSCALL