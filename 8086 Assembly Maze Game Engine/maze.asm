; Ori Maimon, 216383174
; Natan Krombein, 341004471





.model small

; Define the constants:
N_rows EQU 25d
N_columns EQU 80d

GameName_row EQU 1d
GameName_col EQU 35d


.stack 400h
.data
	;data for the openingScreen:
	GameName db 'Beepers Maze', 0
	Instruc1 db 'Hello! In our game, the goal of our hero - beeper, is to get out of the maze.   But it wont be that easy. Beeper is followed by an evil enemy - bopper, who     wants to get his hands on our hero.', 0
	Instruc2 db 'Beeper moves using the arrows. Every time beeper change to green you have to    tap the direction you want to move.', 0
	Instruc3 db 'Note that every time you are not fast enough, Bopper takes another step         closer to our hero. ', 0
	Instruc4 db 'Be careful not to let bopper get too close. He may use his invisibility         cloak!', 0
	Instruc5 db 'Help beeper get out of the maze in as little steps without getting caught!', 0
	Instruc6 db 'Press on space to start your journey. Good luck!', 0
	
	
	;data for the maze:
	beeperPos dw 2000
    oldBeeperPos dw 0
    bopperPos dw 1994
    oldBopperPos dw 0
    moveMemory db 04h, 04h, 04h, 00h
    mazeWallHorizontal dw 1346,1368,1670,1678,1682,1684,1830,1832,2150,2152,2310,2320,2626,2638,2640,2648
    mazeWallVertical dw 1346,2786,1680,2000,2160,2800,1684,2484,1368,2808
	
	;data for reflections:
	bad db 'Bad!', 0
	good db 'Good job!', 0
	wow db 'WOW!', 0
	amazing db 'Amazing!', 0

	
	;data for the winScreen:
	youWon db 'YOU WON!', 0
	decripWon db 'You won! Thanks to you our hero was saved :)', 0
	
	;data for the lostScreen:
	youLost db 'YOU LOST!', 0
	decripLost db 'You lost! Our hero is now suffering at the hands of bopper :(', 0
	numStepsUnits db 0
	numStepsTens db 0
	msg db 'It',20h,'took',20h,20h,20h,20h,'steps',20h,'for',20h,'Beeper',20h,'to',20h,'escape','$'
	
.code

START:
	; Initializing data segment
	mov ax, @data
	mov ds, ax
	
	; Setting extra segment to screen memory
	mov ax, 0b800h
	mov es, ax
	
	; Calling to a function that make all the screen black
	call clearScreen
	
	; Calling to a function that print the opening screen
	call openingScreen
	
	
	; The program is caused to be delayed, and the ruling is waiting to press the keyboard
OS:	mov ah, 01h
	int 21h
	
	; Now the character received is in register AL.
	mov bh, 20h
	cmp al, bh ; Checks if the character that been received is 'A'.
	jnz OS ; If not - remain at openingScreen. Else - continu.
	
	; Reprogram interrupts so they are not taken by the OS
    in al, 21h
    or al, 02h
    out 21h, al
	


    call clearScreen
    call printMaze
    mov ax, 0
	mov cx, 0
    call printCharacter
    mov ax, 1
    call printCharacter
	
gameLoop:

	mov ax, 1
    call printCharacter
	
	;Make beeper yellow:
	mov ax, 0;+
	mov cx, 0;+
	call printCharacter;+

	
	; Save the seconds in al, and the target time in dl.
	mov al, 00h;+
	out 70h, al;+
	;Reading the second through port 71h
	in al, 71h;+
	xor dx, dx
	mov dl, al;+
	
	;Since dl is in BCD format we need to add 2 carfully
	mov dh, dl
	and dh, 00001111b
	cmp dh, 8d
	jz L8
	cmp dh, 9d
	jz L9
	add dl, 0000010b
	jmp LOtherWize
L8:	;if dl=????1000 so:
	and dl, 11110000b
	add dl, 00010000b
	jmp LOtherWize
	
L9:	;if dl=????1001 so:
	and dl, 11110000b
	add dl, 00010001b
	jmp LOtherWize

LOtherWize:
	mov dh, dl
	and dh, 11110000b
	cmp dh, 01100000b
	jb LFinal
	and dl, 00001111b
	
LFinal:
		
		
delayLoop:	
	
	xor ax, ax
	in al, 64h ; get LSB
	test al, 01h ; Check if pressed
	jz afterPress
	in al, 60h ; get input
	
afterPress:
	;Sending a request code for a second via port 70h
	mov al, 00h
	out 70h, al
	;Reading the second through port 71h
	in al, 71h
	cmp al, dl
	jne delayLoop ; If we passed bh seconds we exit the loop. 
	
	
	; Make beeper green:
	mov ax, 0;+
	mov cx, 1;+
	call printCharacter;+

	xor ax, ax
	xor dx, dx
	; Save the seconds in al, and the target time in dl.
	mov al, 00h;+
	out 70h, al;+
	;Reading the second through port 71h
	in al, 71h;+
	mov dl, al;+
	
	;Since dl is in BCD format we need to add 1 cerfully
	mov dh, dl
	and dh, 00001111b
	cmp dh, 9d
	jz L9_1S
	add dl, 0000001b
	jmp LOtherWize_1S
	
L9_1S:	;if dl=????1001 so:
	and dl, 11110000b
	add dl, 00010000b
	jmp LOtherWize_1S

LOtherWize_1S:
	mov dh, dl
	and dh, 11110000b
	cmp dh, 01100000b
	jb LFinal_1S
	and dl, 00001111b
	
LFinal_1S:
	
	
    call readKeyboard

	;update number of steps
    mov bx, offset numStepsUnits
    mov si, offset numStepsTens
	push cx
	push dx
	xor cx ,cx
	xor dx, dx
	mov cl, ds:[bx]
	mov dl, ds:[si]
	cmp cl,9
	jz nextTen
	inc cl
	jmp updatedSteps
nextTen:
	inc dl
	mov cl,0
updatedSteps:
	mov ds:[bx],cl
	mov ds:[si],dl
	pop dx
	pop cx

	xor bx, bx 
	xor si, si
	
    mov bx, offset beeperPos
    mov si, offset bopperPos
    mov bx, ds:[bx]
    mov si, ds:[si]
    cmp bx,si
    jz lose
    cmp bx,2798
    jz win
    call moveBopper
	

    mov bx, offset beeperPos
    mov si, offset bopperPos
    mov bx, ds:[bx]
    mov si, ds:[si]
    cmp bx,si
	jz lose
    jmp gameLoop

lose:
    mov ax, 1
    call clearScreen
	call lostScreen
    jmp quit
win:
    ;Insert when won
	call clearScreen
	call winScreen
	call printSteps
    jmp quit
quit:
    ; Return interrupts to OS
    in al, 21h
    and al, 0FDh
    out 21h, al
	;Until here.
	
	
	; Calling for commands to end the program
	mov ax, 4c00h
	int 21h

	
	
	
	
	
	



	; The code of the openingScreen function:
	; This function is responsible when called to print on the screen the name of the game and the instructions
	openingScreen proc uses ax bx cx

		;printing the Game Name:----------------------------------
		;load the pointer of "GameName" to si
		lea si, GameName
		
		;For the title - black background, yellow font color
		mov ah, 0Eh ;black background, yellow foreground
		
		;The place we want to start write the title
		mov bx, (0A0h + GameName_col * 2d + GameName_row * 160d)
		
		write_GameName_loop:
			;Load the next character of 'title' to AL
			lodsb ;Load byte at DS:SI into AL, and increment SI
			
			;Check if we been reached to the NULL character
			cmp al, 0
			jz break_GameName
		
			;Print to the screen the current character
			mov es:[bx], ax
			
			;Next time print in the next pixel
			add bx, 2d
		
		jmp write_GameName_loop
		
	break_GameName:
	
	
		;printing the first section of the instructions:----------------------------------
		;load the pointer of "Instruc1" to si
		lea si, Instruc1
		
		;For the instructions - black background, white font color
		mov ah, 0Fh ;black background, yellow foreground
		
		;The place we want to start write the Instruc1
		mov bx, (0A0h + 4d + (GameName_row + 2d) * 160d)
		
		write_Instruc1_loop:
			;Load the next character of 'Instruc1' to AL
			lodsb ;Load byte at DS:SI into AL, and increment SI
			
			;Check if we been reached to the NULL character
			cmp al, 0
			jz break_Instruc1
		
			;Print to the screen the current character
			mov es:[bx], ax
			
			;Next time print in the next pixel
			add bx, 2d
		
		jmp write_Instruc1_loop
		
	break_Instruc1:
	
	
		;printing the second section of the instructions:----------------------------------
		;load the pointer of "Instruc2" to si
		lea si, Instruc2
	
		
		;The place we want to start write the Instruc2
		mov bx, (0A0h + 4d + (GameName_row + 6d) * 160d)
		
		write_Instruc2_loop:
			;Load the next character of 'Instruc2' to AL
			lodsb ;Load byte at DS:SI into AL, and increment SI
			
			;Check if we been reached to the NULL character
			cmp al, 0
			jz break_Instruc2
		
			;Print to the screen the current character
			mov es:[bx], ax
			
			;Next time print in the next pixel
			add bx, 2d
		
		jmp write_Instruc2_loop
		
	break_Instruc2:
	
		;printing the third section of the instructions:----------------------------------
		;load the pointer of "Instruc3" to si
		lea si, Instruc3
	
		
		;The place we want to start write the Instruc2
		mov bx, (0A0h + 4d + (GameName_row + 8d) * 160d)
		
		write_Instruc3_loop:
			;Load the next character of 'Instruc3' to AL
			lodsb ;Load byte at DS:SI into AL, and increment SI
			
			;Check if we been reached to the NULL character
			cmp al, 0
			jz break_Instruc3
		
			;Print to the screen the current character
			mov es:[bx], ax
			
			;Next time print in the next pixel
			add bx, 2d
		
		jmp write_Instruc3_loop
		
	break_Instruc3:
	
		;printing the fourth section of the instructions:----------------------------------
		;load the pointer of "Instruc4" to si
		lea si, Instruc4
	
		
		;The place we want to start write the Instruc4
		mov bx, (0A0h + 4d + (GameName_row + 10d) * 160d)
		
		write_Instruc4_loop:
			;Load the next character of 'Instruc4' to AL
			lodsb ;Load byte at DS:SI into AL, and increment SI
			
			;Check if we been reached to the NULL character
			cmp al, 0
			jz break_Instruc4
		
			;Print to the screen the current character
			mov es:[bx], ax
			
			;Next time print in the next pixel
			add bx, 2d
		
		jmp write_Instruc4_loop
	break_Instruc4:	
	
		;printing the fifth section of the instructions:----------------------------------
		;load the pointer of "Instruc5" to si
		lea si, Instruc5
	
		
		;The place we want to start write the Instruc5
		mov bx, (0A0h + 4d + (GameName_row + 13d) * 160d)
		
		write_Instruc5_loop:
			;Load the next character of 'Instruc5' to AL
			lodsb ;Load byte at DS:SI into AL, and increment SI
			
			;Check if we been reached to the NULL character
			cmp al, 0
			jz break_Instruc5
		
			;Print to the screen the current character
			mov es:[bx], ax
			
			;Next time print in the next pixel
			add bx, 2d
		
		jmp write_Instruc5_loop
		
	break_Instruc5:
	
		;printing the sixth section of the instructions:----------------------------------
		;load the pointer of "Instruc6" to si
		lea si, Instruc6
	
		
		;The place we want to start write the Instruc6
		mov bx, (0A0h + 4d + (GameName_row + 16d) * 160d)
		
		write_Instruc6_loop:
			;Load the next character of 'Instruc6' to AL
			lodsb ;Load byte at DS:SI into AL, and increment SI
			
			;Check if we been reached to the NULL character
			cmp al, 0
			jz break_Instruc6
		
			;Print to the screen the current character
			mov es:[bx], ax
			
			;Next time print in the next pixel
			add bx, 2d
		
		jmp write_Instruc6_loop
		
	break_Instruc6:
	
		ret
	openingScreen endp

	; The code of the winScreen function:
	; This function is responsible when called to print on the screen the name of the game and the instructions
	winScreen proc uses ax bx cx
		
		;printing the "YOU WON!":----------------------------------
		;load the pointer of "youWon" to si
		lea si, youWon
		
		;For the title - black background, yellow font color
		mov ah, 0Eh ;black background, yellow foreground
		
		;The place we want to start write the title
		mov bx, (0A0h + (GameName_col + 3d)* 2d + GameName_row * 160d)
		
		write_youWon_loop:
			;Load the next character of 'youWon' to AL
			lodsb ;Load byte at DS:SI into AL, and increment SI
			
			;Check if we been reached to the NULL character
			cmp al, 0
			jz break_youWon
		
			;Print to the screen the current character
			mov es:[bx], ax
			
			;Next time print in the next pixel
			add bx, 2d
		
		jmp write_youWon_loop
		
	break_youWon:
	
	
		;load the pointer of "decripWon" to si
		lea si, decripWon
		
		;For the decription - black background, white font color
		mov ah, 0Eh ;black background, yellow foreground
		
		;The place we want to start write the decripWon
		mov bx, (0A0h + 4d + (GameName_row + 2d) * 160d)
		
		write_decripWon_loop:
			;Load the next character of 'decripWon' to AL
			lodsb ;Load byte at DS:SI into AL, and increment SI
			
			;Check if we been reached to the NULL character
			cmp al, 0
			jz break_decripWon
		
			;Print to the screen the current character
			mov es:[bx], ax
			
			;Next time print in the next pixel
			add bx, 2d
		
		jmp write_decripWon_loop
		
	break_decripWon:
	
		ret
	winScreen endp

	printSteps proc uses ax bx dx di si
		mov bx, offset msg
		mov di, offset numStepsTens
    	mov si, offset numStepsUnits
		xor ax,ax
		xor dx,dx
		mov al, ds:[di]
    	mov dl, ds:[si]
    	add al, 48
    	add dl, 48
    	mov ds:[bx+8],al
    	mov ds:[bx+9],dl
    	mov dx, offset msg
    	mov ah, 9
    	int 21h
		ret
	printSteps endp

	; The code of the lostScreen function:
	; This function is responsible when called to print on the screen that you lose.
	lostScreen proc uses ax bx cx
		
		;printing the "YOU LOST!":----------------------------------
		;load the pointer of "youLost" to si
		lea si, youLost
		
		;For the title - black background, red font color
		mov ah, 04h ;black background, red foreground
		
		;The place we want to start write the title
		mov bx, (0A0h + (GameName_col + 3d)* 2d + GameName_row * 160d)
		
		write_youLost_loop:
			;Load the next character of 'youLost' to AL
			lodsb ;Load byte at DS:SI into AL, and increment SI
			
			;Check if we been reached to the NULL character
			cmp al, 0
			jz break_youLost
		
			;Print to the screen the current character
			mov es:[bx], ax
			
			;Next time print in the next pixel
			add bx, 2d
		
		jmp write_youLost_loop
		
	break_youLost:
	
	
		;load the pointer of "decripLost" to si
		lea si, decripLost
		
		;For the decription - black background, white font color
		mov ah, 0Fh ;black background, white foreground
		
		;The place we want to start write the decripLost
		mov bx, (0A0h + 4d + (GameName_row + 2d) * 160d)
		
		write_decripLost_loop:
			;Load the next character of 'decripLost' to AL
			lodsb ;Load byte at DS:SI into AL, and increment SI
			
			;Check if we been reached to the NULL character
			cmp al, 0
			jz break_decripLost
		
			;Print to the screen the current character
			mov es:[bx], ax
			
			;Next time print in the next pixel
			add bx, 2d
		
		jmp write_decripLost_loop
		
	break_decripLost:
		ret
	lostScreen endp	
	
	; Clear the screen
	clearScreen proc uses si dx
		xor si, si
		xor dx, dx
		mov dl, 20h ; ASCII value of space
	clearLoop:
		mov es:[si], dx
		add si, 2
		cmp si, 4000
		jnz clearLoop
		ret
	clearScreen endp

	; Print the maze layout
	printMaze proc uses bx si dx cx di
		mov dl, 20h ; ASCII value of space
		mov dh, 7Fh ; white background
		
		; print horizontal parts
		mov bx, offset mazeWallHorizontal
		xor di, di
	horizontalLoop:
		mov si, ds:[bx]
		mov cx, ds:[bx+2]
	hLineLoop:
		mov es:[si], dx
		add si, 2
		cmp si, cx
		jnz hLineLoop
		inc di
		add bx, 4
		cmp di, 8
		jnz horizontalLoop
		
		; print vertical parts
		mov bx, offset mazeWallVertical
		xor di, di
	verticalLoop:
		mov si, ds:[bx]
		mov cx, ds:[bx+2]
	vLineLoop:
		mov es:[si], dx
		add si, 160
		cmp si, cx
		jnz vLineLoop
		inc di
		add bx, 4
		cmp di, 5
		jnz verticalLoop
		;printing the Game Name:----------------------------------
		;load the pointer of "GameName" to si
		lea si, GameName
		
		;For the title - black background, yellow font color
		mov ah, 0Eh ;black background, yellow foreground
		
		;The place we want to start write the title
		mov bx, (0A0h + (GameName_col - 2d) * 2d + GameName_row * 160d)
		
		write_GameName2_loop:
			;Load the next character of 'title' to AL
			lodsb ;Load byte at DS:SI into AL, and increment SI
			
			;Check if we been reached to the NULL character
			cmp al, 0
			jz break_GameName2
		
			;Print to the screen the current character
			mov es:[bx], ax
			
			;Next time print in the next pixel
			add bx, 2d
		
		jmp write_GameName2_loop
		
	break_GameName2:
		ret
	printMaze endp 

	; Print characters (Beeper or Bopper)
	printCharacter proc uses dx bx si cx
		cmp ax, 0
		jz printBeeper
		jmp printBopper
	printBeeper:
		mov dl, 02h ; Smiley face
		cmp cx, 0
		jz yellow
		jmp green
	yellow:		
		mov dh, 0Eh ; Yellow text on black background
		jmp afterColor
	green:
		mov dh, 02h ; Yellow text on black background
	afterColor:	
		mov bx, offset beeperPos
		mov si, offset oldBeeperPos
		jmp contPrint
	printBopper:
		mov dl, 06h ; Spade
		mov dh, 04h ; Red text on black background
		mov bx, offset bopperPos
		mov si, offset oldBopperPos
		xor cx, cx
	contPrint:
		mov bx, ds:[bx]
		mov si, ds:[si]
		mov es:[bx], dx
		cmp cx, 0;
		jne L
		cmp bx, si
		je L
		; Clear old position
		mov dh, 00h ; Black text on black background
		mov dl, 20h ; ASCII value of space
		mov es:[si], dx
	L:
		ret
	printCharacter endp

	; Shift move memory array left by one cell
	shiftMoveMemory proc uses bx cx dx
		mov bx, offset moveMemory
		xor cx, cx
	memoryCycle:
		add bx, cx
		mov dx, ds:[bx + 1]
		mov ds:[bx], dx
		inc cx
		cmp cx, 3
		jnz memoryCycle
		add bx, cx
		mov ds:[bx], 0
		ret
	shiftMoveMemory endp

	; Read keyboard input and move Beeper accordingly while saving movements
	readKeyboard proc uses bx
		mov bx, offset moveMemory
	pollKeyBoard:
		;checks if passed 3 secends
		;Sending a request code for a second via port 70h
		mov al, 00h;+
		out 70h, al;+
	
		;Reading the second through port 71h
		in al, 71h;+
		
		cmp al, dl;+
		je notPressed ;+; If we passed 3 seconds we exit the loop. 
		
		xor ax, ax
		in al, 64h ; get LSB
		test al, 01h ; Check if pressed
		jz pollKeyBoard
		in al, 60h ; get input
		cmp al, 91h ; check if 'W'
		jz w
		cmp al, 9Eh ; check if 'A'
		jz a
		cmp al, 9Fh ; check if 'S'
		jz s
		cmp al, 0A0h ; check if 'D'
		jz d
		jmp pollKeyBoard ; if invalid input, loop
	w:
		mov ax, 0
		call moveUp
		jmp exitProc
	a:
		mov ax, 0
		call moveLeft
		jmp exitProc
	s:
		mov ax, 0
		call moveDown
		jmp exitProc
	d:
		mov ax, 0
		call moveRight
		jmp exitProc
	notPressed:
		mov ax, 0
		push cx
		mov cx, 0
		call reflect
		pop cx
	exitProc:
		ret
	readKeyboard endp

	; Move Bopper based on memory
	moveBopper proc uses bx 
	beginProc:
		mov ax, 1
		mov bx, offset moveMemory
		mov bl, ds:[bx]

		cmp bl, 0
		jz noMove
		cmp bl, 1
		jz up
		cmp bl, 2
		jz left
		cmp bl, 3
		jz down
		cmp bl, 4
		jz right
	noMove:
		call shiftMoveMemory
		jmp beginProc
		
	up:
		call moveUp
		jmp movedBopper
	left:
		call moveLeft
		jmp movedBopper
	down:
		call moveDown
		jmp movedBopper
	right:
		call moveRight
		jmp movedBopper
	movedBopper:
		call shiftMoveMemory
		ret
	moveBopper endp
	
	; Move Up for Beeper/Bopper
	moveUp proc uses bx di si cx dx
		cmp ax, 0
		jz beeperUp
		jmp bopperUp
	beeperUp:
		mov bx, offset beeperPos
		mov di, offset oldBeeperPos
		jmp contUp
	bopperUp:
		mov bx, offset bopperPos
		mov di, offset oldBopperPos
	contUp:
		; Check if legal move
		mov si, ds:[bx]
		sub si, 160d
		mov cx, es:[si]
		mov dl, 20h ; ASCII value of space
		mov dh, 7Fh ; white background
		cmp cx, dx
		jz illegalUp
		
		cmp ax, 0
		jnz dontSaveUp
		push bx
		mov bx, offset moveMemory
		mov ds:[bx + 3], 1
		pop bx
	dontSaveUp:
	
		; Save old position and move up 1 row
		mov si, ds:[bx]
		mov ds:[di], si
		sub si, 160d 
		mov ds:[bx], si
		mov cx, 0 ;
		call printCharacter
		
		cmp ax, 0
		jnz endUp
		push cx
		mov cx, 1
		call reflect
		pop cx
		jmp endUp
	illegalUp:
		cmp ax, 0
		jnz endUp
		push bx
		mov bx, offset moveMemory
		mov ds:[bx + 3], 0
		pop bx
		push cx
		mov cx, 0
		call reflect
		pop cx
	endUp:
		ret
	moveUp endp

	; Move Left for Beeper/Bopper
	moveLeft proc uses bx di si cx dx
		cmp ax, 0
		jz beeperLeft
		jmp bopperLeft
	beeperLeft:
		mov bx, offset beeperPos
		mov di, offset oldBeeperPos
		jmp contLeft
	bopperLeft:
		mov bx, offset bopperPos
		mov di, offset oldBopperPos
	contLeft:
		; Check if legal move
		mov si, ds:[bx]
		sub si, 2d
		mov cx, es:[si]
		mov dl, 20h ; ASCII value of space
		mov dh, 7Fh ; white background
		cmp cx, dx
		jz illegalLeft
		
		cmp ax, 0
		jnz dontSaveLeft
		push bx
		mov bx, offset moveMemory
		mov ds:[bx + 3], 2
		pop bx
	dontSaveLeft:
		
		; Save old position and move left 1 column
		mov si, ds:[bx]
		mov ds:[di], si
		sub si, 2d 
		mov ds:[bx], si
		mov cx, 0 ;
		call printCharacter
		
		cmp ax, 0
		jnz endLeft
		push cx
		mov cx, 2
		call reflect
		pop cx
		jmp endLeft
	illegalLeft:
		cmp ax, 0
		jnz endLeft
		push bx
		mov bx, offset moveMemory
		mov ds:[bx + 3], 0
		pop bx
		push cx
		mov cx, 0
		call reflect
		pop cx
	endLeft:
		ret
	moveLeft endp

	; Move Down for Beeper/Bopper
	moveDown proc uses bx di si cx dx
		cmp ax, 0
		jz beeperDown
		jmp bopperDown
	beeperDown:
		mov bx, offset beeperPos
		mov di, offset oldBeeperPos
		jmp contDown
	bopperDown:
		mov bx, offset bopperPos
		mov di, offset oldBopperPos
	contDown:
		; Check if legal move
		mov si, ds:[bx]
		add si, 160d 
		mov cx, es:[si]
		mov dl, 20h ; ASCII value of space
		mov dh, 7Fh ; white background
		cmp cx, dx
		jz illegalDown
		
		cmp ax, 0
		jnz dontSaveDown
		push bx
		mov bx, offset moveMemory
		mov ds:[bx + 3], 3
		pop bx
	dontSaveDown:
	
		; Save old position and move down 1 row
		mov si, ds:[bx]
		mov ds:[di], si
		add si, 160d 
		mov ds:[bx], si
		mov cx, 0 ;
		call printCharacter
		cmp ax, 0
		jnz endDown
		push cx
		mov cx, 3
		call reflect
		pop cx
		jmp endDown
	illegalDown:
		cmp ax, 0
		jnz endDown
		push bx
		mov bx, offset moveMemory
		mov ds:[bx + 3], 0
		pop bx
		push cx
		mov cx, 0
		call reflect
		pop cx
	endDown:
		ret
	moveDown endp

	; Move Right for Beeper/Bopper
	moveRight proc uses bx di si cx dx
    cmp ax, 0
    jz beeperRight
    jmp bopperRight
beeperRight:
    mov bx, offset beeperPos
    mov di, offset oldBeeperPos
    jmp contRight
bopperRight:
    mov bx, offset bopperPos
    mov di, offset oldBopperPos
contRight:
    ; Check if legal move
    mov si, ds:[bx]
    add si, 2d 
    mov cx, es:[si]
    mov dl, 20h ; ASCII value of space
    mov dh, 7Fh ; white background
    cmp cx, dx
    jz illegalRight
	
	cmp ax, 0
	jnz dontSaveRight
	push bx
	mov bx, offset moveMemory
	mov ds:[bx + 3], 4
	pop bx
dontSaveRight:
	
    ; Save old position and move right 1 column
    mov si, ds:[bx]
    mov ds:[di], si
    add si, 2d 
    mov ds:[bx], si
	mov cx, 0
    call printCharacter
	cmp ax, 0
	jnz endRight
	push cx
	mov cx, 1
	call reflect
	pop cx
	jmp endRight
illegalRight:
	cmp ax, 0
	jnz endRight
	push bx
	mov bx, offset moveMemory
	mov ds:[bx + 3], 0
	pop bx
	push cx
	mov cx, 0
	call reflect
	pop cx
endRight:
    ret
moveRight endp	
		
	; reflections fo the player
reflect proc
		;push all the registers that we gonna use
		push ax
		push bx
		push cx
		;For the title - black background, cyan font color
		mov ah, 0Bh ;black background, cyan foreground
		
		;The place we want to start write the reflect
		mov bx, (0A0h + (GameName_col+1d) * 2d + 20 * 160d)
	
		;Clear the previse reflect:
		push cx
		push bx
		mov al, 32d
		mov cx, 10d
		clearRefLoop:
			mov es:[bx], ax
			add bx, 2d
		loop clearRefLoop
		pop bx
		pop cx
	

	
		cmp cx, 0
		jz badL
		cmp cx, 1
		jz goodJobL
		cmp cx, 2
		jz wowL
		cmp cx, 3
		jz amazingL
		
	badL:
		lea si, bad
		jmp exitReflect
	goodJobL:
		lea si, good
		jmp exitReflect
	wowL:
		lea si, wow
		jmp exitReflect
	amazingL:
		lea si, amazing
		jmp exitReflect
	exitReflect:
			write_reflect_loop:
			;Load the next character of the reflect to AL
			lodsb ;Load byte at DS:SI into AL, and increment SI
			
			;Check if we been reached to the NULL character
			cmp al, 0
			jz break_reflect
		
			;Print to the screen the current character
			mov es:[bx], ax
			
			;Next time print in the next pixel
			add bx, 2d
		
			jmp write_reflect_loop
		
	break_reflect:
		;pop all the registers that we used
		pop cx
		pop bx
		pop ax
		ret
	
reflect endp
	
END START	
