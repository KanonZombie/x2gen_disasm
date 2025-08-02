@echo off

SET binReasm=x2_reasm
SET fuenteBase=reasm
SET binOrigen=X-Men 2 - Clone Wars (W) [!]

IF EXIST %binReasm%.bin move /Y %binReasm%.bin research\%binReasm%.prev.bin >NUL

ECHO(
ECHO [104;93m**********************************************************************************[0m
ECHO [104;93m*                                   ASM BUILD                                    *[0m

SET "string=Nuevo bin : %binReasm%                                                           "
SET "string=                                                           %string%"
ECHO [104;93m* %string:~59,78% *[0m

SET "string=Origen: %binOrigen%                                                           "
SET "string=                                                           %string%"
ECHO [104;93m* %string:~59,78% *[0m


ECHO [104;93m**********************************************************************************[0m

ECHO(
ECHO [103;30m                                                                                  [0m
ECHO [103;30m Compilando componentes (z80)                                                     [0m
ECHO [103;30m                                                                                  [0m
ECHO(

..\asmTools\yaza driverz80\driverz80.z80 --list 
REM  > research\salidaZ80.txt

REM ECHO [104;93m**********************************************************************************[0m

ECHO(
ECHO [102;30m                                                                                  [0m
ECHO [102;30m Ejecutando ASM68k                                                                [0m
ECHO [102;30m                                                                                  [0m
ECHO(


ECHO [104;93m  =ccccc,      ,cccc       ccccc      ,cccc,  ?$$$$$$$,  ,ccc,   -ccc         
ECHO [104;93m :::"$$$$bc    $$$$$     ::`$$$$$c,  : $$$$$c`:"$$$$???'`."$$$$c,:`?$$c       
ECHO [104;93m `::::"?$$$$c,z$$$$F     `:: ?$$$$$c,`:`$$$$$h`:`?$$$,` :::`$$$$$$c,"$$h,     
ECHO [104;93m   `::::."$$$$$$$$$'    ..,,,:"$$$$$$h, ?$$$$$$c`:"$$$$$$$b':"$$$$$$$$$$$c    
ECHO [104;93m      `::::"?$$$$$$    :"$$$$c:`$$$$$$$$d$$$P$$$b`:`?$$$c : ::`?$$c "?$$$$h,  
ECHO [104;93m        `:::.$$$$$$$c,`::`????":`?$$$E"?$$$$h ?$$$.`:?$$$h..,,,:"$$$,:."?$$$c 
ECHO [104;93m          `: $$$$$$$$$c, ::``  :::"$$$b `"$$$ :"$$$b`:`?$$$$$$$c``?$F `:: ":: 
ECHO [104;93m           .,$$$$$"?$$$$$c,    `:::"$$$$.::"$.:: ?$$$.:.???????" `:::  ` ```  
ECHO [104;93m           'J$$$$P'::"?$$$$h,   `:::`?$$$c`::``:: .:: : :::::''   `           
ECHO [104;93m          :,$$$$$':::::`?$$$$$c,  ::: "::  ::  ` ::'   ``                     
ECHO [104;93m         .'J$$$$F  `::::: .::::    ` :::'  `                                  
ECHO [104;93m        .: ???):     `:: :::::                                                
ECHO [104;93m        : :::::'        `                                                     
ECHO [104;93m         ``                                                                   [0m

ECHO(

@md build\%fuenteBase% >nul 2>&1
..\asmTools\asm68k.exe /m /ow- /k /p /o ae- %binOrigen%.asm, build\%fuenteBase%\%binOrigen%.bin, , build\%fuenteBase%\%binOrigen%.lst

REM ..\asmTools\clownassembler_asm68k.exe /p %binOrigen%.asm, build\%fuenteBase%\%binOrigen%.bin, , build\%fuenteBase%\%binOrigen%.lst

FC "%binOrigen%.bin" "build\%fuenteBase%\%binOrigen%.bin" > research\diferencias.txt

ECHO total lineas en diferencias
FC "%binOrigen%.bin" "build\%fuenteBase%\%binOrigen%.bin" | find /c /v ""

REM ..\asmTools\analizador.exe research\diferencias.txt "build\%fuenteBase%\%binOrigen%.lst" research\analisis.txt

ECHO(
ECHO Diferencias esperadas: 1282
ECHO(
..\asmTools\CheckSumFixer.exe  "build\%fuenteBase%\%binOrigen%.bin"
ECHO(

..\asmTools\crc32.exe "build\%fuenteBase%\%binOrigen%.bin"  -nf | find /c /v "7A1A6A36" | for /F "delims=" %%a in ('more') do @if %%a == 1 ( Echo [102;30mCRC Correcto[0m ) else ECHO [101;30mCRC incorrecto![0m 
ECHO(
