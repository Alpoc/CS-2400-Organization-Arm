;	Dalton Wiebold
;	Homework 4 Hex to Binary
	
	AREA     Hex2Bin, CODE, READONLY
	ENTRY						;Mark first instruction to execute
	EXPORT	main				;required by the startup code
		
;---------------------------------------------------
main				;Required for all arm
	
	LDR R9, =a	;[R9] = a's address
	BL	Hexa2Bin
	TST R3, #0x80000000		;is [R2]'s MSB negative?
	BNE DONE		;[R2]'s MSB is 1! Exit
	MVN R6, R2	;[R6]<--a's 1's complement
	ADD R6, R6, #1	;[R6]<--a's 2's complement making it negative?

	LDR R9, =b		;load b into R9
	BL	Hex2Bin		;why BL and not B?********************************
	TST R3, #0x80000000		;is [R2]'s MSB negative?
	BNE	DONE
	MOV R7, R2		;[R7]<--b's 2's complement
	
	ADD R6, R6, R7	;[R7]<- (-a) + b	
	LDR R8, =RESULT
	STR R7, [R8]	;store a + (-b) at result. why -b


	

DONE	SWI 0x11		;terminate program
;---Block 1 ----------------------------------------
	
Hexa2Bin		
	MOV R2, #0	;clear result register

Loop_Hex2Bin
	LDRB R3, [R9], #1 ;load first byte of word
	CMP R3, #0x0		;Testing to see if 0x0
	BL	DONE_Hex2Bin
	
	CMP R3, #0		;Testing if lower than '0'
	BLO InvalidHex
	CMP R3, #9		;Is a digit!
	BLO OneThroughNine
	CMP R3, #'A'
	BLO InvalidHex
	CMP R3, #'F'
	BHI InvalidHex
	SUB R3, R3, #'A'	;converting to Bin 10-15
	ADD R3, R3, #10		;again converting to Bin 10-15
	BL	DONE_Hex2Bin
	
	
OneThroughNine
	SUB R3, R3, #'0'	;Converting to Bin 1-9
InvalidHex
	MOV R3 ,#0x00000000	;Invalide so we set result to 0x0

DONE_Hex2Bin
	BX	LR	;return statement for hex2bin
	ALIGN
;---------------------------------------------------
	AREA	Hex2Bin, DATA, READWRITE
		
a	DCB	"A8F", 0	;"null-terminated string" a

		
b	DCB	"7E0C5", 0	;"null-terminated string" b
	ALIGN
		
RESULT
	DCD		0
		
;-----------------------------------		
adrA		DCD		a		;needed to show a in address window
adrB		DCD		b		;for b to show in address window
	
adrR		DCD		RESULT	;needed to show result

	EXPORT	adrA		;also needed to show a in address window
	EXPORT	adrB		;same same
	EXPORT	adrR		;needed to show result
	
	END
		