SetearValoresIniciales:
	LINK	A6, #0

	CLR.w	ram_offsetSaludBack(A5)				; C66C
	MOVE.b	#$FF, ram_offsetPersonaje1up(A5)	; C644
	
	MOVEQ	#0, D0								; 
	MOVE.l	D0, ram_offsetAddressData1up(A5)	; EAA8
	
	CLR.w	-$1754(A5)							; EAAC (parece tener que ver con animaciones o hitboxes)
	MOVE.w	#9, ram_offsetVidasActual(A5)		; Inicializa con 9 vidas (c958)

	CLR.w	ram_offsetSaludBack2up(A5)			; C66A
	MOVE.b	#$FF, ram_offsetPersonaje2up(A5)	; Pone FF en la parte baja de C644

	MOVE.l	D0, ram_offsetAddressData2up(A5)						; E9B8 = 0x00000000 address data de personaje 2up

	CLR.w	-$1844(A5)							; E9BC (idem EAAC para p2)
	MOVE.w	#9, ram_offsetVidasActual2up(A5)	; C956 vidas actual p2

	MOVEQ	#0, D1
	MOVE.b	ram_offsetNivelSiberiaB1Blizzard(A5), D1	; setea Siberia como		(C690 - index en array nivels)
	MOVE.w	D1, ram_offsetNivelActual(A5)				; nivel actual				(CC64)

	MOVE.b	#1, -$38C2(A5)								; C93E

	UNLK	A6
	RTS