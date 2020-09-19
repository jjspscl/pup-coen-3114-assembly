;Group 7 - Munar, Ocampo, Panganiban, Pascual, Pelagio
;		 - CPE 3-4
; yung mga bmp po dito ay pre-made at kasama sa directory na pinagrurun ng asm file
; pati po yung mga .txt file sa electronic component library.
; mag fafail po ito kapag nirun kasi wala yung mga .bmp file HAHA thank you ^_^

.MODEL small
.386
.STACK 100h
org 100h
.data



addbuffer db 50
addtotal db  ?
addchar db 50 dup(?)

;INT================================
textx db 0
texty db 0
printv db 0

conv dw 0
convout db 0

;BMP ===============================
img db 0,0
bg db 'init.bmp',0
menu db 'menu.bmp',0
SIR db 'SIR.bmp',0
menuhov1 db 'menuhov1.bmp',0
menuhov2 db 'menuhov2.bmp',0
menuhov3 db 'menuhov3.bmp',0
menuhov4 db 'menuhov4.bmp',0
menuhov5 db 'menuhov5.bmp',0

infoui db 'info.bmp',0
info1 db 'info1.bmp',0
info2 db 'info2.bmp',0
info3 db 'info3.bmp',0
info4 db 'info4.bmp',0
info5 db 'info5.bmp',0


ppass db 'password.bmp',0

eliback db 'eliback.bmp',0
bfbg db 'bfbg.bmp',0
bfinit db 'BFINIT.bmp',0

filehandle dw ?

Header db 54 dup (0)

Palette db 256*4 dup (0)

ScrLine db 320 dup (0)

ErrorMsg db 'Error', 13, 10,'$'
;================================


;MOUSE ==========================
mminx dw 0
mmaxx dw 0
mminy dw 0
mmaxy dw 0
mouse_go db 0
boxno db 0

;PASSWORD=================================
pas1 DB "ENTER PASSWORD:$"
pas2 DB 10,13,"PASSWORD ACCEPTED!!$"
pas3 DB 10,13,"INCORRECT PASSWORD$"
pas4 DB ?
pas5 DB ?

;LIBRARY==================================
; Message for first input 
msg1 db "Search: $" 
  
	OpenFileErrorMessage db 10,13, 'No such file.','$'
	ReadErrorMessage db 10,13, 'Cannot read from file.','$'

; For each buffered input, we have to reserve space such that
tsize1 db 9       ; First byte contains a value that indicates the number of characters to be received at maximum
asize1 db ?         ; Second byte is reserved for interrupt's use
array1 db 9 dup(?) ; The third byte and on for saving the input. The minimum amount of space required
                    ; here is equal to the value of first byte
array2 db ".txt",0
; Here both values would be concatenated. So, it must be sum of the sizes of both inputs long
array3 db 12 dup('$')



;BINARY FUN===============================
correct_answer db 0
			   
box1show db 30h
box2show db 30h
box3show db 30h
box4show db 30h
box5show db 30h
box6show db 30h
box7show db 30h
box8show db 30h
boxshow db 0
printcoordx db 0
addsub db 0
prev_value db 0
user_sum db 0

;Calculator==========================
txt1 db 13,10,13,10, "Enter 1st Number : $"
msg2 db 13,10, "Enter 2nd Number : $"
msgEr db 13,10, "Error $"
msgCh db 13,10, "Press A to ADD , S to SUBTRACT ,D to MULTIPLY, F to DIVIDE, X to EXIT : $ "
msgSum db 13,10,13,10, "Sum is : $"
msgDif db 13,10,13,10, "Difference is : $"
msgDiv db 13,10,13,10, "Quotient is : $"
msgMul db 13,10,13,10, "Product is : $"
tmp     db ?
answer db ?

.code

;RESET PROGRAM===================
proc reset
		xor ax,ax
		xor bx,bx
		xor cx,cx
		xor dx,dx
		xor si,si
		xor di,di
		
		clc
		ret
endp reset

proc menub
	call reset
	jmp start
endp menub

;INTERUPTS=======================
	
	;WAIT KEYPRESS
	proc keypress
		mov ah,1
		int 21h
		ret
	endp keypress
	
	proc movcur
		mov dl,textx
		mov dh,texty
		mov ah,2
		int 10h
		ret		
	endp movcur
	
	proc printf
		mov dl,printv
		mov ah, 2
		int 21h
		ret
	endp printf
	
	proc down
		mov ah, 02h
		mov dx, 10
		int 21h
		mov dx, 13
		int 21h
		ret
	endp down

;===========================================
;		     ARITHMETIC OPERATORS
;===========================================
proc hex2dec
	mov ax, conv
	MOV BX, 10     ;Initializes divisor
	MOV DX, 0000H    ;Clears DX
	MOV CX, 0000H    ;Clears CX
    
          ;Splitting process starts here
	.Dloop1:  
		MOV DX, 0000H    ;Clears DX during jump
		div BX      ;Divides AX by BX
		PUSH DX     ;Pushes DX(remainder) to stack
		INC CX      ;Increments counter to track the number of digits
		CMP Ax, 0     ;Checks if there is still something in AX to divide
		JNE .Dloop1     ;Jumps if AX is not zero
	
		
	.Dloop2:  
		POP DX      ;Pops from stack to DX
		ADD DX, 30H     ;Converts to it's ASCII equivalent
		
		MOV AH, 02H     
		INT 21H      ;calls DOS to display character
		LOOP .Dloop2    ;Loops till CX equals zero
		RET       ;returns control
	
endp hex2dec

;RANDOMIZER=================================
rand	proc

	RANDSTART:
	MOV AH, 00h  ; interrupts to get system time        
	INT 1AH      ; CX:DX now hold number of clock ticks since midnight      
                ; lets just take the lower bits of DL for a start..
	MOV BH, 0FFh  ; set limit to 57 (ASCII for 9) 
	MOV AH, DL  
	CMP AH, BH   ; compare with value in  DL,      
	JA RANDSTART ; if more, regenerate. if not, continue... 

	MOV BH, 31h ; set limit to 48 (ASCII FOR 0)
	MOV AH, DL  
	CMP AH, BH   ; compare with value in DL
	JB RANDSTART ; if less, regenerate.   
	
	RET
	
rand	endp
;================================	

;BMP OPEN=============================
;=====================================
proc bmps

	call OpenFile		;
    call ReadHeader		;
    call ReadPalette	;PRINT BMP
    call CopyPal		;
    call CopyBitmap		;
	call CloseBmpFile
	ret
endp bmps 


proc OpenFile

    ; Open file
	
    mov ah, 3Dh
    xor al, al
    
    int 21h

    jc openerror
    mov [filehandle], ax
    ret

    openerror:
    mov dx, offset ErrorMsg
    mov ah, 9h
    int 21h
    ret
endp OpenFile
proc ReadHeader

    ; Read BMP file header, 54 bytes

    mov ah,3fh
    mov bx, [filehandle]
    mov cx,54
    mov dx,offset Header
    int 21h
    ret
    endp ReadHeader
    proc ReadPalette

    ; Read BMP file color palette, 256 colors * 4 bytes (400h)

    mov ah,3fh
    mov cx,400h
    mov dx,offset Palette
    int 21h
    ret
endp ReadPalette
proc CopyPal

    ; Copy the colors palette to the video memory
    ; The number of the first color should be sent to port 3C8h
    ; The palette is sent to port 3C9h

    mov si,offset Palette
    mov cx,256
    mov dx,3C8h
    mov al,0

    ; Copy starting color to port 3C8h

    out dx,al

    ; Copy palette itself to port 3C9h

    inc dx
    PalLoop:

    ; Note: Colors in a BMP file are saved as BGR values rather than RGB.

    mov al,[si+2] ; Get red value.
    shr al,2 ; Max. is 255, but video palette maximal

    ; value is 63. Therefore dividing by 4.

    out dx,al ; Send it.
    mov al,[si+1] ; Get green value.
    shr al,2
    out dx,al ; Send it.
    mov al,[si] ; Get blue value.
    shr al,2
    out dx,al ; Send it.
    add si,4 ; Point to next color.

    ; (There is a null chr. after every color.)

    loop PalLoop
    ret
endp CopyPal

proc CopyBitmap

    ; BMP graphics are saved upside-down.
    ; Read the graphic line by line (200 lines in VGA format),
    ; displaying the lines from bottom to top.

    mov ax, 0A000h
    mov es, ax
    mov cx,200
    PrintBMPLoop:
    push cx

    ; di = cx*320, point to the correct screen line

    mov di,cx
    shl cx,6
    shl di,8
    add di,cx

    ; Read one line

    mov ah,3fh
    mov cx,320
    mov dx,offset ScrLine
    int 21h

    ; Copy one line into video memory

    cld 

    ; Clear direction flag, for movsb

    mov cx,320
    mov si,offset ScrLine
    rep movsb 

    ; Copy line to the screen
    ;rep movsb is same as the following code:
    ;mov es:di, ds:si
    ;inc si
    ;inc di
    ;dec cx
    ;loop until cx=0

    pop cx
    loop PrintBMPLoop
    ret
endp CopyBitmap

proc CloseBmpFile near
	mov ah,3Eh
	mov bx, [filehandle]
	int 21h
	ret
ret
endp CloseBmpFile

;MOUSE ===============================
;=====================================

proc check_mouse   ;for checking mouse presence

	mov ax,0h
	int 33h
	ret
	
endp check_mouse

proc show_mouse  ;for enabling mouse pointer
	mov ax,01h
	int 33h
	ret
endp show_mouse

proc mouseinit

	call check_mouse
	cmp ax,0ffffH
	jne exit
	call show_mouse	
	ret
		
endp mouseinit

proc lmouse

	mov ax,0003H
	int 33h
	
	cmp bx, 01h
	jne lmouse	
	ret

endp lmouse

proc lmouse2

	mov ax,0003H
	int 33h
	ret

endp lmouse2


proc mousehov

		cmp cx,mminx
		jl mhov
		cmp cx,mmaxx
		jg mhov
		cmp dx, mminy
		jl mhov
		cmp dx,mmaxy
		jl mhov1
		
		mhov:
			mov boxno, 0
			
		mhov1:
			ret
			
endp mousehov
;ADMINISTRATIVE PASSWORD
PROC PASSWORDZ
AGAIN:

MOV AX,13h
INT 10H

mov dx, offset ppass
call bmps

mov textx,5
mov texty,11
call movcur

MOV AH,9
LEA DX,pas1
INT 21H


MOV AH,8
INT 21H
MOV BL,AL

MOV DL,'*'
MOV AH,2
INT 21H

CMP BL,'2'
JNE INV

MOV AH,8
INT 21H
MOV CL,AL

MOV DL,'*'
MOV AH,2
INT 21H

CMP CL,'6'

JNE INV

MOV AH,8
INT 21H
MOV DH,AL

MOV DL,'*'
MOV AH,2
INT 21H

CMP DH,'3'
JNE INV

MOV AH,8
INT 21H
MOV pas4,AL

MOV DL,'*'
MOV AH,2
INT 21H
CMP pas4,'6'
JNE INV

MOV AH,8
INT 21H
MOV pas5,AL

MOV DL,'*'
MOV AH,2
INT 21H

CMP pas5,'9'
JNE INV
JE VAL

INV:
MOV AH,9
LEA DX,pas3
INT 21H
JMP AGAIN

VAL:
MOV AH,9
LEA DX,pas2
INT 21H
RET
ENDP PASSWORDZ

;=====================================
;    ELECTRONIC COMPONENTS LIBRARY	 
;=====================================
proc elibrary
	
	call reset

	
	mov ax,13h
	int 10h

	mov dx, offset eliback
	call bmps
	
	; Set the value of 
	
	call mouseinit
	
	
	libloop:
	
	call lmouse
	
	;go2 search
	mov mminx, 32
	mov mmaxx, 191
	mov mminy, 16
	mov mmaxy, 23
	mov boxno, 1
	call mousehov
	
	cmp boxno, 1
	je elib_type
	
	;add
	mov mminx, 208
	mov mmaxx, 239
	mov boxno, 2
	call mousehov
	
	cmp boxno, 2
	je addtxt
	
	;exit
	mov mminx, 592
	mov mmaxx, 623
	mov boxno, 'x'
	call mousehov
	
	cmp boxno, 'x'
	je menub
	
	jmp libloop
	popa
endp elibrary
;ADDDDDD SECTION;
proc	addtxt
	mov textx, 2
	mov texty, 2
	call movcur
	
	mov ax, 2
	int 33h 
	
	mov ah, 0ah
	mov dx, offset tsize1
	int 21h
	
	mov ax, 1
	int 33h 

	call addtxtsearch

endp	addtxt

proc addtxtsearch

	mov cx, 0 
	mov cl, asize1 

	


	mov si, offset array1    
	mov di, offset array3    

	start1add:
	mov al, [si]    
	mov [di], al   

	inc si          
	inc di          
	loop start1add


	mov cx, 0
	mov cl, 4

	mov si, offset array2  

	start2add:
	mov ax, [si]
	mov [di], ax
	inc si
	inc di
	loop start2add

	; Copy complete

	mov textx,10
	mov texty,5
	
	call movcur
	
	 
	xor ah, ah
	mov si, ax
	mov array3[si], 0 
	
	
	mov ah, 3dh
	xor al, al 
	mov dx, offset array3
	
	int 21h ;open the file
	
	jc addtxterror
	
	mov bx, ax
	

	repeatadd:
	
    mov ah, 3fh
    mov dx, offset array3
    mov cx, 100 
    int 21h
	
    
	
    mov si, ax
    mov array3[si],'$'
	
	mov ah, 09h
	int 21h ;print on screen
	
    cmp si, 100
    je repeatadd 
	jmp stopadd
 	
	stopadd:
	
	call keypress

	call elibrary

addtxterror:	
	call inputadd
	call keypress

	call elibrary

endp addtxtsearch

proc	inputadd
	mov ah, 3ch				; create file
	mov cx, 0			
	lea dx, array3
	int 21h
	mov [filehandle], ax
	mov ax, 3d02h
	lea dx, array3
	int 21h
	
	mov [filehandle], ax
	
	mov textx,10
	mov texty,5
	
	call movcur
	
	
	mov dx, offset addbuffer
	mov ah, 0ah
	int 21h
	
	; dito nako
	lea dx, addchar
	
	mov ah, 40h
	mov bx, [filehandle]
	mov cl, addtotal
	int 21h
	
	
	mov ah,3Eh
	mov bx, [filehandle]
	int 21h
	ret
endp	inputadd
;;;;;;;;;;;;;;;;;;;;;;;;	
proc elib_type

	mov ax, 2
	int 33h 
	
	mov textx, 2
	mov texty, 2
	call movcur
	
	mov ah, 0ah
	mov dx, offset tsize1
	int 21h
	
	mov ax, 1
	int 33h 

	jmp elib_search
	
endp elib_type

proc elib_search
; Copy first string

	; Loop uses cx register
	mov cx, 0 ; So clean it up first
	mov cl, asize1 ; Put actual size of first input in cl

	
	; The value of cx is same as value of cl now

	mov si, offset array1    ; Offset of first byte of first input is moved in si
	mov di, offset array3    ; Offset of first byte of new string is moved in di ; Here the loop starts

	start1:
	mov al, [si]    ; Copy the value at the address of si in al (one byte)
	mov [di], al    ; Copy this value at the address of di from al

	inc si          ; Move to next byte of source
	inc di          ; Move to next byte of target 
	loop start1

	; loop subtracts 1 from cx and checks if its zero. Zero means break the loop
	; So, the loop appears to run cx times which has number of characters in first input
	; First string copied, start the second

	mov cx, 0
	mov cl, 4

	mov si, offset array2  ; Start copying from first byte of second string
                       ; But the target remains the same

	start2:
	mov ax, [si]
	mov [di], ax
	inc si
	inc di
	loop start2

	; Copy complete

	;mov al, uActualLength 
	xor ah, ah
	mov si, ax
	mov array3[si], 0 ;make sz see 0A function
	
	;mov ah, 09h
	;mov dx, offset array3
	;int 21h
	
	mov ah, 3dh
	xor al, al 
	mov dx, offset array3
	
	
	int 21h ;open the file
	
	jc openErrorl ;if error
	mov bx, ax
	;mov [filehandle], ax 
	
	mov textx,0
	mov texty,5
	call movcur	
	repeat:
    mov ah, 3fh
    mov dx, offset array3
    mov cx, 100
    int 21h
	
    ;jc readError; if error
	
    mov si, ax
    mov array3[si],'$'

	mov ah, 09h
	int 21h ;print on screen
	
	
    cmp si, 100
	je repeat

	jmp stop
    ;jmp stop;jump to end
	

	openErrorl:
	mov textx,10
	mov texty,5
	
	call movcur
	mov ah, 09h
	mov dx, offset OpenFileErrorMessage
	int 21h
    jmp stop

	stop:
	
	call keypress
	;mov ah, 4ch
	;int 21h
	
	call elibrary

;dick
endp elib_search

;=====================================
; 			 BINARY FUN				 
;=====================================
resetbf	proc near	
		mov ax, 3
		int 10h
		mov box1show, 30h
		mov box2show, 30h
		mov box3show, 30h
		mov box4show, 30h
		mov box5show, 30h
		mov box6show, 30h
		mov box7show, 30h
		mov box8show, 30h
		mov user_sum, 0
		mov prev_value,0
		mov correct_answer,0
		mov conv, 0
		ret
resetbf	endp

change_status	proc near
		mov ah, boxshow			; dedeclare value neto after ng mouseclick
		mov prev_value, ah
		
		cmp boxshow, 30h
		je cstat
		
		mov boxshow, 30h
		call sum_up
		call printbox
		ret
cstat:
		mov boxshow, 31h
		call sum_up
		call printbox
		ret
change_status	endp

printbox	proc near
		mov dl, printcoordx		; declare value after mouseclick
		mov dh, 11
		mov ah, 2
		int 10h
		
		mov dl, boxshow
		mov ah, 2
		int 21h
		ret
printbox	endp

sum_up	proc near
		cmp prev_value, 30h
		jne subtract
		
		mov al, addsub
		add user_sum, al ; declare value after mouseclick
		ret
subtract:
		mov al, addsub
		sub user_sum, al	; 
		ret
sum_up	endp

;; go to this after mouseclick
editbox1	proc near
		mov printcoordx, 2
		mov addsub, 128
		mov al, box1show
		mov boxshow, al
		call change_status
		mov al, boxshow
		mov box1show, al
		
		
		jmp game2_loop
editbox1	endp

editbox2	proc near
		mov printcoordx, 7
		mov addsub, 64
		mov al, box2show
		mov boxshow, al
		call change_status
		mov al, boxshow
		mov box2show, al
		
		jmp game2_loop
editbox2	endp

editbox3	proc near
		mov printcoordx, 12
		mov addsub, 32
		mov al, box3show
		mov boxshow, al
		call change_status
		mov al, boxshow
		mov box3show, al
		
		jmp game2_loop
editbox3	endp

editbox4	proc near
		mov printcoordx, 17
		mov addsub, 16
		mov al, box4show
		mov boxshow, al
		call change_status
		mov al, boxshow
		mov box4show, al
		
		jmp game2_loop
editbox4	endp

editbox5	proc near
		mov printcoordx, 22
		mov addsub, 8
		mov al, box5show
		mov boxshow, al
		call change_status
		mov al, boxshow
		mov box5show, al
		
		jmp game2_loop
editbox5	endp

editbox6	proc near
		mov printcoordx, 27
		mov addsub, 4
		mov al, box6show
		mov boxshow, al
		call change_status
		mov al, boxshow
		mov box6show, al
	
		jmp game1_loop
editbox6	endp

editbox7	proc near
		mov printcoordx, 32
		mov addsub, 2
		mov al, box7show
		mov boxshow, al
		call change_status
		mov al, boxshow
		mov box7show, al
		
		jmp game2_loop
editbox7	endp

editbox8	proc near
		mov printcoordx, 37
		mov addsub, 1
		mov al, box8show
		mov boxshow, al
		call change_status
		mov al, boxshow
		mov box8show, al
		
		jmp game2_loop
editbox8	endp

PROC BINARYFUN
new_g:
	mov ax,13h
	int 10h
	
	mov dx, offset bfinit
	call bmps
	
	call keypress
	
	mov dx, offset bfbg
	call bmps
	
	call mouseinit 
	;INITIALIZATION========
	
	mov textx, 2
	mov texty, 11
	mov printv, 30h
	call prints
	
	mov textx, 7
	mov printv, 30h
	call prints
	
	mov textx, 12
	mov printv, 30h 
	call prints
	
	mov textx, 17
	mov printv, 30h 
	call prints
	
	mov textx, 22
	mov printv, 30h 
	call prints
	
	mov textx, 27
	mov printv, 30h 
	call prints
	
	mov textx, 32
	mov printv, 30h  
	call prints
	
	mov textx, 37
	mov printv, 30h
	call prints
	
		call rand
		mov correct_answer,dl
		mov dh, 0
		mov conv, dx
		
		mov bx, 0
		mov textx, 18
		mov texty, 3
		mov printv, dl			
		call movcur
		
		call hex2dec
		 
		
	game1_loop:
	
		
	call lmouse 	;CHECK LEFTCLICK
		
	;COORDS
	mov mminx, 16
	mov mmaxx, 63
	mov mminy, 80
	mov mmaxy, 103
	mov boxno, 1
	call mousehov
	
	cmp boxno, 1
	je editbox1
	
	mov mminx, 128
	mov mmaxx, 175 
	mov boxno, 2
	call mousehov
		
	cmp boxno, 2
	je editbox2
	
	mov mminx, 193
	mov mmaxx, 239
	mov boxno, 3
	call mousehov
		
	cmp boxno, 3
	je editbox3
	
	mov mminx, 256
	mov mmaxx, 303 
	mov boxno, 4
	call mousehov
		
	cmp boxno, 4
	je editbox4
	
	mov mminx, 336
	mov mmaxx, 383  
	mov boxno, 5
	call mousehov
		
	cmp boxno, 5
	je editbox5
	
	mov mminx, 400
	mov mmaxx, 447
	mov boxno, 6
	call mousehov
		
	cmp boxno, 6
	je editbox6
	
	mov mminx, 496
	mov mmaxx, 543
	mov boxno, 7
	call mousehov
		
	cmp boxno, 7
	je editbox7
	
	mov mminx, 576
	mov mmaxx, 623
	mov boxno, 8
	call mousehov
	
		
	cmp boxno, 8
	je editbox8
	
	;EXIT============
	mov mminx, 592
	mov mmaxx, 622
	mov mminy, 8
	mov mmaxy, 23
	mov boxno, 9
	call mousehov
	
	cmp boxno, 9
	je menub

	
	jmp game1_loop
	
anotherg:
	mov ax, 3
	int 10h
	call reset
	call resetbf
	call new_g
game2_loop:
	mov dl, user_sum
	cmp correct_answer, dl
	je anotherg
	jmp game1_loop
prints:
	call movcur
	call printf
	ret

ENDP BINARYFUN

PROG4 PROC
	LEA DX, SIR
	CALL BMPS
	call keypress
	
	jmp menub
PROG4 ENDP
;==================================
; 			CALCULATOR
;==================================

proc calculator

mov ax, 3
int 10h

lea dx, txt1
mov ah, 09h
int 21h
mov bx, 0

start12:
mov ah, 01h
int 21h
cmp al,0dh      
je next1
mov ah,0        
sub al,30h      
push ax         
mov ax,10d      
mul bx          
pop bx          
add bx,ax       
jmp start12      




next1:
push bx
lea dx,msg2
mov ah,09h
int 21h

mov bx,0


start22:
mov ah,01h
int 21h
cmp al,0dh
je choice
mov ah,0
sub al,30h
push ax
mov ax,10d
mul bx
pop bx
add bx,ax 
jmp start22


choice:
lea dx, msgCh
mov ah, 09h
int 21h

mov ah, 01h
mov answer, al
int 21h

cmp al,'f'
je dividing
cmp al, 'F'
je dividing

cmp al,'a'  
je adding
cmp al,'A'  
je adding

cmp al,'s'
je subtracting
cmp al,'S'
je subtracting

cmp al,'d'
je multiplying
cmp al,'D'
je multiplying


cmp al,'x'
je gomenu
cmp al,'X'
je gomenu

error:
lea dx,msgEr
mov ah,09h
int 21h 
jmp gomenu


dividing: 
pop ax
mov dx,0
div bx
push ax
lea dx,msgDiv
mov ah,09h
int 21h 
pop ax
mov cx,0
mov dx,0
mov bx,10d
jmp break

adding:     
pop ax
add ax,bx   
push ax
lea dx,msgSum   
mov ah,09h
int 21h 
pop ax
mov cx,0
mov dx,0
mov bx,10d
jmp break   

multiplying: 
pop ax
mul bx      
push ax     
lea dx,msgMul   
mov ah,09h
int 21h 
pop ax
mov cx,0
mov dx,0
mov bx,10d
jmp break


subtracting: 
pop ax
sub ax,bx 
push ax
lea dx,msgDif
mov ah,09h
int 21h 
pop ax
mov cx,0
mov dx,0
mov bx,10d

break:
div bx
push dx
mov dx,0
inc cx
or ax,ax 
jne break 

ans:        
pop dx
add dl,30h
mov ah,02h
int 21h
loop ans

gomenu:
call keypress
call reset
call menub

endp calculator

prog5	proc near
	 mov ax, 13h
    int 10h
	
    
	call mouseinit
hovstartinfo:

	cmp boxno, 'q'
	je menu_promptinfo
	cmp boxno, 'w'
	je menu_promptinfo
	cmp boxno, 'e'
	je menu_promptinfo
	cmp boxno, 'r'
	je menu_promptinfo
	cmp boxno, 't'
	je menu_promptinfo
	mov dx, offset infoui
	call bmps
	
   
	
menu_promptinfo:
	
	call lmouse2
	cmp bx, 01
	je boxclickinfo
	jne mousehovtryinfo

boxclickinfo:		
	mov mminx, 16
	mov mmaxx, 107
	mov mminy, 117
	mov mmaxy, 199
	mov boxno, 1
	call mousehov
	
	
	mov mminx, 122
	mov mmaxx, 228
	mov boxno, 2
	call mousehov

	
	mov mminx, 274
	mov mmaxx, 391
	mov boxno, 3
	call mousehov
	
	
	mov mminx, 414
	mov mmaxx, 508
	mov boxno, 4
	call mousehov
	
	
	mov mminx,542
	mov mmaxx,635
	mov boxno, 5
	call mousehov
	
	; exit
	mov mminx, 594
	mov mmaxx, 633
	mov mminy, 3
	mov mmaxy, 11
	mov boxno, 6
	call mousehov
	
	cmp boxno, 6
	je menub
	
	
	jmp menu_promptinfo
    
	mousehovtryinfo:
	mov mminx, 16
	mov mmaxx, 107
	mov mminy, 117
	mov mmaxy, 199
	mov boxno, 'q'
	call mousehov
	
	cmp boxno, 'q'
	je hov1info
	
	mov mminx, 122
	mov mmaxx, 228
	mov boxno, 'w'
	call mousehov
	
	cmp boxno, 'w'
	je hov2info
	
	mov mminx, 274
	mov mmaxx, 391
	mov boxno, 'e'
	call mousehov
	
	cmp boxno, 'e'
	je hov3info
	
	mov mminx, 414
	mov mmaxx, 508
	mov boxno, 'r'
	call mousehov
	
	cmp boxno, 'r'
	je hov4info
	
	mov mminx,542
	mov mmaxx,635
	mov boxno, 't'
	call mousehov
	
	cmp boxno, 't'
	jne hovstartinfo
	je hov5info
	
hov1info:	
	lea dx, info1 
	call bmps
	jmp hovstartinfo
hov2info:	
	lea dx, info2 
	call bmps
	jmp hovstartinfo
hov3info:	
	lea dx, info3 
	call bmps
	jmp hovstartinfo
hov4info:	
	lea dx, info4 
	call bmps
	jmp hovstartinfo
hov5info:	
	lea dx, info5 
	call bmps
	jmp hovstartinfo		

prog5	endp

;=====================================
; 			MAIN PROGRAM			 
;=====================================
start:
	mov ax, @data
	mov ds, ax
	
;=====================================
	call PASSWORDZ
	
    ;GRAPHICS INITIALIZATION====
    mov ax, 13h
    int 10h
	
	
	mov dx, offset bg
	call bmps
	
    call keypress
	call mouseinit
hovstart:

	cmp boxno, 'q'
	je menu_prompt
	cmp boxno, 'w'
	je menu_prompt
	cmp boxno, 'e'
	je menu_prompt
	cmp boxno, 'r'
	je menu_prompt
	cmp boxno, 't'
	je menu_prompt
	mov dx, offset menu
	call bmps
	
   
	
menu_prompt:
	
	call lmouse2
	cmp bx, 01
	je boxclick
	jne mousehovtry

boxclick:		
	mov mminx, 90
	mov mmaxx, 187
	mov mminy, 23
	mov mmaxy, 72
	mov boxno, 1
	call mousehov
	
	cmp boxno, 1
	je elibrary
	
	
	mov mminx, 270
	mov mmaxx, 367
	mov boxno, 2
	call mousehov
	
	cmp boxno, 2
	je BINARYFUN
	
	mov mminx, 450
	mov mmaxx, 547
	mov boxno, 3
	call mousehov
	
	cmp boxno, 3
	je calculator
	
	mov mminx, 182
	mov mmaxx, 279
	mov mminy, 109
	mov mmaxy, 158
	mov boxno, 4
	call mousehov
	
	cmp boxno, 4
	je PROG4
	
	mov mminx, 362
	mov mmaxx, 459
	mov boxno, 5
	call mousehov
	
	cmp boxno, 5
	je prog5
	
	;exit
	mov mminx, 594
	mov mmaxx, 633
	mov mminy, 3
	mov mmaxy, 11
	mov boxno, 6
	call mousehov
	
	cmp boxno, 6
	je exit
	
	
	jmp menu_prompt
    
	
	exit:
	call reset
	; Back to text mode
    mov ah, 0
    mov al, 2
    int 10h
	
;================================
	exit2:
    mov ax, 4c00h
    int 21h
	
	mousehovtry:
	mov mminx, 90
	mov mmaxx, 187
	mov mminy, 23
	mov mmaxy, 72
	mov boxno, 'q'
	call mousehov
	
	cmp boxno, 'q'
	;jne	hovstart
	je hov1
	
	mov mminx, 270
	mov mmaxx, 367
	mov boxno, 'w'
	call mousehov
	
	cmp boxno, 'w'
	;jne hovstart
	je hov2
	
	mov mminx, 450
	mov mmaxx, 547
	mov boxno, 'e'
	call mousehov
	
	cmp boxno, 'e'
	;jne hovstart
	je hov3
	
	mov mminx, 182
	mov mmaxx, 279
	mov mminy, 109
	mov mmaxy, 158
	mov boxno, 'r'
	call mousehov
	
	cmp boxno, 'r'
	;jne hovstart
	je hov4
	
	mov mminx, 362
	mov mmaxx, 459
	mov boxno, 't'
	call mousehov
	
	cmp boxno, 't'
	jne hovstart
	je hov5
	
hov1:	
	lea dx, menuhov1 
	call bmps
	jmp hovstart
hov2:	
	lea dx, menuhov2 
	call bmps
	jmp hovstart
hov3:	
	lea dx, menuhov3 
	call bmps
	jmp hovstart	
hov4:	
	lea dx, menuhov4 
	call bmps
	jmp hovstart
hov5:	
	lea dx, menuhov5 
	call bmps
	jmp hovstart		

    END start