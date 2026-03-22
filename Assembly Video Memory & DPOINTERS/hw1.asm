.model small
.stack 100h
.data
	ID1 db 9d dup (?) ; Initialize an array that will save the first ID
	ID2 db 9d dup (?) ; Initialize an array that will save the secend ID
	DPOINTERS dw 2d dup (?) ; Initialize an array that will save the pointers to the first two arrays
.code

START:
	; Initializing data segment
	mov ax, @data
	mov ds, ax
	
	; Setting extra segment to screen memory
	mov ax, 0b800h
	mov es, ax
	
	; Setting DPOINTERS with ID1, ID2 addresses
	mov bx, offset DPOINTERS ; Sets bx to stock the offset of DPOINTERS address
	mov [bx], offset ID1 ; Sets the first place in DPOINTERS to be ID1's adderess 
	mov [bx+2], offset ID2 ; Sets the second place in DPOINTERS to be ID2's adderess
	
	; Setting first ID value
	mov bp, WORD [bx] ; Set bp to stock up ID1's adderess
	mov ds:[bp],51 ; Puts in the 1th place in ID1 array the 1th digit - '3'.
	mov ds:[bp+1],52 ; Puts in the 2th place in ID1 array the 2th digit - '4'.
	mov ds:[bp+2],49 ; Puts in the 3th place in ID1 array the 3th digit - '1'.
	mov ds:[bp+3],48 ; Puts in the 4th place in ID1 array the 4th digit - '0'.
	mov ds:[bp+4],48 ; Puts in the 5th place in ID1 array the 5th digit - '0'.
	mov ds:[bp+5],52 ; Puts in the 6th place in ID1 array the 6th digit - '4'.
	mov ds:[bp+6],52 ; Puts in the 7th place in ID1 array the 7th digit - '4'.
	mov ds:[bp+7],55 ; Puts in the 8th place in ID1 array the 8th digit - '7'.
	mov ds:[bp+8],49 ; Puts in the 9th place in ID1 array the 9th digit - '1'.
	
	; Setting second ID value
	mov bp, WORD [bx+2] ; Set bp to stock up ID2's adderess
	mov ds:[bp],50 ; Puts in the 1th place in ID1 array the 1th digit - '2'.
	mov ds:[bp+1],49 ; Puts in the 2th place in ID1 array the 2th digit - '1'.
	mov ds:[bp+2],54 ; Puts in the 3th place in ID1 array the 3th digit - '6'.
	mov ds:[bp+3],51 ; Puts in the 4th place in ID1 array the 4th digit - '3'.
	mov ds:[bp+4],56 ; Puts in the 5th place in ID1 array the 5th digit - '8'.
	mov ds:[bp+5],51 ; Puts in the 6th place in ID1 array the 6th digit - '3'.
	mov ds:[bp+6],49 ; Puts in the 7th place in ID1 array the 7th digit - '1'.
	mov ds:[bp+7],55 ; Puts in the 8th place in ID1 array the 8th digit - '7'.
	mov ds:[bp+8],52 ; Puts in the 9th place in ID1 array the 9th digit - '4'.
	
	; Print first ID to screen
	mov bx, offset DPOINTERS ; Make sure that bx stock the offset of DPOINTERS address
	mov bp, WORD [bx] ; Set bp to stock up ID1's adderess
	
	mov al, ds:[bp] ; Set up al to stock the 1th digit of ID1
	mov ah, 0Fh ; Background code: black, foreground code: white
	mov es:[900h], ax ; Writing to screen memory
	
	mov al, ds:[bp+1] ; Set up al to stock the 2th digit of ID1
	mov ah, 1Eh ; Background code: blue, foreground code: yellow
	mov es:[900h+2h], ax ; Writing to screen memory
	
	mov al, ds:[bp+2] ; Set up al to stock the 3th digit of ID1
	mov ah, 2Dh ; Background code: green, foreground code: light magenta
	mov es:[900h+4h], ax ; Writing to screen memory
	
	mov al, ds:[bp+3] ; Set up al to stock the 4th digit of ID1
	mov ah, 3Ch ; Background code: cyan, foreground code: light red
	mov es:[900h+6h], ax ; Writing to screen memory
	
	mov al, ds:[bp+4] ; Set up al to stock the 5th digit of ID1
	mov ah, 4Bh ; Background code: red, foreground code: light cyan
	mov es:[900h+8h], ax ; Writing to screen memory
	
	mov al, ds:[bp+5] ; Set up al to stock the 6th digit of ID1
	mov ah, 5Ah ; Background code: magenta, foreground code: light green
	mov es:[900h+8h+2h], ax ; Writing to screen memory
	
	mov al, ds:[bp+6] ; Set up al to stock the 7th digit of ID1
	mov ah, 69h ; Background code: brown, foreground code: light blue
	mov es:[900h+8h+4h], ax ; Writing to screen memory
	
	mov al, ds:[bp+7] ; Set up al to stock the 8th digit of ID1
	mov ah, 78h ; Background code: light gray, foreground code: dark gray
	mov es:[900h+8h+6h], ax ; Writing to screen memory
	
	mov al, ds:[bp+8] ; Set up al to stock the 9th digit of ID1
	mov ah, 12h ; Background code: blue, foreground code: green
	mov es:[900h+8h+8h], ax ; Writing to screen memory
	
	; Print secend ID to screen
	mov bp, WORD [bx+2]
	mov al, ds:[bp] ; Set up al to stock the 1th digit of ID1
	mov ah, 19d ; Set the colors
	mov es:[9A0h], ax ; Writing to screen memory
	
	mov al, ds:[bp+1] ; Set up al to stock the 2th digit of ID1
	mov ah, 28d ; Set the colors
	mov es:[9A0h+2h], ax ; Writing to screen memory
	
	mov al, ds:[bp+2] ; Set up al to stock the 3th digit of ID1
	mov ah, 37d ; Set the colors
	mov es:[9A0h+4h], ax ; Writing to screen memory
	
	mov al, ds:[bp+3] ; Set up al to stock the 4th digit of ID1
	mov ah, 45d ; Set the colors
	mov es:[9A0h+6h], ax ; Writing to screen memory
	
	mov al, ds:[bp+4] ; Set up al to stock the 5th digit of ID1
	mov ah, 56d ; Set the colors
	mov es:[9A0h+8h], ax ; Writing to screen memory
	
	mov al, ds:[bp+5] ; Set up al to stock the 6th digit of ID1
	mov ah, 64d ; Set the colors
	mov es:[9A0h+8h+2h], ax ; Writing to screen memory
	
	mov al, ds:[bp+6] ; Set up al to stock the 7th digit of ID1
	mov ah, 73d ; Set the colors
	mov es:[9A0h+8h+4h], ax ; Writing to screen memory
	
	mov al, ds:[bp+7] ; Set up al to stock the 8th digit of ID1
	mov ah, 82d ; Set the colors
	mov es:[9A0h+8h+6h], ax ; Writing to screen memory
	
	mov al, ds:[bp+8] ; Set up al to stock the 9th digit of ID1
	mov ah, 91d ; Set the colors
	mov es:[9A0h+8h+8h], ax ; Writing to screen memory

	; Terminate program
    mov ax, 4c00h
    int 21h
END START