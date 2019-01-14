@echo off

:init 
   set /p answer=Selecciona una opcion ([c]onectar/[d]esconectar)? 
   if /i "%answer:~,1%" EQU "C" goto params
   if /i "%answer:~,1%" EQU "D" goto disconnect
   goto init

:params 
   set VPN_NAME=XXX
   set IP_RANGE=XXX
   set IP_MASK=255.255.0.0 
   goto route

:route
    rasphone -d %VPN_NAME%
    set IF=-1
    FOR /F "tokens=1-2 delims=." %%a in ('route print ^| findstr /I %VPN_NAME%') do set IF=%%a
    set IF=%IF: =%
    if "%IF%" == "-1"  (
        echo Error obteniendo interfaz para %VPN_NAME%
        exit /b
    )
    route -p add %IP_RANGE% mask %IP_MASK% 0.0.0.0 IF %IF%
    rasphone -h %VPN_NAME%
    rasphone -d %VPN_NAME%
    exit /b

:disconnect 
   set VPN_NAME=XXX
   set IP_RANGE=XXX
   route delete %IP_RANGE%
   rasphone -h %VPN_NAME%
   exit /b