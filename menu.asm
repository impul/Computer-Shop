.data
	MainMenuMessage db '===============================================================================',10,13,'			     Computer shop database:', 10,13,'===============================================================================',10,13,'			[1]. About this program', 13, 10, '			[2]. Print statistic', 13, 10, '			[3]. Print items', 13, 10, '			[4]. Prev item', 13, 10, '			[5]. Search by model', 13, 10, '			[6]. Next item', 13, 10, '			[7]. Add new item', 13, 10, '			[8]. Remove item', 13, 10, '			[9]. Edit exists item', 13, 10, '			[0]. Exit',13,10,10,13,'	Enter numer ->','$'	
	
.code

MainMenu proc
		mov ax , 03H
		int 10h		
			
		mov dx , offset MainMenuMessage
		mov ah , 09H
		int 21H
ret			
MainMenu endp


END