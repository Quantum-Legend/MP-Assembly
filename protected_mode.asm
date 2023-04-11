SECTION .data
    rmsg db 10,'Processor is in real mode'
    rmsg_len equ $-rmsg
    
    pmsg db 10,'Processor is in protected mode'
    pmsg_len equ $-pmsg
    
    gmsg db 10,'GDT contents are: '
    gmsg_len equ $-gmsg
    
    lmsg db 10,'LDT contents are: '
    lmsg_len equ $-lmsg
    
    imsg db 10,'IDT contents are: '
    imsg_len equ $-imsg
    
    tmsg db 10,'Task Register contents are: '
    tmsg_len equ $-tmsg
    
    mmsg db 10,'Machine Status Word: '
    mmsg_len equ $-mmsg
    
    colmsg db ':'
    newline db 10
    
SECTION .bss
	gdt 		resd 1
				resw 1
	ldt 		resw 1
	idt 		resd 1
				resw 1
	tr 			resw 1
	cr0_data	resd 1
	dnum_buff	resb 04
	
	%MACRO DISP 2
		MOV rax,1
		MOV rdi,1
		MOV rsi,%1
		MOV rdx,%2
		SYSCALL
	%ENDMACRO
	
SECTION .text
	GLOBAL _start
		_start:
			SMSW eax
			MOV [cr0_data],eax
			BT eax,0
			JC prmode
			DISP rmsg,rmsg_len
			JMP exit
			
			prmode:
				DISP pmsg,pmsg_len
				SGDT [gdt]
				SLDT [ldt]
				SIDT [idt]
				STR [tr]
				
				DISP gmsg,gmsg_len
				MOV bx,[gdt+4]
				CALL disp_num
				MOV bx,[gdt+2]
				CALL disp_num
				DISP colmsg,1
				MOV bx,[gdt]
				CALL disp_num
				DISP lmsg,lmsg_len
				MOV bx,[ldt]
				CALL disp_num
				DISP imsg,imsg_len
				MOV bx,[idt+4]
				CALL disp_num
				MOV bx,[idt+2]
				CALL disp_num
				DISP colmsg,1
				MOV bx,[idt]
				CALL disp_num
				DISP tmsg,tmsg_len
				MOV bx,[tr]
				CALL disp_num
				DISP mmsg,mmsg_len
				MOV bx,[cr0_data+2]
				CALL disp_num
				MOV bx,[cr0_data]
				CALL disp_num
				DISP newline,1
				
			exit:
				MOV eax,01
				MOV ebx,00
				INT 80H
				
			disp_num:
				MOV esi,dnum_buff
				MOV ecx,04
				
			up1:
				ROL bx,4
				MOV dl,bl
				AND dl,0fH
				ADD dl,30H
				CMP dl,39H
				JBE skip1
				ADD dl,07H
			
			skip1:
				MOV [esi],dl
				INC esi
				LOOP up1

				DISP dnum_buff,4
			RET
