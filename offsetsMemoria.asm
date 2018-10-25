; Diferencia de direcciones de memoria
; para ubicaciones en RAM y ROM
; relativos a A5 (0x200 todo el programa)

; Offsets for memory addresses
; for RAM and ROM locations
; relative to A5 (0x200 in runtime)

ram_offsetNivelActual	    equ -$359C
ram_offsetNivelMagnetoJoin	equ -$3B7E
ram_offsetVidasActual      	equ -$38A8
ram_offsetArrayNiveles     	equ -$E52

ram_offsetNivelSiberiaB1Blizzard     	equ -$3B70

ram_offsetNivelSavageC1Jungle_1     	equ -$3B5A
ram_offsetNivelSavageB1Jungle_2     	equ -$3B5E
ram_offsetNivelSavageA2Perimeter_1     	equ -$3B60
ram_offsetNivelCerebroScreenCredits     	equ -$3B86
ram_offsetNivelCerebroScreenPlayerSelect	equ -$3B88
ram_offsetNivelCerebroScreenLogoAndDemo     equ -$3B8A
ram_offsetNivelCerebroScreenFailure         equ -$3B8C
ram_offsetNivelBaniMazaA1Moving_Blocks      equ -$3B56
ram_offsetNivelCerebroScreenBaniMaza        equ -$3B7E
ram_offsetNivelCerebroScreenFinalText       equ -$3B8E
ram_offsetNivelSpaceB1Maintenance_Shaft     equ -$3B66
ram_offsetNivelCerebroScreenClone           equ -$3B84

ram_offsetLecturaPad_A     	equ -$7A8
ram_offsetLecturaPad_B     	equ -$7A6

rom_offsetLecturaPads                       	equ SubrutinaLeerPads-$200       ; lee primero pad 1 y despues 2
rom_offsetLecturaPad                          	equ SubrutinaLeerJoypad-$200       ; lee pad por parametro
rom_offsetRutinaLimpiarCRAM	                    equ SubRutinaLimpiarCRAM-$200
rom_offsetRutinaHabilitarInterrupciones	        equ SubrutinaHabilitarInterrupciones-$200
rom_offsetRutinaDeshabilitarInterrupciones	    equ SubrutinaDesabilitarInterrupciones-$200
rom_offsetRutinaSetearValoresIniciales          equ SubrutinaSetearValoresIniciales-$200

rom_offsetUbicacionArrayBeast                   equ UbicacionArrayBeast-$200-$2
rom_offsetUbicacionArrayCyclops                 equ UbicacionArrayCyclops-$200-$2
rom_offsetUbicacionArrayGambit                  equ UbicacionArrayGambit-$200-$2
rom_offsetUbicacionArrayNightcrawler            equ UbicacionArrayNightcrawler-$200-$2
rom_offsetUbicacionArrayPsylocke                equ UbicacionArrayPsylocke-$200-$2
rom_offsetUbicacionArrayWolverine               equ UbicacionArrayWolverine-$200-$2
rom_offsetUbicacionArrayMagneto                 equ UbicacionArrayMagneto-$200-$2