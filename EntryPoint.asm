	;*************************************
	; Test reset button
	;*************************************
	TST.l	$00A10008		; Test mystery reset (expansion port reset?)
	BNE.b	PortA_Ok		; Branch if Not Equal (to zero) - to Main
	TST.w	$00A1000C		; Test reset button
PortA_Ok:
	BNE.b	Main			; Branch if Not Equal (to zero) - to Main

	LEA	SetupValues(PC), A5
	MOVEM.w	(A5)+, D5/D6/D7
	MOVEM.l	(A5)+, A0/A1/A2/A3/A4

	;*************************************
	; Write TMSS
	;*************************************
	MOVE.b	-$10FF(A1), D0 		; Read version register	
	ANDI.b	#$0F, D0
	BEQ.b	SkipTMSS
	MOVE.l	#'SEGA', $2F00(A1)	;Predicted (Code-scan)

SkipTMSS:
	MOVE.w	(A4), D0			; vdp status dummy read
	MOVEQ	#0, D0
	MOVEA.l	D0, A6
	MOVE.l	A6, USP			; user stack pointer set

	;*************************************
	; Init VDP
	;------<<< VDP REG. initialize >>>------
	;*************************************
	MOVEQ	#0x17, D1			; 24 registers to write

CopiarRegistros:
	MOVE.b	(A5)+, D5				; vdp reg. 0-23 set
	MOVE.w	D5, (A4)				;    (DMA fill set)
	ADD.w	D7, D5					; Increment register #
	DBF	D1, CopiarRegistros

	;------<<< DMA FILL >>>---------
	MOVE.l	(A5)+, (A4)				; VRAM Fill command
	MOVE.w	D0, (A3)				; FIll VRAM with 0x00

	;*************************************
	; Init Z80
	;*************************************
	MOVE.w	D7, (A1)				; 0x0100, 0x00A11100 - Request access to the Z80 bus, by writing 0x0100 into the BUSREQ port
	MOVE.w	D7, (A2)				; 0x0100, 0x00A11200 - Hold the Z80 in a reset state, by writing 0x0100 into the RESET port

@Wait:
	BTST.b	D0, (A1)				; Test bit 0 of A11100 to see if the 68k has access to the Z80 bus yet
	BNE.b	@Wait
	MOVEQ	#$00000025, D2
	@CopyZ80:
		MOVE.b	(A5)+, (A0)+		; 38 bytes a Z80 RAM
		DBF	D2, @CopyZ80
	MOVE.w	D0, (A2)				; 0x0000 -> 0x00A11200 Release reset state
	MOVE.w	D0, (A1)				; 0x0000 -> 0x00A11100 Release control of bus
	MOVE.w	D7, (A2)				; 0x0100 -> 0x00A11200 Hold the Z80 in a reset state, by writing 0x0100 into the RESET port

	;*************************************
	; Clear RAM
	;*************************************
	@ClearRAM:
		MOVE.l	D0, -(A6)
		DBF	D6, @ClearRAM			; size of RAM/4

	;-------<<< VDP color clear >>>-------------
	MOVE.l	(A5)+, (A4)				; write to CRAM address 0x0000
	MOVE.l	(A5)+, (A4)				; write to VSRAM Write address 0x0000
	MOVEQ	#$0000001F, D3			; 32 longwords
	Init_ClearCRAM:
		MOVE.l	D0, (A3)				; A3 0x00C00000 (vdp_data)
		DBF	D3, Init_ClearCRAM

	; -------<<< V SCROLL clear >>>---------------
	MOVE.l	(A5)+, (A4)				; 40000010 -> 00C00004 vdp_write_vscroll_a a vdp control

	MOVEQ	#$00000013, D4			; 19+1
	Init_ClearVSRAM:
		MOVE.l	D0, (A3)				; A3 0x00C00000 (vdp_data)
		DBF	D4, Init_ClearVSRAM

	;*************************************
	; Init PSG
	;*************************************
	moveq #3, D5           ; 4 bytes of data
	@CopyPSG:
	move.b (A5)+, $11(A3)   ; Copy data to PSG RAM
	dbra D5, @CopyPSG

	;-----------<<< regstars initial >>>------------
	MOVE.w	D0, (A2)				; 0x0000 -> 0x00A11100 Release control of bus
	MOVEM.l	(A6), D0/D1/D2/D3/D4/D5/D6/D7/A0/A1/A2/A3/A4/A5/A6	; blanquea todo menos A7
	MOVE	#$2700, SR				; Disable interrupts

Main:
	BRA.b	GameProgram

SetupValues:
	dc.w	$8000		; VDP register start number
	dc.w	$3FFF		; size of RAM/4
	dc.w	$100		; VDP register diff

	dc.l	z80_RAM_start		; start	of Z80 RAM
	dc.l	z80_BUSREQ_port		; Z80 bus request
	dc.l	z80_Reset_port		; Z80 reset port
	dc.l	vdp_data			; VDP data
	dc.l	vdp_control			; VDP control port

	dc.b	$04					; VDP Reg #0, Disable INT, Disable HV counter
	dc.b	$14					; VDP Reg #1, Enable DMA
	dc.b	($C000>>10)			; VDP Reg #2 - foreground nametable address
	dc.b	($F000>>10)			; VDP Reg #3 - window nametable address
	dc.b	($E000>>13)			; VDP Reg #4 - background nametable address
	dc.b	($D800>>9)			; VDP Reg #5 - sprite table address
	dc.b	$00					; VDP Reg #6
	dc.b	$00					; VDP Reg #7
	dc.b	$00					; VDP Reg #8
	dc.b	$00					; VDP Reg #9
	dc.b	$FF					; VDP Reg #10
	dc.b	$00					; VDP Reg #11 Full scroll
	dc.b	$81					; VDP Reg #12 40 H-Cell mode
	dc.b 	($DC00>>10)			; VDP Reg #13 H-Scroll data at	0xDC00
	dc.b	$00					; VDP Reg #14
	dc.b	$01					; VDP Reg #15 Autoinc to 1
	dc.b	$01					; 16: H Scroll	64 Cell
	dc.b	$00					; 17: Window Plane X pos 0 left (pos in bits 0-4, left/right in bit 7)
	dc.b	$00					; 18: Window Plane Y pos 0 up (pos in bits 0-4, up/down in bit 7)
	dc.b	$FF					; 19: DMA length lo byte
	dc.b	$FF					; 20: DMA length hi byte
	dc.b	$00					; 21: DMA source address lo byte
	dc.b	$00					; 22: DMA source address mid byte
	dc.b	$80					; 23: DMA source address hi byte, memory-to-VRAM mode (bits 6-7)

	dc.l	$40000080			; VRAM Fill command
	
	dc.b	$AF, $01, $D9, $1F	; Z80Data
	dc.b	$11, $27, $00, $21
	dc.b	$26, $00, $F9, $77
	dc.b	$ED, $B0, $DD, $E1
	dc.b	$FD, $E1, $ED, $47
	dc.b	$ED, $4F, $D1, $E1
	dc.b	$F1, $08, $D9, $C1
	dc.b	$D1, $E1, $F1, $F9
	dc.b	$F3, $ED, $56, $36
	dc.b	$E9, $E9, $81, $04
	dc.b	$8F, $02
	
	dc.l	$C0000000
	dc.l	$40000010
	
	dc.b	$9F					; PSGData
	dc.b	$BF
	dc.b	$DF
	dc.b	$FF
