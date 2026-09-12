@echo off
setlocal enabledelayedexpansion
title Envy-Diamond Variable Launcher
echo ===================================================
echo     Envy-Diamond Variable FPS Launcher
echo ===================================================

:: ==========================================
:: CONFIGURACION FACIL
:: Cambia este numero para ajustar el porcentaje (ejemplo: 50, 75, 100)
set PERCENT=75
:: ==========================================

if not exist "OptiScaler.ini" (
    echo Error: OptiScaler.ini no encontrado.
    pause
    exit /b
)

:: Obtener la tasa de refresco (Hz)
for /f "usebackq delims=" %%A in (`powershell -NoProfile -Command "$r = (Get-CimInstance Win32_VideoController | Where-Object CurrentRefreshRate -ne $null | Select-Object -First 1).CurrentRefreshRate; if (-not $r) { $r=60 }; [int]$r"`) do set REFRESH_RATE=%%A

:: Calcular limite
for /f "usebackq delims=" %%B in (`powershell -NoProfile -Command "[math]::Round(%REFRESH_RATE% * %PERCENT% / 100)"`) do set TARGET_FPS=%%B

echo Frecuencia de pantalla detectada : %REFRESH_RATE% Hz
echo Porcentaje configurado           : %PERCENT%%%
echo Aplicando limite constante de FPS: %TARGET_FPS%

:: Actualizar OptiScaler.ini usando PowerShell
powershell -NoProfile -Command "$c = Get-Content 'OptiScaler.ini'; $r = $false; for ($i=0; $i -lt $c.Length; $i++) { if ($c[$i] -match '^FramerateLimit=') { $c[$i] = 'FramerateLimit=%TARGET_FPS%'; $r = $true } }; if (-not $r) { $c += '[Framerate]'; $c += 'FramerateLimit=%TARGET_FPS%' }; $c | Set-Content 'OptiScaler.ini'"

echo.
echo OptiScaler.ini actualizado con exito.
echo Ya puedes abrir el juego normalmente (No lances el daemon).
echo.
pause
