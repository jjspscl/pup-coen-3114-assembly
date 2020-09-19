.MODEL SMALL
ORG 100H


.data
        Q DB 10,13,"INPUT VALUE:","$"
		W DB "INPUT ANOTHER (Y/N):","$"
		E DB ?
		R DB " IS AN UPPER CASE CHARACTER ",10,13,"$"
		T DB " IS AN LOWER CASE CHARACTER ",10,13,"$"
		Y DB " IS AN DIGIT ",10,13,"$"
		U DB " IS AN SPECIAL CHARACTER ",10,13,"$"
		I DB " INVALID INPUT ",10,13,"$"
		D DB 10,13,"$"
		yn1 db ?
.CODE
START:
	PROC MAIN
		MOV AX,@DATA
		MOV DS, AX
		
		MOV AX,3
		INT 10H
		
		
        MOV AH,9
        LEA DX,Q
        INT 21H

        MOV AH,1
        INT 21H
				
		MOV CX, 25H
		MOV E, 41H
		
		;check if uppercase letter
		checkazh:
			CMP E,AL
			je charh
		
			INC E
		loop checkazh
			
		MOV CX, 25H
		MOV E, 61H
		
		checkazl:
		
			CMP E,AL
			je charl
		
			INC E
			LOOP checkazl
		
		MOV CX, 9H
		MOV E, 30H
		
		checkdig:
		
			CMP E,AL
			je charl
			
			INC E
			LOOP checkdig
		
		speciald:
			call DOWN
			call PRINTE
			
			MOV AH,9
			LEA DX,U
			INT 21H
		
			call DOWN
		
			JMP YN
	
		charh:
			call DOWN
			call PRINTE
			
			MOV AH,9
			LEA DX,R
			INT 21H
		
			call DOWN
		
			JMP YN
		
		charl:
			call DOWN
			call PRINTE
			
			MOV AH,9
			LEA DX,T
			INT 21H
		
			call DOWN
		
			JMP YN
			
		dig:
			call DOWN
			call PRINTE
			
			MOV AH,9
			LEA DX,Y
			INT 21H
		
			call DOWN
		
			JMP YN
			
		YN:
			LEA DX, W
			MOV AH,9
			INT 21H
		
			MOV AH,1
			INT 21H
		
			CMP AL,'y'
			JZ MAIN
			CMP AL,'Y'
			JZ MAIN
			
			CMP AL,'N'
			CMP AL,'n'
			JZ EXIT
			JNZ INV
			
		INV:
			call DOWN	
			LEA DX, I
			MOV AH,9
			INT 21H
			MOV AX,0	
			JMP YN
		EXIT:
			INT 20H
	ENDP MAIN

	PROC PRINTE
			PUSHA
			call DOWN
			MOV dl,AL
			mov ah,2
			int 21h
			POPA
			ret
	ENDP PRINTE
	
	PROC DOWN
		PUSHA
		LEA DX, D
		MOV AH,9
		INT 21H
		POPA
		ret
	ENDP DOWN
	
	
end 	start




