CargarArrayNiveles:
	LINK	A6, #0

	PEA	rom_Nivel_SiberiaB1Blizzard(A5) 											; JMP	loc_000FD6A8
	PEA	String_SiberiaB1Blizzard(PC) 	
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)											; JMP	CargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelSiberiaB1Blizzard(A5)

	PEA	rom_Nivel_CerebroScreenSentinels(A5)
	PEA	loc_00005C50(PC)				;CerebroScreen Sentinels
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenSentinels(A5);CerebroScreen Sentinels

	PEA	rom_Nivel_SentinelsD1Exterior_1(A5)
	PEA	loc_00005C38(PC)				;SentinelsD1 Exterior_1
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelSentinelsD1Exterior_1(A5);SentinelsD1 Exterior_1

	PEA	rom_Nivel_CerebroScreenPlayerSelect(A5)
	PEA	loc_00005C1C(PC)				;CerebroScreen PlayerSelect
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	rom_Nivel_SentinelsB1_Exterior_3(A5)
	PEA	loc_00005C04(PC)				; SentinelsB1 Exterior_3
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B74(A5)

	PEA	rom_Nivel_CerebroScreenPlayerSelect(A5)
	PEA	loc_00005BE8(PC)				;CerebroScreen PlayerSelect
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	rom_Nivel_SentinelsA1_CoolantCore(A5)
	PEA	loc_00005BD0(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B76(A5)

	PEA	rom_Nivel_SentinelsB2_Exterior_Escape(A5)
	PEA	loc_00005BB4(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B78(A5)

	PEA	rom_Nivel_CerebroScreenAvalon(A5)
	PEA	loc_00005B9E(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenAvalon(A5);CerebroScreen Avalon

	PEA	rom_Nivel_AvalonB1_Exterior(A5)
	PEA	loc_00005B8C(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B4A(A5)

	PEA	rom_Nivel_CerebroScreenPlayerSelect(A5)
	PEA	loc_00005B70(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	rom_Nivel_AvalonB2_InnerShell(A5)
	PEA	loc_00005B5C(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B4C(A5)

	PEA	rom_Nivel_CerebroScreenPlayerSelect(A5)
	PEA	loc_00005B40(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	rom_Nivel_AvalonA2_Falling_Room(A5)
	PEA	loc_00005B2A(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B4E(A5)

	PEA	rom_Nivel_CerebroScreenPlayerSelect(A5)
	PEA	loc_00005B0E(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	rom_Nivel_AvalonA3_Exodus(A5)
	PEA	loc_00005AFE(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B50(A5)

	PEA	rom_Nivel_CerebroScreenPlayerSelect(A5)
	PEA	loc_00005AE2(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	rom_Nivel_AvalonA4_Throne_Room(A5)
	PEA	loc_00005ACC(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B52(A5)

	PEA	rom_Nivel_CerebroScreenBaniMaza(A5)
	PEA	loc_00005AB4(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenBaniMaza(A5);CerebroScreen BaniMaza

	PEA	rom_Nivel_BaniMazaB2_Exterior(A5)
	PEA	loc_00005AA0(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B54(A5)

	PEA	rom_Nivel_CerebroScreenPlayerSelect(A5)
	PEA	loc_00005A84(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	rom_Nivel_NivelBaniMazaA1Moving_Blocks(A5)
	PEA	loc_00005A6A(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelBaniMazaA1Moving_Blocks(A5) ;BaniMazaA1 Moving_Blocks

	PEA	rom_Nivel_CerebroScreenPlayerSelect(A5)
	PEA	loc_00005A4E(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	rom_Nivel_BaniMazaA2_ApocalypseBoss(A5)
	PEA	loc_00005A34(PC)	; BaniMazaA2 ApocalypseBoss
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B58(A5)

	PEA	rom_Nivel_CerebroScreen_Savage(A5)
	PEA	loc_00005A1E(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenSavage(A5)

	PEA	rom_Nivel_SavageC1_Jungle_1(A5)
	PEA	loc_00005A0C(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelSavageC1Jungle_1(A5)

	PEA	rom_Nivel_CerebroScreenPlayerSelect(A5)
	PEA	loc_000059F0(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	rom_Nivel_SavageB1_Jungle_2(A5)
	PEA	loc_000059DE(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelSavageB1Jungle_2(A5)			;SavageB1 Jungle_2

	PEA	rom_Nivel_CerebroScreenPlayerSelect(A5)
	PEA	loc_000059C2(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	rom_Nivel_SavageA2_Perimeter_1(A5)
	PEA	loc_000059AC(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelSavageA2Perimeter_1(A5) ;SavageA2 Perimeter_1

	PEA	rom_Nivel_CerebroScreenPlayerSelect(A5)
	PEA	loc_00005990(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	rom_Nivel_SavageA3_Perimeter_2(A5)
	PEA	loc_0000597A(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B62(A5)

	PEA	rom_Nivel_CerebroScreenPlayerSelect(A5)
	PEA	loc_0000595E(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	rom_Nivel_SavageA4_Chamber(A5)
	PEA	loc_0000594C(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B64(A5)

	PEA	rom_Nivel_CerebroScreenSpace(A5)
	PEA	loc_00005938(PC)				
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenSpace(A5)

	PEA	rom_Nivel_SpaceB1_Maintenance_Shaft(A5)
	PEA	String_SpaceB1_Maintenance_Shaft(PC)									
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelSpaceB1Maintenance_Shaft(A5)	

	PEA	rom_Nivel_CerebroScreenPlayerSelect(A5)
	PEA	loc_00005902(PC)				
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	rom_Nivel_SpaceA1_Space_Elevator(A5)
	PEA	String_SpaceA1_Space_Elevator(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B68(A5)

	PEA	rom_Nivel_CerebroScreen_Clone(A5)
	PEA	CerebroScreen_Clone(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenClone(A5);CerebroScreen Clone

	PEA	rom_Nivel_CloneA1_Factory_Floor_1(A5)
	PEA	String_CloneA1_Factory_Floor_1(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCloneA1_Factory_Floor_1(A5)

	PEA	rom_Nivel_CerebroScreenPlayerSelect(A5)
	PEA	loc_000058A2(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	rom_Nivel_CloneA2_Vertical_Corridor_1(A5)
	PEA	CloneA2_Vertical_Corridor_1(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCloneA2_Vertical_Corridor_1(A5)

	PEA	rom_Nivel_CerebroScreenPlayerSelect(A5)
	PEA	loc_0000586A(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	rom_Nivel_CloneA5_BroodBoss(A5)
	PEA	String_CloneA5_BroodBoss(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCloneA5_BroodBoss(A5)

	PEA	rom_Nivel_CerebroScreenFinalText(A5)
	PEA	String_CerebroScreen_FinalText(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenFinalText(A5) 

	PEA	rom_Nivel_CerebroScreen_Credits(A5)
	PEA	CerebroScreen_Credits(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenCredits(A5) 

	PEA	rom_Nivel_CerebroScreen_Failure(A5)
	PEA	CerebroScreen_Failure(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenFailure(A5)

	PEA	rom_Nivel_CerebroScreenPlayerSelect(A5)
	PEA	loc_000057F8(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	rom_Nivel_CerebroScreenLogoAndDemo(A5)
	PEA	loc_000057DE(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenLogoAndDemo(A5)

	UNLK	A6
	RTS
