.data
	Buffer db 80 dup(?)   
	ID db 4 dup (32)
	PressAnyKey db '			  Press any key..$'
	TitleMenu db '==============================================================================', 10, 13, '|	   	  	Computer shop database:			  	     |', 10,13,'==============================================================================',10,13,'$'
	StartMenu db '			[1]. About this program', 13, 10,'			[2]. Print items', 13, 10, '			[3]. Add new item', 13, 10, '			[4]. Remove item', 13, 10, '			[5]. Edit exists item', 13, 10, '			[0]. Exit',13,10,10,13,'	Enter numer ->','$'	
    AboutMessage db 10,13,'			______________________________',10,13,'			|   Computer Shop Database   |',10,13,'			|   Created by Boiko Pavlo   |',10,13,'			|          KSM 2016          |',10,13,'			==============================',10,13,10,13,'$'
.code 

ShowMainMenu PROC NEAR
	mov ax , 03H
	int 10h	
	lea DX , TitleMenu
	call write
	lea DX, StartMenu
	call write
ret 
ShowMainMenu ENDP

ReadKeyProc PROC NEAR
	 mov AH, 00h
	 INT 16h
ret 
ReadKeyProc ENDP 

 write PROC NEAR
   push AX
	mov AH, 09h
	INT 21h
   pop AX
ret
write ENDP

 writeln PROC NEAR
   push AX
   push DX
	mov AH, 09h
	 INT 21h
	lea DX, sLN
	 INT 21h	
   pop DX
   pop AX
ret
writeln ENDP

WriteInt PROC NEAR;(AX)
	mov si,0
	mov cx,25
zanul:
	mov Buffer[si],0
	add si,1
	loop zanul
	mov si,0
	mov cx,10
dill:
	cmp ax,10
	jl last
	xor dx,dx
	div cx 		
	xchg ax,dx 	
	add al,'0' 
	mov Buffer[si],al
	add si,1
	xchg ax,dx
	cmp ax,10
	jge dill
last:
	add al,'0'
	mov Buffer[si],al
	add si,1

	mov si,24
	mov cx,25
vuv:
	cmp Buffer[si],0
	jne cifr

	sub si,1
	loop vuv
cifr:
	mov dl,Buffer[si]
	mov ah,02h
	int 21h
	sub si,1
	loop vuv
ret
WriteInt ENDP

ReadInt PROC NEAR
		
	xor AX, AX
	xor BX, BX
	xor CX, CX
	xor DX, DX
	
	call ReadString
	
	StrToIntLoop:
			mov cx,ax 
			mov si,0
			xor AX,AX 

	cycle: 
		mov bL, vString(si)
		sub bL,30h
		add AX,BX
		add si,1
		cmp cx,1
		jne mnoj

			
	ret
	 mnoj:
			mov BL,10
			mul BL
	loop cycle
ret
ReadInt ENDP

ConvertYear PROC NEAR
; int(mYear) -> AX
	push dx bx
	mov bl,10	
	
	mov al, mYear[3]
	sub al, 30h
	mov dx, ax

	xor ax,ax
	mov al, mYear[2]
	sub al, 30h
	mul bl
	add dx,ax
	
	xor ax,ax
	mov al, mYear[1]
	sub al, 30h
	mul bl
	mul bl
	add dx,ax
	
	xor ax,ax
	mov al, mYear[0]
	sub al, 30h
	mul bl
	mul bl
	mul bl
	add AX,dx
	
	pop bx dx
ret
ConvertYear ENDP

PrintID proc
	push AX
	call WriteInt
	pop AX
	cmp AX , 100
	jnb PrintIDEnd
	cmp AX , 10
	jnb PrintIDNotEnd
	mov dl ,32
	mov ah , 02h
	int 21h
	PrintIDNotEnd:
	mov dl, 32
	mov ah , 02h
	int 21h
	PrintIDEnd:
ret
PrintID endp