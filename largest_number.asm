section .data
    numbers db 10, 20, 30, 40, 50, 60, 70, 80, 90, 100    
    size equ $-numbers                                   

section .text
    global _start

_start:
    mov eax, 0                   
    mov ebx, 0                   
    mov ecx, size/4              

    ; Loop through the array
    mov esi, numbers             
    cmp ecx, 0                   
    je end_prog

loop:
    mov ebx, dword [esi]         
    cmp ebx, eax                 
    jle not_largest            
    mov eax, ebx               

not_largest:
    add esi, 4                  
    loop loop                    

end_prog:
    mov eax, 1                   
    xor ebx, ebx                 
    int 0x80                     
