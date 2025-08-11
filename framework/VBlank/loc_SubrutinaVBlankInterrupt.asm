;-------------------------------------------------------------
loc_SubrutinaVBlankInterrupt:
;-------------------------------------------------------------
	LINK	A6, #0
	MOVE.l	D7, -(A7)								; push d7
	MOVE.b	-$3A0C(A5), D7							; d7 = varX
	JSR	rom_offsetLecturaPads(A5)					; lee joypads
	ADDQ.l	#1, -$3A10(A5)							; varY++
	TST.l	-$3A14(A5)								; TeST an operand, V clear, C clear, Z clear si !=0, N clear si positivo, X unchanged	
	BEQ.b	loc_001FDCE8							; branch if Z flag is set (si hay address carga en a0 y ejecuta)
	MOVEA.l	-$3A14(A5), A0							; a0 = varY
	JSR	(A0)										; jmp ^  0000531A - 52EA (Sega Screen)
loc_001FDCE8:										
	TST.b	-$38C0(A5)								; Si -$38C0(A5)	no esta vacio
	BNE.b	loc_001FDD00							; branch if Z is clear 
	TST.b	-$359E(A5)								; Si -$38C0(A5)	no esta vacio
	BNE.b	loc_001FDD00
	TST.l	-$3A18(A5)								; comprueba 3A18 y si tiene address seteada ejecuta
	BEQ.b	loc_001FDD00							;
	MOVEA.l	-$3A18(A5), A0							;
	JSR	(A0)										; si -$38C0(A5) y -$38C0(A5) estan vacios y -$3A18(A5) no esta vacio
loc_001FDD00:
	CLR.b	-$3A0A(A5)
	MOVE.l	-$4(A6), D7								; pop d7 a lo villero
	UNLK	A6
	RTS