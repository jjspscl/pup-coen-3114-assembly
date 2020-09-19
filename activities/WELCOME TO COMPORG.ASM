.MODEL SMALL
.CODE
ORG 100H

S:JMP MAIN                         ;JUMP TO MAIN PROCEDURE
        A DB "ENTER PASSWORD:$"    ;STRING DECLARATIONS
        B DB 10,13,"WELCOME TO COMPORG ASSEMBLY LANGUAGE PROGRAMMING$"
        C DB 10,13,"INVALID CODE$"
        
                           

MAIN    PROC NEAR

        MOV AX,03       ;CLEARS THE SCREEN
        INT 10H

        MOV AH,9        ;STRING OUTPUT
        LEA DX,A        ;LOAD EFFECTIVE ADDRESS(LEA)-IT LOADS THE VARIABLE HOLDING THE STRING
        INT 21H                       
        MOV AH,8        ;INPUT WITHOUT ECHO
        INT 21H
        MOV BL,AL       ;BL=1ST CHARACTER
        MOV AH,8       ;INPUT WITHOUT ECHO
        INT 21H
        MOV CL,AL       ;CL-2ND INPUT
        MOV AH,8       ;CHARACTER INPUT WITHOUT ECHO
        INT 21H
        MOV DH,AL       ;DH-3RD CHARACTER

        CMP BL,'P'      ;COMPARES THE 3-INPUT CHARACTERS
        CMP CL,'U'
        CMP DH,'P'
        JNE INV         ;IF NOT EQUAL JUMP TO INV
        JE VAL          ;IF EQUAL JUMP TO VAL                     

INV:
        MOV AH,9        ;DISPLAYS THE 3RD STRING
        LEA DX,C
        INT 21H
        JMP EXIT

VAL:                   ;DISPLAYS THE 2ND STRING
        MOV AH,9
        LEA DX,B
        INT 21H

EXIT:  INT 20H           ;END OF PROGRAM

MAIN ENDP              ;END MAIN PROCEDURE
END S                  ;END THE ENTIRE PROGRAM


