SetearValoresIniciales:
	LINK	A6, #0
	CLR.w	-$3B94(A5)
	MOVE.b	#$FF, -$3BBC(A5)					; Pone FF en la parte alta de C644
	MOVEQ	#0, D0								; d0 = 0x00000000
	MOVE.l	D0, -$1758(A5)						
	CLR.w	-$1754(A5)
	MOVE.w	#9, ram_offsetVidasActual(A5)		; Inicializa con 9 vidas
	CLR.w	-$3B96(A5)
	MOVE.b	#$FF, -$3BBB(A5)					; Pone FF en la parte baja de C644
	MOVE.l	D0, -$1848(A5)
	CLR.w	-$1844(A5)	
	MOVE.w	#9, -$38AA(A5)
	MOVEQ	#0, D1
	MOVE.b	ram_offsetNivelSiberiaB1Blizzard(A5), D1
	MOVE.w	D1, ram_offsetNivelActual(A5)
	MOVE.b	#1, -$38C2(A5)
	UNLK	A6
	RTS