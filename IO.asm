.data
Inputbuff db 80 dup(?)
String20 db 20 dup (' ')
Int10 db 10 dup(' ')
NewLine db 10,13,'$'	
.code
;=========================
;Читання нажатої клавіші
;=========================	 
ReadKey PROC NEAR
	 mov AH, 00h
	 INT 16h
ret 
ReadKey ENDP 
;=========================
;Вивід рядка на екран
;=========================	 
writeString PROC NEAR
   push AX
	mov AH, 09h
	INT 21h
   pop AX
ret
writeString ENDP
;=========================
;Введення стрічки в буфер
;=========================	 
ReadString20 PROC NEAR;
	xor SI, SI
	mov CX,20
nullStr20:	
	mov String20[SI],' '
	INC SI
loop nullStr20
	xor SI, SI
read:
	call ReadKey
	 
	cmp AL, 8
	je BackSpace
	cmp AL, 13
	je returnStr20
	cmp AL, 32				
	jl read
	cmp AL, 122
	jg read
	 
	cmp SI, 20			
	jge read	
	
	mov DL, AL
	mov AH,2h
	INT 21h
	
	mov String20[SI], AL
	INC SI	
	jmp read
returnStr20:
	mov AX, SI
ret
BackSpace:
	cmp SI,0
	je read
	
	mov String20[SI],32
	dec SI	
	mov   bh, 0   
	mov   ah, 3
	int   10h
	dec DL
	mov   bh, 0 
	mov   ah, 2
	int   10h
	 
	mov  al, ' '    
	mov  bh,0      
	mov  cx,1       
	mov  ah, 0Ah
	int  10h

jmp read
ReadString20 ENDP 
;=========================
;Введення цілого
;=========================	 
ReadInt10 PROC NEAR
	xor SI, SI
	push AX
	mov CX, 10
nullInt10:	
	mov Int10[SI],' '
	INC SI
loop nullInt10
	xor SI, SI
ReadIntKey:
	call ReadKey
	 
	cmp AL, 8
	je BackSpaceI
	cmp AL, 13				
	je returnInt10
	cmp AL, 30h				
	jl ReadIntKey
	cmp AL, 39h
	jg ReadIntKey
	 
	pop BX
	push BX
	cmp SI, BX
	jge ReadIntKey
	
	mov DL, AL
	mov AH,2h
	INT 21h
	
	mov Int10[SI], AL
	INC SI	
	jmp ReadIntKey
returnInt10:
	mov AX, SI
	pop SI
ret
BackSpaceI:
	cmp SI,0
	je ReadIntKey
	
	mov Int10[SI],32
	dec SI	
	mov   bh, 0   
	mov   ah, 3	
	int   10h
dec DL
	mov   bh, 0    
	mov   ah, 2
	int   10h
	 
	mov  al, ' '     
	mov  bh,0       
	mov  cx,1       
	mov  ah, 0Ah
	int  10h

jmp ReadIntKey
ReadInt10 ENDP 
;=========================
;Виведення рядка + ентер
;=========================	 
writeln PROC NEAR
   push AX
   push DX
	mov AH, 09h
	 INT 21h
	lea DX, NewLine
	 INT 21h	
   pop DX
   pop AX
ret
writeln ENDP
;Read int to ax
WriteInt PROC NEAR
	mov si,0
	mov cx,25
zanul:
	mov Inputbuff[si],0
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
	mov Inputbuff[si],al
	add si,1
	xchg ax,dx
	cmp ax,10
	jge dill
last:
	add al,'0'
	mov Inputbuff[si],al
	add si,1

	mov si,24
	mov cx,25
vuv:
	cmp Inputbuff[si],0
	jne cifr

	sub si,1
	loop vuv
cifr:
	mov dl,Inputbuff[si]
	mov ah,02h
	int 21h
	sub si,1
	loop vuv
ret
WriteInt ENDP
;=========================
;Читання числа з клавіатури
;=========================	 
ReadInt PROC NEAR
		
	xor AX, AX
	xor BX, BX
	xor CX, CX
	xor DX, DX
	
	call ReadString20
	
	StrToIntLoop:
			mov cx,ax 
			mov si,0
			xor AX,AX

	cycle: 
		mov bL, String20(si)
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
ReadInt ENDP


