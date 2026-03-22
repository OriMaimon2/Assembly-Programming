; Natan Krombein 341004471
; Ori Maimon 216383174


.model small

; Define the constants:
N_rows EQU 12d
N_columns EQU 24d
height EQU 8d
horn_length EQU 8d

.stack 100h
.data
.code

START:
	; Initializing data segment
	mov ax, @data
	mov ds, ax
	
	; Setting extra segment to screen memory
	mov ax, 0b800h
	mov es, ax
	
	
	
	; Starting of the printing

	;Initializes the color to be printed to brown
	mov ax, 2EDBh ;Background color: yellow
	
	;printing the rectangle:------------------------------------------------------------------------------
	;printing first half of the rectangle:
	mov cx, N_columns ;number of iterations
	mov bx, 1656d ;the place on the screen that we want start printing
  L1:
	mov es:[bx], ax ; Writing to screen memory the upper line
	mov es:[bx + ((N_rows-1)*160d)], ax ; Writing to screen memory the button line
	add bx, 0002h ; Move to the next place in the screen memory
	loop L1
	
	;printing second half of the rectangle:
	mov cx, (N_rows-2d) ;number of iterations
	mov bx, 1656d ;the place on the screen that we want start printing
  L2:
  	add bx, 160d ; Move to the next place in the screen memory
	mov es:[bx], ax ; Writing to screen memory the left column
	mov es:[bx+2], ax ; Writing to screen memory the left column
	mov es:[bx + ((N_columns-1)*2d)], ax ; Writing to screen memory the right column
	mov es:[bx + ((N_columns-1)*2d) - 2d], ax ; Writing to screen memory the right column
	loop L2


	;printing the rhombus:------------------------------------------------------------------------------
	;printing first half of the rhombus:
	mov cx, height ;number of iterations
	mov bx, 1504d ;the place on the screen that we want start printing
	mov si, 0d ;The dist between each pixle
  L3:
	mov es:[bx + si], ax ; Writing to screen memory the upper line
	mov di, 28d
	sub di, si
	mov es:[bx + di], ax ; Writing to screen memory the button line
	sub bx, 160d ; Move to the next place in the screen memory
	add si, 2d
	loop L3
	
	;printing second half of the rhombus:
	mov cx, height ;number of iterations
	mov bx, 1824d ;the place on the screen that we want start printing
	mov si, 0d ;The dist between each pixle
  L4:
	mov es:[bx + si], ax ; Writing to screen memory the upper line
	mov di, 28d
	sub di, si
	mov es:[bx + di], ax ; Writing to screen memory the button line
	add bx, 160d ; Move to the next place in the screen memory
	add si, 2d
	loop L4
	
	
	;printing the horns:------------------------------------------------------------------------------
	;printing the right horn:
	mov cx, horn_length ;number of iterations
	mov bx, 1656d+N_columns*2d ;the place on the screen that we want start printing
  L5:
	mov ax, 22DBh ; Background code: green
	mov es:[bx], ax ; Writing to screen memory the upper pixle
	mov es:[bx + 2d], ax 
	mov es:[bx + 4d], ax
	mov ax, 24DBh ; Background code: red
	mov es:[bx + 320d], ax ; Writing to screen memory the medium pixle
	mov es:[bx + 322d], ax 
	mov es:[bx + 324d], ax
	mov ax, 21DBh ; Background code: blue
	mov es:[bx + 640d], ax ; Writing to screen memory the button pixle
	mov es:[bx + 642d], ax 
	mov es:[bx + 644d], ax
	add bx, 166d ; Move to the next place and to the next line
	loop L5
	
	;printing the left horn:
	mov cx, horn_length ;number of iterations
	mov bx, 1654d ;the place on the screen that we want start printing
  L6:
	mov ax, 22DBh ; Background code: green
	mov es:[bx], ax ; Writing to screen memory the upper pixle
	mov es:[bx - 2d], ax 
	mov es:[bx - 4d], ax
	mov ax, 24DBh ; Background code: red
	mov es:[bx + 320d], ax ; Writing to screen memory the medium pixle
	mov es:[bx + 318d], ax 
	mov es:[bx + 316d], ax
	mov ax, 21DBh ; Background code: blue
	mov es:[bx + 640d], ax ; Writing to screen memory the button pixle
	mov es:[bx + 638d], ax 
	mov es:[bx + 636d], ax
	add bx, 154d ; Move to the next place and to the next line
	loop L6
	; Terminate program
    mov ax, 4c00h
    int 21h
END START