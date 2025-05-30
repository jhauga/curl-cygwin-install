@echo off & title "setHostFolder"
REM setHostFolder
::  Set the path for InstallWinget.wsb

cd /D "%~dp0"

:: Process to ensure path is correct for config.
cd> tmpFileSetHostFolder.txt
sed -i "s/\\/-:-/g" tmpFileSetHostFolder.txt

:: Store current directory in variable - see cmdVar.bat
call cmdVar "type tmpFileSetHostFolder.txt" _curDir

:: Remove prior config if exists.
if EXIST runInstallWinget.wsb del /Q runInstallWinget.wsb >nul 2>nul
copy /Y InstallWinget.wsb runInstallWinget.wsb >nul 2>nul

:: Remove prior sandbox if exists.
if EXIST sandbox rmdir /S/Q sandbox >nul 2>nul
xcopy /E/I map sandbox >nul 2>nul

:: Start process for Sandbox.
call :_startSetHostFolder 1 & goto:eof

:_startSetHostFolder
 if "%1"=="1" (
  rem update with current path
  sed -i -E -e "s/(<HostFolder>)(.*)(<\/HostFolder>)/\1%_curDir%\\sandbox\3/" -e "s/-:-/\\/g" runInstallWinget.wsb
  
  echo When Sandbox Opens, open the mapped folder and double click "runInstall.bat". & rem
  echo:
  pause
  echo:
  
  rem start sandbox, mapping clean sandbox folder
  runInstallWinget.wsb
  
  rem remove tmp file for windows command line variable
  del tmpFileSetHostFolder.txt
  
  rem output final notes on process
  echo Press Enter to Close this Window:                                              & rem
  echo NOTE - the entire install process should take around 15 minutes.               & rem
  echo NOTE - if needed delete runInstallWinget.wsb and sandbox folder after install. & rem
  echo:
  pause
  exit /b
 )
goto:eof