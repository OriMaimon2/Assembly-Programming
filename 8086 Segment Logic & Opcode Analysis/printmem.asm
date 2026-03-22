; Natan Krombein 341004471
; Ori Maimon 216383174

.model small
.stack 100h

.data
    X dw 1234h ; Initialize variable to store first parameter
    Y dw 5678h ; Initialize variable to store second parameter

.code

START:
    ; Initialize data segment
    mov ax, @data
    mov ds, ax
    
    ; Set extra segment to screen memory
    mov ax, 0b800h
    mov es, ax
    
    ; Load parameters from memory into registers
    mov ax, [X] ; Load X into AX
    mov dx, [Y] ; Load Y into DX
    add dx, ax  ; Add AX to DX, result is in DX
    
    ; Initialize loop variables for printing
    mov si, 1900h  
    mov cl, 4      ; Set CL to 4 for shifting

Print_Loop:
    mov bx, dx    ; Copy DX to BX for manipulation
    and bx, 0Fh   ; Mask lower 4 bits to get a single hex digit
    add bx, 30h   ; Convert to ASCII ('0'-'9' range)
    cmp bx, 3Ah   ; Check if it is beyond '9'
    jl Skip_Jump  ; If not, skip adjustment
    add bx, 7h    ; Adjust to get 'A'-'F' range
Skip_Jump:
    mov es:[si], bl  ; Move the ASCII character to video memory
    shr dx, cl    ; Shift DX right by 4 bits to get the next hex digit
    sub si, 2h    ; Move SI to the previous character position (2 bytes back)
    cmp dx, 0     ; Check if all digits are processed
    jne Print_Loop ; If not, repeat loop
    
    ; Terminate program
    mov ax, 4c00h
    int 21h 
END START
