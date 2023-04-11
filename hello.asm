SECTION .data
    msg1: db 'Hello World! Welcome to the world of Microprocessors',0xA
    len1 equ $-msg1

SECTION .text
    GLOBAL _start
    _start:
    MOV eax,1
    MOV ebx,1
    MOV esi,msg1
    MOV edx,len1
    syscall
