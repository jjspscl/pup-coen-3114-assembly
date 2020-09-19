.model small
.code
org 100h

start:
		mov ax,3
		int 10h
		
		mov cx,3
		jmp main
		x db "PUP_CEA_CPE$"
		y db "COMPORG_3-4$"
		z db "EXPERIMENT_NO.3$"
		
main proc near
	
a: 		mov ah,9
		mov dx, offset x
		int 21h
		call down
		loop a
		
		mov cx,3
b: 		mov ah,9
		mov dx, offset y
		int 21h
		call down
		loop b
		
		
		mov cx,3
c: 		mov ah,9
		mov dx, offset z
		int 21h
		call down
		loop c
		
		mov ah, 4ch
		int 20h	
		
main endp

down   proc near
		mov ah, 2
		mov dl, 13
		int 21h
		mov dl,10
		int 21h
		ret
		
down endp
end start