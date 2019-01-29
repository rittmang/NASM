;ALP to accept 4 32 bit numbers and display it
SECTION .data
msg: db "enter numbers",10
len: equ $-msg
msg1: db "the entered numbers are",10
len1: equ $-msg1
msg2: db "Enter number of numbers to enter",10
len2: equ $-msg2
count: db 0 ; 1 byte!
count2: db 0 ; a spare byte - not apparently used. That'll help, but not enough.

SECTION .bss
num resd 4 ; 4 dwords = 16 bytes.
countlimit resd 1 ; 4 bytes - this is enough, as used...


SECTION .text
global _start

	string_to_int: ;I copied this function from the internet
					; expects: string in esi, count in ecx
					; returns: number in eax

					xor ebx,ebx
	
	.next_digit:
					movzx eax,byte[esi]
					inc esi
               			; I'd make sure we had a valid digit here!
					sub al,'0'
					imul ebx,10
					add ebx,eax
					loop .next_digit
					mov eax,ebx
					ret
 
	_start:
		
					;print message

					mov edx,len2
					mov ecx,msg2
					mov ebx,1
					mov eax,4
					int 0x80
	
		;Read the number of numbers (syscall)
		
	        		mov edx,2 ; one for the digit, one for the linefeed
					mov ecx,countlimit
					mov ebx,0
					mov eax,3
					int 0x80
	
		;print message

						mov edx,len
						mov ecx,msg
						mov ebx,1
						mov eax,4
						int 0x80
		
		;Not important but just clean esi and ecx before calling the string_to_int function
						xor esi,esi
						xor ecx,ecx
		
		;Call the string_to_int function, the output is going to be in eax
						mov esi,countlimit
						mov ecx,1
						call string_to_int
		
		;Put the number N in the contents at [count] address
						mov dword[count],eax ; dword into byte variable!
		
		loop1:
						mov edx,9 ; why 9 innings, Mr. Doubleday?
						mov ecx,esi
						mov ebx,2 ; stderr? (perhaps surprisingly, this works!)
						mov eax,3
						int 0x80

						add esi,9 ; first string goes in the buffer, second string starts in the buffer; after that...
						dec dword[count] ; byte variable!
						jne loop1

		;print message

						mov edx,len1
						mov ecx,msg1
						mov ebx,1
						mov eax,4
						int 0x80

		;print accepted numbers
		;initilaize counter
		
		;ReCall the string_to_int function to put result in eax again (Since eax was changed)
						
						mov esi,countlimit ; I don't know why this hasn't been overwritten.
						mov ecx,1
						call string_to_int
		
						mov dword[count],eax ; byte variable, again.
	
		loop2:
						mov edx,32 ; why 32?
						mov ecx,esi
						mov ebx,1
						mov eax,4
						int 0x80
		
						add esi,32 ; way past the end of our buffer!
                        ; at this point, we've printed all of the 4-number version, and don't really need to loop...
						dec dword[count]
						jnz loop2

		;system call to exit
	
						mov ebx,0
						mov eax,1
						int 0x80
