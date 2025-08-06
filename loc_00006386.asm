; ===============================================================
; Subrutina: Actualización de Barras de Energía/Vida de Personajes
; Dirección: $00006386
; 
; Función: Actualiza y dibuja las barras de energía/vida de los personajes
;          en pantalla. Maneja tanto el jugador 1 como el jugador 2,
;          calculando los segmentos de energía y renderizándolos visualmente.
;
; Variables locales:
;   -$C(A6)  - Puntero a datos gráficos de energía (Player 1)
;   -$8(A6)  - Puntero a datos gráficos de energía (Player 2)
;   -$4(A6)  - Dirección calculada para renderizado
;
; Registros utilizados:
;   A3 - Puntero a datos del jugador 1
;   A4 - Puntero a datos del jugador 2
;   D6 - Valor de energía actual
;   D7 - Número de segmentos de energía a mostrar
;   D3 - Flag de condición
; ===============================================================
loc_00006386:
	LINK	A6, #-$0000000C					; Crear stack frame con variables locales
	MOVEM.l	A4/A3/D7/D6/D3, -(A7)		; Guardar registros en stack
	LEA	$3F8A(A5), A0					; A0 = puntero a tabla de datos gráficos 1
	MOVE.l	$2(A0), -$C(A6)				; Guardar puntero gráficos P1 en variable local
	LEA	$3F82(A5), A0					; A0 = puntero a tabla de datos gráficos 2
	MOVE.l	$2(A0), -$8(A6)				; Guardar puntero gráficos P2 en variable local
	CLR.b	-$38B2(A5)						; Limpiar flag de actualización
	MOVE.b	-$38E2(A5), D0					; D0 = configuración actual de pantalla
	CMP.b	-$38E0(A5), D0					; ¿Cambió la configuración?
	BEQ.b	loc_000063BE					; Si no, continuar normalmente
	MOVE.b	-$38E0(A5), -$38E2(A5)		; Actualizar configuración actual
	JSR	loc_00006584(PC)				; Inicializar datos gráficos
	BRA.w	loc_0000657A					; Saltar al final
loc_000063BE:
	; --- Procesamiento de energía del Jugador 1 ---
	MOVE.w	-$1754(A5), D0					; D0 = estado del jugador 1
	EXT.l	D0								; Extender a long
	MOVE.w	#$C000, D1						; Máscara de estado
	AND.w	D0, D1							; Aislar bits de estado
	MOVEQ	#0, D0
	MOVE.w	D1, D0							; D0 = bits de estado
	CMPI.l	#$00008000, D0					; ¿Jugador 1 activo?
	BNE.w	loc_0000649C					; Si no, saltar a jugador 2
	LEA	ram_offsetAddressData1up(A5), A3	; A3 = datos del jugador 1
	MOVE.w	$68(A3), D6						; D6 = energía actual del jugador 1
	BGT.b	loc_000063E6					; Si > 0, calcular segmentos
	CLR.w	D7								; D7 = 0 (sin energía)
	BRA.b	loc_00006414					; Ir a renderizado
loc_000063E6:
	; --- Cálculo de segmentos de energía ---
	EXT.l	D6								; Extender energía a long
	MOVE.l	D6, D0							; D0 = energía
	SUBQ.l	#1, D0							; D0 = energía - 1
	ASR.l	#8, D0							; D0 = (energía - 1) / 256
	MOVE.w	D0, D7							; D7 = segmentos base
	ADDQ.w	#1, D7							; D7 = segmentos + 1
	MOVEQ	#0, D0
	MOVE.w	D7, D0							; D0 = número de segmentos
	CMPI.w	#9, D0							; ¿Más de 9 segmentos?
	BLS.b	loc_00006400					; Si no, continuar
	MOVEQ	#9, D7							; Limitar a 9 segmentos máximo
	BRA.b	loc_00006414					; Ir a renderizado
loc_00006400:
	MOVEQ	#0, D0
	MOVE.w	D7, D0							; D0 = segmentos
	CMPI.w	#2, D0							; ¿Menos de 3 segmentos?
	BHI.b	loc_00006414					; Si no, continuar
	MOVEQ	#$00000010, D0					; Máscara para flag especial
	AND.l	-$35A2(A5), D0					; ¿Flag especial activo?
	BEQ.b	loc_00006414					; Si no, continuar
	CLR.w	D7								; Forzar energía a 0 (estado crítico)
loc_00006414:
	; --- Renderizado de barra de energía del jugador 1 ---
	MOVEQ	#0, D0
	MOVE.w	D7, D0							; D0 = segmentos a dibujar
	LSL.l	#7, D0							; D0 = segmentos * 128 (tamaño por segmento)
	ADD.l	-$C(A6), D0						; D0 = dirección base + offset
	MOVE.l	D0, -$4(A6)						; Guardar dirección de renderizado
	PEA	$00000080.w						; Tamaño: 128 bytes
	MOVE.l	#$0000FF80, -(A7)				; Dirección destino en VRAM (P1)
	MOVE.l	-$4(A6), -(A7)					; Dirección fuente de datos gráficos
	JSR	$51DA(A5)						; Transferir gráficos a VRAM
	TST.b	-$18A8(A5)						; ¿Jugador 1 tiene display activo?
	LEA	$C(A7), A7						; Limpiar stack
	BEQ.b	loc_0000649C					; Si no, saltar a jugador 2
	; --- Procesamiento adicional de visualización del jugador 1 ---
	MOVE.w	$9E(A3), D7						; D7 = valor adicional de estado
	ASR.w	#2, D7							; D7 = valor / 4
	MOVEQ	#0, D0
	MOVE.w	D7, D0							; D0 = valor procesado
	CMPI.w	#8, D0							; ¿Valor >= 8?
	SCS	D3								; D3 = flag de condición
	NEG.b	D3								; Invertir flag
	BEQ.b	loc_0000645A					; Si condición falsa, usar valor
	MOVEQ	#0, D0
	MOVE.w	D7, D0							; D0 = valor original
	TST.l	D0								; Probar valor
	BRA.b	loc_0000645C					; Continuar
loc_0000645A:
	MOVEQ	#8, D0							; D0 = 8 (valor límite)
loc_0000645C:
	MOVE.w	D0, D7							; D7 = valor final
	MOVEQ	#0, D0
	MOVE.w	D7, D0							; D0 = valor a verificar
	MOVEQ	#8, D1							; D1 = 8
	CMP.l	D0, D1							; ¿Valor == 8?
	BNE.b	loc_00006478					; Si no, continuar
	MOVEQ	#8, D0							; Máscara para flag especial
	AND.l	-$35A2(A5), D0					; ¿Flag especial activo?
	BEQ.b	loc_00006472					; Si no, saltar
	ADDQ.w	#1, D7							; Incrementar valor
loc_00006472:
	MOVE.b	#1, -$38B2(A5)					; Establecer flag de actualización
loc_00006478:
	; --- Renderizado adicional del jugador 1 ---
	MOVEQ	#0, D0
	MOVE.w	D7, D0							; D0 = valor de segmentos
	LSL.l	#7, D0							; D0 = valor * 128
	ADD.l	-$8(A6), D0						; D0 = dirección base P2 + offset
	MOVE.l	D0, -$4(A6)						; Guardar dirección de renderizado
	PEA	$00000080.w						; Tamaño: 128 bytes
	MOVE.l	#$0000FF00, -(A7)				; Dirección destino en VRAM (adicional P1)
	MOVE.l	-$4(A6), -(A7)					; Dirección fuente de datos gráficos
	JSR	$51DA(A5)						; Transferir gráficos a VRAM
	LEA	$C(A7), A7						; Limpiar stack
loc_0000649C:
	; --- Procesamiento de energía del Jugador 2 ---
	MOVE.w	-$1844(A5), D0					; D0 = estado del jugador 2
	EXT.l	D0								; Extender a long
	MOVE.w	#$C000, D1						; Máscara de estado
	AND.w	D0, D1							; Aislar bits de estado
	MOVEQ	#0, D0
	MOVE.w	D1, D0							; D0 = bits de estado
	CMPI.l	#$00008000, D0					; ¿Jugador 2 activo?
	BNE.w	loc_0000657A					; Si no, finalizar
	LEA	ram_offsetAddressData2up(A5), A4	; A4 = datos del jugador 2
	MOVE.w	$68(A4), D6						; D6 = energía actual del jugador 2
	BGT.b	loc_000064C4					; Si > 0, calcular segmentos
	CLR.w	D7								; D7 = 0 (sin energía)
	BRA.b	loc_000064F2					; Ir a renderizado
loc_000064C4:
	; --- Cálculo de segmentos de energía (Jugador 2) ---
	EXT.l	D6								; Extender energía a long
	MOVE.l	D6, D0							; D0 = energía
	SUBQ.l	#1, D0							; D0 = energía - 1
	ASR.l	#8, D0							; D0 = (energía - 1) / 256
	MOVE.w	D0, D7							; D7 = segmentos base
	ADDQ.w	#1, D7							; D7 = segmentos + 1
	MOVEQ	#0, D0
	MOVE.w	D7, D0							; D0 = número de segmentos
	CMPI.w	#9, D0							; ¿Más de 9 segmentos?
	BLS.b	loc_000064DE					; Si no, continuar
	MOVEQ	#9, D7							; Limitar a 9 segmentos máximo
	BRA.b	loc_000064F2					; Ir a renderizado
loc_000064DE:
	MOVEQ	#0, D0
	MOVE.w	D7, D0							; D0 = segmentos
	CMPI.w	#2, D0							; ¿Menos de 3 segmentos?
	BHI.b	loc_000064F2					; Si no, continuar
	MOVEQ	#$00000010, D0					; Máscara para flag especial
	AND.l	-$35A2(A5), D0					; ¿Flag especial activo?
	BEQ.b	loc_000064F2					; Si no, continuar
	CLR.w	D7								; Forzar energía a 0 (estado crítico)
loc_000064F2:
	; --- Renderizado de barra de energía del jugador 2 ---
	MOVEQ	#0, D0
	MOVE.w	D7, D0							; D0 = segmentos a dibujar
	LSL.l	#7, D0							; D0 = segmentos * 128 (tamaño por segmento)
	ADD.l	-$C(A6), D0						; D0 = dirección base + offset
	MOVE.l	D0, -$4(A6)						; Guardar dirección de renderizado
	PEA	$00000080.w						; Tamaño: 128 bytes
	MOVE.l	#$0000FC00, -(A7)				; Dirección destino en VRAM (P2)
	MOVE.l	-$4(A6), -(A7)					; Dirección fuente de datos gráficos
	JSR	$51DA(A5)						; Transferir gráficos a VRAM
	TST.b	-$18AA(A5)						; ¿Jugador 2 tiene display activo?
	LEA	$C(A7), A7						; Limpiar stack
	BEQ.b	loc_0000657A					; Si no, finalizar
	; --- Procesamiento adicional de visualización del jugador 2 ---
	MOVE.w	$9E(A4), D7						; D7 = valor adicional de estado
	ASR.w	#2, D7							; D7 = valor / 4
	MOVEQ	#0, D0
	MOVE.w	D7, D0							; D0 = valor procesado
	CMPI.w	#8, D0							; ¿Valor >= 8?
	SCS	D3								; D3 = flag de condición
	NEG.b	D3								; Invertir flag
	BEQ.b	loc_00006538					; Si condición falsa, usar valor
	MOVEQ	#0, D0
	MOVE.w	D7, D0							; D0 = valor original
	TST.l	D0								; Probar valor
	BRA.b	loc_0000653A					; Continuar
loc_00006538:
	MOVEQ	#8, D0							; D0 = 8 (valor límite)
loc_0000653A:
	MOVE.w	D0, D7							; D7 = valor final
	MOVEQ	#0, D0
	MOVE.w	D7, D0							; D0 = valor a verificar
	MOVEQ	#8, D1							; D1 = 8
	CMP.l	D0, D1							; ¿Valor == 8?
	BNE.b	loc_00006556					; Si no, continuar
	MOVEQ	#8, D0							; Máscara para flag especial
	AND.l	-$35A2(A5), D0					; ¿Flag especial activo?
	BEQ.b	loc_00006550					; Si no, saltar
	ADDQ.w	#1, D7							; Incrementar valor
loc_00006550:
	MOVE.b	#1, -$38B2(A5)					; Establecer flag de actualización
loc_00006556:
	; --- Renderizado adicional del jugador 2 ---
	MOVEQ	#0, D0
	MOVE.w	D7, D0							; D0 = valor de segmentos
	LSL.l	#7, D0							; D0 = valor * 128
	ADD.l	-$8(A6), D0						; D0 = dirección base P2 + offset
	MOVE.l	D0, -$4(A6)						; Guardar dirección de renderizado
	PEA	$00000080.w						; Tamaño: 128 bytes
	MOVE.l	#$0000FC80, -(A7)				; Dirección destino en VRAM (adicional P2)
	MOVE.l	-$4(A6), -(A7)					; Dirección fuente de datos gráficos
	JSR	$51DA(A5)						; Transferir gráficos a VRAM
	LEA	$C(A7), A7						; Limpiar stack
loc_0000657A:
	; --- Finalización de la subrutina ---
	MOVEM.l	-$20(A6), D3/D6/D7/A3/A4		; Restaurar registros del stack
	UNLK	A6								; Destruir stack frame
	RTS									; Retornar al caller
