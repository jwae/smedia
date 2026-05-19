@echo off
setlocal EnableExtensions

set "ROOT=%~dp0"
if "%ROOT:~-1%"=="\" set "ROOT=%ROOT:~0,-1%"

set "TRANSFER=%ROOT%\transfer"
set "APPDIR=%TRANSFER%\smedia-demo"

echo.
echo Erstelle Demo-Transferordner...

if exist "%APPDIR%" (
  echo Entferne alten Inhalt: "%APPDIR%"
  rmdir /S /Q "%APPDIR%"
)

mkdir "%APPDIR%" >nul 2>nul
mkdir "%APPDIR%\backend" >nul 2>nul
mkdir "%APPDIR%\dist" >nul 2>nul

echo.
echo Kopiere Backend...
xcopy "%ROOT%\backend" "%APPDIR%\backend\" /E /I /Y >nul

echo Kopiere Frontend-Build...
if exist "%ROOT%\dist\index.html" (
  xcopy "%ROOT%\dist" "%APPDIR%\dist\" /E /I /Y >nul
) else (
  echo WARNUNG: Kein dist-Build gefunden.
  echo Fuehre zuerst "npm run demo:build" aus.
)

echo Kopiere Projektdateien...
for %%F in (
  package.json
  package-lock.json
  openapi.yaml
  README-DEMO.md
  start-demo.ps1
  start-demo.bat
) do (
  if exist "%ROOT%\%%F" copy /Y "%ROOT%\%%F" "%APPDIR%\%%F" >nul
)

echo.
echo Suche SQL-Dump...
set "DUMPFILE="
if exist "%ROOT%\smedia_demo.sql" (
  set "DUMPFILE=%ROOT%\smedia_demo.sql"
) else (
  for /f "delims=" %%F in ('dir /B /A:-D /O:-D "%ROOT%\DB\dump-smedia-*.sql" 2^>nul') do (
    if not defined DUMPFILE set "DUMPFILE=%ROOT%\DB\%%F"
  )
)

if defined DUMPFILE (
  copy /Y "%DUMPFILE%" "%APPDIR%\smedia_demo.sql" >nul
  echo SQL-Dump gefunden und kopiert: smedia_demo.sql
  echo Quelle: %DUMPFILE%
) else (
  echo WARNUNG: Keine Datei "%ROOT%\smedia_demo.sql" gefunden.
  echo Auch kein Dump in "%ROOT%\DB\dump-smedia-*.sql" gefunden.
  echo Erzeuge vorher einen Dump, z. B.:
  echo   mysqldump -u root -P 3307 -p smedia ^> smedia_demo.sql
)

echo.
echo Transferpaket fertig:
echo   %APPDIR%
echo.
echo Enthalten sind:
echo   - backend\
echo   - dist\
echo   - package.json / package-lock.json
echo   - openapi.yaml
echo   - README-DEMO.md
echo   - start-demo.ps1
echo   - start-demo.bat
if exist "%APPDIR%\smedia_demo.sql" echo   - smedia_demo.sql
echo.
echo Naechster Schritt:
echo   Den Ordner "%APPDIR%" auf den Zielrechner kopieren.
echo.
pause
