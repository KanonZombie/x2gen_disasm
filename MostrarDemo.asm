; A PARTIR DE ACA, LOGICA PARA MOSTRAR DEMO

	MOVE.w	ram_offsetAddressIndiceDEMO(A5), D0								; RAM C670 (0000)
	BMI.b	loc_00005E4E								; BMI � Branch on MInus (Negative)
	CMPI.w	#3, D0
	BGT.b	loc_00005E4E								; branc si es mas grande que 3 (pone en cero y cen en Nightcrawler)
	ADD.w	D0, D0
	MOVE.w	loc_00005E46(PC,D0.w), D0
	JMP	loc_00005E46-2(PC,D0.w)	;Predicted (Code-scan) (Uncertain target!)

loc_00005E46:
	dc.w	loc_00005E52-loc_00005E46+2
	dc.w	loc_00005E6C-loc_00005E46+2
	dc.w	loc_00005E86-loc_00005E46+2
	dc.w	loc_00005EA0-loc_00005E46+2

; DEMO Nightcrawler en templo???? (si, pero la primera vez no entra -????- )
loc_00005E4E:
	CLR.w	ram_offsetAddressIndiceDEMO(A5)	;Predicted (Code-scan)

loc_00005E52:
	MOVEQ	#0, D7	;Predicted (Code-scan)
	MOVE.b	ram_offsetNivelBaniMazaA1Moving_Blocks(A5), D7	;Predicted (Code-scan)
	TST.l	D7	;Predicted (Code-scan)
	LEA	$3E9A(A5), A0	;Predicted (Code-scan)
	MOVEA.l	$2(A0), A3	;Predicted (Code-scan)
	LEA	rom_offsetUbicacionArrayNightcrawler(A5), A0	;Predicted (Code-scan)
	MOVEA.l	$2(A0), A4	;Predicted (Code-scan)
	BRA.b	EjecutaDEMO	;Predicted (Code-scan)

; DEMO Cyclops en SentinelsB1 Exterior_3
loc_00005E6C:	
	MOVEQ	#0, D7	;Predicted (Code-scan)
	MOVE.b	-$3B74(A5), D7	;Predicted (Code-scan)
	TST.l	D7	;Predicted (Code-scan)		
	LEA	$3E92(A5), A0	;Predicted (Code-scan)
	MOVEA.l	$2(A0), A3	;Predicted (Code-scan)
	LEA	rom_offsetUbicacionArrayCyclops(A5), A0	;Predicted (Code-scan)
	MOVEA.l	$2(A0), A4	;Predicted (Code-scan)
	BRA.b	EjecutaDEMO	;Predicted (Code-scan)
	
; DEMO Psylocke en Avalon
loc_00005E86:	
	MOVEQ	#0, D7	;Predicted (Code-scan)
	MOVE.b	-$3B4C(A5), D7	;AvalonB2 InnerShell
	TST.l	D7	;Predicted (Code-scan)		
	LEA	$3E8A(A5), A0	;Predicted (Code-scan)
	MOVEA.l	$2(A0), A3	;Predicted (Code-scan)
	LEA	rom_offsetUbicacionArrayPsylocke(A5), A0	;Predicted (Code-scan)
	MOVEA.l	$2(A0), A4	;Predicted (Code-scan)
	BRA.b	EjecutaDEMO	;Predicted (Code-scan)
	
; DEMO Beast en SentinelsD1Exterior
loc_00005EA0:
	MOVEQ	#0, D7	;Predicted (Code-scan)
	MOVE.b	ram_offsetNivelSentinelsD1Exterior_1(A5), D7	;Predicted (Code-scan)
	TST.l	D7	;Predicted (Code-scan)		
	LEA	$3E82(A5), A0	;Predicted (Code-scan)
	MOVEA.l	$2(A0), A3	;Predicted (Code-scan)
	LEA	rom_offsetUbicacionArrayBeast(A5), A0	;Predicted (Code-scan)
	MOVEA.l	$2(A0), A4	;Predicted (Code-scan)

;------------------------------------------------
; A3: Adress con Input de control
; A4: Adress del personaje seleccionado para 1up
; D7: Id de Nivel
;------------------------------------------------
EjecutaDEMO:
	ADDQ.w	#1, ram_offsetAddressIndiceDEMO(A5)	
	MOVE.l	A4, ram_offsetAddressData1up(A5)		; RAM EAA8 mueve el configurado a address personaje
	MOVE.w	#$0900, ram_offsetSaludBack(A5)			; setea 9 en salud player 1
	MOVE.l	A3, ram_offsetFlagInputParaDEMO(A5)		
	MOVE.b	#1, ram_offsetFlagEsDEMO(A5)			
	MOVE.w	D7, ram_offsetNivelActual(A5)	

	LEA	loc_00006B2C(PC), A0						;Idem inicio de nivel
	MOVE.l	A0, -$38E8(A5)							

	LEA	loc_00006B64(PC), A0						;Idem inicio de nivel
	MOVE.l	A0, -$38EC(A5)							

	MOVE.b	#1, ram_offsetAddressFlagDesactivaSFX(A5)							;Predicted (Code-scan)

	MOVE.l	D7, D0									;Predicted (Code-scan)
	ASL.w	#3, D0									;Predicted (Code-scan)
	LEA	ram_offsetArrayNiveles(A5), A0				;Predicted (Code-scan)

	MOVEA.l	$4(A0,D0.w), A1	;Predicted (Code-scan)

	JSR	(A1)	;Predicted (Code-scan) (Uncertain target!)

	CLR.b	ram_offsetAddressFlagDesactivaSFX(A5)	;Predicted (Code-scan)
	JSR	$4ACA(A5)	;loc_001E2C3E
	TST.b	-$38C6(A5)	;Predicted (Code-scan)
	BEQ.b	loc_00005F0C	;Predicted (Code-scan)
	ORI.w	#2, ram_C5A2_FlagCheats(A5)	;Predicted (Code-scan)
loc_00005F0C:
	JSR	SetearValoresIniciales(PC)	;Predicted (Code-scan)

LoopearInicioNivel:
	CLR.b	-$38C2(A5)						; RAM C93E
	BRA.w	InicioNivel					; inicio nivel loop

