.data
	sLN db 13,10,'$'
	sSlash db '|$'
	sSpase db '   $'

	vFileHandle DW ?
	vFileName db 'Database.txt',0,'$'
	vFileHandleTMP DW ?
	vFileNameTMP db 'Temp.txt',0,'$'	
	vString db 28 dup (' ')
	vInt10	db 10 dup(' ')	
	vItemInd dw 0
	vItemsCNT	dw 0

	sEnterName		db 5 dup(32),'Name: $'
	sEnterModel		db 5 dup(32),'Model: $'
	sEnterYear		db 5 dup(32),'Year: $'
	sEnterPrice		db 5 dup(32),'Price: $'	
	
  mName 	db 28 dup(32),'$'
  mModel 	db 28 dup(32),'$'
  mYear		db 4 dup(32),'$'
  mPrice 	db 8 dup(32),'$'
  vStructSize dw 75
  vAllStruct  db 75 dup(?)
  
	EnterItemEdit db 10,13,'		Please enter ID to edit ->$'
	EnterItemNimer db 10,13,'		Please enter ID to remove ->$'
	RemoveItemErrorMessage db 10,13,'Please select correct ID!$'
	EnterItemErrorMessage db 10,13,'Please select correct ID!$'
	sPrintItems db '|ID |  Name                      |   Model                    |Year|  Price  |',10,13,'$'
	sMinus db '------------------------------------------------------------------------------',10,13,'$'
	sAddNewItem db 12 dup(32),'Add New Item! Type the parameters, please..$'	
	sEditExistsItem db 12 dup(32),'Edit exists Item! Type the parameters, please.. $'	
	NoItemInDataBaseMessage db 13,10,13,10,'         Sorry, Database is empty , add item to Database!$'	
	sDone	 db 13,10,'Done!$'
	sCanceled		 db 13,10,'Canceled!$'
	
	sEMopen db '***Error! Cannt open file!**',13,10,'$'
	sEMaxCNT DB	'***Error! Cannt add Item! There are to many Items!**',13,10,'$'
;=====================================================================
.code
Init PROC NEAR
	mov AX, @data
	mov DS, AX
	mov ES, AX

	call OpenFiles
	mov vItemInd,0

	mov AL, 2 
	mov CX, 0
	mov DX, 0
	mov BX, vFileHandle
	 mov AH, 42h
	 INT 21h	
	div vStructSize
	mov vItemsCNT, AX
ret
Init ENDP

Destr PROC NEAR
	call CloseFiles
ret
Destr ENDP

About PROC NEAR
	mov ax , 03H
	int 10h
	lea DX, TitleMenu
	call write
	lea DX, AboutMessage 
	call write
	lea DX , PressAnyKey
	call write
	mov ah, 01 
	int 21H
ret
About ENDP

PrintItems PROC NEAR

	cmp vItemsCNT , 0
	je NoShow
	mov ax , 03H
	int 10h
	
	lea DX , TitleMenu
	call write
	
	lea DX, sPrintItems
	call write
	lea DX , sMinus
	call write
	mov cx , vItemsCNT
	mov vItemInd, 0
StartShow:
	push CX
	call ShowItem
	inc vItemInd
	pop CX
	loop StartShow
	
	lea DX , sMinus
	call write
	
	lea DX , PressAnyKey
	call write
	mov ah , 01H
	int 21H
ret
NoShow:
	lea dx , NoItemInDataBaseMessage
	call write
	mov ah , 01H
	int 21H
ret
PrintItems ENDP

AddItem PROC NEAR
	mov ax , 03H
	int 10h	
	lea DX , TitleMenu
	call write
	
	lea DX, sAddNewItem
	call writeln
	
	cmp vItemsCNT,12
	jg MaxCNT
	mov AX, vItemsCNT
	mov vItemIND, AX
	call AddEditItem
ret
MaxCNT:
	lea DX, sEMaxCNT
	call writeln
ret
AddItem ENDP

RemoveItem PROC NEAR
  cmp vItemsCNT , 0
	je NoShow
	mov ax , 03H
	int 10h
	
	lea DX , TitleMenu
	call write
	
	lea DX, sPrintItems
	call write
	
	lea DX , sMinus
	call write
	
	mov cx , vItemsCNT
	mov vItemInd, 0
StartShowRemove:
	push CX
	call ShowItem
	inc vItemInd
	pop CX
	loop StartShowRemove
	
	lea DX , sMinus
	call write
	
	lea DX , EnterItemNimer
	call write
	call ReadInt
	
	mov vItemIND , AX
	cmp AX , vItemsCNT
	jnb RemoveItemError
	
mov BX, vFileHandle
	mov AL, 0
	xor DX,DX
	xor CX,CX
	 mov AH, 42h
	 INT 21h

xor SI, SI
mov CX, vItemsCNT
CopyCycle1:
	push CX
	;COPY
	mov CX, vStructSize
	mov BX, vFileHandle
	lea DX, vAllStruct
	 mov AH, 3fh
	 INT 21h

	cmp SI, vItemInd	
	je nextPh	
	
	mov CX, AX
	mov BX, vFileHandleTMP
	lea DX, vAllStruct
	 mov AH, 40h
	 INT 21h	

	nextPh:
	INC SI
	pop CX
loop CopyCycle1
	mov BX, vFileHandle
	mov AH, 3eh
	int 21h
	lea DX, vFileName
	mov AH,41h 
	int 21H
	 
	mov DX, offset vFileNameTMP
	mov DI, offset vFileName
	 mov AH, 56h
	 INT 21h
	call CloseFiles
	call OpenFiles
	DEC vItemsCNT
	lea DX, sDone
	call write	
ret
RemoveItemError:
	lea dx , NoItemInDataBaseMessage
	call write
	mov ah , 01H
	int 21H
ret
RemoveItem ENDP 

EditItem PROC NEAR
 cmp vItemsCNT , 0
	je NoShowEdit

	mov ax , 03H
	int 10h
	
	lea DX , TitleMenu
	call write
	
	lea DX, sPrintItems
	call write
	
	lea DX , sMinus
	call write
	
	mov cx , vItemsCNT
	mov vItemInd, 0
StartShowEdit:
	push CX
	call ShowItem
	inc vItemInd
	pop CX
	loop StartShowEdit
	
	lea DX , sMinus
	call write
	
	lea DX, sEditExistsItem
	call writeln
	
	lea DX , EnterItemEdit
	call write
	call ReadInt
	cmp AX , vItemsCNT
	jnb EnterItemError
	
	lea DX, sLN
	call write
	
	mov vItemIND, AX
	
	call AddEditItem
	DEC vItemsCNT
ret
EnterItemError:
	lea DX , EnterItemErrorMessage
	call writeln
	mov ah , 01H
	int 21H
ret

NoShowEdit:
	lea dx , NoItemInDataBaseMessage
	call write
	mov ah , 01H
	int 21H
ret

EditItem ENDP

ShowItem PROC NEAR
	push vItemIND
	call ReadItem
PrtPh:
	lea DX , sSlash
	call write
	
	pop vItemIND
	mov AX, vItemIND
	call PrintID

	lea DX , sSlash
	call write
	lea DX, mName	
	call write
;	 
	lea DX , sSlash
	call write
	lea DX, mModel
	call write	
;	 
	lea DX , sSlash
	call write
	lea DX, mYear
	call write		 
;	 
	lea DX , sSlash
	call write
	lea DX, mPrice
	call write
	
	mov ah , 02H
	mov dl , 24H
	int 21H
	
	lea DX , sSlash
	call writeln
	
ret
ShowItem ENDP

AddEditItem PROC NEAR

	lea DX, sEnterName
	call write

	call ReadString
	cmp ax,0
	jne NotCanceled
	
	lea DX, sCanceled
	call write	
ret
NotCanceled:

	xor SI, SI
	mov CX,28	
To_mName:	
	mov AL,vString[SI]
	mov mName[SI],AL
	INC SI
loop To_mName

	lea DX, sLN
	call write
	lea DX, sEnterModel
	 call write
	 
	 call ReadString
	 
	xor SI, SI
	mov CX,28
To_mModel:	
	mov AL,vString[SI]
	mov mModel[SI],AL
	INC SI
loop To_mModel

	lea DX, sLN
	call write
	lea DX, sEnterYear
	 call write
	 
	 mov AX,4
	 call ReadInt10
	 
	xor SI, SI
	mov CX,4
To_mYear:	
	mov AL,vInt10[SI]
	mov mYear[SI],AL
	INC SI
loop To_mYear

	lea DX, sLN
	call write
	lea DX, sEnterPrice
	 call write
	 
	 mov AX,5
	 call ReadInt10

	xor SI, SI
	mov CX,5
To_mPrice:	
	mov AL,vInt10[SI]
	mov mPrice[SI],AL
	INC SI
loop To_mPrice
	
	call WriteItem
	
	INC vItemsCNT
	lea DX, sDone
	call write
ret
AddEditItem ENDP 

ReadString PROC NEAR

	xor SI, SI
	mov CX,28
zanulStr28:	
	mov vString[SI],' '
	INC SI
loop zanulStr28
	xor SI, SI
readChar:
	call ReadKeyProc	
	 
	cmp AL, 8
	je BackSlash
	cmp AL, 13				
	je returnStr28
	cmp AL, 32				
	jl readChar
	cmp AL, 122
	jg readChar
	 
	cmp SI, 28
	jge readChar
	
	mov DL, AL
	mov AH,2h
	INT 21h
	
	mov vString[SI], AL	
	INC SI	
	jmp readChar
returnStr28:
	mov AX, SI
ret
BackSlash:
	cmp SI,0
	je readChar
	
	mov vString[SI],32
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

jmp readChar
ReadString ENDP 

ReadInt10 PROC NEAR
	xor SI, SI
	push AX 	
	mov CX, 10
zanulInt10:	
	mov vInt10[SI],' '
	INC SI
loop zanulInt10
	xor SI, SI
mReadInt:
	call ReadKeyProc
	 
	cmp AL, 8
	je BackSlashI
	cmp AL, 13				
	je returnInt10
	cmp AL, 30h			
	jl mReadInt
	cmp AL, 39h
	jg mReadInt
	 
	pop BX
	push BX
	cmp SI, BX				
	jge mReadInt	
	
	mov DL, AL
	mov AH,2h
	INT 21h
	
	mov vInt10[SI], AL
	INC SI	
	jmp mReadInt
returnInt10:
	mov AX, SI
	pop SI
ret
BackSlashI:
	cmp SI,0
	je mReadInt
	
	mov vInt10[SI],32
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

jmp mReadInt
ReadInt10 ENDP 

OpenFiles PROC NEAR
	lea SI, vFileName
	mov BX, 2		
	mov CX, 0	
	mov DX, 1			
	 mov AX, 716Ch	 	 
	 INT 21h
	jc createFile
mov vFileHandle, AX
jmp createTMPfile
createFile: 
	lea SI, vFileName
	mov BX, 2		
	mov CX, 0		
	mov DX, 10h			
	 mov AX, 716Ch	 	 
	 INT 21h
	mov vFileHandle, AX
	
createTMPfile:
	lea DX, vFileNameTMP
	 mov AH,41h 
	 INT 21h

	lea SI, vFileNameTMP
	mov BX, 2			
	mov CX, 0			
	mov DX, 10h	
	 mov AX, 716Ch	 	 
	 INT 21h
	mov vFileHandleTMP, AX
	
ret
OpenFiles ENDP

CloseFiles PROC NEAR
	mov BX, vFileHandle
	 mov AH, 3eh
	 int 21h
	mov BX, vFileHandleTMP
	 mov AH, 3eh
	 int 21h	 
	mov DX, offset vFileNameTMP
	 mov AH,41h 
	 INT 21h
ret
CloseFiles ENDP
	 
ReadItem PROC NEAR
mov BX, vItemInd
mov AX, vStructSize
mul BX
mov DX, AX

mov BX, vFileHandle
mov CX, 0
mov AL, 0
 mov AH,42h
 INT 21h
 
	mov AL, 1
	mov CX, 0	
	mov DX, 1
	mov AH, 42h
	INT 21h
	
	mov CX, 28
	mov BX, vFileHandle
	lea DX, mName
	 mov AH, 3fh
	 INT 21h
	 
	mov AL, 1
	mov CX, 0	
	mov DX, 1
	 mov AH, 42h
	 INT 21h
	 

	mov CX, 28
	mov BX, vFileHandle
	lea DX, mModel
	 mov AH, 3fh
	 INT 21h

	mov AL, 1
	mov CX, 0	
	mov DX, 1
	 mov AH, 42h
	 INT 21h

	mov CX, 4
	mov BX, vFileHandle
	lea DX, mYear
	 mov AH, 3fh
	 INT 21h

	mov AL, 1
	mov CX, 0	
	mov DX, 1
	 mov AH, 42h
	 INT 21h

	mov CX, 8
	mov BX, vFileHandle
	lea DX, mPrice
	 mov AH, 3fh
	 INT 21h 	 
	push AX
	
	mov AL, 1
	mov CX, 0	
	mov DX, 1
	mov AH, 42h
	INT 21h
	
	mov AL, 1
	mov CX, 0	
	mov DX, 2	
	mov AH, 42h
	INT 21h		 
	 
	pop AX
ret
ReadItem ENDP

WriteItem PROC NEAR

	mov AX, vStructSize
	mul vItemInd
	mov DX, AX
	
	mov AL, 0	
	mov CX, 0
	mov BX, vFileHandle
	 mov AH, 42h
	 INT 21h	
	
	mov CX, 1
	mov BX, vFileHandle
	lea DX, sSlash
	mov AH, 40h
	INT 21h
	
	mov CX, 28
	mov BX, vFileHandle
	lea DX, mName
	 mov AH, 40h
	 INT 21h
	
	mov CX, 1	
	mov BX, vFileHandle
	lea DX, sSlash
	 mov AH, 40h
	 INT 21h
	
	mov CX, 28
	mov BX, vFileHandle
	lea DX, mModel
	 mov AH, 40h
	 INT 21h

	mov CX, 1	
	mov BX, vFileHandle
	lea DX, sSlash
	 mov AH, 40h
	 INT 21h
	
	mov CX, 4
	mov BX, vFileHandle
	lea DX, mYear
	 mov AH, 40h
	 INT 21h

	mov CX, 1
	mov BX, vFileHandle
	lea DX, sSlash
	 mov AH, 40h
	 INT 21h
	 
	mov CX, 8
	mov BX, vFileHandle
	lea DX, mPrice
	mov AH, 40h
	INT 21h
	
	mov CX, 1	
	mov BX, vFileHandle
	lea DX, sSlash
	mov AH, 40h
	INT 21h
	
	mov CX, 2	
	mov BX, vFileHandle
	lea DX, sLN
	 mov AH, 40h
	 INT 21h	 
ret
WriteItem ENDP
