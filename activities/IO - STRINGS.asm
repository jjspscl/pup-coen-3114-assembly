.model small

.stack 100h
.data

buff        db  26        ;max char
            db  ?         ;place holder for required input
            db  26 dup(0) ;-26

            .code
main:
            mov ax, @data
            mov ds, ax              

;input                               
            mov ah, 0Ah 		;get string
            mov dx, offset buff
            int 21h 
				

;replace CHR(13) by '$'.
            mov si, offset buff + 1 ;input char
            mov cl, [ si ] ;lenght
            mov ch, 0      ;reset for cx
            inc cx ;13
            add si, cx ;chr13 string pointer
            mov al, '$'
            mov [ si ], al ;replace chr13 to 'S'            

;output                   
            mov ah, 9 ;out
            mov dx, offset buff + 2 ;end if string ended in '$'
            int 21h

            mov ah, 4ch
            int 21h

            end main