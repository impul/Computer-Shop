.model small
.stack 100h
.386
.data
	FileIsOpen dw 0
	FileHandle DW ?
	FileName db "Database",0
.code
	mov ax , @data
	mov ds , ax
	jmp OpenFile
	call Init
Start:	
	
StartMenu:
	call MainMenu
	
	mov AH, 00h
	INT 16h

	cmp AL,'0'
	jl StartMenu
	cmp AL,'9'
	jg StartMenu
	
	cmp AL, '1'	
	je ACTION_about 

	cmp AL, '2'	
	je ACTION_print 

	cmp AL, '3'		
	je ACTION_add 

	cmp AL, '4'		
	je ACTION_remove
	
	cmp AL, '5'	
	je ACTION_edit
 
	cmp AL, '0'	
	je EXIT		 

jmp StartMenu
	
	ACTION_about:
	call About
	jmp StartMenu
	
	ACTION_print:
	;call PrintItems
	jmp StartMenu
	
	ACTION_add:
	;call AddItem
	jmp StartMenu
	
	ACTION_remove:
	;call RemoveItem
	jmp StartMenu
	
	ACTION_edit:
	;call EditItem
	jmp StartMenu

	
	
EXIT:
	jmp CloseFile
	
include file.asm
include Actions.asm
include menu.asm
include IO.asm


end start