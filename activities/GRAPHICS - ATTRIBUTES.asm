.model small
.code
org 100h

start:
		mov ax,3
		int 10h
		
		mov cx,4
		jmp main
		y db "BLUE$"
		x db "RED$"
		
		
main proc near
	
a: 		mov ah,9
		mov dx, offset x
		int 21h
		call down
		loop a
		
		mov cx,4
b: 		mov ah,9
		mov dx, offset y
		int 21h
		call down
		loop b
		
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