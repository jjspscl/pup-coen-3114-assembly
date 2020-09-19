.model small
.org 100h

.data

.code
main proc near
	
	MOV AX, @DATA
	MOV DS, AX
	
	
	MOV AH, 2
	MOV DL, 'A'
	
	;A-Z
	MOV CX, 26
	@LOOP:
		
		INT 21H
		
		INC DX
		DEC CX
		
	JNZ @LOOP
	
	MOV DL, ' '
	INT 21H
	
	;Z-A
	MOV CX, 26
	MOV DL, 'A'
	@LOOP2:
		
		INT 21H
		
		INC DX
		DEC CX
		
	JNZ @LOOP2
	
	;-------------
	MOV DX,	10
	MOV AH, 2
	INT 21H
	
	MOV DX, 13
	MOV AH, 2
	INT 21H
	;-------------
	
	;0-9
	MOV CX, 10
	MOV DL, '0'
	@LOOP3:
		
		INT 21H
		
		INC DX
		DEC CX
		
	JNZ @LOOP3
	
	;--------------
	
	MOV DL, ' '
	INT 21H
	
	;--------------
	
	;9-0
	MOV CX, 10
	MOV DL, '9'
	
	@LOOP4:
		
		INT 21H
		
		DEC DX
		DEC CX
		
	JNZ @LOOP4

	
	
endp main