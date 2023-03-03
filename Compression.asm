; B.O.B.bin
; Chakan - The Forever Man.bin
; Escape From Mars Starring Taz.bin
; Pink Goes to Hollywood.bin
; Spider-Man vs The Kingpin.bin
; Taz-Mania.bin
; Wacky Worlds.bin
; X-Men 2 - Clone Wars (W) [!].bin

loc_0015F3F0:
; recibe
; a0 = ubicacion en ROM de la data comprimida (ej 0x000F5B1B)
; a1 = ubicacion en RAM
; a3 = direccion de la rutina que mueve data a data port
; a4 = vdp data port
; d2
; d3 = 8
; d4 = 0
; d6 con un 0x10
; d5 con la word cargada de una posicion en la rom (por ej F5B1C)

	MOVE.w	D6, D0 							; d0 = d6 (0x10)
	SUBQ.w	#8, D0							; d0 = d0-0x8 (0x8)
	MOVE.w	D5, D1							; d1 = d5 (0xB6DE)
	LSR.w	D0, D1							; d1 ( 0xB6 )
	ANDI.w	#$00FF, D1						; al pepe
	CMPI.w	#$00FC, D1						; N = D1 < FC, 
	BGE.w	loc_0015F540					; Branch on Greater than or Equal (da false)
	ADD.w	D1, D1							; d1 = d1+d1 (0x16c)
	SUB.b	(A1,D1.w), D6					; d6 = d6-$FFB548 (a1 = 0x00FFB3DC )
	CMPI.w	#9, D6							; if d6 >= 9
	BGE.b	loc_0015F416					; ir a 
	ADDQ.w	#8, D6							; ---todo esto----
	ASL.w	#8, D5							; si d6 < 9
	MOVE.b	(A0)+, D5						; ----------------
loc_0015F416:
	MOVE.b	$1(A1,D1.w), D1					; d1 = $FFB549

loc_0015F41A:
	MOVE.w	D1, D0							; d0 = d1
	ANDI.w	#$000F, D1						; blanquea d1 menos ultimo digito
	BEQ.w	loc_0015F4D8					; branch si queda en 0
	ASL.w	#2, D1
	MOVE.l	loc_0015F456(PC,D1.w), D7		; llena d7 con los repetidos
	ANDI.w	#$00F0, D0
	BEQ.w	loc_0015F500
	LSR.w	#4, D0
	ADDQ.w	#1, D0
loc_0015F436:
	MOVE.w	D3, D1							; d1 = d3 
	ASL.w	#2, D1							; d1 = d1 * 4
	MOVE.l	loc_0015F496(PC,D1.w), D1		; pone F en d1 segun d1
	CMP.w	D3, D0
	BEQ.b	loc_0015F4BA					; if d3 = d0 (puede que se la ultima vuelta)
	BGT.w	loc_0015F4C8					; if d0 > d3
	; menor o igual
	; la diferencia la usa para buscar en 496

	SUB.w	D0, D3							; d3 = d3 - d0
	MOVE.w	D3, D0							; d0 = d3
	ASL.w	#2, D0							; d0 = d0 * 4
	SUB.l	loc_0015F496(PC,D0.w), D1		; RESTA!!!!!!!!!!!! d1 = d1 - lo que diga el array
	AND.l	D7, D1							; del valor obtenido del array de repetidos, and contra lo que quedo de la operatoria de Fs
	OR.l	D1, D4
	BRA.b	loc_0015F3F0

loc_0015F456:
	dc.l	$00000000
	dc.l	$11111111
	dc.l	$22222222
	dc.l	$33333333
	dc.l	$44444444
	dc.l	$55555555
	dc.l	$66666666
	dc.l	$77777777
	dc.l	$88888888
	dc.l	$99999999
	dc.l	$AAAAAAAA
	dc.l	$BBBBBBBB
	dc.l	$CCCCCCCC
	dc.l	$DDDDDDDD
	dc.l	$EEEEEEEE
	dc.l	$FFFFFFFF

loc_0015F496:
	dc.l	$00000000	; loc_0015F496( 0 )
	dc.l	$0000000F	; loc_0015F496( 4 )
	dc.l	$000000FF	; loc_0015F496( 8 )
	dc.l	$00000FFF	; loc_0015F496( 12 )
	dc.l	$0000FFFF	; loc_0015F496( 16 )
	dc.l	$000FFFFF	; loc_0015F496( 20 )
	dc.l	$00FFFFFF	; loc_0015F496( 24 )
	dc.l	$0FFFFFFF	; loc_0015F496( 28 )
	dc.l	$FFFFFFFF	; loc_0015F496( 32 )

loc_0015F4BA:
	AND.l	D7, D1
	OR.l	D1, D4
	JSR	(A3)						; copia la palabra a la VRAM en loc_0015F57E
	MOVEQ	#0, D4
	MOVEQ	#8, D3
	BRA.w	loc_0015F3F0			; vuelve arriba
loc_0015F4C8:
	AND.l	D7, D1
	OR.l	D1, D4
	JSR	(A3)						; copia la palabra a la VRAM en loc_0015F57E
	SUB.w	D3, D0
	MOVEQ	#0, D4
	MOVEQ	#8, D3
	BRA.w	loc_0015F436
loc_0015F4D8:
	ANDI.w	#$00F0, D0				; blanquea anteultimo digito de d0
	LSR.w	#4, D0					; mueve el anteultimo digito al ultimo
	ADDQ.w	#1, D0					; d0 = d0 + 1

loc_0015F4E0:
	CMP.w	D3, D0					
	BEQ.b	loc_0015F4EC			; if d0 = d3
	BGT.b	loc_0015F4F6			; if d0 > d3
	SUB.w	D0, D3					; d0 = d0 - d3
	BRA.w	loc_0015F3F0			; vuelve arriba
	loc_0015F4EC:
		JSR	(A3)					; copia la palabra a la VRAM en loc_0015F57E
		MOVEQ	#0, D4				; d4 = 0
		MOVEQ	#8, D3				; d3 = 8
		BRA.w	loc_0015F3F0		; vuelve arriba
	loc_0015F4F6:
		JSR	(A3)					; copia la palabra a la VRAM en loc_0015F57E
		SUB.w	D3, D0				; d0 = d0 - d3
		MOVEQ	#0, D4				; d4 = 0
		MOVEQ	#8, D3				; d3 = 8
		BRA.b	loc_0015F4E0		; loopea

loc_0015F500:
	MOVE.w	D3, D1
	ASL.w	#2, D1
	MOVE.l	loc_0015F51C(PC,D1.w), D1		; data comprimida o cifrada
	AND.l	D7, D1
	OR.l	D1, D4
	SUBQ.w	#1, D3
	BNE.w	loc_0015F3F0
	JSR	(A3)
	MOVEQ	#0, D4
	MOVEQ	#8, D3
	BRA.w	loc_0015F3F0

loc_0015F51C:
	dc.l	$00000000
	dc.l	$0000000F
	dc.l	$000000F0
	dc.l	$00000F00
	dc.l	$0000F000
	dc.l	$000F0000
	dc.l	$00F00000
	dc.l	$0F000000
	dc.l	$F0000000

loc_0015F540:
	SUBQ.w	#6, D6
	CMPI.w	#9, D6
	BGE.b	loc_0015F54E
	ADDQ.w	#8, D6
	ASL.w	#8, D5
	MOVE.b	(A0)+, D5
loc_0015F54E:
	SUBQ.w	#8, D6
	MOVE.w	D5, D1
	LSR.w	D6, D1
	CMPI.w	#9, D6
	BGE.w	loc_0015F41A
	ADDQ.w	#8, D6
	ASL.w	#8, D5
	MOVE.b	(A0)+, D5
	BRA.w	loc_0015F41A
loc_0015F566:
	MOVE.l	D4, (A4)					; d4 -> 0x00C00000
	SUBQ.w	#1, D2						; d2 = d2 - 1 (eo -> df)
	BEQ.b	loc_0015F56E
	RTS
loc_0015F56E:
	MOVEA.l	(A7)+, A0
	RTS
