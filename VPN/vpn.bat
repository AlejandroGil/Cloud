@echo off

:init 
   set /p answer=Selecciona una opcion ([c]onectar/[d]esconectar)?
   if /i "%answer:~,1%" EQU "C" goto params
   if /i "%answer:~,1%" EQU "D" goto disconnect
   echo Elige c para conectar y d para desconectar
   goto init

:params 
   set /p VPN_NAME=Nombre de la VPN: 
   set /p IP_RANGE=Direccion IP: 
   set /p IP_MASK=Mascara IP: 
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
   set /p VPN_NAME=Nombre de la VPN: 
   set /p IP_RANGE=Direccion IP: 
   route delete %IP_RANGE%
   rasphone -h %VPN_NAME%
   exit /b