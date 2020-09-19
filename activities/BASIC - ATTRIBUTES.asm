.model small
.code
org 100h

start:

main	proc near
		mov bh, 0
		mov al, 'Q'
		call first
		call second
		call third
		int 20h
		
main 	endp

first	proc near
		mov cx, 24
		mov bl, 44h		;color
		mov dh, 0		
		
x:		mov dl, 0
		mov ah, 2
		int 10h
		push cx
		mov ah, 9		;print text on cursor
		mov cx, 80
		int 10h
		pop cx
		inc dh
		loop x
		ret

first	endp
second	proc near

		mov cx, 12
		mov bl, 22h
		mov dh, 13
		
y:		mov dl, 0
		mov ah, 2
		int 10h
		push cx
		mov ah, 9		;print
		mov cx, 25
		int 10h
		pop cx
		inc dh
		loop y
		ret
		
second	endp

third	proc near
		mov cx, 12
		mov bl, 11h
		mov dh, 13
		
z:		mov dl, 55
		mov ah, 2
		int 10h
		push cx
		mov ah, 9
		mov cx, 25
		int 10h
		pop cx
		inc dh
		loop z
		ret

third	endp

end		start