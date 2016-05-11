.data
;==================================
	itemIdentificator db ?
	itemsCount dw 0
	AboutMessage db 10,13,'			______________________________',10,13,'			|   Computer Shop Database   |',10,13,'			|   Created by Boiko Pavlo   |',10,13,'			|          KSM 2016          |',10,13,'			==============================',10,13,10,13,'			  Press any key..$'
.code 

About proc
	mov ax , 03H
	int 10h
	mov AH, 09H
	mov DX, offset AboutMessage 
	int 21H
	mov ah, 01 
	int 21H
	ret
About endp

Init proc
	mov itemIdentificator, 0

	mov AL, 2	; зсув щодо кінця файла
	mov CX, 0
	mov DX, 0
	mov BX, FileHandle
	mov AH, 42h
	INT 21h	
	div itemSize
	mov itemsCount, AX
Init endp

PrintItems proc
	
PrintItems endp

