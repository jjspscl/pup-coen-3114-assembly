.MODEL SMALL
.CODE
ORG 100H


S:JMP MAIN

x DB "ENTER PASSWORD:$"
y DB 10,13,"PASSWORD ACCEPTED!!$"
z DB 10,13,"BAWAL MANGHACK$"
a DB ?
l DB ?


MAIN PROC NEAR

MOV AX,03
INT 10H

MOV AH,9
LEA DX,x
INT 21H

MOV AH,8
INT 21H
MOV BL,AL

MOV DL,'*'
MOV AH,2
INT 21H

MOV AH,8
INT 21H
MOV CL,AL

MOV DL,'*'
MOV AH,2
INT 21H

MOV AH,8
INT 21H
MOV DH,AL

MOV DL,'*'
MOV AH,2
INT 21H

MOV AH,8
INT 21H
MOV a,AL

MOV DL,'*'
MOV AH,2
INT 21H

MOV AH,8
INT 21H
MOV l,AL

MOV DL,'*'
MOV AH,2
INT 21H


CMP BL,'A'
CMP CL,'L'
CMP DH,'V'
CMP a,'I'
CMP l,'N'
JNE INV
JE VAL

INV:
MOV AH,9
LEA DX,z
INT 21H
JMP EXIT

VAL:
MOV AH,9
LEA DX,y
INT 21H

EXIT:   
INT 20H

MAIN ENDP
END S





