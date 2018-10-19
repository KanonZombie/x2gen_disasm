vdp_control				equ 0x00C00004
vdp_data				equ 0x00C00000

vdp_write_vscroll_a     equ 0x40000010
vdp_write_vscroll_b     equ 0x40020010

vdp_write_tiles			equ 0x40000000

vdp_write_palette_00	equ 0xC0000000

pad_data_a				equ 0x00A10003

vdp_write_plane_a		equ 0x40000003
vdp_write_plane_b		equ 0x60000003

z80_RAM_start			equ 0x00A00000
z80_BUSREQ_port			equ	0x00A11100
z80_Reset_port			equ 0x00A11200

z80_ram_end     		equ 0x00A02000     	; end of non-reserved Z80 RAM


ram_offsetNivelActual	    equ -$359C
ram_offsetNivelMagnetoJoin	equ -$3B7E
ram_offsetVidasActual      	equ -$38A8

ram_offsetLecturaPad_A     	equ -$7A8
ram_offsetLecturaPad_B     	equ -$7A6