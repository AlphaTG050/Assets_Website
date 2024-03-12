@echo off

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

:Script
cls
echo.
set /p drive_letter=Bitte gib den Laufwerkbuchstaben ein (z.B C): 

if not exist %drive_letter%:\ (
    echo.
    echo Der von Ihnen eingegebene Laufwerkbuchstabe "%drive_letter%" existiert nicht.
    echo.
    goto Script
)

if not exist %drive_letter%:\temp\DiskResults md %drive_letter%:\temp\DiskResults

set /a randomNumber=%random% %% 99999 + 1

set "filename=DiskResults_"
set "date_str=%date:~10,4%%date:~3,2%.%date:~0,2%"
set "swapped_date=%date:~10,4%%date:~0,2%.%date:~3,2%"
set "randomNumber=#%randomNumber%"

ECHO.
ECHO.
ECHO Disk Test Results
echo ----------------------------
echo.
echo READ
winsat disk -seq -read -drive %drive_letter%: | findstr /R "^.*$" >> "%drive_letter%:\temp\DiskResults\%filename%%swapped_date%_%randomNumber%%~x1.txt"
for /f "tokens=*" %%a in ('winsat disk -seq -read -drive %drive_letter%:') do echo %%a
echo.
echo WRITE
winsat disk -seq -write -drive %drive_letter%: | findstr /R "^.*$" >> "%drive_letter%:\temp\DiskResults\%filename%%swapped_date%_%randomNumber%%~x1.txt"
for /f "tokens=*" %%a in ('winsat disk -seq -write -drive %drive_letter%:') do echo %%a
echo.
echo.
ECHO Disk Result is saved in %drive_letter%\temp\DiskResults
echo ------------------------------------------------
echo.
pause
goto Script