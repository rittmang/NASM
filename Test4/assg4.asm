section .data
menumsg db "*********STRING OPERATIONS*************",10
	db "1. Enter String",10
	db "2. Length of String",10
	db "3. Palindrome",10
	db "4. Exit",10
	db "Enter choice:",10
menumsglen equ $-menumsg

msg1 db "Enter String",10
msglen1 equ $-msg1

msg2 db "String is",10
msglen2 equ $-msg2

msg3 db "Length of string is",10
msglen3 equ $-msg3

msg4 db "String is palindrome",10
msglen4 equ $-msg4

msg5 db "String is NOT palindrome",10
msglen5 equ $-msg5

msg6 db "String operations performed successfully",10
msglen6 equ $-msg6

nwln db 10

section .bss
	strlen1 resb 2
	str1 resb 30
	str2 resb 30
	choice resb 3
	cnt resb 3	; First byte for number & second for enter key

%macro rw 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

section .text
	global _start	;declared global
	
			;tell linker the entry point
_start:			
	rw 1,1,menumsg,menumsglen
	rw 0,0,choice,2
	cmp byte[choice],'1'
	je l1
	cmp byte[choice],'2'
	je l2
	cmp byte[choice],'3'
	je l3
	cmp byte[choice],'4'
	je exit


			;accept string
l1:
	rw 1,1,msg1,msglen1
	rw 0,0,str1,10
	dec rax
	mov byte[strlen1],al
	mov byte[cnt],al
	rw 1,1,msg2,msglen2
	rw 1,1,str1,[cnt]
	rw 1,1,nwln,1
	jmp _start

			;Length
l2:
	rw 1,1,msg3,msglen3
	add byte[strlen1],30h
	rw 1,1,strlen1,1
	rw 1,1,nwln,1
	jmp _start
			;Palindrome
l3:
	mov rsi,str1
	mov rdi,str1
	mov cx,[cnt]

l31:
	inc rdi
	dec cx
	jnz l31
	dec rdi
l32:
	mov al,[rsi]
	cmp al,[rdi]
	je l33
	rw 1,1, msg5,msglen5; String not Palindrome
	jmp _start

l33:
	inc rsi
	dec rdi
	dec byte[cnt]
	jnz l32
	rw 1,1,msg4,msglen4;Palindrome
	jmp _start

exit:
	rw 1,1,msg6,msglen6	;performed succesfully
	mov rax,60
	mov rdi,0
	syscall ;call kernel
