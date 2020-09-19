.model small

org 100h

.stack 100h

.data
	blkx db 0,0,0,0,0 ;5
		 db 1,1,1,1,1,1,1 ;7 
		 db 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2 ;15
		 db 3,3,3,3,3,3,3,3,3,3,3,3	;12
		 db 4,4,4,4,4,4,4,4,4,4,4,4,4,4 ;14
		 db 5,5,5,5,5,5,5,5,5,5,5,5,5 ;13
		 db 6,6,6,6,6,6,6 ;7
		 db 7,7,7,7,7,7,7,7,7 ;9
		 db 8,8,8,8,8,8,8,8,8,8,8 ;11
		 db 9,9,9,9,9,9,9,9,9,9,9,9,9,9 ;14
		 db 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10 ;17
		 db 11,11,11,11,11,11,11,11,11,11,11,11,11,11,11 ;15
		 db 12,12,12,12,12,12,12,12,12,12,12,12,12,12,12 ;15
		 db 13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13 ;18
		 db 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14 ;17
		 db 15,15,15,15,15,15,15,15,15,15 ;10
		 db 16,16,16 ;3
		 db 17,17,17 ;3
		 db 18,18,18 ;3
		 db 19,19,19 ;3
		 db 20,20,20,20,20,20,20 ;7
		 db 21,21,21 ;3
		 db 22,22,22,22 ;4
		 db 23,23,23 ;3 
		 
		 
	blky db	17,18,19,20,21
		 db 16,17,18,19,20,21,22
		 db 15,16,17,18,19,20,21,22,23,27,28,29,31,32,33
		 db 15,16,17,18,19,20,21,22,23,28,31,33	
		 db 15,16,17,18,19,20,21,22,23,26,28,31,32,33 
		 db 15,16,17,18,19,20,21,22,23,26,27,28,31
		 db 16,17,18,19,20,21,22 
		 db 17,18,19,20,21,22,23,24,25
		 db 10,11,12,13,18,19,20,21,22,26,27
		 db 9,10,11,12,13,14,15,17,18,19,20,21,26,27
		 db 8,9,10,11,12,13,14,15,16,17,18,19,20,21,26,28,29
		 db 8,9,10,11,12,13,14,15,16,17,18,19,20,21,29
		 db 8,9,10,11,12,13,14,15,16,17,18,19,20,21,29 
		 db 8,9,10,11,12,13,14,15,16,17,18,19,20,21,29,30,32,33
		 db 9,10,11,12,13,14,15,17,20,21,22,29,30,31,32,33
		 db 10,11,12,13,14,16,26,28,31,32
		 db 17,26,32
		 db 16,22,32
		 db 17,22,32
		 db 18,23,31
		 db 19,20,21,24,28,29,30
		 db 21,24,28
		 db 22,25,26,27
		 db 23,24,25
		 
	fcx db 3,4,6,7,7,7,11,14,15,15,14,12,6,6,2
	
	fcy db 23,22,22,22,22,22,18,17,17,17,18,19,22,22,23
			
	eyx db 13,13,13
		db 14,14,14
		db 15,15,15
		db 16,16
		
	eyy db 25,26,28
		db 25,26,28
		db 25,26,28
		db 25,26
		
	eex db 25,26,28
		db 25,26,28
		db 25,26,28
		db 25,26
		
	eey db 25,26,28
		db 25,26,28
		db 25,26,28
		db 25,26
		
	puy db 26,28,26
	pux	db 16,15,15
	
.code

start:

main:

		mov ax,	@DATA
		mov ds,	ax
		
		mov ax,	0
		
		mov bh, 0	;page no.
		mov al, 219	;char to display
		
		call bg		;call function 
		
		call fc		;draw face
		
		
		call eye	;draw eye
		
		
		call blk	;draw black
		
	@blink:			;blink animation
		call eye1
		
		mov cx, 0Ah
		mov dx, 8480h
		mov ah, 86h
		mov al, 0
		int 15h
		
		
		mov al, 219
		
		call eye2
		
		mov cx, 0Ah
		mov dx, 8480h
		mov ah, 86h
		mov al, 0
		int 15h
		
		mov al, 219
		
		call eye3
		
		mov cx, 0Ah
		mov dx, 8480h
		mov ah, 86h
		mov al, 0
		int 15h
		
		
		mov al, 219
		
		call eye4
		call pup
		
		mov cx, 0Ah
		mov dx, 8480h
		mov ah, 86h
		mov al, 0
		int 15h
		
		
		mov al, 219
		
	jnz @blink
	
		int 20h		;exit program
	0
eye1:
		mov bl, 0Ah			;color
		mov cx,3 		;counter
		
		mov si, offset eyx
		mov di, offset eyy
	
	e1:		
		mov dh, [si]		;move cursor x
		mov dl, [di]		;move cursor y
		mov ah, 2
		int 10h
		
		push cx
		mov ah, 9
		mov cx, 1
		int 10h
		
		pop cx
		
		inc dh
		inc si
		inc di
		
		loop e1
		ret
	

eye2:
		mov bl, 0Ah			;color
		mov cx,8 		;counter
		
		mov si, offset eyx
		mov di, offset eyy
	
	e2:		
		mov dh, [si]		;move cursor x
		mov dl, [di]		;move cursor y
		mov ah, 2
		int 10h
		
		push cx
		mov ah, 9
		mov cx, 1
		int 10h
		
		pop cx
		
		inc dh
		inc si
		inc di
		
		loop e2
		ret


eye3:
		mov bl, 0Ah			;color
		mov cx,11 		;counter
		
		mov si, offset eyx
		mov di, offset eyy
	
	e3:		
		mov dh, [si]		;move cursor x
		mov dl, [di]		;move cursor y
		mov ah, 2
		int 10h
		
		push cx
		mov ah, 9
		mov cx, 1
		int 10h
		
		pop cx
		
		inc dh
		inc si
		inc di
		
		loop e3
		ret


eye4:
		mov bl, 0Fh			;color
		mov cx,11 		;counter
		
		mov si, offset eyx
		mov di, offset eyy
	
	e4:		
		mov dh, [si]		;move cursor x
		mov dl, [di]		;move cursor y
		mov ah, 2
		int 10h
		
		push cx
		mov ah, 9
		mov cx, 1
		int 10h
		
		pop cx
		
		inc dh
		inc si
		inc di
		
		loop e4
		ret
	
pup:
		mov bl, 00h			;color
		mov cx,3 		;counter
		
		mov si, offset pux
		mov di, offset puy
	
	e5:		
		mov dh, [si]		;move cursor x
		mov dl, [di]		;move cursor y
		mov ah, 2
		int 10h
		
		push cx
		mov ah, 9
		mov cx, 1
		int 10h
		
		pop cx
		
		inc dh
		inc si
		inc di
		
		loop e5
		ret

bg:
		mov cx, 24	;counter
		mov bl, 77H ;color
		mov dh, 0	;row		
		
	x:	mov dl, 0	;column
		mov ah, 2	;set cursor position from dh,dl
		int 10h
		
		push cx
		mov ah, 9		;print text on cursor
		mov cx, 80
		int 10h
		
		pop cx
		inc dh
		
		loop x
		
		ret

fc:
		mov bl, 0Ah		;color
		mov cx, 15		;counter
		
		mov si, offset fcx
		mov di, offset fcy
		mov dh, 8			;move cursor x
		
	y:	mov dl, [di]		;move cursor y
		mov ah, 2
		int 10h
		
		push cx
		
		mov ah, 9
		mov cl, [si]
		int 10h
		
		pop cx
		
		
		inc si
		inc di
		inc dh
		
		
		loop y
		ret

eye:
		mov bl, 0Fh			;color
		mov cx,11 		;counter
		
		mov si, offset eyx
		mov di, offset eyy
	
	z1:		
		mov dh, [si]		;move cursor x
		mov dl, [di]		;move cursor y
		mov ah, 2
		int 10h
		
		push cx
		mov ah, 9
		mov cx, 1
		int 10h
		
		pop cx
		
		inc dh
		inc si
		inc di
		
		loop z1
		ret


blk:

		mov bl, 00h			;color
		mov cx, 226		;counter
		
		mov si, offset blkx
		mov di, offset blky
	
	z:		
		mov dh, [si]		;move cursor x
		mov dl, [di]		;move cursor y
		mov ah, 2
		int 10h
		
		push cx
		mov ah, 9
		mov cx, 1
		int 10h
		
		pop cx
		
		inc dh
		inc si
		inc di
		
		loop z
		ret





end		start