; llama primero con d0=0 y despues d0=1
; deja el resultado en formato 0000 MXYZ SACB RLDU
LeerJoypad:
	CMPI.w	#1, D0						; Valida d0
	BLE.b	EsParametroPuertoValido		; continua si es menor o igual a 1
	RTS
	EsParametroPuertoValido:
	MOVE.w	#$0100, z80_BUSREQ_port		;request access
	MOVE.w	#$0100, z80_Reset_port		;request access

	loc_001FD636:
		BTST.b	#0, z80_BUSREQ_port
		BNE.b	loc_001FD636				; espera al z80

	ADD.w	D0, D0					; d0 = d0+d0 ( 0 player 1, 2 player 2 )
	MOVEA.l	#pad_data_a, A0			; a0 = 0x00A10003
	ADDA.w	D0, A0					; 0x00A10003 (pad a) o 0x00A10005 (pad b)

	MOVEQ	#0, D0					; d0 = 0
	MOVE.b	#$40, $6(A0)			; pone 40 en el control port A
	NOP								; -----
	NOP								; -----
	MOVE.b	#$40, (A0)				; pone 40 en el data port?
	MOVEQ	#0, D0					; d0 = 0
	NOP								; -----
	NOP								; -----
	NOP								; -----
	MOVE.b	(A0), D0				; d0 = leectura pad
	CMPI.b	#$70, D0
	BEQ.w	SalirLecturaPad			; error? 
	MOVE.b	#0, (A0)				; pone 0 de vuelta
	LSL.w	#8, D0					; mueve al upper byte
	MOVE.b	(A0), D0				; lee pad
	CMPI.b	#$3F, D0				; CBRLDU alone 
	BEQ.w	SalirLecturaPad
	MOVE.b	#$40, (A0)
	MOVEQ	#0, D1					; d1 = 0
	NOP
	NOP
	NOP
	MOVE.b	(A0), D1				; d1 = lectura pad
	MOVE.b	#0, (A0)				; pone 0 de vuelta
	LSL.w	#8, D1					; mueve al upper byte
	MOVE.b	(A0), D1				; lee pad
	MOVE.b	#$40, (A0)				; Write bit 7 to data port
	MOVEQ	#0, D2					; d2 = 0
	NOP
	NOP
	NOP
	MOVE.b	(A0), D2				; d2 = lectura pad
	MOVE.b	#0, (A0)				; pone 0 de vuelta
	LSL.w	#8, D2					; mueve al upper byte
	MOVE.b	(A0), D2				; lee pad
	MOVE.b	#$40, (A0)				; Write bit 7 to data port
	SWAP	D2						; intercambia?
	NOP
	NOP
	NOP
	MOVE.b	(A0), D2				; d2 = lectura pad
	MOVE.b	#0, (A0)
	LSL.w	#8, D2					; mueve al upper byte
	MOVE.b	(A0), D2				; lee pad
	MOVE.b	#$40, (A0)				; Write bit 7 to data port
	SWAP	D2
	CMP.w	D0, D1
	BNE.b	SalirLecturaPad
	CMP.w	D1, D2
	BEQ.b	loc_001FD6F8
	ANDI.w	#$000F, D2
	BNE.b	SalirLecturaPad
	LSL.b	#2, D0
	LSL.w	#2, D0
	ROR.w	#8, D0
	ROR.b	#2, D0
	ANDI.w	#$00FF, D0
	SWAP	D2
	ANDI.w	#$0F00, D2
	OR.w	D2, D0
	NOT.w	D0
	ANDI.l	#$00004FFF, D0
	MOVE.w	#0, z80_BUSREQ_port		;release
	RTS

loc_001FD6F8:
	LSL.b	#2, D0
	LSL.w	#2, D0
	ROR.w	#8, D0
	ROR.b	#2, D0
	ANDI.l	#$000000FF, D0
	NOT.b	D0
	MOVE.w	#0, z80_BUSREQ_port
	RTS

SalirLecturaPad:
	MOVE.w	#$8000, D0
	MOVE.w	#0, z80_BUSREQ_port
	RTS

