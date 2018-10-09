;========================================================================================================
;========================================================================================================
;========================================================================================================
; a continuacion, muestra leyenda de region erronea
;========================================================================================================
;========================================================================================================
;========================================================================================================

	LEA	vdp_data, A4				;Predicted (Code-scan)
	LEA	vdp_control, A5				;Predicted (Code-scan)
	MOVE.w	#$8164, (A5)			;V interrupt on, display on, DMA on, Genesis mode on
	MOVE.w	#$8230, (A5)			;Pattern table for Scroll Plane A at VRAM 0xC000 (bits 3-5 = bits 13-15)
	MOVE.w	#$8C81, (A5)			;Shadows and highlights off, interlace off, H40 mode (320 x 224 screen res)
	MOVE.w	#$8F02, (A5)			;auto increment en 2
	MOVE.w	#$9001, (A5)			;Vert. scroll 32, Horiz. scroll 64

	MOVE.l	#$C0020000, (A5)		;Set vdp to write color 1 of palette 0
	MOVE.w	#$0EEE, (A4)			;Sets color 1 of palette 0 as white
	
	MOVE.l	#vdp_write_tiles, (A5)	;Set vdp to write tiles

	LEA	FuenteComprimida(PC), A0		;Carga ubicacion de los tiles

	MOVE.w	#$003A, D0				;Pone 58 en D6 para loopear 59 veces
	MOVE.l	#$10000000, D2			;Predicted (Code-scan)

DescomprimirTile:								; inicio loop 59
	MOVE.w	#7, D6							; Pone 7 en D6 para loopear 8 veces

DescomprimirByteEnLongword:					; inicio loop 8 out
	MOVE.b	(A0)+, D1						
	MOVE.l	#0, D4							

	MOVE.w	#7, D5							

ArmarLongwordSegunBinario:			
	ROL.l	#4, D2							
	ROR.b	#1, D1							 
	BCC.b	SaltarSetear1					; Branch on Carry Clear
	OR.l	D2, D4							; pone 1 en la posicion en que se encuentra D2 cuando d1 rota
SaltarSetear1:
	DBF	D5, ArmarLongwordSegunBinario			; 8 veces (8 longwords forman tile)

	MOVE.l	D4, (A4)						; mueve tile descomprimida
	DBF	D6, DescomprimirByteEnLongword			; Fin loop 8 veces out

	DBF	D0, DescomprimirTile					; Loop 59 veces (0x3A = 58)

	;====================================================================	
	; Leyenda DEVELOPED FOR USE ONLY WITH <Descripcion regiones> SYSTEMS
	;====================================================================	

	MOVE.b	#8, D1					; Coordenada x
	LEA	StringDevelopedFor(PC), A0	; 'DEVELOPED FOR USE ONLY WITH' ;Predicted (Code-scan)
	MOVE.b	(A0)+, D0				; Coordenada y
	BSR.w	ImprimeTexto			
	LEA	loc_000001F0, A1			; a1 = 'JEU             ' ; Country codes permitidos

MuestraRegionPermitida:				; loop cada country code permitido
	CMPI.b	#$20, (A1)								; cuando encuentra espacio (final) en los country codes
	BEQ.b	ImprimeSYSTEMS							; imprimeSYSTEMS() y  finaliza
	LEA	TablaSistemasCodigoDescripcion(PC), A2

ForEachCountry:						; loop descripciones
	MOVE.w	(A2)+, D4								; d4 = 004A
	
	TST.b	D4										; si esta vacio el codigo de sistema
	BEQ.b	AvanzarArrayCountryCodesPermitidos		; Va al siguiente Country Code()
	
	CMP.b	(A1), D4								; si no es el mismo codigo
	BNE.b	AvanzarTablaDescripciones				; Va al siguiente en la tabla de descripciones

	CMPI.b	#$20, $1(A1)							; compara si el siguiente country es espacio (ie actual ultimo)
	BNE.b	ImprimirDescripcionSistema				; branch si da falso (hay mas)

	CMPA.l	#loc_000001F0, A1						; compara si cambio a1 (es la primera que entra)
	BEQ.b	ImprimirDescripcionSistema				; branch si es cierto

	LEA	StringAmpersand(PC), A0						; no hay mas countries, y no es el primero
	MOVE.b	(A0)+, D0								; imprime el ampersand
	ADDQ.w	#1, D1									; ( es el ultimo y hubo otro mas impreso )
	BSR.w	ImprimeTexto							;

ImprimirDescripcionSistema:
	LEA	ArrayRegiones(PC), A0		; al pedo
	ADDA.l	(A2)+, A0				; pone en a0 la direccion de la descri del sistema (relativa al ArrayRegiones)
	MOVE.b	(A0)+, D0				; la coordenada x en el array de descri
	ADDQ.w	#1, D1					; suma 1 a la coord y
	BSR.w	ImprimeTexto			
	BRA.b	AvanzarArrayCountryCodesPermitidos

AvanzarTablaDescripciones:
	ADDQ.l	#4, A2				; siguiente codigo (4 bytes por la address de la descripcion)
	BRA.b	ForEachCountry		; loop descripciones 

AvanzarArrayCountryCodesPermitidos:
	ADDQ.l	#1, A1							; Avanza el array de country codes permitidos
	BRA.b	MuestraRegionPermitida		; loop cada country code permitido	

ImprimeSYSTEMS:
	LEA	StringSystems(PC), A0	
	MOVE.b	(A0)+, D0			; coordenada x
	ADDQ.w	#1, D1				; coordenada y
	BSR.w	ImprimeTexto		

Trampa:
	BRA.b	Trampa

ImprimeTexto:
	; A0 = addresss del texto
	; d0 = coord Y
	; d1 = coord X
	MOVE.b	D1, D2					; d2 = d1
	ANDI.l	#$000000FF, D2			; d2 = 9 (limpia la parte alta)
	SWAP	D2						; d2 = 0009 0000
	LSL.l	#7, D2					; d2 = 0480 0000 (0000 0100 1000 0000 0000 0000 0000 0000 Logical Shift Left x 7)
	MOVE.b	D0, D3					; d3 = d0 ($12)
	ANDI.l	#$000000FF, D3			; d3 = 00000012 (limpia la parte alta)
	SWAP	D3						; d3 = 0012 0000
	ASL.l	#1, D3					; d3 = 0024 0000 (Arithmetic Shift Left x 1)  Predicted (Code-scan)
	ADD.l	D3, D2					; d2 = d2 + d3 
	ADDI.l	#vdp_write_plane_a, D2	; d2 = d2 + 0x40000003
	MOVE.l	D2, (A5)				; envia al control port que va a escribir en el plano A en las coordenadas que vinieron en d1 y d0?
EscribeCharacter:	
	TST.b	(A0)								; if A0 = 0
	BEQ.b	EscribeCharacter_Break				; 	break
	MOVE.b	(A0)+, D2							; d2 = char en a0
	SUBI.b	#$20, D2							; d2 = d2 - 20 (puede ser indice en el char map)
	ANDI.w	#$00FF, D2							; d2.w = d2
	MOVE.w	D2, (A4)							; escribe a dataport
	BRA.b	EscribeCharacter					;Predicted (Code-scan)
EscribeCharacter_Break:
	RTS

ArrayRegiones:
	dc.b	$4A ; JAPAN
	dc.b	$00 ; ???
	dc.b	$55 ; USA
	dc.b	$45 ; EUROPE

TablaSistemasCodigoDescripcion:
	dc.w	$004A		;	' J'
	dc.l	StringMDJapan-ArrayRegiones	
	dc.w	$0055		;	' U'
	dc.l	StringGenesis-ArrayRegiones
	dc.w	$0045		;	' E'
	dc.l	StringMDEurope-ArrayRegiones

	dc.w	$0000		; probablemente para alinear

StringDevelopedFor:
	dc.b	$06, 'DEVELOPED FOR USE ONLY WITH', 0 ;0x0 (0x001F45FC-0x001F4619, Entry count: 0x1D) [Unknown data]

StringAmpersand:
	dc.b	$12, '&',0 ;0x0 (0x001F4619-0x001F461C, Entry count: 0x3) [Unknown data]

StringSystems:
	dc.b	$0F, 'SYSTEMS.',0

StringMDJapan:
	dc.b	$0C, 'NTSC MEGA DRIVE',0					; ArrayRegiones + 42
StringGenesis:
	dc.b	$0D, 'NTSC GENESIS',0						; ArrayRegiones + 53
StringMDEurope:
	dc.b	$04, 'PAL AND FRENCH SECAM MEGA DRIVE',0 	; ArrayRegiones + 61

FuenteComprimida: 
	dc.b	$00 	; 00000000
	dc.b	$00 	; 00000000
	dc.b	$00 	; 00000000
	dc.b	$00 	; 00000000
	dc.b	$00 	; 00000000
	dc.b	$00 	; 00000000
	dc.b	$00 	; 00000000
	dc.b	$00 	; 00000000

	dc.b	$18 	; 00011000
	dc.b	$18 	; 00011000
	dc.b	$18 	; 00011000
	dc.b	$18 	; 00011000
	dc.b	$00 	; 00000000
	dc.b	$18 	; 00011000
	dc.b	$18 	; 00011000
	dc.b	$00 	; 00000000

	dc.b	$36 	; 00110110
	dc.b	$36 	; 00110110
	dc.b	$48 	; 01001000
	dc.b	$00 	; 00000000
	dc.b	$00 	; 00000000
	dc.b	$00 	; 00000000
	dc.b	$00 	; 00000000
	dc.b	$00 	; 00000000

	dc.b	$12 	; 00010010
	dc.b	$12 	; 00010010
	dc.b	$7F 	; 01111111
	dc.b	$12 	; 00010010
	dc.b	$7F 	; 01111111
	dc.b	$24 	; 00100100
	dc.b	$24 	; 00100100
	dc.b	$00 	; 00000000

	dc.b	$08
	dc.b	$3F
	dc.b	$48
	dc.b	$3E
	dc.b	$09
	dc.b	$7E
	dc.b	$08
	dc.b	$00

	dc.b	$71
	dc.b	$52
	dc.b	$74
	dc.b	$08
	dc.b	$17
	dc.b	$25
	dc.b	$47
	dc.b	$00

	dc.b	$18
	dc.b	$24
	dc.b	$18
	dc.b	$29
	dc.b	$45
	dc.b	$46
	dc.b	$39
	dc.b	$00

	dc.b	$30
	dc.b	$30
	dc.b	$40
	dc.b	$00
	dc.b	$00
	dc.b	$00
	dc.b	$00
	dc.b	$00

	dc.b	$0C
	dc.b	$10
	dc.b	$20
	dc.b	$20
	dc.b	$20
	dc.b	$10
	dc.b	$0C
	dc.b	$00

	dc.b	$30
	dc.b	$08
	dc.b	$04
	dc.b	$04
	dc.b	$04
	dc.b	$08
	dc.b	$30
	dc.b	$00

	dc.b	$00
	dc.b	$08
	dc.b	$2A
	dc.b	$1C
	dc.b	$2A
	dc.b	$08
	dc.b	$00
	dc.b	$00

	dc.b	$08
	dc.b	$08
	dc.b	$08
	dc.b	$7F
	dc.b	$08
	dc.b	$08
	dc.b	$08
	dc.b	$00

	dc.b	$00
	dc.b	$00
	dc.b	$00
	dc.b	$00
	dc.b	$00
	dc.b	$30
	dc.b	$30
	dc.b	$40

	dc.b	$00
	dc.b	$00
	dc.b	$00
	dc.b	$7F
	dc.b	$00
	dc.b	$00
	dc.b	$00
	dc.b	$00

	dc.b	$00
	dc.b	$00
	dc.b	$00
	dc.b	$00
	dc.b	$00
	dc.b	$30
	dc.b	$30
	dc.b	$00

	dc.b	$01
	dc.b	$02
	dc.b	$04
	dc.b	$08
	dc.b	$10
	dc.b	$20
	dc.b	$40
	dc.b	$00

	dc.b	$1E
	dc.b	$33
	dc.b	$33
	dc.b	$33
	dc.b	$33
	dc.b	$33
	dc.b	$1E
	dc.b	$00

	dc.b	$18
	dc.b	$38
	dc.b	$18
	dc.b	$18
	dc.b	$18
	dc.b	$18
	dc.b	$3C
	dc.b	$00

	dc.b	$3E
	dc.b	$63
	dc.b	$63
	dc.b	$0E
	dc.b	$38
	dc.b	$60
	dc.b	$7F
	dc.b	$00

	dc.b	$3E
	dc.b	$63
	dc.b	$03
	dc.b	$1E
	dc.b	$03
	dc.b	$63
	dc.b	$3E
	dc.b	$00

	dc.b	$06
	dc.b	$0E
	dc.b	$1E
	dc.b	$36
	dc.b	$66
	dc.b	$7F
	dc.b	$06
	dc.b	$00

	dc.b	$7E
	dc.b	$60
	dc.b	$7E
	dc.b	$63
	dc.b	$03
	dc.b	$63
	dc.b	$3E
	dc.b	$00

	dc.b	$3E
	dc.b	$63
	dc.b	$60
	dc.b	$7E
	dc.b	$63
	dc.b	$63
	dc.b	$3E
	dc.b	$00

	dc.b	$3F
	dc.b	$63
	dc.b	$06
	dc.b	$06
	dc.b	$0C
	dc.b	$0C
	dc.b	$18
	dc.b	$00

	dc.b	$3E
	dc.b	$63
	dc.b	$63
	dc.b	$3E
	dc.b	$63
	dc.b	$63
	dc.b	$3E
	dc.b	$00

	dc.b	$3E
	dc.b	$63
	dc.b	$63
	dc.b	$3F
	dc.b	$03
	dc.b	$63
	dc.b	$3E
	dc.b	$00

	dc.b	$00
	dc.b	$18
	dc.b	$18
	dc.b	$00
	dc.b	$00
	dc.b	$18
	dc.b	$18
	dc.b	$00

	dc.b	$00
	dc.b	$18
	dc.b	$18
	dc.b	$00
	dc.b	$00
	dc.b	$18
	dc.b	$18
	dc.b	$20

	dc.b	$03
	dc.b	$0C
	dc.b	$30
	dc.b	$40
	dc.b	$30
	dc.b	$0C
	dc.b	$03
	dc.b	$00

	dc.b	$00
	dc.b	$00
	dc.b	$7F
	dc.b	$00
	dc.b	$7F
	dc.b	$00
	dc.b	$00
	dc.b	$00

	dc.b	$60
	dc.b	$18
	dc.b	$06
	dc.b	$01
	dc.b	$06
	dc.b	$18
	dc.b	$60
	dc.b	$00

	dc.b	$3E
	dc.b	$63
	dc.b	$03
	dc.b	$1E
	dc.b	$18
	dc.b	$00
	dc.b	$18
	dc.b	$00

	dc.b	$3C
	dc.b	$42
	dc.b	$39
	dc.b	$49
	dc.b	$49
	dc.b	$49
	dc.b	$36
	dc.b	$00

	dc.b	$1C
	dc.b	$1C
	dc.b	$36
	dc.b	$36
	dc.b	$7F
	dc.b	$63
	dc.b	$63
	dc.b	$00

	dc.b	$7E
	dc.b	$63
	dc.b	$63
	dc.b	$7E
	dc.b	$63
	dc.b	$63
	dc.b	$7E
	dc.b	$00

	dc.b	$3E
	dc.b	$73
	dc.b	$60
	dc.b	$60
	dc.b	$60
	dc.b	$73
	dc.b	$3E
	dc.b	$00

	dc.b	$7E
	dc.b	$63
	dc.b	$63
	dc.b	$63
	dc.b	$63
	dc.b	$63
	dc.b	$7E
	dc.b	$00

	dc.b	$3F
	dc.b	$30
	dc.b	$30
	dc.b	$3E
	dc.b	$30
	dc.b	$30
	dc.b	$3F
	dc.b	$00

	dc.b	$3F
	dc.b	$30
	dc.b	$30
	dc.b	$3E
	dc.b	$30
	dc.b	$30
	dc.b	$30
	dc.b	$00

	dc.b	$3E
	dc.b	$73
	dc.b	$60
	dc.b	$67
	dc.b	$63
	dc.b	$73
	dc.b	$3E
	dc.b	$00

	dc.b	$66
	dc.b	$66
	dc.b	$66
	dc.b	$7E
	dc.b	$66
	dc.b	$66
	dc.b	$66
	dc.b	$00

	dc.b	$18
	dc.b	$18
	dc.b	$18
	dc.b	$18
	dc.b	$18
	dc.b	$18
	dc.b	$18
	dc.b	$00

	dc.b	$0C
	dc.b	$0C
	dc.b	$0C
	dc.b	$0C
	dc.b	$CC
	dc.b	$CC
	dc.b	$78
	dc.b	$00

	dc.b	$63
	dc.b	$66
	dc.b	$6C
	dc.b	$78
	dc.b	$6C
	dc.b	$66
	dc.b	$63
	dc.b	$00

	dc.b	$60
	dc.b	$60
	dc.b	$60
	dc.b	$60
	dc.b	$60
	dc.b	$60
	dc.b	$7F
	dc.b	$00

	dc.b	$63
	dc.b	$77
	dc.b	$7F
	dc.b	$6B
	dc.b	$6B
	dc.b	$63
	dc.b	$63
	dc.b	$00

	dc.b	$63
	dc.b	$73
	dc.b	$7B
	dc.b	$7F
	dc.b	$6F
	dc.b	$67
	dc.b	$63
	dc.b	$00

	dc.b	$3E
	dc.b	$63
	dc.b	$63
	dc.b	$63
	dc.b	$63
	dc.b	$63
	dc.b	$3E
	dc.b	$00

	dc.b	$7E
	dc.b	$63
	dc.b	$63
	dc.b	$7E
	dc.b	$60
	dc.b	$60
	dc.b	$60
	dc.b	$00

	dc.b	$3E
	dc.b	$63
	dc.b	$63
	dc.b	$63
	dc.b	$6F
	dc.b	$63
	dc.b	$3F
	dc.b	$00

	dc.b	$7E
	dc.b	$63
	dc.b	$63
	dc.b	$7E
	dc.b	$68
	dc.b	$66
	dc.b	$67
	dc.b	$00

	dc.b	$3E
	dc.b	$63
	dc.b	$70
	dc.b	$3E
	dc.b	$07
	dc.b	$63
	dc.b	$3E
	dc.b	$00

	dc.b	$7E
	dc.b	$18
	dc.b	$18
	dc.b	$18
	dc.b	$18
	dc.b	$18
	dc.b	$18
	dc.b	$00

	dc.b	$66
	dc.b	$66
	dc.b	$66
	dc.b	$66
	dc.b	$66
	dc.b	$66
	dc.b	$3C
	dc.b	$00

	dc.b	$63
	dc.b	$63
	dc.b	$63
	dc.b	$36
	dc.b	$36
	dc.b	$1C
	dc.b	$1C
	dc.b	$00

	dc.b	$6B
	dc.b	$6B
	dc.b	$6B
	dc.b	$6B
	dc.b	$6B
	dc.b	$7F
	dc.b	$36
	dc.b	$00

	dc.b	$63
	dc.b	$63
	dc.b	$36
	dc.b	$1C
	dc.b	$36
	dc.b	$63
	dc.b	$63
	dc.b	$00

	dc.b	$66
	dc.b	$66
	dc.b	$66
	dc.b	$3C
	dc.b	$18
	dc.b	$18
	dc.b	$18
	dc.b	$00

	dc.b	$7F
	dc.b	$07
	dc.b	$0E
	dc.b	$1C
	dc.b	$38
	dc.b	$70
	dc.b	$7F
	dc.b	$00

