; ===============================================================================
; FUNCIÓN: Procesamiento y Escalado de Sprites de Personajes
; ===============================================================================
; Descripción: Función principal para el procesamiento, escalado y renderizado
;              de sprites de personajes. Maneja la conversión de datos de sprite
;              desde formato comprimido a buffer de destino, aplicando escalado
;              y transformaciones según los parámetros especificados
; Parámetros:  $8(A6) = Puntero a estructura de datos de sprite base
;              $E(A6) = Índice de sprite/frame (word)
;              $10(A6) = Puntero a buffer de destino para sprite procesado
; Variables locales en stack:
;              -$4(A6) = Puntero a buffer de trabajo
;              -$8(A6) = Puntero actual en buffer de destino
;              -$A(A6) = Ancho del sprite en bytes
;              -$C(A6) = Alto del sprite en píxeles
;              -$E(A6) = Coordenada X de origen
;              -$10(A6) = Coordenada Y de origen
;              -$12(A6) = Flags de escalado horizontal
;              -$13(A6) = Flag de inversión horizontal
;              -$14(A6) = Flag de inversión vertical
; ===============================================================================
loc_001FC35C:
	; === Configuración inicial del stack frame ===
	LINK	A6, #-$00000014				; Crear stack frame con 20 bytes de variables locales
	MOVEM.l	A4/A3/A2/D7/D6/D5/D4/D3/D2, -(A7)	; Guardar registros de trabajo
	
	; === Calcular offset del sprite en la tabla ===
	MOVEA.l	$8(A6), A0					; A0 = puntero a estructura base de sprites
	LEA	$24(A0), A4					; A4 = puntero a tabla de sprites (base + $24)
	MOVE.w	$E(A6), D0					; D0 = índice de sprite/frame
	ADD.w	D0, D0						; D0 *= 2
	ADD.w	D0, D0						; D0 *= 4 (cada entrada son 4 bytes)
	MOVE.w	D0, D1						; D1 = D0 (backup)
	ADD.w	D0, D0						; D0 *= 8
	ADD.w	D0, D0						; D0 *= 16
	ADD.w	D1, D0						; D0 = D0 + D1 (D0 *= 20, entrada de 20 bytes)
	ADDA.w	D0, A4						; A4 = puntero al sprite específico
	
	; === Leer información del sprite y preparar parámetros ===
	MOVEQ	#0, D7						; D7 = contador de frames/layers
	MOVE.b	$10(A4), D7					; D7 = número de frames en este sprite
	
	; === Extraer coordenadas y dimensiones del sprite ===
	MOVE.b	(A4), D0					; D0 = coordenada X inicial
	EXT.w	D0							; Extender a word con signo
	MOVE.w	D0, -$E(A6)					; Guardar X inicial
	MOVE.b	$2(A4), D1					; D1 = coordenada X final
	EXT.w	D1							; Extender a word con signo
	SUB.w	D0, D1						; D1 = ancho (X_final - X_inicial)
	MOVEQ	#1, D0						; D0 = 1 para alineación
	AND.w	D1, D0						; D0 = ancho & 1 (verificar paridad)
	ADD.w	D0, D1						; Alinear ancho a número par
	MOVE.w	D1, -$A(A6)					; Guardar ancho alineado
	
	MOVE.b	$1(A4), D0					; D0 = coordenada Y inicial
	EXT.w	D0							; Extender a word con signo
	MOVE.w	D0, -$10(A6)				; Guardar Y inicial
	MOVE.b	$3(A4), D2					; D2 = coordenada Y final
	EXT.w	D2							; Extender a word con signo
	SUB.w	D0, D2						; D2 = alto (Y_final - Y_inicial)
	MOVE.w	D2, -$C(A6)					; Guardar alto del sprite
	
	; === Configurar buffer de destino ===
	MOVEA.l	$10(A6), A0					; A0 = puntero a buffer de destino
	CLR.b	$2(A0)						; Limpiar byte de estado 2
	CLR.b	$3(A0)						; Limpiar byte de estado 3
	MOVE.b	D1, $4(A0)					; Escribir ancho en buffer
	MOVE.b	D2, $5(A0)					; Escribir alto en buffer
	
	; === Calcular tamaño total y preparar área de trabajo ===
	MOVE.w	D2, D0						; D0 = alto
	MULU.w	D1, D0						; D0 = alto × ancho = tamaño total
	LEA	$26(A0), A3					; A3 = puntero a área de datos (buffer + $26)
	MOVE.l	A3, -$4(A6)					; Guardar puntero base de trabajo
	
	; === Limpiar buffer de datos ===
	MOVEQ	#0, D2						; D2 = valor de limpieza (0)
	MOVE.w	D0, D1						; D1 = tamaño total
	LSR.w	#2, D1						; D1 = tamaño/4 (limpieza por longwords)
	BRA.b	loc_001FC3DE				; Saltar al bucle de limpieza

loc_001FC3DC:
	MOVE.l	D2, (A3)+					; Limpiar 4 bytes y avanzar

loc_001FC3DE:
	DBF	D1, loc_001FC3DC			; Repetir hasta limpiar todo
	ANDI.w	#3, D0						; D0 = bytes restantes (módulo 4)
	BRA.b	loc_001FC3EA				; Saltar al bucle de bytes

loc_001FC3E8:
	MOVE.b	D2, (A3)+					; Limpiar 1 byte y avanzar

loc_001FC3EA:
	DBF	D0, loc_001FC3E8			; Repetir hasta limpiar bytes restantes
	
	; === Configurar puntero a datos de sprite y tabla de lookup ===
	MOVE.w	$12(A4), D0					; D0 = offset a datos de sprite
	MOVEA.l	$8(A6), A4					; A4 = estructura base nuevamente
	ADDA.w	D0, A4						; A4 = puntero a datos de sprite reales
	LEA	loc_001FBFCC(PC), A1		; A1 = tabla de lookup para decodificación
	BRA.w	loc_001FC5F0				; Saltar al bucle principal

; === BUCLE PRINCIPAL: Procesamiento de cada frame/layer del sprite ===
loc_001FC400:
	; === Decodificar flags de transformación del sprite ===
	MOVE.w	$4(A4), D0					; D0 = word de flags y atributos
	MOVE.w	D0, D5						; D5 = copia para escalado horizontal
	ANDI.w	#3, D5						; D5 = bits 0-1 (factor de escalado horizontal)
	MOVE.w	D5, -$12(A6)				; Guardar factor de escalado horizontal
	MOVE.w	D0, D6						; D6 = copia para escalado vertical
	LSR.w	#2, D6						; D6 >> 2
	ANDI.w	#3, D6						; D6 = bits 2-3 (factor de escalado vertical)
	ROL.w	#5, D0						; Rotar para acceder a flags superiores
	MOVE.w	D0, D1						; D1 = copia de flags rotados
	ANDI.w	#1, D1						; D1 = bit de inversión horizontal
	MOVE.b	D1, -$13(A6)				; Guardar flag de inversión horizontal
	ANDI.w	#2, D0						; D0 = bit de inversión vertical
	MOVE.b	D0, -$14(A6)				; Guardar flag de inversión vertical
	
	; === Calcular posición inicial en buffer de destino ===
	MOVE.w	(A4), D0					; D0 = coordenada X del sprite
	SUB.w	-$E(A6), D0					; D0 = X relativa (X_sprite - X_base)
	MOVE.w	$2(A4), D1					; D1 = coordenada Y del sprite
	SUB.w	-$10(A6), D1				; D1 = Y relativa (Y_sprite - Y_base)
	
	; === Configurar direcciones de avance según orientación ===
	MOVEQ	#0, D3						; D3 = avance horizontal por defecto
	MOVEQ	#-8, D4						; D4 = avance vertical por defecto (-8)
	MOVE.w	-$A(A6), D3					; D3 = ancho del sprite (avance normal)
	MOVEQ	#0, D2						; D2 = offset de alineación
	
	; === Ajustar para inversión horizontal ===
	TST.b	-$13(A6)					; ¿Inversión horizontal activa?
	BEQ.b	loc_001FC450				; Si no, continuar normal
	MOVE.b	loc_001FC462(PC,D6.w), D2	; D2 = offset según factor de escalado vertical
	ADD.w	D2, D0						; Ajustar X inicial
	NEG.l	D4							; D4 = +8 (invertir avance vertical)

loc_001FC450:
	; === Ajustar para inversión vertical ===
	TST.b	-$14(A6)					; ¿Inversión vertical activa?
	BEQ.b	loc_001FC466				; Si no, continuar
	MOVE.b	loc_001FC462(PC,D5.w), D2	; D2 = offset según factor de escalado horizontal
	SUBQ.w	#1, D2						; Ajustar offset
	ADD.w	D2, D1						; Ajustar Y inicial
	NEG.l	D3							; Invertir avance horizontal
	BRA.b	loc_001FC466				; Continuar

loc_001FC462:
	dc.b	$08, $10, $18, $20			; Tabla de offsets de escalado [8, 16, 24, 32]

loc_001FC466:
	; === Calcular posición final en buffer ===
	ADD.l	D4, D3						; D3 = avance combinado
	MOVEA.l	-$4(A6), A3					; A3 = puntero base del buffer
	MULU.w	-$A(A6), D1					; D1 = Y × ancho (offset de línea)
	ADDA.l	D1, A3						; A3 += offset de línea
	ADDA.w	D0, A3						; A3 += offset de columna
	MOVE.l	A3, -$8(A6)					; Guardar posición actual en buffer
	
	; === Preparar puntero a datos de sprite ===
	MOVEA.l	$8(A6), A2					; A2 = estructura base
	ADDA.w	$6(A4), A2					; A2 = puntero a datos de este frame

; === BUCLE VERTICAL: Procesar filas según escalado ===
loc_001FC480:
	MOVE.w	-$12(A6), D5				; D5 = factor de escalado horizontal

; === BUCLE HORIZONTAL: Procesar columnas según escalado ===
loc_001FC484:
	MOVEQ	#7, D4						; D4 = contador de columnas (8 columnas por bloque)

; === BUCLE DE PIXELS: Procesar 8 pixels por iteración ===
loc_001FC486:
	; === Leer datos del sprite (4 bytes = 8 pixels en 4bpp) ===
	MOVE.l	(A2)+, D2					; D2 = datos de 8 pixels, avanzar puntero
	BNE.b	loc_001FC49E				; Si no es 0, procesar pixels
	
	; === Caso especial: Datos vacíos (transparentes) ===
	MOVEQ	#0, D0						; D0 = 0
	MOVE.w	-$A(A6), D0					; D0 = ancho del sprite
	TST.b	-$14(A6)					; ¿Inversión vertical activa?
	BEQ.b	loc_001FC498				; Si no, usar avance normal
	NEG.l	D0							; Invertir dirección de avance

loc_001FC498:
	ADDA.l	D0, A3						; Avanzar posición en buffer
	BRA.w	loc_001FC5CC				; Continuar con siguiente grupo

; === Procesamiento de pixels según orientación ===
loc_001FC49E:
	TST.b	-$13(A6)					; ¿Inversión horizontal activa?
	BNE.w	loc_001FC53A				; Si sí, usar procesamiento invertido
	
	; === PROCESAMIENTO NORMAL (sin inversión horizontal) ===
	; --- Procesar pixel 1 ---
	ROL.l	#8, D2						; Rotar para acceder al primer pixel
	MOVEQ	#0, D0						; D0 = 0
	MOVE.b	D2, D0						; D0 = índice de color del pixel
	BEQ.b	loc_001FC4C8				; Si es 0 (transparente), saltar
	ADD.w	D0, D0						; D0 *= 2 (índice en tabla de words)
	MOVE.w	(A1,D0.w), D0				; D0 = valor de color desde tabla lookup
	MOVE.w	D0, D1						; D1 = copia del color
	LSR.w	#8, D1						; D1 = byte alto del color
	BEQ.b	loc_001FC4BC				; Si byte alto es 0, saltar
	MOVE.b	D1, (A3)					; Escribir byte alto en buffer

loc_001FC4BC:
	ADDQ.w	#1, A3						; Avanzar posición en buffer
	TST.b	D0							; ¿Byte bajo del color es 0?
	BEQ.b	loc_001FC4C4				; Si es 0, saltar
	MOVE.b	D0, (A3)					; Escribir byte bajo en buffer

loc_001FC4C4:
	ADDQ.w	#1, A3						; Avanzar posición en buffer
	BRA.b	loc_001FC4CA				; Continuar con siguiente pixel

loc_001FC4C8:
	ADDQ.w	#2, A3						; Saltar 2 bytes (pixel transparente)

loc_001FC4CA:
	; --- Procesar pixel 2 ---
	ROL.l	#8, D2						; Rotar para acceder al segundo pixel
	MOVEQ	#0, D0						; D0 = 0
	MOVE.b	D2, D0						; D0 = índice de color del pixel
	BEQ.b	loc_001FC4EC				; Si es 0 (transparente), saltar
	ADD.w	D0, D0						; D0 *= 2 (índice en tabla de words)
	MOVE.w	(A1,D0.w), D0				; D0 = valor de color desde tabla lookup
	MOVE.w	D0, D1						; D1 = copia del color
	LSR.w	#8, D1						; D1 = byte alto del color
	BEQ.b	loc_001FC4E0				; Si byte alto es 0, saltar
	MOVE.b	D1, (A3)					; Escribir byte alto en buffer

loc_001FC4E0:
	ADDQ.w	#1, A3						; Avanzar posición en buffer
	TST.b	D0							; ¿Byte bajo del color es 0?
	BEQ.b	loc_001FC4E8				; Si es 0, saltar
	MOVE.b	D0, (A3)					; Escribir byte bajo en buffer

loc_001FC4E8:
	ADDQ.w	#1, A3						; Avanzar posición en buffer
	BRA.b	loc_001FC4EE				; Continuar con siguiente pixel

loc_001FC4EC:
	ADDQ.w	#2, A3						; Saltar 2 bytes (pixel transparente)

loc_001FC4EE:
	; --- Procesar pixel 3 ---
	ROL.l	#8, D2						; Rotar para acceder al tercer pixel
	MOVEQ	#0, D0						; D0 = 0
	MOVE.b	D2, D0						; D0 = índice de color del pixel
	BEQ.b	loc_001FC510				; Si es 0 (transparente), saltar
	ADD.w	D0, D0						; D0 *= 2 (índice en tabla de words)
	MOVE.w	(A1,D0.w), D0				; D0 = valor de color desde tabla lookup
	MOVE.w	D0, D1						; D1 = copia del color
	LSR.w	#8, D1						; D1 = byte alto del color
	BEQ.b	loc_001FC504				; Si byte alto es 0, saltar
	MOVE.b	D1, (A3)					; Escribir byte alto en buffer

loc_001FC504:
	ADDQ.w	#1, A3						; Avanzar posición en buffer
	TST.b	D0							; ¿Byte bajo del color es 0?
	BEQ.b	loc_001FC50C				; Si es 0, saltar
	MOVE.b	D0, (A3)					; Escribir byte bajo en buffer

loc_001FC50C:
	ADDQ.w	#1, A3						; Avanzar posición en buffer
	BRA.b	loc_001FC512				; Continuar con siguiente pixel

loc_001FC510:
	ADDQ.w	#2, A3						; Saltar 2 bytes (pixel transparente)

loc_001FC512:
	; --- Procesar pixel 4 ---
	ROL.l	#8, D2						; Rotar para acceder al cuarto pixel
	MOVEQ	#0, D0						; D0 = 0
	MOVE.b	D2, D0						; D0 = índice de color del pixel
	BEQ.b	loc_001FC534				; Si es 0 (transparente), saltar
	ADD.w	D0, D0						; D0 *= 2 (índice en tabla de words)
	MOVE.w	(A1,D0.w), D0				; D0 = valor de color desde tabla lookup
	MOVE.w	D0, D1						; D1 = copia del color
	LSR.w	#8, D1						; D1 = byte alto del color
	BEQ.b	loc_001FC528				; Si byte alto es 0, saltar
	MOVE.b	D1, (A3)					; Escribir byte alto en buffer

loc_001FC528:
	ADDQ.w	#1, A3						; Avanzar posición en buffer
	TST.b	D0							; ¿Byte bajo del color es 0?
	BEQ.b	loc_001FC530				; Si es 0, saltar
	MOVE.b	D0, (A3)					; Escribir byte bajo en buffer

loc_001FC530:
	ADDQ.w	#1, A3						; Avanzar posición en buffer
	BRA.b	loc_001FC536				; Continuar

loc_001FC534:
	ADDQ.w	#2, A3						; Saltar 2 bytes (pixel transparente)

loc_001FC536:
	BRA.w	loc_001FC5CA				; Saltar al final del bucle de pixels

; === PROCESAMIENTO CON INVERSIÓN HORIZONTAL ===
loc_001FC53A:
	; --- Procesar pixel 1 (invertido) ---
	ROL.l	#8, D2						; Rotar para acceder al primer pixel
	MOVEQ	#0, D0						; D0 = 0
	MOVE.b	D2, D0						; D0 = índice de color del pixel
	BEQ.b	loc_001FC55C				; Si es 0 (transparente), saltar
	ADD.w	D0, D0						; D0 *= 2 (índice en tabla de words)
	MOVE.w	(A1,D0.w), D0				; D0 = valor de color desde tabla lookup
	MOVE.w	D0, D1						; D1 = copia del color
	SUBQ.w	#1, A3						; Retroceder posición (inversión horizontal)
	LSR.w	#8, D1						; D1 = byte alto del color
	BEQ.b	loc_001FC552				; Si byte alto es 0, saltar
	MOVE.b	D1, (A3)					; Escribir byte alto en buffer

loc_001FC552:
	SUBQ.w	#1, A3						; Retroceder posición
	TST.b	D0							; ¿Byte bajo del color es 0?
	BEQ.b	loc_001FC55E				; Si es 0, continuar
	MOVE.b	D0, (A3)					; Escribir byte bajo en buffer
	BRA.b	loc_001FC55E				; Continuar

loc_001FC55C:
	SUBQ.w	#2, A3						; Retroceder 2 posiciones (pixel transparente)

loc_001FC55E:
	; --- Procesar pixel 2 (invertido) ---
	ROL.l	#8, D2						; Rotar para acceder al segundo pixel
	MOVEQ	#0, D0						; D0 = 0
	MOVE.b	D2, D0						; D0 = índice de color del pixel
	BEQ.b	loc_001FC580				; Si es 0 (transparente), saltar
	ADD.w	D0, D0						; D0 *= 2 (índice en tabla de words)
	MOVE.w	(A1,D0.w), D0				; D0 = valor de color desde tabla lookup
	MOVE.w	D0, D1						; D1 = copia del color
	SUBQ.w	#1, A3						; Retroceder posición (inversión horizontal)
	LSR.w	#8, D1						; D1 = byte alto del color
	BEQ.b	loc_001FC576				; Si byte alto es 0, saltar
	MOVE.b	D1, (A3)					; Escribir byte alto en buffer

loc_001FC576:
	SUBQ.w	#1, A3						; Retroceder posición
	TST.b	D0							; ¿Byte bajo del color es 0?
	BEQ.b	loc_001FC582				; Si es 0, continuar
	MOVE.b	D0, (A3)					; Escribir byte bajo en buffer
	BRA.b	loc_001FC582				; Continuar

loc_001FC580:
	SUBQ.w	#2, A3						; Retroceder 2 posiciones (pixel transparente)

loc_001FC582:
	; --- Procesar pixel 3 (invertido) ---
	ROL.l	#8, D2						; Rotar para acceder al tercer pixel
	MOVEQ	#0, D0						; D0 = 0
	MOVE.b	D2, D0						; D0 = índice de color del pixel
	BEQ.b	loc_001FC5A4				; Si es 0 (transparente), saltar
	ADD.w	D0, D0						; D0 *= 2 (índice en tabla de words)
	MOVE.w	(A1,D0.w), D0				; D0 = valor de color desde tabla lookup
	MOVE.w	D0, D1						; D1 = copia del color
	SUBQ.w	#1, A3						; Retroceder posición (inversión horizontal)
	LSR.w	#8, D1						; D1 = byte alto del color
	BEQ.b	loc_001FC59A				; Si byte alto es 0, saltar
	MOVE.b	D1, (A3)					; Escribir byte alto en buffer

loc_001FC59A:
	SUBQ.w	#1, A3						; Retroceder posición
	TST.b	D0							; ¿Byte bajo del color es 0?
	BEQ.b	loc_001FC5A6				; Si es 0, continuar
	MOVE.b	D0, (A3)					; Escribir byte bajo en buffer
	BRA.b	loc_001FC5A6				; Continuar

loc_001FC5A4:
	SUBQ.w	#2, A3						; Retroceder 2 posiciones (pixel transparente)

loc_001FC5A6:
	; --- Procesar pixel 4 (invertido) ---
	ROL.l	#8, D2						; Rotar para acceder al cuarto pixel
	MOVEQ	#0, D0						; D0 = 0
	MOVE.b	D2, D0						; D0 = índice de color del pixel
	BEQ.b	loc_001FC5C8				; Si es 0 (transparente), saltar
	ADD.w	D0, D0						; D0 *= 2 (índice en tabla de words)
	MOVE.w	(A1,D0.w), D0				; D0 = valor de color desde tabla lookup
	MOVE.w	D0, D1						; D1 = copia del color
	SUBQ.w	#1, A3						; Retroceder posición (inversión horizontal)
	LSR.w	#8, D1						; D1 = byte alto del color
	BEQ.b	loc_001FC5BE				; Si byte alto es 0, saltar
	MOVE.b	D1, (A3)					; Escribir byte alto en buffer

loc_001FC5BE:
	SUBQ.w	#1, A3						; Retroceder posición
	TST.b	D0							; ¿Byte bajo del color es 0?
	BEQ.b	loc_001FC5CA				; Si es 0, continuar
	MOVE.b	D0, (A3)					; Escribir byte bajo en buffer
	BRA.b	loc_001FC5CA				; Continuar

loc_001FC5C8:
	SUBQ.w	#2, A3						; Retroceder 2 posiciones (pixel transparente)

; === Control de bucles y avance de posición ===
loc_001FC5CA:
	ADDA.l	D3, A3						; Aplicar avance combinado al puntero del buffer

loc_001FC5CC:
	; === Continuar bucle de pixels (8 pixels por grupo) ===
	DBF	D4, loc_001FC486			; D4--, si >= 0 procesar siguiente grupo de pixels
	
	; === Continuar bucle horizontal (según factor de escalado) ===
	DBF	D5, loc_001FC484			; D5--, si >= 0 procesar siguiente columna escalada
	
	; === Preparar siguiente línea y ajustar posición ===
	MOVEA.l	-$8(A6), A3					; A3 = posición base de la línea actual
	TST.b	-$13(A6)					; ¿Inversión horizontal activa?
	BEQ.b	loc_001FC5E2				; Si no, avanzar normalmente
	SUBQ.w	#8, A3						; Ajustar posición para inversión horizontal
	BRA.b	loc_001FC5E4				; Continuar

loc_001FC5E2:
	ADDQ.w	#8, A3						; Avanzar 8 bytes (1 línea de 8 pixels)

loc_001FC5E4:
	MOVE.l	A3, -$8(A6)					; Actualizar posición base para siguiente línea
	
	; === Continuar bucle vertical (según factor de escalado) ===
	DBF	D6, loc_001FC480			; D6--, si >= 0 procesar siguiente fila escalada
	
	; === Avanzar al siguiente frame/layer del sprite ===
	LEA	$8(A4), A4					; A4 += 8 (siguiente estructura de frame)

; === Control del bucle principal de frames ===
loc_001FC5F0:
	DBF	D7, loc_001FC400			; D7--, si >= 0 procesar siguiente frame
	
	; === Restaurar registros y retornar ===
	MOVEM.l	-$38(A6), D2/D3/D4/D5/D6/D7/A2/A3/A4	; Restaurar registros guardados
	UNLK	A6							; Destruir stack frame
	RTS								; Retornar
