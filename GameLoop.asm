; ===============================================================
; FUNCIÓN: InicioJuego - Game Loop Principal
; ===============================================================
; Función principal del juego que maneja:
; - Inicialización del sistema
; - Loop principal de niveles
; - Manejo de vidas y game over
; - Transiciones entre niveles
; - Control del modo DEMO
; ===============================================================
InicioJuego:
	LINK	A6, #0							; Crear stack frame
	MOVEM.l	A4/A3/D7/D6/D5/D3, -(A7)		; Preservar registros utilizados

	; ===== INICIALIZACIÓN DEL SISTEMA =====
	MOVEQ	#0, D0
	MOVE.l	D0, -$38B0(A5)					; Limpiar variable del sistema

	CLR.b	ram_offsetFlagEsDEMO(A5)		; RAM C7E6 - Desactivar flag de DEMO
	CLR.b	-$38B6(A5)						; RAM C94A - Limpiar flag sistema
	CLR.b	-$38C4(A5)						; RAM C93C - Limpiar flag sistema

	MOVE.w	#3, -$38AC(A5)					; RAM C954 - Configurar parámetro inicial

	CLR.w	-$3B00(A5)						; RAM C700 - Limpiar contador sistema

	; ===== CARGAR DATOS INICIALES =====
	JSR	CargarArrayNiveles(PC)				; Cargar tabla de niveles disponibles

	MOVE.w	#$FFFF, ram_offsetNivelActualBack(A5)	; RAM C66E - Inicializar nivel anterior como "ninguno"

	JSR	SetearValoresIniciales(PC)			; Configurar valores por defecto del juego

; ===============================================================
; LOOP PRINCIPAL DE NIVELES
; ===============================================================
InicioNivel:								
	; ===== OBTENER DATOS DEL NIVEL ACTUAL =====
	MOVE.w	ram_offsetNivelActual(A5), D0	; D0 = índice del nivel actual
	ASL.w	#3, D0							; D0 *= 8 (cada entrada del array son 8 bytes)

	LEA	ram_offsetArrayNiveles(A5), A0		; A0 = puntero al array de niveles
	TST.l	$4(A0,D0.w)						; Verificar si existe rutina para este nivel (offset +4)
	BEQ.b	loc_00005D2C					; Si no existe, saltar a verificación de vidas

	; ===== CONFIGURAR CALLBACKS DEL NIVEL =====
	LEA	loc_00006B2C(PC), A0			; Cargar dirección de callback 1
	MOVE.l	A0, -$38E8(A5)					; RAM C918 - Guardar callback 1

	LEA	loc_00006B64(PC), A0			; Cargar dirección de callback 2
	MOVE.l	A0, -$38EC(A5)					; RAM C914 - Guardar callback 2

	; ===== EJECUTAR NIVEL =====
	MOVE.w	ram_offsetNivelActual(A5), D0	; Obtener índice del nivel otra vez
	ASL.w	#3, D0							; D0 *= 8

	LEA	ram_offsetArrayNiveles(A5), A0		; A0 = array de niveles
	MOVEA.l	$4(A0,D0.w), A1					; A1 = puntero a rutina del nivel
	
	JSR	(A1)								; ¡EJECUTAR NIVEL!
	
	; ===== LIMPIEZA POST-NIVEL =====
	JSR	$4ACA(A5)							; Llamar rutina de limpieza (loc_001E2C3E)

; ===============================================================
; VERIFICACIÓN DE ESTADO DE JUGADORES
; ===============================================================
loc_00005D2C:								
	; ===== BACKUP DE SALUD PLAYER 1 =====
	MOVEQ	#-1, D0
	CMP.b	ram_offsetPersonaje1up(A5), D0		; ¿Hay Player 1 seleccionado?
	BEQ.b	loc_00005D3A					; Si no hay P1, saltar
	MOVE.w	ram_offsetSaludActual(A5), ram_offsetSaludBack(A5)	; Hacer backup de salud P1

loc_00005D3A:
	; ===== BACKUP DE SALUD PLAYER 2 =====
	MOVEQ	#-1, D0
	CMP.b	ram_offsetPersonaje2up(A5), D0		; ¿Hay Player 2 seleccionado?
	BEQ.b	loc_00005D48					; Si no hay P2, saltar
	MOVE.w	ram_offsetSalud2up(A5), ram_offsetSaludBack2up(A5)	; Hacer backup de salud P2

; ===============================================================
; ANÁLISIS DE ESTADO DE VIDA DE LOS JUGADORES
; ===============================================================
loc_00005D48:
	; ===== VERIFICAR ESTADO PLAYER 1 =====
	TST.w	ram_offsetSaludBack(A5)			; ¿Player 1 tiene salud > 0?
	SGT	D3									; D3 = 0xFF si salud > 0, sino 0x00
	NEG.b	D3								; Invertir: D3 = 0x01 si salud > 0, sino 0xFF
	BEQ.b	loc_00005D56					; Si salud > 0, D3 será 0, saltar
	MOVEQ	#0, D0							; D0 = 0 (Player 1 vivo)
	BRA.b	loc_00005D58
loc_00005D56:
	MOVEQ	#1, D0							; D0 = 1 (Player 1 muerto)
loc_00005D58:
	MOVE.b	D0, D5							; D5 = estado Player 1 (0=vivo, 1=muerto)

	; ===== VERIFICAR ESTADO PLAYER 2 =====
	TST.w	ram_offsetSaludBack2up(A5)		; ¿Player 2 tiene salud > 0?
	SGT	D3									; D3 = 0xFF si salud > 0, sino 0x00
	NEG.b	D3								; Invertir: D3 = 0x01 si salud > 0, sino 0xFF
	BEQ.b	loc_00005D68					; Si salud > 0, D3 será 0, saltar
	MOVEQ	#0, D0							; D0 = 0 (Player 2 vivo)
	BRA.b	loc_00005D6A	
loc_00005D68:
	MOVEQ	#1, D0							; D0 = 1 (Player 2 muerto)
loc_00005D6A:
	MOVE.b	D0, D6							; D6 = estado Player 2 (0=vivo, 1=muerto)

	; D5 = estado Player 1 (0=vivo, 1=muerto)
	; D6 = estado Player 2 (0=vivo, 1=muerto)

; ===============================================================
; MANEJO DE VIDAS Y RESURRECCIONES - PLAYER 1
; ===============================================================
	TST.b	D5								; ¿Player 1 está muerto?
	BEQ.b	loc_00005D9E					; Si está vivo, saltar a verificar Player 2
	MOVEQ	#-1, D0							
	CMP.b	ram_offsetPersonaje1up(A5), D0	; ¿Hay Player 1 seleccionado?
	BEQ.b	loc_00005D9E					; Si no hay P1, saltar a verificar Player 2
	
	; Player 1 murió y existe - verificar vidas restantes
	TST.w	ram_offsetVidasActual(A5)		; ¿Quedan vidas para Player 1?
	BEQ.b	loc_00005D8A					; Si no quedan vidas, eliminar player
	
	; Hay vidas restantes - resucitar Player 1
	SUBQ.w	#1, ram_offsetVidasActual(A5)	; Restar 1 vida
	MOVE.w	#$0700, ram_offsetSaludBack(A5)	; Restaurar salud completa (nueva vida)
	BRA.b	loc_00005D9E					; Continuar con Player 2

loc_00005D8A:								; Player 1 sin vidas restantes
	CLR.w	ram_offsetSaludBack(A5)			; Confirmar salud en 0
	MOVE.b	#$FF, ram_offsetPersonaje1up(A5)	; Marcar P1 como "ninguno" (eliminado)
	MOVEQ	#0, D0	
	MOVE.l	D0, ram_offsetAddressData1up(A5)	; Limpiar datos del personaje P1
	CLR.w	-$1754(A5)						; Limpiar variable relacionada P1

; ===============================================================
; MANEJO DE VIDAS Y RESURRECCIONES - PLAYER 2
; ===============================================================
loc_00005D9E:								
	TST.b	D6								; ¿Player 2 está muerto?
	BEQ.b	loc_00005DD0					; Si está vivo, continuar
	MOVEQ	#-1, D0
	CMP.b	ram_offsetPersonaje2up(A5), D0	; ¿Hay Player 2 seleccionado?
	BEQ.b	loc_00005DD0					; Si no hay P2, continuar
	
	; Player 2 murió y existe - verificar vidas restantes
	TST.w	ram_offsetVidasActual2up(A5)	; ¿Quedan vidas para Player 2?
	BEQ.b	loc_00005DBC					; Si no quedan vidas, eliminar player
	
	; Hay vidas restantes - resucitar Player 2
	SUBQ.w	#1, ram_offsetVidasActual2up(A5)	; Restar 1 vida
	MOVE.w	#$0700, ram_offsetSaludBack2up(A5)	; Restaurar salud completa (nueva vida)
	BRA.b	loc_00005DD0					; Continuar con lógica de progresión

loc_00005DBC:								; Player 2 sin vidas restantes
	CLR.w	ram_offsetSaludBack2up(A5)		; Confirmar salud en 0
	MOVE.b	#$FF, ram_offsetPersonaje2up(A5)	; Marcar P2 como "ninguno" (eliminado)
	MOVEQ	#0, D0
	MOVE.l	D0, ram_offsetAddressData2up(A5)	; Limpiar datos del personaje P2
	CLR.w	-$1844(A5)						; Limpiar variable relacionada P2

; ===============================================================
; LÓGICA DE PROGRESIÓN DEL JUEGO
; ===============================================================
loc_00005DD0:
	TST.b	-$38C2(A5)						; ¿Está activado el flag de modo DEMO?
	BNE.b	loc_00005E26					; Si es DEMO, manejar diferente
	
	; ===== VERIFICAR CONDICIONES DE GAME OVER =====
	TST.b	D5								; ¿Player 1 está vivo?
	BEQ.b	loc_00005DDE					; Si P1 vivo, avanzar nivel
	TST.b	D6								; ¿Player 2 está vivo?
	BNE.b	loc_00005DF8					; Si ambos muertos, manejar game over

; ===============================================================
; AVANCE AL SIGUIENTE NIVEL
; ===============================================================
loc_00005DDE:
	ADDQ.w	#1, ram_offsetNivelActual(A5)	; Avanzar al siguiente nivel
	MOVEQ	#0, D0
	MOVE.b	ram_offsetNivelCerebroScreenCredits(A5), D0	; D0 = nivel de credits
	CMP.w	ram_offsetNivelActual(A5), D0	; ¿El nuevo nivel llegó a los credits?
	BGE.w	LoopearInicioNivel				; Si no llegó a credits, continuar con el nivel

	; Si llegó al final del juego (credits), reiniciar
	JSR	SetearValoresIniciales(PC)		; Reiniciar valores del juego
	BRA.w	LoopearInicioNivel				; Volver al loop principal

; ===============================================================
; MANEJO DE SITUACIONES ESPECIALES
; ===============================================================
loc_00005DF8:
	; Ambos players están muertos - verificar si alguno puede continuar
	TST.w	ram_offsetSaludBack(A5)			; ¿Player 1 tiene salud de backup?
	BNE.b	SetearPlayerSelectyLoopear		; Si tiene, ir a pantalla de selección
	TST.w	ram_offsetSaludBack2up(A5)		; ¿Player 2 tiene salud de backup?
	BEQ.b	SetearGameOveryLoopear			; Si ninguno tiene, GAME OVER

SetearPlayerSelectyLoopear:
	; Al menos un player puede continuar - ir a pantalla de selección
	MOVE.w	ram_offsetNivelActual(A5), ram_offsetNivelActualBack(A5)	; Guardar nivel actual
	MOVEQ	#0, D0
	MOVE.b	ram_offsetNivelCerebroScreenPlayerSelect(A5), D0	; Cargar nivel de player select
	MOVE.w	D0, ram_offsetNivelActual(A5)	; Cambiar a pantalla de selección
	BRA.w	LoopearInicioNivel				; Reiniciar loop

SetearGameOveryLoopear:
	; Ambos players sin posibilidad de continuar - GAME OVER
	MOVEQ	#0, D0
	MOVE.b	ram_offsetNivelCerebroScreenFailure(A5), D0	; Cargar nivel de game over
	MOVE.w	D0, ram_offsetNivelActual(A5)	; Cambiar a pantalla de game over
	BRA.w	LoopearInicioNivel				; Reiniciar loop

; ===============================================================
; MANEJO DEL MODO DEMO
; ===============================================================
loc_00005E26:
	MOVEQ	#-1, D0
	CMP.w	ram_offsetNivelActual(A5), D0	; ¿Nivel actual es -1 (fin de demo)?
	BNE.w	LoopearInicioNivel				; Si no es fin de demo, continuar loop

	include "MostrarDemo.asm"

;---------------------------------------------------------------
;-	FIN DEL LOOP DE NIVEL
;---------------------------------------------------------------

