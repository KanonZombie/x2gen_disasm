@echo off

IF EXIST x2_reass.bin move /Y x2_reass.bin x2_reass.prev.bin >NUL
asm68k /k /p /o ae- X-Men 2 - Clone Wars (W) [!].asm, x2_reass.bin >errors.txt, , x2_reass.lst
REM asm68k /k /p /o -n X-Men 2 - Clone Wars (W) [!].asm, x2_reass.bin >errors.txt, , x2_reass.lst
REM fixheadr.exe x2_reass.bin
VBinDiff "X-Men 2 - Clone Wars (W) [!].bin" "x2_reass.bin"