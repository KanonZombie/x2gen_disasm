REM @echo off

SET binReasm=x2_reasm
SET binOrigen=X-Men 2 - Clone Wars (W) [!]

echo %binReasm%
echo %binOrigen%

IF EXIST %binReasm%.bin move /Y %binReasm%.bin %binReasm%.prev.bin >NUL

asm68k /ow- /k /p /o ae- %binOrigen%.asm, %binReasm%.bin >errors.txt, , %binReasm%.lst

REM fixheadr.exe x2_reasm.bin

IF EXIST VBinDiff.exe VBinDiff "%binOrigen%.bin" "%binReasm%.bin"

FC "%binOrigen%.bin" "%binReasm%.bin" > diferencias.txt

ECHO total lineas en diferencias
FC "%binOrigen%.bin" "%binReasm%.bin" | find /c /v ""

REM analizador.exe  diferencias.txt x2_reasm.lst analisis.txt