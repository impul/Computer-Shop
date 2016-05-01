.data
	FileHandle DW ?
	FileName db "Database",0
	FileHandleTMP DW ?
	FileNameTMP db "Database_tmp",0		
.code
;===============================
;Відкриття файла
;===============================
OpenFiles PROC 
	lea SI, FileName
	mov BX, 2			
	mov CX, 0		
	mov DX, 1	
	 mov AX, 716Ch	 	 
	 INT 21h
	jc createFile
mov FileHandle, AX
jmp createTMPfile
createFile:
	lea SI, FileName
	mov BX, 2		
	mov CX, 0		
	mov DX, 10h		
	 mov AX, 716Ch	 	 
	 INT 21h
	mov FileHandle, AX
	
createTMPfile:
	lea DX, FileNameTMP
	 mov AH,41h 
	 INT 21h

	lea SI, FileNameTMP
	mov BX, 2		
	mov CX, 0			
	mov DX, 10h		
	 mov AX, 716Ch	 	 
	 INT 21h
	mov FileHandleTMP, AX
	
ret
OpenFiles ENDP
;===============================
;Закриття файла
;===============================
CloseFiles PROC NEAR
	mov BX, FileHandle
	 mov AH, 3eh
	 int 21h
	mov BX, FileHandleTMP
	 mov AH, 3eh
	 int 21h	 
ret
CloseFiles ENDP