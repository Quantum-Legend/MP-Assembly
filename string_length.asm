SECTION .data
    msg1 db 10,'Enter the input string: '
    msg1_len equ $-msg1
    msg2 db 10,'The entered string is: '
    msg2_len equ $-msg2
    msg3 db 10,'The length of the string is: '
    msg3_len equ $-msg3
    newline db 10

SECTION .bss
    string resb 50
    stringlen equ $-string
    count resd 1
    dispnum resb 16

SECTION .text
    global _start
    _start:
        disp_msg1:
            MOV rax,1
            MOV rdi,1
            MOV rsi,msg1
            MOV rdx,msg1_len
            SYSCALL
            
        accept_str:
            MOV rax,0
            MOV rdi,0
            MOV rsi,string
            MOV rdx,stringlen
            SYSCALL
            MOV [count],rax

        disp_msg2:
            MOV rax,1
            MOV rdi,1
            MOV rsi,msg2
            MOV rdx,msg2_len
            SYSCALL

        disp_str:
            MOV rax,1
            MOV rdi,1
            MOV rsi,string
            MOV rdx,[count]
            SYSCALL

        disp_msg3:
            MOV rax,1
            MOV rdi,1
            MOV rsi,msg3
            MOV rdx,msg3_len
            SYSCALL
            
        disp_strlen:
            MOV rsi,dispnum+15
            MOV rax,[count]
            MOV rcx,16
            DEC rax
            len_16digit:
                MOV rdx,0
                MOV rbx,10
                DIV rbx
                ADD dl,30H
                MOV [rsi],dl
                DEC rsi
            LOOP len_16digit
            MOV rax,1
            MOV rdi,1
            MOV rsi,dispnum
            MOV rdx,16
            SYSCALL

        newline_proc:
            MOV rax,1
            MOV rdi,1
            MOV rsi,newline
            MOV rdx,1
            SYSCALL

        exit:
            MOV rax,60
            MOV rdi,0
            SYSCALL
