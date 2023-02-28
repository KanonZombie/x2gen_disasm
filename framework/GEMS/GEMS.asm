*
* gemsholdz80 - take the z80 bus
*

PedirAccesoZ80ConEspera:
	MOVE.w	#$0100, z80_BUSREQ_port		; 0x0100, 0x00A11100 - Request access to the Z80 bus, by writing 0x0100 into the BUSREQ port
	@EsperarAccesoZ80:
		BTST.b	#0, z80_BUSREQ_port		; Test bit 0 of A11100 to see if the 68k has access to the Z80 bus yet
		BNE.b	@EsperarAccesoZ80
	RTS

*
* gemsreleasez80 - release the z80 bus
*
LiberarZ80:
	MOVE.w	#0, z80_BUSREQ_port			; 0x0000 -> 0x00A11100 Release control of bus
	RTS

*
* gemsdmastart - tell the z80 we want to do dma
*
loc_001FE3F6:
	MOVE	SR, -(A7)
	ORI	#$0700, SR
loc_001FE3FC:
	MOVE.w	#$0100, z80_BUSREQ_port
loc_001FE404:
	BTST.b	#0, z80_BUSREQ_port
	BNE.b	loc_001FE404
	MOVE.b	#1, $00A01B20
	MOVE.b	$00A01B21, D0
	MOVE.w	#0, z80_BUSREQ_port
	TST.b	D0
	BEQ.b	loc_001FE430
	MOVEQ	#$00000044, D0
loc_001FE42A:
	DBF	D0, loc_001FE42A
	BRA.b	loc_001FE3FC
loc_001FE430:
	MOVE	(A7)+, SR
	RTS

loc_001FE434:
	MOVE	SR, -(A7)
	ORI	#$0700, SR
	JSR	PedirAccesoZ80ConEspera(PC)
	MOVE.b	#0, $00A01B20
	JSR	LiberarZ80(PC)
	MOVE	(A7)+, SR
	RTS

*
* gemsloadz80 - bus request the z80 and download the code between Z80CODE and Z80END
*
loc_001FE44E:
	MOVE.l	A1, -(A7)					; push a1
	MOVE	SR, -(A7)					; push sr
	ORI	#$0700, SR
	MOVE.w	#$0100, z80_Reset_port		; #0x0100, 0x00A11200 - Hold the Z80 in a reset state, by writing 0x0100 into the RESET port
	JSR	PedirAccesoZ80ConEspera(PC)
	LEA	DriverZ80(PC), A0
	LEA	DriverZ80_FIN-1(PC), A1
	MOVE.l	A1, D0						; calcula cantidad de bytes
	SUB.l	A0, D0						; entre DriverZ80
	SUBQ.w	#1, D0						; y DriverZ80_FIN
	LEA	z80_RAM_start, A1

	loc_001FE476:
		MOVE.b	(A0)+, (A1)+				; copia lo de DriverZ80 a z80 ram
		DBF	D0, loc_001FE476

	loc_001FE47C:
		MOVE.b	#0, (A1)+					;pone 0 hasta el final de la z80 ram
		CMPA.l	#z80_ram_end, A1			
		BNE.b	loc_001FE47C

	MOVE	(A7)+, SR					; pop sr
	MOVEA.l	(A7)+, A1					; pop a1
	RTS

;gemsstartz80
loc_001FE48E:
	MOVE	SR, -(A7)					; push SR
	ORI	#$0700, SR
	MOVE.w	#0, z80_Reset_port			; 0x0000 -> 0x00A11200 Release reset state
	MOVEQ	#$0000000F, D0
	loc_001FE49E:
		SUBQ.l	#1, D0						;wait?
		BNE.b	loc_001FE49E
	MOVE.w	#0, z80_BUSREQ_port			; 0x0000 -> 0x00A11100 Release control of bus
	MOVE.w	#$0100, z80_Reset_port		; 0x0100, 0x00A11200 - Hold the Z80 in a reset state, by writing 0x0100 into the RESET port
	MOVE	(A7)+, SR					; pop SR
	RTS

;--------------------------------------------------------------------------------
ObtenerValor36DeZ80RAM:
;	Obtiene y pone en d1 el valor en z80 ram 0036
;	deja A00036 en a0, A01B40 en a1, cosas en stack
;	z80 tomado
;--------------------------------------------------------------------------------
	MOVEA.l	(A7)+, A0					; pop A0		

	LINK	A6, #0

	MOVEM.l	A1/D1, -(A7)				; push
	MOVE	SR, -(A7)					; push
	MOVE.l	A0, -(A7)					; push

	LEA	$00A00036, A0					; $A00000-$A0FFFF Espacio de memoria Z80 64kb
	LEA	$00A01B40, A1
	ORI	#$0700, SR						; DeshabilitarInterrupciones

	; duplicado de PedirAccesoZ80ConEspera
	MOVE.w	#$0100, z80_BUSREQ_port		; #0x0100, 0x00A11100 - Request access to the Z80 bus, by writing 0x0100 into the BUSREQ port
	@EsperarAccesoZ80_2:
		BTST.b	#0, z80_BUSREQ_port		; Test bit 0 of A11100 to see if the 68k has access to the Z80 bus yet
		BNE.b	@EsperarAccesoZ80_2

	MOVE.b	(A0), D1					;  d1
	EXT.w	D1
	RTS
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; aca termina lo que empez� en ObtenerValor36DeZ80RAM
ObtenerValor36DeZ80RAM_parte3:
	MOVE.w	#0, z80_BUSREQ_port			; 0x0000 -> 0x00A11100 Release control of bus
	MOVE	(A7)+, SR					; pop
	MOVEM.l	(A7)+, D1/A1				; pop
	UNLK	A6							
	RTS
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; aca continua lo que empez� en ObtenerValor36DeZ80RAM
ObtenerValor36DeZ80RAM_parte2:
	MOVE.b	#$FF, (A1,D1.w)		; mueve FF a 00A01B40 + d1
	ADDQ.b	#1, D1				; d1 + 1
	ANDI.b	#$3F, D1			; blanquea d1 menos los 6 ceros finales

loc_001FE50A:
	MOVE.b	D0, (A1,D1.w)		; mueve d0 (36?) a 00A01B40 + d1
	ADDQ.b	#1, D1				; d1 + 1
	ANDI.b	#$3F, D1			; blanquea d1 menos los 6 ceros finales
	MOVE.b	D1, (A0)			; d1 -> z80ram 0036 (pos original)
	RTS
;--------------------------------------------------------------------------------

loc_001FE518:
	JSR	ObtenerValor36DeZ80RAM(PC)
	MOVE.l	$8(A6), D0
	JSR	loc_001FE50A(PC)
	JMP	ObtenerValor36DeZ80RAM_parte3(PC)
loc_001FE528:
	JSR	ObtenerValor36DeZ80RAM(PC)
	MOVE.l	$8(A6), D0
	JSR	loc_001FE50A(PC)
	ASR.l	#8, D0
	JSR	loc_001FE50A(PC)
	ASR.l	#8, D0
	JSR	loc_001FE50A(PC)
	JMP	ObtenerValor36DeZ80RAM_parte3(PC)

*
* gemsinit - initialize the z80 and send pointers to data in 68000 space
*
* stack frame after the link:
*         +------------------+
*         +   sampbankptr    +  00pppppp
*  +20    +------------------+
*         +    seqbankptr    +  00pppppp
*  +16    +------------------+
*         +    envbankptr    +  00pppppp
*  +12    +------------------+
*         +   patchbankptr   +  00pppppp
*  +8     +------------------+
*         +  return address  +
*  +4     +------------------+
*         +    previous a6   +
*    a6-> +------------------+
loc_001FE544:
	LINK	A6, #0
	JSR	loc_001FE44E(PC)			; hold reset, llena z80 RAM
	JSR	loc_001FE48E(PC)			; release request, rest. hold reset
	MOVEQ	#-1, D0
	MOVE.l	D0, -(A7)
	JSR	loc_001FE518(PC)
	MOVEQ	#$0000000B, D0
	MOVE.l	D0, -(A7)
	JSR	loc_001FE518(PC)
	MOVE.l	$8(A6), -(A7)			; patchbankptr loc_001618BC
	JSR	loc_001FE528(PC)
	MOVE.l	$C(A6), -(A7)			; envbankptr loc_00163BF2
	JSR	loc_001FE528(PC)
	MOVE.l	$10(A6), -(A7)			; seqbankptr 001641BE
	JSR	loc_001FE528(PC)
	MOVE.l	$14(A6), -(A7)			; sampbankptr loc_0017B8AA
	JSR	loc_001FE528(PC)
	UNLK	A6
	RTS


loc_001FE584:									; Siberia Blizzard
	JSR	ObtenerValor36DeZ80RAM(PC)
	TST.b	ram_offsetAddressFlagDesactivaSFX(A5)
	BNE.w	ObtenerValor36DeZ80RAM_parte3		; salida de loop?
	MOVEQ	#$00000010, D0
loc_001FE592:
	JSR	ObtenerValor36DeZ80RAM_parte2(PC)
	MOVE.l	$8(A6), D0
	JSR	loc_001FE50A(PC)
	JMP	ObtenerValor36DeZ80RAM_parte3(PC)
loc_001FE5A2:
	JSR	ObtenerValor36DeZ80RAM(PC)
	TST.b	ram_offsetAddressFlagDesactivaSFX(A5)
	BNE.w	ObtenerValor36DeZ80RAM_parte3
	MOVEQ	#$00000012, D0
	BRA.b	loc_001FE592
	NOP
loc_001FE5B4:
	JSR	ObtenerValor36DeZ80RAM(PC)
	TST.b	ram_offsetAddressFlagDesactivaSFX(A5)
	BNE.w	ObtenerValor36DeZ80RAM_parte3
	MOVEQ	#$00000020, D0
	BRA.b	loc_001FE592
	NOP
loc_001FE5C6:
	JSR	ObtenerValor36DeZ80RAM(PC)
	TST.b	ram_offsetAddressFlagDesactivaSFX(A5)
	BNE.w	ObtenerValor36DeZ80RAM_parte3
	MOVEQ	#$0000000C, D0
	JSR	ObtenerValor36DeZ80RAM_parte2(PC)
	JMP	ObtenerValor36DeZ80RAM_parte3(PC)
loc_001FE5DC:
	JSR	ObtenerValor36DeZ80RAM(PC)
	TST.b	ram_offsetAddressFlagDesactivaSFX(A5)
	BNE.w	ObtenerValor36DeZ80RAM_parte3
	MOVEQ	#$0000000D, D0
	JSR	ObtenerValor36DeZ80RAM_parte2(PC)
	JMP	ObtenerValor36DeZ80RAM_parte3(PC)
loc_001FE5F2:
	JSR	ObtenerValor36DeZ80RAM(PC)
	TST.b	ram_offsetAddressFlagDesactivaSFX(A5)
	BNE.w	ObtenerValor36DeZ80RAM_parte3
	MOVEQ	#$00000016, D0				; d0 = 0x16
	JSR	ObtenerValor36DeZ80RAM_parte2(PC)
	JMP	ObtenerValor36DeZ80RAM_parte3(PC)
	NOP
	JSR ObtenerValor36DeZ80RAM(PC)
	TST.b	ram_offsetAddressFlagDesactivaSFX(A5)
	BNE.w	ObtenerValor36DeZ80RAM_parte3
	MOVEQ	#2, D0
loc_001FE618:
	JSR	ObtenerValor36DeZ80RAM_parte2(PC)
	MOVE.l	$8(A6), D0
	JSR	loc_001FE50A(PC)
	MOVE.l	$C(A6), D0
	JSR	loc_001FE50A(PC)
	JMP	ObtenerValor36DeZ80RAM_parte3(PC)
loc_001FE630:
	JSR	ObtenerValor36DeZ80RAM(PC)
	TST.b	ram_offsetAddressFlagDesactivaSFX(A5)
	BNE.w	ObtenerValor36DeZ80RAM_parte3
	MOVEQ	#$0000001B, D0
	BRA.w	loc_001FE618
	dc.b	$4E, $71 ;0x0 (0x001FE642-0x001FE644, Entry count: 0x2) [Unknown data]
loc_001FE644:
	TST.b	ram_offsetAddressFlagDesactivaSFX(A5)
	BNE.b	loc_001FE66A
	MOVE	SR, -(A7)
	ORI	#$0700, SR
	JSR	PedirAccesoZ80ConEspera(PC)
	MOVEQ	#0, D0
	MOVE.b	$9(A7), D0
	LEA	$00A01B22, A0
	MOVE.b	(A0,D0.w), D0
	JSR	LiberarZ80(PC)
	MOVE	(A7)+, SR
loc_001FE66A:
	RTS
