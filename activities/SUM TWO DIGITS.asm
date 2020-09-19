.model small
org 100h

.data
	Q db "INPUT AN INTEGER [00-99]: $"
	W db "INPUT THE INTEGER TO BE ADDED [00-99]: $"
	E db " THEIR SUM IS: $"
	R db 10,13,"$"
	tempa db ?
	tempb db ?
	tempc db ?
	
.code
start:	
main	proc near
		mov ax, 3
		int 10h
	
		mov ax, @data
		mov ds, ax
		
		lea dx, Q
		call o_string				
		
		call input
		mov cl, al							; INPUT-STORE THE TENTHS DIGIT TO CL
		
		call input
		mov bl, al							; INPUT-STORE THE ONES DIGIT TO BL
		
		call nxt_line
		
		lea dx, W
		call o_string					
		
		call input
		mov ch, al							; INPUT-STORE THE TENTHS DIGIT TO CH
		
		call input
		mov bh, al							; INPUT-STORE THE TENTHS DIGIT TO BH
	
		call nxt_line
		
		lea dx, E
		call o_string					
							
		call addones
		mov dl, al							; ADD ONES THEN STORE TO DL
		
		add dl, '0'
		
		mov tempa, dl						; STORE FOR OUTPUT
		 
		call addtens						; ADD TENTHS 
		
		mov dl, al
		add dl, '0'
		
		mov tempb, dl
		
		mov dl, ah
		add dl, '0'
		mov tempc, dl						; STORE AH TO DL IF TENTHS CARRIES
		
		mov dl, tempc
		call o_char
		
		mov dl, tempb
		call o_char
		
		mov dl, tempa
		call o_char
	
		mov ah, 4ch
		int 21h

main 	endp


o_string		proc near						; PRINT STRING
		mov ah, 9
		int 21h
		ret
o_string		endp


o_char		proc near						; PRINT CHAR
		mov ah,2
		int 21h
		ret
o_char		endp

			
input	proc near							; KEYBOARD INPUT
		mov ah, 1
		int 21h
		ret
input	endp


nxt_line proc near								; NEXT LINE
		lea dx, R
		mov ah, 9
		int 21h
		ret
nxt_line	endp


addones proc near
		add bh, bl
		mov al, bh
		mov ah, 0
		aaa
		ret
addones	endp


addtens	proc near
		
		add ch, ah   
		add ch, cl
		mov al, ch
		mov ah,0
		aaa
		ret
		
addtens	endp


end	start