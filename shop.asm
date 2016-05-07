.model small
.stack 100h
.386
.code

Start:	
	mov ax , @data
	mov ds , ax
	call OpenFiles
StartMenu:
	call MainMenu
	
	mov AH, 00h
	INT 16h
			
	cmp AL,'0'
	jl StartMenu
	cmp AL,'9'
	jg StartMenu
	
	cmp AL, '1'	
	 je ACTION_about	; 1- Вивід на екран "Про програму"

	cmp AL, '2'
	 je ACTION_stat		; 2- Вивід статистики
	 
	cmp AL, '3'
	 je ACTION_print	; 3- Виводимо на екран список телефонів
	 
	cmp AL, '4'
	 je ACTION_prev		; 4- Попередній запис
	 
	cmp AL, '5'
	 je ACTION_view		; 4- Запис під індексом
	 
	cmp AL, '6'
	 je ACTION_next		; 6- Наступний запис
	 
	cmp AL, '7'	
	 je ACTION_add		; 2- Форма добавлення нового телефону
	 
	cmp AL, '8'		 
	 je ACTION_remove	; 3- Видалення телефону
	 
	cmp AL, '9'	 
	 je ACTION_edit		; 4- Редагування даних про телефону
	 
	cmp AL, '0'	
	 je EXIT		 
	 
jmp StartMenu
	 
	ACTION_about:
	;call About
	jmp StartMenu
	
	ACTION_stat:
	;call PrintStat
	jmp StartMenu

	ACTION_print:
	;call PrintItems
	jmp StartMenu
	
	ACTION_prev:
	;call PrevItem
	jmp StartMenu
	
	ACTION_view:
	;call ViewItem
	jmp StartMenu
	
	ACTION_next:
	;call NextItem
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
	
	call CloseFiles
	
	mov AX, 4C00h
	INT 21h
	
include file.asm
include IO.asm
include menu.asm

end start