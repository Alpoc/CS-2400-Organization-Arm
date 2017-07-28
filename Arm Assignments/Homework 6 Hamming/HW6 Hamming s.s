;Dalton Wiebold

	AREA Homework6, CODE, READONLY
	ENTRY
	EXPORT main
;--------------------------------------------
;--------------------------------------------
main
	LDR		R1, =HCode -1
	MOV		R2, #1				;R2 is our counter register
	MOV		R7, #0				;its already zero but we make 0 to make sure

ErrorDet
	LDRB	R4, [R1, R2]		;R4 <- [R1 + R2]
	CMP		R4, #'0'
	BEQ		IsZero
	CMP		R4, #'1'
	BEQ		IsOne
	B		DoneErrDet

IsZero
	ADD		R2, R2, #1	
	B		ErrorDet
IsOne
	EOR		R7, R7, R2
	ADD		R2, R2, #1
	B		ErrorDet
;--------------------------------------------	
DoneErrDet
	CBZ		R7, DoneErrCorrect
	LDRB	R4, [R1, R7]
	
	CMP		R4, #'0'
	BEQ		yesZero
	MOV		R4, #'0'
	B		Store
yesZero	
	MOV		R4, #'1'
Store
	STRB	R4, [R1, R7]
;-------------------------------------------	
DoneErrCorrect
	MOV		R2, #1
	LDR		R3, =ScrWord - 1
	MOV		R4, #1
	MOV		R5, #1
	
Loop
	LDRB	R6, [R1, R2]	;[R6] <LDRB- [[R1]+[R2]]
	CMP		R6, #0x0
	BEQ		Done
	CMP		R2, R5
	BEQ		Equal
	STRB	R6, [R3, R4]	;[[R3]+[R4]] <STRB- [R6]
	ADD		R4, R4, #1		;R4++
MID	
	ADD		R2, R2, #1
	B		Loop
	
	
Equal	
	MOVS	R5, R5, LSL #1
	B		MID
Done
	STRB	R6, [R3, R4]	;storing 0 into it for good practice
;--------------------------------------------
;--------------------------------------------
end_program
	MOV		R0, #0x18
	LDR		R1, =0x20026
	SVC		#0x11
;--------------------------------------------
;--------------------------------------------
	AREA	Homework6Data, DATA, READWRITE

MAX_LEN	EQU		0x64
	
HCode	DCB		"010011100101", 0
		ALIGN
			
ScrWord	SPACE MAX_LEN
	

;------------------------------
adrHCode	DCD		HCode
adrScrWord	DCD		ScrWord	
		ALIGN

		EXPORT	adrHCode
		EXPORT	adrScrWord
		
		END