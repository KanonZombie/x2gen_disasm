; Diferencia de direcciones de memoria
; para ubicaciones en RAM y ROM
; relativos a A5 (0x200 todo el programa)

; Offsets for memory addresses
; for RAM and ROM locations
; relative to A5 (0x200 in runtime)

ram_Offset                  equ $FFFF0000-$200

ram_offsetPersonaje1up          	equ	ram_Offset+$C644
ram_offsetPersonaje2up          	equ	ram_Offset+$C645
ram_offsetSaludBack2up          	equ	ram_Offset+$C66A
ram_offsetSaludBack         		equ	ram_Offset+$C66C
ram_offsetNivelActualBack			equ ram_Offset+$C66E            ; C66E -$3B92(A5)
ram_offsetAddressIndiceDEMO         equ	ram_Offset+$C670 ; -$3B90(A5)

ram_offsetFlagInputParaDEMO             equ	ram_Offset+$C7E2 ; -$3A1E
ram_offsetFlagEsDEMO                    equ	ram_Offset+$C7E6 ; -$3A1A(A5)

;ram_offsetNivelMagnetoJoin	equ -$3B7E
;ram_offsetVidasActual      	equ -$38A8  ;C958
ram_offsetVidasActual      		equ	ram_Offset+$C958
ram_offsetVidasActual2up   		equ	ram_Offset+$C956

ram_offsetNivelActual	    equ ram_Offset+$CC64            ; CC64 -$359C(A5)

; C956 vidas 2up

ram_offsetSaludActual           equ	ram_Offset+$EB10

;CLR.w	-$3B96(A5)							; C66A
;	MOVE.w	-$17E0(A5), ram_offsetSaludBack2up(A5)	;Predicted (Code-scan) RAM EA20 -> RAM C66A (si termian ok nivel no entra)
ram_offsetSalud2up              equ	ram_Offset+$EA20


ram_offsetAddressData1up        equ	ram_Offset+$EAA8 ;	MOVE.l	$2(A0), -$1758(A5)
ram_offsetAddressData2up        equ	ram_Offset+$E9B8 ;	MOVE.l	$2(A0), -$1848(A5)

ram_offsetAddressFlagDesactivaSFX       equ	ram_Offset+$E954 ; -$18AC(A5)

ram_offsetArrayNiveles      	equ -$E52
ram_offsetArrayNivelesCount   	equ -$E54

ram_offsetNivelBaniMazaA1Moving_Blocks      equ -$3B56
ram_offsetNivelSavageC1Jungle_1          	equ -$3B5A
ram_offsetNivelSavageB1Jungle_2          	equ -$3B5E
ram_offsetNivelSavageA2Perimeter_1         	equ -$3B60
ram_offsetNivelSpaceB1Maintenance_Shaft     equ -$3B66
ram_offsetNivelCloneA1_Factory_Floor_1      equ -$3B6A
ram_offsetNivelCloneA2_Vertical_Corridor_1  equ -$3B6C
ram_offsetNivelCloneA5_BroodBoss            equ -$3B6E
ram_offsetNivelSiberiaB1Blizzard          	equ -$3B70
ram_offsetNivelSentinelsD1Exterior_1        equ -$3B72
ram_offsetNivelCerebroScreenSentinels       equ -$3B7A
ram_offsetNivelCerebroScreenAvalon          equ -$3B7C
ram_offsetNivelCerebroScreenBaniMaza        equ -$3B7E
ram_offsetNivelCerebroScreenSavage          equ -$3B80
ram_offsetNivelCerebroScreenSpace           equ -$3B82
ram_offsetNivelCerebroScreenClone           equ -$3B84
ram_offsetNivelCerebroScreenCredits     	equ -$3B86
ram_offsetNivelCerebroScreenPlayerSelect	equ -$3B88
ram_offsetNivelCerebroScreenLogoAndDemo     equ -$3B8A
ram_offsetNivelCerebroScreenFailure         equ -$3B8C
ram_offsetNivelCerebroScreenFinalText       equ -$3B8E

ram_offsetLecturaPad_A     	equ -$7A8
ram_offsetLecturaPad_B     	equ -$7A6

rom_offsetJMP_00006242                	        equ JMP_00006242-$200
rom_offsetRNGSeleccionPersonaje                	equ SubrutinaRNGSeleccionPersonaje-$200

rom_Nivel_SiberiaB1Blizzard                 	equ SubrutinaNivel_SiberiaB1Blizzard-$200
rom_Nivel_CerebroScreenSentinels                equ SubrutinaNivel_CerebroScreenSentinels-$200
rom_Nivel_SentinelsD1Exterior_1                 equ SubrutinaNivel_SentinelsD1Exterior_1-$200
rom_Nivel_CerebroScreenPlayerSelect             equ SubrutinaNivel_CerebroScreenPlayerSelect-$200
rom_Nivel_CerebroScreenLogoAndDemo              equ SubrutinaNivel_CerebroScreenLogoAndDemo-$200
rom_Nivel_CerebroScreen_Failure                 equ SubrutinaNivel_CerebroScreen_Failure-$200
rom_Nivel_CerebroScreen_Credits                 equ SubrutinaNivel_CerebroScreen_Credits-$200
rom_Nivel_CerebroScreenFinalText                equ SubrutinaNivel_CerebroScreenFinalText-$200
rom_Nivel_CloneA5_BroodBoss                     equ SubrutinaNivel_CloneA5_BroodBoss-$200
rom_Nivel_CloneA2_Vertical_Corridor_1           equ SubrutinaNivel_CloneA2_Vertical_Corridor_1-$200
rom_Nivel_CloneA1_Factory_Floor_1               equ SubrutinaNivel_CloneA1_Factory_Floor_1-$200
rom_Nivel_CerebroScreen_Clone                   equ SubrutinaNivel_CerebroScreen_Clone-$200
rom_Nivel_SpaceA1_Space_Elevator                equ SubrutinaNivel_SpaceA1_Space_Elevator-$200
rom_Nivel_SpaceB1_Maintenance_Shaft             equ SubrutinaNivel_SpaceB1_Maintenance_Shaft-$200
rom_Nivel_CerebroScreenSpace                    equ SubrutinaNivel_CerebroScreenSpace-$200
rom_Nivel_SavageA4_Chamber                      equ SubrutinaNivel_SavageA4_Chamber-$200
rom_Nivel_SavageA3_Perimeter_2                  equ SubrutinaNivel_SavageA3_Perimeter_2-$200
rom_Nivel_SavageA2_Perimeter_1                  equ SubrutinaNivel_SavageA2_Perimeter_1-$200
rom_Nivel_SavageB1_Jungle_2                     equ SubrutinaNivel_SavageB1_Jungle_2-$200
rom_Nivel_SavageC1_Jungle_1                     equ SubrutinaNivel_SavageC1_Jungle_1-$200
rom_Nivel_CerebroScreen_Savage                  equ SubrutinaNivel_CerebroScreen_Savage-$200
rom_Nivel_BaniMazaA2_ApocalypseBoss             equ SubrutinaNivel_BaniMazaA2_ApocalypseBoss-$200
rom_Nivel_NivelBaniMazaA1Moving_Blocks          equ SubrutinaNivel_NivelBaniMazaA1Moving_Blocks-$200
rom_Nivel_BaniMazaB2_Exterior                   equ SubrutinaNivel_BaniMazaB2_Exterior-$200
rom_Nivel_CerebroScreenBaniMaza                 equ SubrutinaNivel_CerebroScreenBaniMaza-$200
rom_Nivel_AvalonA4_Throne_Room                  equ SubrutinaNivel_AvalonA4_Throne_Room-$200
rom_Nivel_AvalonA3_Exodus                       equ SubrutinaNivel_AvalonA3_Exodus-$200
rom_Nivel_AvalonA2_Falling_Room                 equ SubrutinaNivel_AvalonA2_Falling_Room-$200
rom_Nivel_AvalonB2_InnerShell                   equ SubrutinaNivel_AvalonB2_InnerShell-$200
rom_Nivel_AvalonB1_Exterior                     equ SubrutinaNivel_AvalonB1_Exterior-$200
rom_Nivel_CerebroScreenAvalon                   equ SubrutinaNivel_CerebroScreenAvalon-$200
rom_Nivel_SentinelsB2_Exterior_Escape           equ SubrutinaNivel_SentinelsB2_Exterior_Escape-$200
rom_Nivel_SentinelsA1_CoolantCore               equ SubrutinaNivel_SentinelsA1_CoolantCore-$200
rom_Nivel_SentinelsB1_Exterior_3                equ SubrutinaNivel_SentinelsB1_Exterior_3-$200

rom_offsetLecturaPads                       	equ SubrutinaLeerPads-$200       ; lee primero pad 1 y despues 2
rom_offsetLecturaPad                          	equ SubrutinaLeerJoypad-$200       ; lee pad por parametro
rom_offsetRutinaLimpiarCRAM	                    equ SubRutinaLimpiarCRAM-$200
rom_offsetRutinaHabilitarInterrupciones	        equ SubrutinaHabilitarInterrupciones-$200
rom_offsetRutinaDeshabilitarInterrupciones	    equ SubrutinaDesabilitarInterrupciones-$200
rom_offsetRutinaSetearValoresIniciales          equ SubrutinaSetearValoresIniciales-$200
rom_offsetRutinaCargarDataDeNivel               equ SubrutinaCargarDataDeNivel-$200
rom_offsetRutinaBlanquearRAMNoReservada         equ loc_0000438A-$200

rom_offsetUbicacionArrayBeast                   equ UbicacionArrayBeast-$200-$2
rom_offsetUbicacionArrayCyclops                 equ UbicacionArrayCyclops-$200-$2
rom_offsetUbicacionArrayGambit                  equ UbicacionArrayGambit-$200-$2
rom_offsetUbicacionArrayNightcrawler            equ UbicacionArrayNightcrawler-$200-$2
rom_offsetUbicacionArrayPsylocke                equ UbicacionArrayPsylocke-$200-$2
rom_offsetUbicacionArrayWolverine               equ UbicacionArrayWolverine-$200
rom_offsetUbicacionArrayMagneto                 equ UbicacionArrayMagneto-$200-$2


rom_offsetRutina_CerebroScreenFinalText         equ Subrutina_CerebroScreenFinalText-$200