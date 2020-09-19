.model small
.code
org 100h

start:	jmp main
		x db "INPUT A SINGLE DIGIT NUMBER : $"
		y db "INPUT ANOTHER SINGLE DIGIT NUMBER : $"
		z db "THEIR SUM IS : $"

main	proc near

		mov dx, offset x	;print string
		call print
		
		call input_ok		;input
		mov cl, al			;save first input
		
		call down			;move to last line, then down
		
		mov dx, offset y
		call print
		
		call input_ok
		mov ch, al			;save second input
		
		call down
		
		mov dx, offset z
		call print
		
		add ch, cl			;add inputs (to ch)
		mov ah, 2
		
		cmp ch, 0AH
		jg greater

		mov dl, ch
		add dl, ch
		
		mov ah, 2
		
		mov dl, ch
		add dl, '0'
		int 21h
		
		end:
			int 20h
		
main	endp

down	proc near

		mov ah, 2
		mov dl, 13
		int 21h
		
		mov dl, 10
		int 21h
		ret

down	endp

print	proc near
		
		mov ah, 9
		int 21h
		ret

print	endp

input_ok	proc near
		
		mov ah, 1
		int 21h
		sub al, '0'
		ret
		
input_ok	endp

greater		proc near

		mov ah,00		;clear for remainder
		
		mov al,ch		;sum to al
		
		mov bl, 10		; al / bl = decimal 
		div bl	
		
		mov cl,ah		;mov remainder
		
		;print carry
		mov dl, al
		add dl, 48
		mov ah, 02H
		int 21h
		
		;print remainder
		mov dl, cl
		add dl, 48
		mov ah, 02h
		int 21h
		
		jmp end
	int 20h
	
greater		endp

end start