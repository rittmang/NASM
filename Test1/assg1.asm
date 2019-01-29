section .data
msg db "Enter name:",10
msglen equ $-msg
newline db 10

section .bss
name resb 20
temp resb 1

section .text
global _start
_start:
mov rax,1
mov rdi,1
mov rsi,msg
mov rdx,msglen
syscall

mov rax,0
mov rdi,0
mov rsi,name
mov rdx,15
syscall

mov rax,1
mov rdi,1
mov rsi,newline
mov rdx,1
syscall

mov rax,1
mov rdi,1
mov rsi,name
mov rdx,15
syscall

mov rax,1
mov rdi,1
mov rsi,newline
mov rdx,1
syscall

mov rax,60
mov rdi,0
syscall
