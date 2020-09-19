.model small
org 100h
.data

	jup db 25h,12H,15H,1FH,2BH
	sum db 0
	
	
.code

	main proc
		
		mov ax,	@DATA
		mov dx,	ax
		
		mov ax,	0	
		mov cx,5
		
		mov bx, offset jup
		
		lp:
		add al, [bx]
		
		inc bx
		dec cx
		
		jnz lp
		
		mov sum, al
		
		mov dl, sum
		mov ah, 2
		int 21h
		
		mov ah, 4ch
		int 21h
		
	endp main
ret