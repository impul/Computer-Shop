.data
	FileHandle DW ?
	FileName db "Database",0
	ErrorOpenFile db "Can`t open database file!$"
.code
;===============================
;Відкриття файла
;===============================
OpenFiles PROC 
	mov AX , 3D02H
	mov DX, offset FileName	 
	INT 21h
	jc ErrorOpen
	mov FileHandle, AX
	ret
ErrorOpen:
	mov ah , 09H
	mov dx , offset ErrorOpenFile
	int 21H
	mov ah , 01 
	int 21H
	
	mov ah , 4CH
	int 21H
OpenFiles ENDP
;===============================
;Закриття файла
;===============================
CloseFiles PROC NEAR
	mov BX, FileHandle
	 mov AH, 3eh
	 int 21h
ret
CloseFiles ENDP