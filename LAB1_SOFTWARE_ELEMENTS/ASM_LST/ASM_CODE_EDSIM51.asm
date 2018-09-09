;TITLE: USE SHIFT INSTRUCTION TO IMPLEMENT MULTIPLY AND DIVIDE INSTRUCTION
; AUTHOR: VIKRANT WAJE
; DATE: 2 SEPTEMBER 2018
; TOOLS USED: EDSIM51

	ORG 0000 ; Code written from 0000H onwards
	X EQU 2AH
	Y EQU 02H
	Y4 EQU 20H
	REMAINDER EQU 22H
	QUOTIENT EQU 21H
	Z EQU 23H
	ERRORCODE EQU 30H
	NOERROR EQU 00H
	DIVIDEBYZERO EQU 01H
	OVERFLOW EQU 02H
	MOV R4,#4 ; Move multiplier of 4 into Accumulator 
	MOV B,#Y ; Move Y into B register
	MOV R5,#0; Counter
	MOV R2,#2 ; Value of multiplier 2
	MOV R3,B ;Keep Backup of B into R3
UP:MOV A,R4; Recover the original value
	INC R5; Increment counter value
	MOV R4,A; Keep Backup of A
	MOV A,R5; Move R5 into accumulator for multiplying by 2
	ADD A,R5; Multiplying counter value by 2
	MOV R2,A; Storing the multiplied value into R2
	MOV A,R4; Restoring the value of accumulator
	SUBB A,R2; Subtract multiplied value from accumulator
	MOV R0,A; store the result/count value in register R0 which will act as a remainder
	SUBB A,R2; Subtract the multiplied value from already subtracted value to know whether next iteration is possible
	JZ DOWN; Jump to DOWN if result is zero
	JNC UP; If result is not negative, jump up
DOWN:MOV A,R5; Giving the incremented counter value to accumulator
	MOV R3,A;COUNTER
	MOV A,B; Move the value of Y into accumulator
MULT1:CLR C; Clear the carry flag
	RLC A; Rotate the accumulator left to multiply by 2
	JC OFLOW
	DJNZ R3,MULT1 ; Decrement and jump to MULT1 until zero
	MOV R1,A; Store the result in R1
MULT2:ADD A,B; Add the result to remainder 
	JC OFLOW
	DJNZ R0,MULT2; Decrement the counter until zero and jump back
	MOV B,A; Get value of Y into B
	JNZ SKIP
	MOV R0,#ERRORCODE; Move the address 0x30 into R0
	MOV A,#DIVIDEBYZERO
	MOV @R0,A

	SJMP ENDLOOP
SKIP:	MOV R0,#Y4; Make R0 as pointer to address 0x20
    MOV @R0,B; Move the divisor Y*4 into 0x20




	MOV A,#X; Get value of X into Accumulator
	MOV R0,A; Take backup of Accumulator into R0
	MOV R1,#0; Initialise a counter
DIVIDE:MOV A,R0; Restore the value of accumulator which changes from second iteration onwards
	SUBB A,B;; Subtract Divisor from dividened
	MOV R0,A; Move the remainder from accumulator to R0
	SUBB A,B; Subtract the value to know whether the next iteration will follow
	INC R1; Increment the counter
	JNC DIVIDE; If no carry, jump to DIVIDE
	MOV A,R0; Move remainder to accumulator
	MOV R0,#REMAINDER
	MOV @R0,A; Move Remainder to 0x21
	MOV A,R1; Take Quotient
	MOV R0,#QUOTIENT; Make R0 to point to address 0x22
	MOV @R0,A; Move Quotient to address 0x22
	MOV R0,#Z; Move the address 0x23 into R0
	MOV @R0,A; Move the result into address 0x23
	MOV A,#NOERROR; Successful execution, write 00H into internal RAM 30H
	MOV R0,#ERRORCODE; Move the address 0x30 into R0
	MOV @R0,A
	SJMP ENDLOOP; Emulating while loop
OFLOW: MOV R0,#Z; When the result is above 8 bits
		MOV @R0,A;
		MOV R0,#ERRORCODE
		MOV A,#OVERFLOW
		MOV @R0,A

ENDLOOP:
;
	MOV R5,#1
	JNZ ENDLOOP	
	
