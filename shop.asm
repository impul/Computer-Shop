.model small
.stack 100h
.code
Start:	
	mov ax , @data
	mov ds , ax
StartMenu:
	call MainMenu
	
	mov AH, 00h
	INT 16h
			
	cmp AL,'0'
	jl StartMenu
	cmp AL,'9'
	jg StartMenu

	mov AX, 4C00h
	INT 21h
include IO.asm
include menu.asm

end start