;	Dalton Wiebold
;	Homework 4 part 2

	AREA StringMixer, CODE, READONLY
	ENTRY 
	EXPORT main
		
;-------------------------------------------------
main

	LDR		R1,	=StrOne
	LDR		R2, =StrTwo
	LDR 	R3, =MixStr
;-------------------------------------------------	
loop_one
	LDRB	R4, [R1], #1	;loading first char into temp reg
							;and move counter forward one
	CBZ		R4, Done_strOne	;checking if sting one is done
	;CMP		R4, #0
	;BEQ		Done_strOne
	STRB	R4, [R3], #1	;[[R3]] <- [R4]. from temp to mixstr r3++
	LDRB	R4, [R2], #1	;first StrTwo into tmp r2++
	CBZ		R4, Done_strTwo	;is strTwo empty?
	STRB	R4, [R3], #1
	B		loop_one
	

;-------------------------------------------------
Done_strOne
	LDRB	R4,	[R2], #1
	CBZ		R4, DONE
	STRB	R4, [R3], #1
	B		Done_strOne

Done_strTwo
	LDRB	R4, [R1], #1
	CBZ 	R4, DONE
	STRB	R4, [R3], #1
	B		Done_strTwo

DONE
	MOV      R0, #0x18		
	LDR      R1, =0x20026	
	SVC		 #0x11	
	
	ALIGN
;-------------------------------------------------
	AREA 	StringMixerData, DATA, READWRITE
		
StrOne	DCB		"Hello Metro State!", 0
StrTwo	DCB		"I like assembly programming."
		ALIGN

MAX_LEN	EQU	0x64		;symbolic name
;EQU		0	;MAYBE USE THIS covered in class but not sure. check later
MixStr	SPACE	MAX_LEN + 1	;the sum of both words will not be greater


adrStrOne	DCD		StrOne
adrStrTwo	DCD		StrTwo
adrMixStr	DCD		MixStr
	ALIGN
	
	EXPORT	adrStrOne
	EXPORT	adrStrTwo
	EXPORT	adrMixStr
		
	END
