%macro rw 4		      
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

section .data
	arr times 64 db 0;Like duplicate instruction arr DB 34 DUP (0)
	;arr db 10h,20h,30h,40h,50h;arr1 db "10,20,30,40,50",10
	;arr1len equ $-arr1
	
	msg2 db "The elements of array:",10
	msg2len equ $-msg2
	msg1 db "Sum of array:",10
	msg1len equ $-msg1
	
	cnt db 5
	temp1 db 0;Displat output one by one
	
section .bss
	sum resb 2
	num resb 3;store entered number
	temp resb 2;after rotating by 4 store value Ax=1234h->2341h
	
section .text
	global _start

_start:
	mov rbp,arr;added nw ; rbp - base pointer is alternate used for cx?
	
nextnum:
	rw 1,1,msg2,msg2len;The elements of array
	rw 0,0,num,3
	mov rcx,0
	mov rax,0
	mov rsi,num
	
up:
	mov cl,byte[rsi]
	cmp cl,0ah
	je packed
	cmp cl,39h
	jbe down
	sub cl,07h

down:
	sub cl,30h
	rol al,4
	add al,cl
	inc rsi
	jmp up
	
packed:
	mov byte[rbp],al
	inc rbp
	dec byte[cnt]
	jnz nextnum
	
	mov rsi,arr
	mov ax,00h
	mov bx,0h
	mov cx,5

up2:
	mov bl,byte[rsi]
	add ax,bx;
	jnc skip
	inc ah
	
skip:
	inc rsi
	dec cx
	jnz up2
	
	mov word[sum],ax
	rw 1,1,msg1,msg1len;Sum of array:
	call disp
	
exit:	mov rax,60
	mov rdi,0
	syscall
	
disp:
	mov bp,4
	mov ax,word[sum]
	
up1:
	rol ax,4
	mov [temp],ax
	and ax,0fh
	cmp al,09
	jbe down1
	add al,07
	
down1:
	add al,30h
	mov [temp1],al
	rw 1,1,temp1,1
	
	mov ax,word[temp]
	dec bp
	jnz up1
	ret
	
