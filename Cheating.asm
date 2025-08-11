; ===============================================================
; Sistema de Códigos de Trucos (Cheat Codes)
; ===============================================================
; Maneja la detección e implementación de secuencias de trucos
; durante el juego. Procesa entradas del controlador para
; identificar códigos específicos y activar los efectos
; correspondientes como vidas infinitas, salud, cambios de nivel,
; etc.
;
; Parámetros:
;   - Utiliza el estado actual del controlador y flags de trucos
;   - Lee secuencias de comandos almacenadas en memoria
;
; Retorna:
;   - Modifica flags de trucos activos según códigos detectados
;   - Puede alterar estado del juego (vidas, salud, nivel)
; ===============================================================
loc_0015C42A:
	LINK	A6, #0
	MOVEM.l	D7/D6, -(A7)
	CLR.b	-$3A08(A5)		; Limpiar flag de entrada de trucos
	JSR	$50FA(A5)		; Procesar entrada del controlador
	TST.l	-$1666(A5)		; ¿Hay secuencia de truco activa?
	BEQ.w	loc_0015C5F2		; Si no, procesar entrada directa
	
	; -------------------------------------------------------
	; Procesamiento de Secuencia de Truco Activa
	; -------------------------------------------------------
	MOVEQ	#$0000007F, D0		; Máscara para extraer botón presionado
	AND.w	-$3A26(A5), D0		; Aplicar máscara a entrada P1
	BEQ.w	loc_0015CA36		; Si no hay entrada, salir
	MOVEQ	#$0000007F, D6		; Guardar código de botón en D6
	AND.w	-$3A26(A5), D6
	MOVEA.l	-$1666(A5), A0		; A0 = puntero a secuencia actual
	CMP.b	(A0), D6		; ¿Coincide con siguiente paso?
	BNE.w	loc_0015C5E4		; Si no, cancelar secuencia
	ADDQ.l	#1, -$1666(A5)		; Avanzar al siguiente paso
	MOVEA.l	-$1666(A5), A0		; Obtener nuevo puntero
	MOVEQ	#0, D0
	MOVE.b	(A0), D0		; Leer siguiente byte de secuencia
	CMPI.w	#$00FF, D0		; ¿Es marcador de fin? ($FF)
	BNE.w	loc_0015CA36		; Si no, continuar secuencia
	
	; -------------------------------------------------------
	; Ejecutar Truco - Dispatcher por Tipo
	; -------------------------------------------------------
	MOVE.w	-$3C58(A5), D0		; Obtener ID del truco completado
	SUBQ.w	#1, D0			; Ajustar índice (base 0)
	BMI.w	loc_0015C5D6		; Si negativo, error - limpiar
	CMPI.w	#8, D0			; ¿ID válido? (0-8)
	BGT.w	loc_0015C5D6		; Si > 8, error - limpiar
	ADD.w	D0, D0			; D0 * 2 para tabla de palabras
	MOVE.w	loc_0015C48C(PC,D0.w), D0	; Obtener offset desde tabla
	JMP	loc_0015C48C-2(PC,D0.w)	; Saltar a manejador específico

; Tabla de Offsets para Manejadores de Trucos
loc_0015C48C:
    dc.w	loc_0015C49E-loc_0015C48C+2
	dc.w	loc_0015C4BA-loc_0015C48C+2
	dc.w	loc_0015C4E2-loc_0015C48C+2
	dc.w	loc_0015C4FE-loc_0015C48C+2
	dc.w	loc_0015C51A-loc_0015C48C+2
	dc.w	loc_0015C564-loc_0015C48C+2
	dc.w	loc_0015C57E-loc_0015C48C+2
	dc.w	loc_0015C598-loc_0015C48C+2
    dc.w	loc_0015C5B2-loc_0015C48C+2

; ===============================================================
; Truco #1: Activar Flag de Trucos + Sonido
; ===============================================================
loc_0015C49E:
	MOVEQ	#$0000001B, D0		; ID de sonido para confirmación
	MOVE.l	D0, -(A7)		; Parámetro para función de sonido
	JSR	$5222(A5)		; Reproducir sonido de confirmación
	MOVEQ	#$0000001B, D0		; Mismo sonido
	MOVE.l	D0, -(A7)		; Parámetro adicional
	JSR	$521A(A5)		; Función auxiliar de sonido
	ORI.w	#$0010, ram_C5A2_FlagCheats(A5)	; Activar flag básico de trucos
	ADDQ.w	#8, A7			; Limpiar stack (2 parámetros)
	BRA.w	loc_0015C5D6		; Ir a limpieza final

; ===============================================================
; Truco #2: Vidas Infinitas + Flag de Trucos
; ===============================================================
loc_0015C4BA:
	MOVEQ	#$00000022, D0		; ID de sonido diferente
	MOVE.l	D0, -(A7)		; Parámetro para sonido
	JSR	$5222(A5)		; Reproducir sonido de confirmación
	MOVEQ	#$00000022, D0		; Mismo sonido
	MOVE.l	D0, -(A7)		; Parámetro adicional
	JSR	$521A(A5)		; Función auxiliar de sonido
	ORI.w	#$0020, ram_C5A2_FlagCheats(A5)	; Activar flag de vidas infinitas
	MOVE.w	#$0063, ram_offsetVidasActual(A5)	; 99 vidas para P1
	MOVE.w	#$0063, ram_offsetVidasActual2up(A5)	; 99 vidas para P2
	ADDQ.w	#8, A7			; Limpiar stack
	BRA.w	loc_0015C5D6		; Ir a limpieza final

; ===============================================================
; Truco #3: Habilidades Mejoradas 
; ===============================================================
loc_0015C4E2:
	MOVEQ	#$00000036, D0		; ID de sonido para habilidades
	MOVE.l	D0, -(A7)
	JSR	$5222(A5)		; Reproducir sonido
	MOVEQ	#$00000036, D0
	MOVE.l	D0, -(A7)
	JSR	$521A(A5)
	ORI.w	#$00C0, ram_C5A2_FlagCheats(A5)	; Activar flags combinados
	ADDQ.w	#8, A7
	BRA.w	loc_0015C5D6

; ===============================================================
; Truco #4: Habilidades Mejoradas (Duplicado)
; ===============================================================
loc_0015C4FE:
	MOVEQ	#$00000036, D0		; Mismo efecto que #3
	MOVE.l	D0, -(A7)
	JSR	$5222(A5)
	MOVEQ	#$00000036, D0
	MOVE.l	D0, -(A7)
	JSR	$521A(A5)
	ORI.w	#$00C0, ram_C5A2_FlagCheats(A5)	; Flags de habilidades
	ADDQ.w	#8, A7
	BRA.w	loc_0015C5D6

; ===============================================================
; Truco #5: Truco Especial con Verificación de Controles
; ===============================================================
loc_0015C51A:
	MOVEQ	#$00000037, D0		; Sonido especial
	MOVE.l	D0, -(A7)
	JSR	$5222(A5)
	MOVEQ	#$00000037, D0
	MOVE.l	D0, -(A7)
	JSR	$521A(A5)
	; Verificación especial de estado de controles
	MOVE.w	-$1754(A5), D0		; Estado de control P1
	EXT.l	D0			; Extender a longword
	MOVE.w	#$C000, D1		; Máscara para botones específicos
	AND.w	D0, D1			; Aplicar máscara
	MOVEQ	#0, D0
	MOVE.w	D1, D0
	CMPI.l	#$00008000, D0		; ¿Estado específico?
	ADDQ.w	#8, A7			; Limpiar stack primero
	BNE.w	loc_0015C5D6		; Si no coincide, salir
	MOVE.w	-$1844(A5), D0		; Estado de control P2
	EXT.l	D0
	MOVE.w	#$C000, D1		; Misma máscara
	AND.w	D0, D1
	MOVEQ	#0, D0
	MOVE.w	D1, D0
	CMPI.l	#$00008000, D0		; ¿Ambos jugadores activos?
	BNE.b	loc_0015C5D6		; Si no, salir
	JSR	$3A(A5)			; Función especial desbloqueada
	BRA.b	loc_0015C5D6		; Ir a limpieza

; ===============================================================
; Truco #6: Activar Flag de Trucos Avanzados + Sonido
; ===============================================================
loc_0015C564:
	MOVEQ	#$00000039, D0		; ID de sonido #57 (confirmación especial)
	MOVE.l	D0, -(A7)		; Parámetro para función de sonido
	JSR	$5222(A5)		; Reproducir sonido de confirmación
	MOVEQ	#$00000039, D0		; Mismo ID de sonido
	MOVE.l	D0, -(A7)		; Parámetro para función auxiliar
	JSR	$521A(A5)		; Función auxiliar de sonido/audio
	ORI.w	#$2000, -$3C5E(A5)	; Activar flag de trucos bit 13 ($2000)
	ADDQ.w	#8, A7			; Limpiar stack (2 parámetros de sonido)
	BRA.b	loc_0015C5D6		; Ir a limpieza y finalización

; ===============================================================
; Truco #7: Activar Navegación de Niveles + Sonido
; ===============================================================
loc_0015C57E:
	MOVEQ	#$00000026, D0		; ID de sonido #38 (confirmación navegación)
	MOVE.l	D0, -(A7)		; Parámetro para función de sonido
	JSR	$5222(A5)		; Reproducir sonido de confirmación
	MOVEQ	#$00000026, D0		; Mismo ID de sonido
	MOVE.l	D0, -(A7)		; Parámetro para función auxiliar
	JSR	$521A(A5)		; Función auxiliar de sonido/audio
	ORI.w	#$0400, -$3C5E(A5)	; Activar flag navegación niveles bit 10 ($0400)
	ADDQ.w	#8, A7			; Limpiar stack (2 parámetros de sonido)
	BRA.b	loc_0015C5D6		; Ir a limpieza y finalización

; ===============================================================
; Truco #8: Activar Sistema de Invencibilidad + Sonido
; ===============================================================
loc_0015C598:
	MOVEQ	#$00000024, D0		; ID de sonido #36 (confirmación invencibilidad)
	MOVE.l	D0, -(A7)		; Parámetro para función de sonido
	JSR	$5222(A5)		; Reproducir sonido de confirmación
	MOVEQ	#$00000024, D0		; Mismo ID de sonido
	MOVE.l	D0, -(A7)		; Parámetro para función auxiliar
	JSR	$521A(A5)		; Función auxiliar de sonido/audio
	ORI.w	#$0200, -$3C5E(A5)	; Activar flag invencibilidad bit 9 ($0200)
	ADDQ.w	#8, A7			; Limpiar stack (2 parámetros de sonido)
	BRA.b	loc_0015C5D6		; Ir a limpieza y finalización

; ===============================================================
; Truco #9: Modo Dios - Activar Todos los Trucos + Vidas Máximas
; ===============================================================
; Flags Activados ($27F0):
;   - Bit 4 ($0010): Trucos básicos habilitados
;   - Bit 5 ($0020): Vidas infinitas
;   - Bit 6 ($0040): Habilidades mejoradas parte 1
;   - Bit 7 ($0080): Habilidades mejoradas parte 2
;   - Bit 8 ($0100): Funciones especiales
;   - Bit 9 ($0200): Sistema de invencibilidad
;   - Bit 10 ($0400): Navegación de niveles
;   - Bit 13 ($2000): Trucos avanzados
;
; Parámetros:
;   - Ninguno (utiliza estado global del sistema de trucos)
;
; Retorna:
;   - Modifica ram_offsetVidasActual y ram_offsetVidasActual2up = 99
;   - Modifica ram_C5A2_FlagCheats con flags $27F0
;   - Efectos de sonido reproducidos
;   - Modo dios completamente activado
; ===============================================================
loc_0015C5B2:
	MOVEQ	#$0000004F, D0		; ID de sonido #79 (confirmación modo dios)
	MOVE.l	D0, -(A7)		; Parámetro para función de sonido
	JSR	$5222(A5)		; Reproducir sonido de confirmación
	MOVEQ	#$0000004F, D0		; Mismo ID de sonido
	MOVE.l	D0, -(A7)		; Parámetro para función auxiliar
	JSR	$521A(A5)		; Función auxiliar de sonido/audio
	MOVE.w	#$0063, ram_offsetVidasActual(A5)	; 99 vidas para Jugador 1
	MOVE.w	#$0063, ram_offsetVidasActual2up(A5)	; 99 vidas para Jugador 2
	ORI.w	#$27F0, -$3C5E(A5)	; Activar flags combinados modo dios ($27F0)
	ADDQ.w	#8, A7			; Limpiar stack (2 parámetros de sonido)

; ===============================================================
; Limpieza después de Ejecutar Truco
; ===============================================================
loc_0015C5D6:
	CLR.w	-$3C58(A5)		; Limpiar ID de truco activo
	MOVEQ	#0, D0
	MOVE.l	D0, -$1666(A5)		; Limpiar puntero de secuencia
	BRA.w	loc_0015CA36		; Ir a procesamiento final

; ===============================================================
; Cancelar Secuencia por Error de Entrada
; ===============================================================
loc_0015C5E4:
	CLR.w	-$3C58(A5)		; Limpiar ID de truco
	MOVEQ	#0, D0
	MOVE.l	D0, -$1666(A5)		; Limpiar secuencia activa
	BRA.w	loc_0015CA36		; Continuar procesamiento

; ===============================================================
; Procesamiento de Entrada Directa (Sin Secuencia Activa)
; ===============================================================
loc_0015C5F2:
	MOVEQ	#$0000007F, D6		; Máscara de entrada
	AND.w	-$3A2E(A5), D6		; Aplicar a entrada del pad
	TST.w	D6			; ¿Hay entrada?
	BEQ.w	loc_0015CA36		; Si no, salir
	
	; -------------------------------------------------------
	; Verificar Códigos de Activación de Trucos Inmediatos
	; -------------------------------------------------------
	CMPI.w	#$0021, D6		; ¿Botón de activación 1? (!= $21)
	BNE.b	loc_0015C666		; Si no, probar siguiente
	
	; Truco de Salud Instantáneo
	MOVEQ	#$00000010, D0		; Flag de trucos básicos
	AND.w	ram_C5A2_FlagCheats(A5), D0	; ¿Ya activado?
	BEQ.b	loc_0015C63C		; Si no, iniciar secuencia
	
	; Aplicar efecto inmediato de salud
	MOVEQ	#$0000001B, D0		; Sonido de confirmación
	MOVE.l	D0, -(A7)
	JSR	$5222(A5)		; Reproducir sonido
	MOVEQ	#$0000001B, D0
	MOVE.l	D0, -(A7)
	JSR	$521A(A5)
	TST.w	ram_offsetSaludActual(A5)	; ¿P1 tiene salud?
	ADDQ.w	#8, A7			; Limpiar stack
	BLE.b	loc_0015C62A		; Si no, verificar P2
	MOVE.w	#$0900, ram_offsetSaludActual(A5)	; Restaurar salud P1 al máximo

loc_0015C62A:
	TST.w	ram_offsetSalud2up(A5)	; ¿P2 tiene salud?
	BLE.w	loc_0015CA36		; Si no, terminar
	MOVE.w	#$0900, ram_offsetSalud2up(A5)	; Restaurar salud P2
	BRA.w	loc_0015CA36		; Terminar

; Iniciar secuencia de truco tipo 1
loc_0015C63C:
	MOVE.w	#1, -$3C58(A5)		; Establecer ID de truco #1
	MOVEQ	#$0000000C, D0		; Código de control específico
	CMP.w	ram_offsetLecturaPad_B(A5), D0	; ¿Control específico activo?
	BNE.b	loc_0015C658		; Si no, usar secuencia alternativa
	LEA	$E0A(A5), A0		; Puntero a secuencia primaria
	MOVE.l	$2(A0), -$1666(A5)	; Establecer puntero de secuencia
	BRA.w	loc_0015CA36		; Continuar procesamiento

loc_0015C658:
	LEA	$E3A(A5), A0		; Puntero a secuencia alternativa  
	MOVE.l	$2(A0), -$1666(A5)	; Establecer puntero
	BRA.w	loc_0015CA36		; Continuar

; ===============================================================
; Verificador de Código de Activación #2 (Botón $0022)
; ===============================================================
; Maneja la detección del código de activación de trucos #2.
; Verifica si el flag de vidas infinitas ya está activo y si es así,
; omite la activación. Si no está activo, inicia la secuencia para
; el truco #2 basado en el tipo de controlador detectado.
;
; Código de Activación: $0022 (combinación específica de botones)
; Truco Asociado: #2 (Vidas Infinitas)
; Flag Verificado: $0020 (bit 5 - vidas infinitas)
;
; Funcionalidad:
;   - Detecta código de activación $0022
;   - Verifica si las vidas infinitas ya están activas
;   - Inicia secuencia de truco #2 según tipo de controlador
;   - Previene activación duplicada del mismo truco
;
; Parámetros:
;   - D6: Código de botón de entrada ($0022 esperado)
;   - ram_offsetLecturaPad_B: Tipo de controlador
;   - ram_C5A2_FlagCheats: Flags de trucos activos
;
; Retorna:
;   - Puntero de secuencia establecido en -$1666(A5)
;   - ID de truco #2 establecido en -$3C58(A5)
;   - O salto a procesamiento final si ya está activo
; ===============================================================
loc_0015C666:
	CMPI.w	#$0022, D6		; ¿Es el código de activación #2?
	BNE.b	loc_0015C6A0		; Si no, probar siguiente código
	MOVEQ	#$00000020, D0		; Máscara para flag de vidas infinitas
	AND.w	-$3C5E(A5), D0		; ¿Ya está activo el flag de vidas infinitas?
	BNE.w	loc_0015CA36		; Si ya está activo, omitir activación
	MOVE.w	#2, -$3C58(A5)		; Establecer ID de truco #2 (vidas infinitas)
	MOVEQ	#$0000000C, D0		; Código de controlador específico
	CMP.w	ram_offsetLecturaPad_B(A5), D0	; ¿Es controlador tipo $0C?
	BNE.b	loc_0015C692		; Si no, usar secuencia alternativa
	LEA	$E12(A5), A0		; A0 = puntero a secuencia primaria truco #2
	MOVE.l	$2(A0), -$1666(A5)	; Establecer puntero de secuencia activa
	BRA.w	loc_0015CA36		; Continuar con procesamiento final

loc_0015C692:
	LEA	$E42(A5), A0		; A0 = puntero a secuencia alternativa truco #2
	MOVE.l	$2(A0), -$1666(A5)	; Establecer puntero de secuencia activa
	BRA.w	loc_0015CA36		; Continuar con procesamiento final

; ===============================================================
; Verificador de Código de Activación #3 (Botón $0024)
; ===============================================================
; Maneja la detección del código de activación de trucos #3 y
; la funcionalidad de navegación hacia atrás en niveles cuando
; los trucos ya están activos. Si el flag de habilidades mejoradas
; está activo, permite retroceder un nivel. Si no, inicia la
; secuencia para activar el truco #3.
;
; Código de Activación: $0024 (combinación específica de botones)
; Truco Asociado: #3 (Habilidades Mejoradas)
; Flag Verificado: $0040 (bit 6 - habilidades mejoradas)
;
; Funcionalidad Dual:
;   1. Navegación: Si flag $0040 activo → retroceder nivel
;   2. Activación: Si flag inactivo → iniciar secuencia truco #3
;
; Efectos de Navegación:
;   - Decrementa nivel actual en 1
;   - Activa flags de transición de nivel
;   - Marca para recarga de nivel
;
; Parámetros:
;   - D6: Código de botón de entrada ($0024 esperado)
;   - ram_offsetLecturaPad_B: Tipo de controlador
;   - ram_C5A2_FlagCheats: Flags de trucos activos
;   - ram_offsetNivelActual: Nivel actual del juego
;
; Retorna:
;   - Si navegación: nivel decrementado y flags de transición
;   - Si activación: puntero de secuencia y ID de truco #3
; ===============================================================
loc_0015C6A0:
	CMPI.w	#$0024, D6		; ¿Es el código de activación #3?
	BNE.b	loc_0015C6F2		; Si no, probar siguiente código
	MOVEQ	#$00000040, D0		; Máscara para flag de habilidades mejoradas
	AND.w	-$3C5E(A5), D0		; ¿Ya está activo el flag de habilidades?
	BEQ.b	loc_0015C6C8		; Si no está activo, iniciar secuencia
	
	; -------------------------------------------------------
	; Navegación Hacia Atrás (Flag Activo)
	; -------------------------------------------------------
	SUBQ.w	#1, ram_offsetNivelActual(A5)	; Retroceder un nivel
	MOVE.b	#1, -$1662(A5)		; Marcar para resurrección/recarga
	MOVE.b	#1, -$38C2(A5)		; Flag de transición de nivel
	MOVE.w	#1, -$359A(A5)		; Flag de cambio de estado
	BRA.w	loc_0015CA36		; Continuar con procesamiento final

	; -------------------------------------------------------
	; Iniciar Secuencia de Truco #3 (Flag Inactivo)
	; -------------------------------------------------------
loc_0015C6C8:
	MOVE.w	#3, -$3C58(A5)		; Establecer ID de truco #3 (habilidades)
	MOVEQ	#$0000000C, D0		; Código de controlador específico
	CMP.w	ram_offsetLecturaPad_B(A5), D0	; ¿Es controlador tipo $0C?
	BNE.b	loc_0015C6E4		; Si no, usar secuencia alternativa
	LEA	$E1A(A5), A0		; A0 = puntero a secuencia primaria truco #3
	MOVE.l	$2(A0), -$1666(A5)	; Establecer puntero de secuencia activa
	BRA.w	loc_0015CA36		; Continuar con procesamiento final

loc_0015C6E4:
	LEA	$E4A(A5), A0		; A0 = puntero a secuencia alternativa truco #3
	MOVE.l	$2(A0), -$1666(A5)	; Establecer puntero de secuencia activa
	BRA.w	loc_0015CA36		; Continuar con procesamiento final

; ===============================================================
; Verificador de Código de Activación #4 (Botón $0028)
; ===============================================================
; Maneja la detección del código de activación de trucos #4 y
; la funcionalidad de navegación hacia adelante en niveles cuando
; los trucos ya están activos. Si el flag de habilidades avanzadas
; está activo, permite avanzar un nivel. Si no, inicia la
; secuencia para activar el truco #3 (reutiliza mismas secuencias).
;
; Código de Activación: $0028 (combinación específica de botones)
; Truco Asociado: #3 (Habilidades Mejoradas - secuencias compartidas)
; Flag Verificado: $0080 (bit 7 - habilidades avanzadas)
;
; Funcionalidad Dual:
;   1. Navegación: Si flag $0080 activo → avanzar nivel
;   2. Activación: Si flag inactivo → iniciar secuencia truco #3
;
; Efectos de Navegación:
;   - Incrementa nivel actual en 1
;   - Activa flags de transición de nivel
;   - Marca para recarga de nivel
;
; Parámetros:
;   - D6: Código de botón de entrada ($0028 esperado)
;   - ram_offsetLecturaPad_B: Tipo de controlador
;   - ram_C5A2_FlagCheats: Flags de trucos activos
;   - ram_offsetNivelActual: Nivel actual del juego
;
; Retorna:
;   - Si navegación: nivel incrementado y flags de transición
;   - Si activación: puntero de secuencia y ID de truco #3
; ===============================================================
loc_0015C6F2:
	CMPI.w	#$0028, D6		; ¿Es el código de activación #4?
	BNE.b	loc_0015C740		; Si no, probar siguiente código
	MOVE.w	#$0080, D0		; Máscara para flag de habilidades avanzadas
	AND.w	-$3C5E(A5), D0		; ¿Ya está activo el flag de habilidades avanzadas?
	BEQ.b	loc_0015C716		; Si no está activo, iniciar secuencia
	
	; -------------------------------------------------------
	; Navegación Hacia Adelante (Flag Activo)
	; -------------------------------------------------------
	ADDQ.w	#1, ram_offsetNivelActual(A5)	; Avanzar un nivel
	MOVE.b	#1, -$1662(A5)		; Marcar para resurrección/recarga
	MOVE.w	#1, -$359A(A5)		; Flag de cambio de estado
	BRA.w	loc_0015CA36		; Continuar con procesamiento final

	; -------------------------------------------------------
	; Iniciar Secuencia de Truco #3 (Flag Inactivo)
	; -------------------------------------------------------
	; Nota: Reutiliza las mismas secuencias que el código $0024
	; para activar habilidades mejoradas
loc_0015C716:
	MOVE.w	#3, -$3C58(A5)		; Establecer ID de truco #3 (habilidades)
	MOVEQ	#$0000000C, D0		; Código de controlador específico
	CMP.w	ram_offsetLecturaPad_B(A5), D0	; ¿Es controlador tipo $0C?
	BNE.b	loc_0015C732		; Si no, usar secuencia alternativa
	LEA	$E1A(A5), A0		; A0 = puntero a secuencia primaria truco #3
	MOVE.l	$2(A0), -$1666(A5)	; Establecer puntero de secuencia activa
	BRA.w	loc_0015CA36		; Continuar con procesamiento final

loc_0015C732:
	LEA	$E4A(A5), A0		; A0 = puntero a secuencia alternativa truco #3
	MOVE.l	$2(A0), -$1666(A5)	; Establecer puntero de secuencia activa
	BRA.w	loc_0015CA36		; Continuar con procesamiento final

; ===============================================================
; Verificador de Código de Activación #5 (Botón $0012)
; ===============================================================
; Maneja la detección del código de activación de trucos #5 y
; la funcionalidad especial cuando los trucos están activos.
; Si el flag de funciones especiales está activo, realiza
; verificación dual de controladores y ejecuta función especial.
; Si no, inicia la secuencia para activar el truco #5.
;
; Código de Activación: $0012 (combinación específica de botones)
; Truco Asociado: #5 (Funciones Especiales)
; Flag Verificado: $0100 (bit 8 - funciones especiales)
;
; Funcionalidad Dual:
;   1. Modo Especial: Si flag $0100 activo → verificación de controles dual
;   2. Activación: Si flag inactivo → iniciar secuencia truco #5
;
; Verificación Especial:
;   - Requiere estado específico en ambos controladores ($8000)
;   - Máscara $C000 aplicada a entradas de P1 y P2
;   - Ejecuta función especial JSR $3A(A5) si ambos coinciden
;
; Parámetros:
;   - D6: Código de botón de entrada ($0012 esperado)
;   - ram_offsetLecturaPad_B: Tipo de controlador
;   - ram_C5A2_FlagCheats: Flags de trucos activos
;   - -$1754(A5): Estado de control P1
;   - -$1844(A5): Estado de control P2
;
; Retorna:
;   - Si modo especial: ejecuta función especial o sale
;   - Si activación: puntero de secuencia y ID de truco #5
; ===============================================================
loc_0015C740:
	CMPI.w	#$0012, D6		; ¿Es el código de activación #5?
	BNE.w	loc_0015C7CA		; Si no, probar siguiente código
	MOVE.w	#$0100, D0		; Máscara para flag de funciones especiales
	AND.w	-$3C5E(A5), D0		; ¿Ya está activo el flag de funciones especiales?
	BEQ.b	loc_0015C7A0		; Si no está activo, iniciar secuencia
	
	; -------------------------------------------------------
	; Modo Especial - Verificación Dual de Controladores
	; -------------------------------------------------------
	MOVEQ	#$00000037, D0		; ID de sonido especial #55
	MOVE.l	D0, -(A7)		; Parámetro para función de sonido
	JSR	$5222(A5)		; Reproducir sonido de confirmación
	MOVEQ	#$00000037, D0		; Mismo ID de sonido
	MOVE.l	D0, -(A7)		; Parámetro para función auxiliar
	JSR	$521A(A5)		; Función auxiliar de sonido/audio
	
	; Verificar estado de controlador P1
	MOVE.w	-$1754(A5), D0		; Obtener estado de control P1
	EXT.l	D0			; Extender a longword para comparación
	MOVE.w	#$C000, D1		; Máscara para botones específicos
	AND.w	D0, D1			; Aplicar máscara al estado P1
	MOVEQ	#0, D0			; Limpiar D0
	MOVE.w	D1, D0			; Cargar resultado enmascarado
	CMPI.l	#$00008000, D0		; ¿Estado específico P1? ($8000)
	ADDQ.w	#8, A7			; Limpiar stack (2 parámetros de sonido)
	BNE.w	loc_0015CA36		; Si no coincide, salir sin ejecutar
	
	; Verificar estado de controlador P2
	MOVE.w	-$1844(A5), D0		; Obtener estado de control P2
	EXT.l	D0			; Extender a longword para comparación
	MOVE.w	#$C000, D1		; Misma máscara para botones específicos
	AND.w	D0, D1			; Aplicar máscara al estado P2
	MOVEQ	#0, D0			; Limpiar D0
	MOVE.w	D1, D0			; Cargar resultado enmascarado
	CMPI.l	#$00008000, D0		; ¿Estado específico P2? ($8000)
	BNE.w	loc_0015CA36		; Si no coincide, salir sin ejecutar
	
	; Ambos controladores en estado correcto - ejecutar función especial
	JSR	$3A(A5)			; Llamar función especial desbloqueada
	BRA.w	loc_0015CA36		; Ir a procesamiento final

	; -------------------------------------------------------
	; Iniciar Secuencia de Truco #5 (Flag Inactivo)
	; -------------------------------------------------------
loc_0015C7A0:
	MOVE.w	#5, -$3C58(A5)		; Establecer ID de truco #5 (funciones especiales)
	MOVEQ	#$0000000C, D0		; Código de controlador específico
	CMP.w	ram_offsetLecturaPad_B(A5), D0	; ¿Es controlador tipo $0C?
	BNE.b	loc_0015C7BC		; Si no, usar secuencia alternativa
	LEA	$E22(A5), A0		; A0 = puntero a secuencia primaria truco #5
	MOVE.l	$2(A0), -$1666(A5)	; Establecer puntero de secuencia activa
	BRA.w	loc_0015CA36		; Continuar con procesamiento final

loc_0015C7BC:
	LEA	$E52(A5), A0		; A0 = puntero a secuencia alternativa truco #5
	MOVE.l	$2(A0), -$1666(A5)	; Establecer puntero de secuencia activa
	BRA.w	loc_0015CA36		; Continuar con procesamiento final

; ===============================================================
; Verificador de Código de Navegación Avanzada #6 (Botón $0014)
; ===============================================================
; Maneja la detección del código de activación para navegación
; avanzada de niveles. Si el flag de navegación está activo,
; implementa un sistema de navegación hacia adelante con
; verificación inteligente de niveles disponibles. Si no está
; activo, inicia la secuencia para activar el truco #7.
;
; Código de Activación: $0014 (combinación específica de botones)
; Truco Asociado: #7 (Navegación de Niveles)
; Flag Verificado: $0400 (bit 10 - navegación de niveles)
;
; Funcionalidad Dual:
;   1. Navegación Inteligente: Si flag $0400 activo → buscar siguiente nivel válido
;   2. Activación: Si flag inactivo → iniciar secuencia truco #7
;
; Sistema de Navegación Avanzada:
;   - Busca secuencialmente niveles disponibles hacia adelante
;   - Verifica múltiples ubicaciones de Cerebro (Clone, Space, Savage, etc.)
;   - Solo selecciona niveles que están desbloqueados y disponibles
;   - Implementa lógica de fallback si no encuentra niveles válidos
;
; Parámetros:
;   - D6: Código de botón de entrada ($0014 esperado)
;   - ram_offsetLecturaPad_B: Tipo de controlador
;   - ram_C5A2_FlagCheats: Flags de trucos activos
;   - ram_offsetNivelActual: Nivel actual del juego
;   - ram_offsetNivelCerebroScreen*: Estados de desbloqueado por ubicación
;
; Retorna:
;   - Si navegación: nivel válido seleccionado y flags de transición
;   - Si activación: puntero de secuencia y ID de truco #7
; ===============================================================
loc_0015C7CA:
	CMPI.w	#$0014, D6		; ¿Es el código de navegación avanzada #6?
	BNE.w	loc_0015C8D8		; Si no, probar siguiente código
	MOVE.w	#$0400, D0		; Máscara para flag de navegación de niveles
	AND.w	-$3C5E(A5), D0		; ¿Ya está activo el flag de navegación?
	BEQ.w	loc_0015C8AE		; Si no está activo, iniciar secuencia
	
	; -------------------------------------------------------
	; Sistema de Navegación Inteligente Hacia Adelante
	; -------------------------------------------------------
	CLR.w	D7			; D7 = nivel candidato (inicialmente 0)
	MOVEQ	#$00000026, D0		; ID de sonido #38 (confirmación navegación)
	MOVE.l	D0, -(A7)		; Parámetro para función de sonido
	JSR	$5222(A5)		; Reproducir sonido de confirmación
	MOVEQ	#$00000026, D0		; Mismo ID de sonido
	MOVE.l	D0, -(A7)		; Parámetro para función auxiliar
	JSR	$521A(A5)		; Función auxiliar de sonido/audio
	TST.w	D7			; ¿Ya encontramos un nivel válido?
	ADDQ.w	#8, A7			; Limpiar stack (2 parámetros de sonido)
	BNE.b	loc_0015C80C		; Si ya tenemos nivel, usar ese
	
	; Verificar nivel Clone (primera prioridad)
	MOVEQ	#0, D0			; Limpiar D0
	MOVE.b	ram_offsetNivelCerebroScreenClone(A5), D0	; Obtener nivel máximo Clone
	ADDQ.w	#1, D0			; Incrementar para comparación
	CMP.w	ram_offsetNivelActual(A5), D0	; ¿Nivel actual >= nivel Clone?
	BGE.b	loc_0015C80C		; Si sí, no usar Clone
	MOVEQ	#0, D7			; Limpiar candidato
	MOVE.b	ram_offsetNivelCerebroScreenClone(A5), D7	; D7 = nivel Clone
	TST.l	D7			; ¿Es nivel válido? (no cero)

loc_0015C80C:
	TST.w	D7			; ¿Ya encontramos nivel válido?
	BNE.b	loc_0015C826		; Si sí, verificar siguiente
	
	; Verificar nivel Space (segunda prioridad)
	MOVEQ	#0, D0			; Limpiar D0
	MOVE.b	ram_offsetNivelCerebroScreenSpace(A5), D0	; Obtener nivel máximo Space
	ADDQ.w	#1, D0			; Incrementar para comparación
	CMP.w	ram_offsetNivelActual(A5), D0	; ¿Nivel actual >= nivel Space?
	BGE.b	loc_0015C826		; Si sí, no usar Space
	MOVEQ	#0, D7			; Limpiar candidato
	MOVE.b	ram_offsetNivelCerebroScreenSpace(A5), D7	; D7 = nivel Space
	TST.l	D7			; ¿Es nivel válido? (no cero)

loc_0015C826:
	TST.w	D7			; ¿Ya encontramos nivel válido?
	BNE.b	loc_0015C840		; Si sí, verificar siguiente
	
	; Verificar nivel Savage (tercera prioridad)
	MOVEQ	#0, D0			; Limpiar D0
	MOVE.b	ram_offsetNivelCerebroScreenSavage(A5), D0	; Obtener nivel máximo Savage
	ADDQ.w	#1, D0			; Incrementar para comparación
	CMP.w	ram_offsetNivelActual(A5), D0	; ¿Nivel actual >= nivel Savage?
	BGE.b	loc_0015C840		; Si sí, no usar Savage
	MOVEQ	#0, D7			; Limpiar candidato
	MOVE.b	ram_offsetNivelCerebroScreenSavage(A5), D7	; D7 = nivel Savage
	TST.l	D7			; ¿Es nivel válido? (no cero)

loc_0015C840:
	TST.w	D7			; ¿Ya encontramos nivel válido?
	BNE.b	loc_0015C85A		; Si sí, verificar siguiente
	
	; Verificar nivel BaniMaza (cuarta prioridad)
	MOVEQ	#0, D0			; Limpiar D0
	MOVE.b	ram_offsetNivelCerebroScreenBaniMaza(A5), D0	; Obtener nivel máximo BaniMaza
	ADDQ.w	#1, D0			; Incrementar para comparación
	CMP.w	ram_offsetNivelActual(A5), D0	; ¿Nivel actual >= nivel BaniMaza?
	BGE.b	loc_0015C85A		; Si sí, no usar BaniMaza
	MOVEQ	#0, D7			; Limpiar candidato
	MOVE.b	ram_offsetNivelCerebroScreenBaniMaza(A5), D7	; D7 = nivel BaniMaza
	TST.l	D7			; ¿Es nivel válido? (no cero)

loc_0015C85A:
	TST.w	D7			; ¿Ya encontramos nivel válido?
	BNE.b	loc_0015C874		; Si sí, verificar siguiente
	
	; Verificar nivel Avalon (quinta prioridad)
	MOVEQ	#0, D0			; Limpiar D0
	MOVE.b	ram_offsetNivelCerebroScreenAvalon(A5), D0	; Obtener nivel máximo Avalon
	ADDQ.w	#1, D0			; Incrementar para comparación
	CMP.w	ram_offsetNivelActual(A5), D0	; ¿Nivel actual >= nivel Avalon?
	BGE.b	loc_0015C874		; Si sí, no usar Avalon
	MOVEQ	#0, D7			; Limpiar candidato
	MOVE.b	ram_offsetNivelCerebroScreenAvalon(A5), D7	; D7 = nivel Avalon
	TST.l	D7			; ¿Es nivel válido? (no cero)

loc_0015C874:
	TST.w	D7			; ¿Ya encontramos nivel válido?
	BNE.b	loc_0015C88E		; Si sí, verificar último
	
	; Verificar nivel Sentinels (última prioridad)
	MOVEQ	#0, D0			; Limpiar D0
	MOVE.b	ram_offsetNivelCerebroScreenSentinels(A5), D0	; Obtener nivel máximo Sentinels
	ADDQ.w	#1, D0			; Incrementar para comparación
	CMP.w	ram_offsetNivelActual(A5), D0	; ¿Nivel actual >= nivel Sentinels?
	BGE.b	loc_0015C88E		; Si sí, no usar Sentinels
	MOVEQ	#0, D7			; Limpiar candidato
	MOVE.b	ram_offsetNivelCerebroScreenSentinels(A5), D7	; D7 = nivel Sentinels
	TST.l	D7			; ¿Es nivel válido? (no cero)

loc_0015C88E:
	TST.w	D7			; ¿Encontramos algún nivel válido?
	BEQ.w	loc_0015CA36		; Si no, salir sin cambios
	
	; -------------------------------------------------------
	; Aplicar Navegación - Cambiar a Nivel Seleccionado
	; -------------------------------------------------------
	MOVE.w	D7, ram_offsetNivelActual(A5)	; Establecer nuevo nivel actual
	MOVE.b	#1, -$1662(A5)		; Marcar para resurrección/recarga
	MOVE.w	#1, -$359A(A5)		; Flag de cambio de estado
	MOVE.b	#1, -$38C2(A5)		; Flag de transición de nivel
	BRA.w	loc_0015CA36		; Continuar con procesamiento final

	; -------------------------------------------------------
	; Iniciar Secuencia de Truco #7 (Flag Inactivo)
	; -------------------------------------------------------
loc_0015C8AE:
	MOVE.w	#7, -$3C58(A5)		; Establecer ID de truco #7 (navegación niveles)
	MOVEQ	#$0000000C, D0		; Código de controlador específico
	CMP.w	ram_offsetLecturaPad_B(A5), D0	; ¿Es controlador tipo $0C?
	BNE.b	loc_0015C8CA		; Si no, usar secuencia alternativa
	LEA	$E2A(A5), A0		; A0 = puntero a secuencia primaria truco #7
	MOVE.l	$2(A0), -$1666(A5)	; Establecer puntero de secuencia activa
	BRA.w	loc_0015CA36		; Continuar con procesamiento final

loc_0015C8CA:
	LEA	$E5A(A5), A0		; A0 = puntero a secuencia alternativa truco #7
	MOVE.l	$2(A0), -$1666(A5)	; Establecer puntero de secuencia activa
	BRA.w	loc_0015CA36		; Continuar con procesamiento final

; ===============================================================
; Verificador de Código de Navegación Inversa #7 (Botón $0018)
; ===============================================================
; Maneja la detección del código de activación para navegación
; inversa de niveles. Si el flag de navegación está activo,
; implementa un sistema de navegación hacia atrás con
; verificación inteligente de niveles disponibles en orden
; inverso al código $0014. Si no está activo, inicia la
; secuencia para activar el truco #7.
;
; Código de Activación: $0018 (combinación específica de botones)
; Truco Asociado: #7 (Navegación de Niveles)
; Flag Verificado: $0400 (bit 10 - navegación de niveles)
;
; Funcionalidad Dual:
;   1. Navegación Inversa: Si flag $0400 activo → buscar nivel anterior válido
;   2. Activación: Si flag inactivo → iniciar secuencia truco #7
;
; Sistema de Navegación Inversa:
;   - Busca secuencialmente niveles disponibles hacia atrás
;   - Verifica múltiples ubicaciones de Cerebro en orden inverso
;   - Solo selecciona niveles que están desbloqueados y son menores al actual
;   - Prioridad inversa: Sentinels → Avalon → BaniMaza → Savage → Space → Clone
;
; Parámetros:
;   - D6: Código de botón de entrada ($0018 esperado)
;   - ram_offsetLecturaPad_B: Tipo de controlador
;   - ram_C5A2_FlagCheats: Flags de trucos activos
;   - ram_offsetNivelActual: Nivel actual del juego
;   - ram_offsetNivelCerebroScreen*: Estados de desbloqueado por ubicación
;
; Retorna:
;   - Si navegación: nivel válido anterior seleccionado y flags de transición
;   - Si activación: puntero de secuencia y ID de truco #7
; ===============================================================
loc_0015C8D8:
	CMPI.w	#$0018, D6		; ¿Es el código de navegación inversa #7?
	BNE.w	loc_0015C9D6		; Si no, probar siguiente código
	MOVE.w	#$0400, D0		; Máscara para flag de navegación de niveles
	AND.w	-$3C5E(A5), D0		; ¿Ya está activo el flag de navegación?
	BEQ.w	loc_0015C9B0		; Si no está activo, iniciar secuencia
	
	; -------------------------------------------------------
	; Sistema de Navegación Inteligente Hacia Atrás
	; -------------------------------------------------------
	CLR.w	D7			; D7 = nivel candidato (inicialmente 0)
	MOVEQ	#$00000026, D0		; ID de sonido #38 (confirmación navegación)
	MOVE.l	D0, -(A7)		; Parámetro para función de sonido
	JSR	$5222(A5)		; Reproducir sonido de confirmación
	MOVEQ	#$00000026, D0		; Mismo ID de sonido
	MOVE.l	D0, -(A7)		; Parámetro para función auxiliar
	JSR	$521A(A5)		; Función auxiliar de sonido/audio
	TST.w	D7			; ¿Ya encontramos un nivel válido?
	ADDQ.w	#8, A7			; Limpiar stack (2 parámetros de sonido)
	BNE.b	loc_0015C918		; Si ya tenemos nivel, usar ese
	
	; Verificar nivel Sentinels (primera prioridad inversa)
	MOVEQ	#0, D0			; Limpiar D0
	MOVE.b	ram_offsetNivelCerebroScreenSentinels(A5), D0	; Obtener nivel máximo Sentinels
	CMP.w	ram_offsetNivelActual(A5), D0	; ¿Nivel Sentinels < nivel actual?
	BLE.b	loc_0015C918		; Si no, no usar Sentinels
	MOVEQ	#0, D7			; Limpiar candidato
	MOVE.b	ram_offsetNivelCerebroScreenSentinels(A5), D7	; D7 = nivel Sentinels
	TST.l	D7			; ¿Es nivel válido? (no cero)

loc_0015C918:
	TST.w	D7			; ¿Ya encontramos nivel válido?
	BNE.b	loc_0015C930		; Si sí, verificar siguiente
	
	; Verificar nivel Avalon (segunda prioridad inversa)
	MOVEQ	#0, D0			; Limpiar D0
	MOVE.b	ram_offsetNivelCerebroScreenAvalon(A5), D0	; Obtener nivel máximo Avalon
	CMP.w	ram_offsetNivelActual(A5), D0	; ¿Nivel Avalon < nivel actual?
	BLE.b	loc_0015C930		; Si no, no usar Avalon
	MOVEQ	#0, D7			; Limpiar candidato
	MOVE.b	ram_offsetNivelCerebroScreenAvalon(A5), D7	; D7 = nivel Avalon
	TST.l	D7			; ¿Es nivel válido? (no cero)

loc_0015C930:
	TST.w	D7			; ¿Ya encontramos nivel válido?
	BNE.b	loc_0015C948		; Si sí, verificar siguiente
	
	; Verificar nivel BaniMaza (tercera prioridad inversa)
	MOVEQ	#0, D0			; Limpiar D0
	MOVE.b	ram_offsetNivelCerebroScreenBaniMaza(A5), D0	; Obtener nivel máximo BaniMaza
	CMP.w	ram_offsetNivelActual(A5), D0	; ¿Nivel BaniMaza < nivel actual?
	BLE.b	loc_0015C948		; Si no, no usar BaniMaza
	MOVEQ	#0, D7			; Limpiar candidato
	MOVE.b	ram_offsetNivelCerebroScreenBaniMaza(A5), D7	; D7 = nivel BaniMaza
	TST.l	D7			; ¿Es nivel válido? (no cero)

loc_0015C948:
	TST.w	D7			; ¿Ya encontramos nivel válido?
	BNE.b	loc_0015C960		; Si sí, verificar siguiente
	
	; Verificar nivel Savage (cuarta prioridad inversa)
	MOVEQ	#0, D0			; Limpiar D0
	MOVE.b	ram_offsetNivelCerebroScreenSavage(A5), D0	; Obtener nivel máximo Savage
	CMP.w	ram_offsetNivelActual(A5), D0	; ¿Nivel Savage < nivel actual?
	BLE.b	loc_0015C960		; Si no, no usar Savage
	MOVEQ	#0, D7			; Limpiar candidato
	MOVE.b	ram_offsetNivelCerebroScreenSavage(A5), D7	; D7 = nivel Savage
	TST.l	D7			; ¿Es nivel válido? (no cero)

loc_0015C960:
	TST.w	D7			; ¿Ya encontramos nivel válido?
	BNE.b	loc_0015C978		; Si sí, verificar siguiente
	
	; Verificar nivel Space (quinta prioridad inversa)
	MOVEQ	#0, D0			; Limpiar D0
	MOVE.b	ram_offsetNivelCerebroScreenSpace(A5), D0	; Obtener nivel máximo Space
	CMP.w	ram_offsetNivelActual(A5), D0	; ¿Nivel Space < nivel actual?
	BLE.b	loc_0015C978		; Si no, no usar Space
	MOVEQ	#0, D7			; Limpiar candidato
	MOVE.b	ram_offsetNivelCerebroScreenSpace(A5), D7	; D7 = nivel Space
	TST.l	D7			; ¿Es nivel válido? (no cero)

loc_0015C978:
	TST.w	D7			; ¿Ya encontramos nivel válido?
	BNE.b	loc_0015C990		; Si sí, verificar último
	
	; Verificar nivel Clone (última prioridad inversa)
	MOVEQ	#0, D0			; Limpiar D0
	MOVE.b	ram_offsetNivelCerebroScreenClone(A5), D0	; Obtener nivel máximo Clone
	CMP.w	ram_offsetNivelActual(A5), D0	; ¿Nivel Clone < nivel actual?
	BLE.b	loc_0015C990		; Si no, no usar Clone
	MOVEQ	#0, D7			; Limpiar candidato
	MOVE.b	ram_offsetNivelCerebroScreenClone(A5), D7	; D7 = nivel Clone
	TST.l	D7			; ¿Es nivel válido? (no cero)

loc_0015C990:
	TST.w	D7			; ¿Encontramos algún nivel válido hacia atrás?
	BEQ.w	loc_0015CA36		; Si no, salir sin cambios
	
	; -------------------------------------------------------
	; Aplicar Navegación Inversa - Cambiar a Nivel Anterior
	; -------------------------------------------------------
	MOVE.w	D7, ram_offsetNivelActual(A5)	; Establecer nuevo nivel actual
	MOVE.b	#1, -$1662(A5)		; Marcar para resurrección/recarga
	MOVE.w	#1, -$359A(A5)		; Flag de cambio de estado
	MOVE.b	#1, -$38C2(A5)		; Flag de transición de nivel
	BRA.w	loc_0015CA36		; Continuar con procesamiento final

	; -------------------------------------------------------
	; Iniciar Secuencia de Truco #7 (Flag Inactivo)
	; -------------------------------------------------------
loc_0015C9B0:
	MOVE.w	#7, -$3C58(A5)		; Establecer ID de truco #7 (navegación niveles)
	MOVEQ	#$0000000C, D0		; Código de controlador específico
	CMP.w	ram_offsetLecturaPad_B(A5), D0	; ¿Es controlador tipo $0C?
	BNE.b	loc_0015C9CA		; Si no, usar secuencia alternativa
	LEA	$E2A(A5), A0		; A0 = puntero a secuencia primaria truco #7
	MOVE.l	$2(A0), -$1666(A5)	; Establecer puntero de secuencia activa
	BRA.b	loc_0015CA36		; Continuar con procesamiento final

loc_0015C9CA:
	LEA	$E5A(A5), A0		; A0 = puntero a secuencia alternativa truco #7
	MOVE.l	$2(A0), -$1666(A5)	; Establecer puntero de secuencia activa
	BRA.b	loc_0015CA36		; Continuar con procesamiento final

; ===============================================================
; Verificador de Código de Invencibilidad #8 (Botón $0011)
; ===============================================================
; Maneja la detección del código de activación final para el
; sistema de invencibilidad y salud máxima. Si el flag de
; invencibilidad está activo, proporciona salud máxima instantánea
; ($7FFF) a ambos jugadores. Si no está activo, inicia la
; secuencia para activar el truco #8 (invencibilidad).
;
; Código de Activación: $0011 (combinación específica de botones)
; Truco Asociado: #8 (Sistema de Invencibilidad)
; Flag Verificado: $0200 (bit 9 - invencibilidad)
;
; Funcionalidad Dual:
;   1. Super Salud: Si flag $0200 activo → salud máxima instantánea
;   2. Activación: Si flag inactivo → iniciar secuencia truco #8
;
; Efectos de Super Salud:
;   - Establece salud P1 y P2 a valor máximo ($7FFF = 32767)
;   - Solo afecta jugadores que están vivos (salud > 0)
;   - Reproduce sonido de confirmación (#36)
;
; Diferencias con Otros Códigos de Salud:
;   - Valor máximo absoluto ($7FFF vs $0900 en códigos básicos)
;   - Requiere flag de invencibilidad activo
;   - Es el código de salud más poderoso del sistema
;
; Parámetros:
;   - D6: Código de botón de entrada ($0011 esperado)
;   - ram_offsetLecturaPad_B: Tipo de controlador
;   - ram_C5A2_FlagCheats: Flags de trucos activos
;   - ram_offsetSaludActual: Salud actual P1
;   - ram_offsetSalud2up: Salud actual P2
;
; Retorna:
;   - Si super salud: valores de salud establecidos a $7FFF
;   - Si activación: puntero de secuencia y ID de truco #8
; ===============================================================
loc_0015C9D6:
	CMPI.w	#$0011, D6		; ¿Es el código de invencibilidad final #8?
	BNE.b	loc_0015CA36		; Si no, terminar procesamiento (último código)
	MOVE.w	#$0200, D0		; Máscara para flag de invencibilidad
	AND.w	-$3C5E(A5), D0		; ¿Ya está activo el flag de invencibilidad?
	BEQ.b	loc_0015CA12		; Si no está activo, iniciar secuencia
	
	; -------------------------------------------------------
	; Modo Super Salud - Salud Máxima Instantánea
	; -------------------------------------------------------
	MOVEQ	#$00000024, D0		; ID de sonido #36 (confirmación invencibilidad)
	MOVE.l	D0, -(A7)		; Parámetro para función de sonido
	JSR	$5222(A5)		; Reproducir sonido de confirmación
	MOVEQ	#$00000024, D0		; Mismo ID de sonido
	MOVE.l	D0, -(A7)		; Parámetro para función auxiliar
	JSR	$521A(A5)		; Función auxiliar de sonido/audio
	
	; Verificar y establecer super salud para Jugador 1
	TST.w	ram_offsetSaludActual(A5)	; ¿P1 está vivo? (salud > 0)
	ADDQ.w	#8, A7			; Limpiar stack (2 parámetros de sonido)
	BLE.b	loc_0015CA04		; Si está muerto, verificar P2
	MOVE.w	#$7FFF, ram_offsetSaludActual(A5)	; Establecer salud máxima absoluta P1

loc_0015CA04:
	; Verificar y establecer super salud para Jugador 2
	TST.w	ram_offsetSalud2up(A5)	; ¿P2 está vivo? (salud > 0)
	BLE.b	loc_0015CA36		; Si está muerto, terminar
	MOVE.w	#$7FFF, ram_offsetSalud2up(A5)	; Establecer salud máxima absoluta P2
	BRA.b	loc_0015CA36		; Ir a procesamiento final

	; -------------------------------------------------------
	; Iniciar Secuencia de Truco #8 (Flag Inactivo)
	; -------------------------------------------------------
loc_0015CA12:
	MOVE.w	#8, -$3C58(A5)		; Establecer ID de truco #8 (invencibilidad)
	MOVEQ	#$0000000C, D0		; Código de controlador específico
	CMP.w	ram_offsetLecturaPad_B(A5), D0	; ¿Es controlador tipo $0C?
	BNE.b	loc_0015CA2C		; Si no, usar secuencia alternativa
	LEA	$E32(A5), A0		; A0 = puntero a secuencia primaria truco #8
	MOVE.l	$2(A0), -$1666(A5)	; Establecer puntero de secuencia activa
	BRA.b	loc_0015CA36		; Continuar con procesamiento final

loc_0015CA2C:
	LEA	$E62(A5), A0		; A0 = puntero a secuencia alternativa truco #8
	MOVE.l	$2(A0), -$1666(A5)	; Establecer puntero de secuencia activa

; ===============================================================
; Procesamiento Final y Detección de Botón Start
; ===============================================================
loc_0015CA36:
	; Verificar presión de START para resurrección inmediata
	TST.w	ram_offsetSaludActual(A5)	; ¿P1 tiene salud?
	BLE.b	loc_0015CA4C		; Si no, verificar P2
	MOVE.w	#$0080, D0		; Máscara para botón START
	AND.w	-$3A2E(A5), D0		; ¿START presionado en P1?
	BEQ.b	loc_0015CA4C		; Si no, continuar
	MOVE.b	#1, -$1662(A5)		; Marcar para resurrección

loc_0015CA4C:
	TST.w	ram_offsetSalud2up(A5)	; ¿P2 tiene salud?
	BLE.b	loc_0015CA62		; Si no, terminar
	MOVE.w	#$0080, D0		; Máscara para START
	AND.w	-$3A30(A5), D0		; ¿START presionado en P2?
	BEQ.b	loc_0015CA62		; Si no, terminar
	MOVE.b	#1, -$1662(A5)		; Marcar para resurrección

loc_0015CA62:
	MOVEM.l	-$8(A6), D6/D7		; Restaurar registros
	UNLK	A6			; Restaurar frame pointer
	RTS				; Retornar al llamador
