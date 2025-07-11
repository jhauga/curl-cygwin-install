@echo off & title "runInstall"
REM runInstall
::  Run install of winget, then install current script

:: Debug variables - when debugging in sandbox change as needed.
set "_debug=0"           & rem default (0) 1 run debugging in sandbox
set "_debugStep=1"       & rem default (1) [1-9] call step in subroutine
set "_debugRemoveDump=0" & rem default (0) 1 deletes dump

cd /D "%~dp0"

:: Set cmdVar full path in variable, ensuring it can be used outside folder.
set "_cmdVar=%~dp0cmdVar.bat"

:: Debuug - if degugging in sandbox.
if "%_debug%"=="1" (
 if "%_debugRemoveDump%"=="1" (
  if EXIST "dump" rmdir /S/Q dump
 ) 
 call current.bat ":_curl_cygwin" %_debugStep%
 call :_cleanRunInstall 1 --curl
) else if NOT EXIST initalize.txt (
 rem ****************************************************************************
 rem START PROCESS AS NORMAL
 rem ****************************************************************************
 echo Installing winget: & rem
 powershell.exe -ExecutionPolicy Bypass -File "C:\Users\WDAGUtilityAccount\Desktop\sandbox\install-winget.ps1"
 echo ready > initalize.txt
 runInstall.bat
) else (
 rem check if notepad set for install
 if EXIST "install_notepad.txt" (
  winget install Notepad++.Notepad++ --source winget
  del /Q install_notepad.txt
 )
 echo Installing cygwin: & rem
 winget install cygwin.cygwin --source winget
 
 echo Setting Temp Path for Session: & rem
 set PATH=C:\cygwin64\bin\;%PATH%
 
 echo Setting User Path to Include cygwin: & rem
 setx PATH "C:\cygwin64\bin\;%PATH%"
 
 call current.bat ":_curl_cygwin"
 call :_cleanRunInstall 1
)
goto:eof

:_cleanRunInstall
 if "%1"=="1" (  
  cd "%~dp0"
  if EXIST "initalize.txt" del /Q initalize.txt
  rm -rf https*
  echo Run Install Complete: & rem
  echo:
  echo What Happened?
  pause
 )
 exit /b
goto:eof