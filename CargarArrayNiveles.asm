CargarArrayNiveles:
	LINK	A6, #0

	PEA	$298A(A5) 											; JMP	loc_000FD6A8
	PEA	String_SiberiaB1Blizzard(PC) 	
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)											; JMP	CargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelSiberiaB1Blizzard(A5)

	PEA	$E92(A5)
	PEA	loc_00005C50(PC)				;CerebroScreen Sentinels
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenSentinels(A5);CerebroScreen Sentinels

	PEA	$2412(A5)
	PEA	loc_00005C38(PC)				;SentinelsD1 Exterior_1
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelSentinelsD1Exterior_1(A5);SentinelsD1 Exterior_1

	PEA	$EC2(A5)
	PEA	loc_00005C1C(PC)				;CerebroScreen PlayerSelect
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	$2932(A5)
	PEA	loc_00005C04(PC)				; SentinelsB1 Exterior_3
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B74(A5)

	PEA	$EC2(A5)
	PEA	loc_00005BE8(PC)				;CerebroScreen PlayerSelect
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	$262A(A5)
	PEA	loc_00005BD0(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B76(A5)

	PEA	$294A(A5)
	PEA	loc_00005BB4(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B78(A5)

	PEA	$E9A(A5)
	PEA	loc_00005B9E(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenAvalon(A5);CerebroScreen Avalon

	PEA	$BA(A5)
	PEA	loc_00005B8C(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B4A(A5)

	PEA	$EC2(A5)
	PEA	loc_00005B70(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	$4FA(A5)
	PEA	loc_00005B5C(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B4C(A5)

	PEA	$EC2(A5)
	PEA	loc_00005B40(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	$502(A5)
	PEA	loc_00005B2A(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B4E(A5)

	PEA	$EC2(A5)
	PEA	loc_00005B0E(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	$60A(A5)
	PEA	loc_00005AFE(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B50(A5)

	PEA	$EC2(A5)
	PEA	loc_00005AE2(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	$732(A5)
	PEA	loc_00005ACC(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B52(A5)

	PEA	$EA2(A5)
	PEA	loc_00005AB4(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenBaniMaza(A5);CerebroScreen BaniMaza

	PEA	$CAA(A5)
	PEA	loc_00005AA0(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B54(A5)

	PEA	$EC2(A5)
	PEA	loc_00005A84(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	$82A(A5)
	PEA	loc_00005A6A(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelBaniMazaA1Moving_Blocks(A5) ;BaniMazaA1 Moving_Blocks

	PEA	$EC2(A5)
	PEA	loc_00005A4E(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	$9B2(A5)
	PEA	loc_00005A34(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B58(A5)

	PEA	$EAA(A5)
	PEA	loc_00005A1E(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenSavage(A5);CerebroScreen Savage

	PEA	$2312(A5)
	PEA	loc_00005A0C(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelSavageC1Jungle_1(A5)		; SavageC1 Jungle_1

	PEA	$EC2(A5)
	PEA	loc_000059F0(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	$231A(A5)
	PEA	loc_000059DE(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelSavageB1Jungle_2(A5)			;SavageB1 Jungle_2

	PEA	$EC2(A5)
	PEA	loc_000059C2(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	$1C22(A5)
	PEA	loc_000059AC(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelSavageA2Perimeter_1(A5) ;SavageA2 Perimeter_1

	PEA	$EC2(A5)
	PEA	loc_00005990(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	$1C72(A5)
	PEA	loc_0000597A(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B62(A5)

	PEA	$EC2(A5)
	PEA	loc_0000595E(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	$1CA2(A5)
	PEA	loc_0000594C(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B64(A5)

	PEA	$EB2(A5)
	PEA	loc_00005938(PC)				; CerebroScreen Space
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenSpace(A5);CerebroScreen Space

	PEA	$2A22(A5)
	PEA	loc_0000591E(PC)				; SpaceB1 Maintenance_Shaft
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelSpaceB1Maintenance_Shaft(A5);SpaceB1 Maintenance_Shaft

	PEA	$EC2(A5)
	PEA	loc_00005902(PC)				; CerebroScreen PlayerSelect
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	$2AAA(A5)
	PEA	loc_000058EA(PC)				; SpaceA1 Space_Elevator
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B68(A5)

	PEA	$EBA(A5)
	PEA	loc_000058D6(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenClone(A5);CerebroScreen Clone

	PEA	$10CA(A5)
	PEA	loc_000058BE(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B6A(A5)

	PEA	$EC2(A5)
	PEA	loc_000058A2(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	$118A(A5)
	PEA	CloneA2_Vertical_Corridor_1(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B6C(A5)

	PEA	$EC2(A5)
	PEA	loc_0000586A(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5)

	PEA	$1442(A5)
	PEA	loc_00005858(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, -$3B6E(A5)

	PEA	$ED2(A5)
	PEA	loc_00005840(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenFinalText(A5) ; CerebroScreen FinalText

	PEA	$EDA(A5)
	PEA	CerebroScreen_Credits(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenCredits(A5) ;CerebroScreen Credits

	PEA	$EE2(A5)
	PEA	CerebroScreen_Failure(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenFailure(A5)

	PEA	$EC2(A5)
	PEA	loc_000057F8(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenPlayerSelect(A5);CerebroScreen PlayerSelect

	PEA	$ECA(A5)
	PEA	loc_000057DE(PC)
	JSR	rom_offsetRutinaCargarDataDeNivel(A5)
	MOVE.b	D0, ram_offsetNivelCerebroScreenLogoAndDemo(A5)

	UNLK	A6
	RTS

