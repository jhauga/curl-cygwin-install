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
set "_instructLine=%~dp0instructLine.bat"

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
 call "%_instructLine%" /H Installing winget:
 call "%_instructLine%" /D
 call "%_instructLine%" /B
 powershell.exe -ExecutionPolicy Bypass -File "C:\Users\WDAGUtilityAccount\Desktop\sandbox\install-winget.ps1"
 echo ready > initalize.txt
 runInstall.bat
) else (
 rem check if notepad set for install
 if EXIST "install_notepad.txt" (
  winget install Notepad++.Notepad++ --source winget
  del /Q install_notepad.txt
 )
 call "%_instructLine%" /H Installing cygwin:
 call "%_instructLine%" /D
 call "%_instructLine%" /B
 winget install cygwin.cygwin --source winget
 
 call "%_instructLine%" /H Setting Temp Path for Session:
 call "%_instructLine%" /D
 call "%_instructLine%" /B
 set PATH=C:\cygwin64\bin\;%PATH%
 
 call "%_instructLine%" "Setting User path to include cygwin."
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
  call "%_instructLine%" /H Run Install Complete: & rem
  call "%_instructLine%" /B
  call "%_instructLine%" "What Happened?"
  call "%_instructLine%" /B
  pause
 )
 exit /b
goto:eof