.data
	SuccessfulOpening db 10,13, "File successful opening..",10,13,'$'
	CloseFileMessage db 10,13,"File successful saved and closed!..",'$'
	FileNotOpen db 10,13,"File not open..",'$'
	FileAlreadyOpen db 10, 13,"File already open..",'$'
	SaveFileMessage db 10,13,"File saved!..",'$'
	FileOpenErrorMessage db 10,13,"Unable to open (find) the file $"
	endl db 10,13,'$'
	
;=================================================================
	itemName db 20 dup (32),'$'
	itemPrice db 5 dup (32),'$'
	itemCount db 5 dup (32),'$'
	itemSize dw 30
.code

OpenFile:
	;
	; TODO : Open any file
	;
	cmp [FileIsOpen] , 0
	je FileNotOpened
	
	mov ah , 09H
	mov dx , offset FileAlreadyOpen
	int 21H
	jmp WeitKey
			
	FileNotOpened:
	mov ax , 3D02H
	mov dx , offset FileName
	int 21H

	jnc NOT_FileOpenError
	jmp FileOpenError
	NOT_FileOpenError:

	mov [FileHandle] , ax
	mov [FileIsOpen] , 1

	mov ah , 09H
	mov dx , offset SuccessfulOpening
	int 21H
			
	mov dx , [FileIsOpen]
	cmp dx , 1
	je LoadStruct

	mov ah , 09H
	mov dx , offset FileNotOpen
	int 21H

WeitKey:
	mov ah , 01H
	int 21H

	mov ax , 03H
	int 10h
jmp StartMenu
	;==============================
SaveFile:

	mov dx , [FileIsOpen]
	cmp dx , 1
	je SaveSileGood

	mov ah , 09H
	mov dx , offset FileNotOpen
	int 21H

	jmp WeitKey
SaveSileGood:
	mov ah , 3EH
	mov bx , [FileHandle]
	int 21H

	mov ax , 3D02H
	mov dx , offset FileName
	int 21H

	jc FileOpenError
	mov [FileHandle] , ax

	mov ah , 09H
	mov dx , offset SaveFileMessage
	int 21H

	jmp WeitKey
	
FileOpenError:
	mov AH, 09H
	mov DX , offset FileOpenErrorMessage
	int 21H
	jmp WeitKey
;==============================
CloseFile:s
	mov ax , 03H
	int 10h
	mov dx , [FileIsOpen]
	cmp dx , 1
	je YesFileOpen

	mov ah , 09H
	mov dx , offset FileNotOpen
	int 21H

	mov AH , 01H
	int 21H
	
	mov AX, 4C00h
	INT 21h

	YesFileOpen:
	mov ah , 3EH
	mov bx , [FileHandle]
	int 21H
	mov [FileIsOpen] , 0
	mov ah , 09H
	mov dx , offset CloseFileMessage
	int 21H
	
	mov AH , 01H
	int 21H
	
	mov AX, 4C00h
	INT 21h

LoadStruct:
	mov BX, vPhoneInd
	mov AX, itemSize
	mul BX
	mov DX, AX

	mov BX, FileHandle
	mov CX, 0
	mov AL, 0
	mov AH,42h
	INT 21h