;Dalton Wiebold

	AREA	Homework5, CODE, READONLY
	ENTRY
	EXPORT	main
;----------------------------------------------	
main
	LDR		R1,  =HexStr		;load hexString into R1
	BL		Hexa2Bin				;converts HexStr to binary R2 is the rusult register
	LDR		R4, =TwosComp		;changed from R2 on spec
	LDR		R10, =RvsDecStr
	LDR		R9,  =DecStr		;load decimal string into R9

	STR		R2, [R4]			;changed to R4. Flow chart is R3
	TST		R2,	#0x80000000		;testing to see if negative. TS changed from R4
	BEQ		Reverse				;Branch if possitive - Z flag is set

;-----------------------------------------------
; R2 is negative section
	MOV		R6, #'-'			;if its negative the add a negative symbol twosComp
	STRB	R6, [R9], #1
	MVN		R2, R2				;flow chart: MVN [R2]
	ADD		R2, R2, #1			;flow chart: ADD [R2] <- [R2] + 1
;-----------------------------------------------	

Reverse
	MOV		R4, #0
	;added this for spec. to clear out twosComp
Reverse_loop
	BL		Divide
	ADD		R2, R2, #'0'		;R2 is the remainder. adding '0' to make ascii
	STRB	R2, [R10], #1		;Storing ascii in RDec and incrementing 1      !!!!!!!R2, R5 ???
								;[[R10]] <STRB- [R2], [R10]++
	MOV		R2, R5				;moving the quotient onto r2
	CMP		R2, #0
	BNE		Reverse_loop
;-------------------------------------------------------------------
;-------------------------------------------------------------------
DoneRev
	LDR		R11, =RvsDecStr		;changing rvs decimal to this guy, becuase flow chat
	
Loop_dec
	SUB		R10, R10, #1		;decrement old Rvs by 1
	LDRB	R2, [R10]
	STRB	R2, [R9], #1		;storing into decStr, increment by 1
	CMP		R10, R11
	BHI		Loop_dec
	
;----------------------------------------------
;----------------------------------------------
end_main
	MOV		R0, #0x18
	LDR		R1, =0x20026
	SVC		#0x11
;-----------------------------------------------------------------------
;-----------------------------------------------------------------------
Hexa2Bin		
	MOV R2, #0	;clear result register

Loop_Hex2Bin
	LDRB R3, [R1], #1 ;changed from r9. load first byte of hexstr
	CMP R3, #0x0		;Testing to see if 0x0
	BEQ	DONE_Hex2Bin	;could use CBZ
	SUB R3, R3, #'0'	;convert ascii to digitssss

	CMP R3, #0		;Testing if lower than '0'
	BLO ToAscii
	CMP R3, #9		;Is a digit!
	BHI ToAscii		;changed from BLO
	B	Shifting
		
ToAscii
	ADD R3, R3, #'0'	;convert back to ascii
	SUB R3, R3, #'A'	;convert hex range A-F
	CMP R3, #0		;is it lower then 0 (10)
	BLO InvalidHex	;not a valid hexadecimal digit
	CMP R3, #5		;is it higher then 5(15)
	BHI InvalidHex	;not a valid hexadecimal digit
	ADD R3, R3, #10	;adjust to hex values
	
Shifting

;---------------------------------------------------
	MOVS R2, R2, LSL #4
	ADDS R2, R2, R3
	B	Loop_Hex2Bin	;trying both 
	
InvalidHex
	MOV R2 ,#0xFFFFFFFF	;Changed from 0x00000000??

DONE_Hex2Bin
	BX	LR	;return statement for hex2bin
	ALIGN
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;Divide By 10 Subroutine
;used the logic from arm division.s from blackboard
;R2 is the Remainder... as said on flow
;R5 is the Quotient.... a deviation from the flow
Divide
	MOV		R5, #0		;R5 will be the result register AKA Quotient
					
Loop_Divide
	CMP		R2, #10		;since we are dividing by 10 we can stop once the remainder is < 10
						;if this was division by any other number we would compaire to that number
	BLO		Division_Done
	SUB		R2, R2, #10	;subtracting 10 or dividing by 10 once
	ADD		R5, R5, #1	;adding one is our counter. so how many times we can divide is the counter
						;So, if we can 
	B		Loop_Divide
	
Division_Done
	BX	LR				;branch back to where called from will retaining register values
	
	ALIGN				;needed to get rid of padding warning
	

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
	AREA	Homework5Data, DATA, READWRITE
	
HexStr
	DCB		"80000000", 0	;null terminated string
	ALIGN
		
TwosComp
	DCD		0			;initialize signed word as 0
	ALIGN
		
DecStr
	SPACE	12			;reserved a chung of zeroed memory with a length of 12 bytes
	ALIGN

RvsDecStr
	SPACE	11			;11 bytes of zeroed memory
	ALIGN
		
;-------------------------------------------------------
adrHexStr		DCD		HexStr	
adrTwosComp		DCD		TwosComp
adrDecStr		DCD		DecStr		
adrRvsDecStr	DCD		RvsDecStr
		EXPORT	adrHexStr
		EXPORT	adrTwosComp
		EXPORT	adrDecStr
		EXPORT	adrRvsDecStr
		ALIGN
		
		END	