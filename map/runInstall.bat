@echo off & title "runInstall"
REM runInstall
::  Run install of winget, then install current script

:: Debug variables - when debugging in sandbox change as needed.
set "_debug=0"           & rem default (0) 1 run debugging in sandbox
set "_debugStep=1"       & rem default (1) [1-9] call step in subroutine
set "_debugRemoveDump=0" & rem default (0) 1 deletes dump

:: This is to run the install process on a schedule that follows curl releases.
set "_runAsScheduledTask=0"
set "_debugRunAsScheduledTask=0"

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
 call "%_instructLine%" /H "Installing winget:"
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
 call "%_instructLine%" /H "Installing cygwin:"
 call "%_instructLine%" /D
 call "%_instructLine%" /B
 winget install cygwin.cygwin --source winget

 call "%_instructLine%" /H "Setting Temp Path for Session:"
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
  cd /D "%~dp0"
  if EXIST "initalize.txt" del /Q initalize.txt
  rm -rf https*
  call "%_instructLine%" /H "Run Install Complete:"
  call "%_instructLine%" /B
  if "%_runAsScheduledTask%"=="0" (
   call "%_instructLine%" "What Happened?"
   call "%_instructLine%" /B
   pause
  ) else (
   if EXIST "install_check.txt" (
    call "%_cmdVar%" "type install_check.txt" _installCheck
   ) else (
    set "_installCheck=Fail"
   )
   call :_cleanRunInstall 2 & goto:eof
  )
 )
 if "%1"=="2" (
  rem NOTE - check `curlInstructionWork.txt` with a delay of over an hour to ensure install completed
  if "%_installCheck%"=="install_check" (
   echo Fail> curlInstructionWork.txt
  ) else (
   echo Pass> curlInstructionWork.txt
  )
  if "%_debugRunAsScheduledTask%"=="1" (
   call "%_instructLine%" "What Happened?"
   pause
   set _debugRunAsScheduledTask=
  )
  shutdown /s /t 0
 )
 exit /b
goto:eof