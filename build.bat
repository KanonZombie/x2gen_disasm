@echo off

IF EXIST x2_reasm.bin move /Y x2_reasm.bin x2_reasm.prev.bin >NUL
asm68k /k /p /o ae- X-Men 2 - Clone Wars (W) [!].asm, x2_reasm.bin >errors.txt, , x2_reasm.lst
REM fixheadr.exe x2_reasm.bin

IF EXIST VBinDiff.exe VBinDiff "X-Men 2 - Clone Wars (W) [!].bin" "x2_reasm.bin"

FC "X-Men 2 - Clone Wars (W) [!].bin" "x2_reasm.bin" > diferencias.txt

REM Expresiones para buscar en diferencias.txt

REM Issue ADD optimizado como ADDI
REM ([0-9ABCDEF]{8}: D0 06\r\n[0-9ABCDEF]{8}: [0-9ABCDEF][0-9ABCDEF] [0-9ABCDEF][0-9ABCDEF]\r\n)
REM =============ADDI issue===========\r\n\1=================================\r\n