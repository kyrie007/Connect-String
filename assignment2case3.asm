ORG 0H
SJMP MAIN
STRING1: DB "SS77777"
DB 0
STRING1_L: DB 7
STRING2: DB "E"
DB 0
STRING2_L: DB 1

STRCPY:;get the string
MOV A,#00H ;give A = 0
MOVC A,@A+DPTR ; A point to DPTR where string is
CJNE A, #00H, CNT; judge if the string is NULL, if not goto CNT
MOV A,R2 ; A <- R2; here R2 represent the length of the string
RET ; quit

CNT:;continue to send char one by one to R0
MOV @R0,A ; (R0) <- A
MOV A,R2 ; A <- R2
INC A ; A++
MOV R2,A ; R2 <- A ;R2++ R2 represent the current length of the string
INC R0 ;R0 point to the next address
INC DPTR ;dptr point to next address
JMP STRCPY

STRCONCAT:;copy string1 to R0 then copy string 2 to R0 
MOV R2,#00H;initialize R2(length) to 0
MOV DPTR,#STRING1
Call STRCPY
MOV DPTR,#STRING2
Call STRCPY
RET

TESTSTRING: 
Call STRCONCAT
MOV DPTR,#STRING1_L;check if length is right
MOV A,#00H
MOVC A,@A+DPTR
MOV R4,A
MOV A,R2
SUBB A,R4
MOV R2,A ;A = R2 - R4 ; here A should be total length - string1_length
MOV DPTR, #STRING2_L;check if length is right
MOV A,#00H
MOVC A,@A+DPTR
MOV R4,A
MOV A,R2
SUBB A,R4 ;A = R2- R4
CJNE A,#00H,ERROR; if after subb, length A is not 0 ,goto ERROR
MOV R0, #60H
MOV DPTR,#STRING1
MOV A,#00H
MOVC A,@A+DPTR
CJNE A,#00H,FOR1
JMP TOANOTHER

FOR1:; check if the content is same
MOV R4,A ;R4 <- A 
MOV A,@R0 ;A <- (R0) ;(R0) is the content in R0 location
SUBB A, R4 ; A = A-R4 = (R0) - R4
CJNE A,#00H,ERROR ; if A not 0,goto ERROR
INC R0 ;R0++ ;point to next address
INC DPTR ;point to next address
MOV A,#00H
MOVC A,@A+DPTR
CJNE A,#00H,FOR1 ; if A is not 0, continue loop


TOANOTHER: ; point to string2
MOV A,#00H
MOV DPTR,#STRING2
MOVC A,@A+DPTR
CJNE A,#00H,FOR2 ; if A is not 0, goto FOR2
JMP SUCCESS

FOR2: ; same like FOR1
MOV R4,A  
MOV A,@R0
SUBB A, R4
CJNE A,#00H,ERROR
INC R0
INC DPTR
MOV A,#00H
MOVC A,@A+DPTR
CJNE A,#00H,FOR2
JMP SUCCESS

MAIN:
MOV R0, #60H
Call TESTSTRING 
SUCCESS: SJMP SUCCESS 
ERROR: SJMP ERROR
END