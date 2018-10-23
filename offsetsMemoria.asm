; Diferencia de direcciones de memoria
; para ubicaciones en RAM y ROM
; relativos a A5 (0x200 todo el programa)

; Offsets for memory addresses
; for RAM and ROM locations
; relative to A5 (0x200 in runtime)

ram_offsetNivelActual	    equ -$359C
ram_offsetNivelMagnetoJoin	equ -$3B7E
ram_offsetVidasActual      	equ -$38A8

ram_offsetLecturaPad_A     	equ -$7A8
ram_offsetLecturaPad_B     	equ -$7A6

rom_offsetLecturaPads                       	equ SubrutinaLeerPads-$200       ; lee primero pad 1 y despues 2
rom_offsetLecturaPad                          	equ SubrutinaLeerJoypad-$200       ; lee pad por parametro
rom_offsetRutinaLimpiarCRAM	                    equ SubRutinaLimpiarCRAM-$200
rom_offsetRutinaHabilitarInterrupciones	        equ SubrutinaHabilitarInterrupciones-$200
rom_offsetRutinaDeshabilitarInterrupciones	    equ SubrutinaDesabilitarInterrupciones-$200