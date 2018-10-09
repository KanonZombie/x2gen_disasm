@echo off

SET binReasm=x2_reasm
SET binOrigen=X-Men 2 - Clone Wars (W) [!]

IF EXIST %binReasm%.bin move /Y %binReasm%.bin %binReasm%.prev.bin >NUL

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

yaza driverz80\driverz80.z80 > salidaZ80.txt

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

asm68k /ow- /k /p /o ae- %binOrigen%.asm, %binReasm%.bin >errors.txt, , %binReasm%.lst

REM fixheadr.exe x2_reasm.bin

IF EXIST VBinDiff.exe VBinDiff "%binOrigen%.bin" "%binReasm%.bin"

FC "%binOrigen%.bin" "%binReasm%.bin" > diferencias.txt

ECHO total lineas en diferencias
FC "%binOrigen%.bin" "%binReasm%.bin" | find /c /v ""

REM analizador.exe  diferencias.txt x2_reasm.lst analisis.txt