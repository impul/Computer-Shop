.model small
.stack 100h
.code
START:	


	mov AX, 4C00h
	INT 21h

include IO.asm
end start