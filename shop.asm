.286
.model small
.stack 100h
.code
START:
	 ;mov AH , 00
	;mov AL ,10H
	;int 10H
	call Init 			
ReadKey:
	call ShowMainMenu	
	mov al, 25
	call ReadKeyProc
	  
	sub AL, 30h

	cmp AL,0
	jl ReadKey
	cmp AL,9
	jg ReadKey
	
	cmp AL, 1	
	 je ACTION_about
	 
	cmp AL, 2
	je ACTION_print 
	 
	cmp AL, 3	
	 je ACTION_add
	 
	cmp AL, 4		 
	 je ACTION_remove
	 
	cmp AL, 5	 
	 je ACTION_edit	
	 
	cmp AL, 0	
	 je EXIT	 
	 
jmp ReadKey

ACTION_about:
	call About
	jmp ReadKey

ACTION_print:
	call PrintItems
	jmp ReadKey
	
ACTION_add:
	call AddItem
	jmp ReadKey
	
ACTION_remove:
	call RemoveItem
	jmp ReadKey
	
ACTION_edit:
	call EditItem
	jmp ReadKey
	
EXIT:
	call Destr	

	mov AX, 4C00h
	INT 21h

include menu.asm
include Actions.asm
end start

