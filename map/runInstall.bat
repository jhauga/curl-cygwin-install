@echo off & title "runInstall"
REM runInstall
::  Run install of winget, then install current script

:: Set the debug variables
if NOT DEFINED _debug (
 call "%~dp0setDebugVar.bat"
 "%~dp0%~n0.bat" & exit /b
)

:: This is to run the install process on a schedule that follows curl releases.
set "_runAsScheduledTask=0"

cd /D "%~dp0"

:: Set cmdVar full path in variable, ensuring it can be used outside folder.
set "_cmdVar=%~dp0cmdVar.bat"
set "_instructLine=%~dp0instructLine.bat"

:: HOT-GLUE for issue #1, file to check when duplicating scheduled task
echo Sandbox Running > sandBoxRan.txt

:: Debuug - if degugging in sandbox.
if "%_debug%"=="1" (
 if "%_debugRemoveDump%"=="1" (
  if EXIST "dump" rmdir /S/Q dump
 )
 call current.bat ":_current_cygwin" %_debugStep%
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
 set PATH=%PATH%;C:\cygwin64\bin\

 call "%_instructLine%" "Setting User path to include cygwin."
 setx PATH "%PATH%;C:\cygwin64\bin"

 call "%_instructLine%" "Installing setup-x86_64 binaries, using alias pkg."
 curl https://www.cygwin.com/setup-x86_64.exe -o "C:\cygwin64\bin\pkg.exe"
 if EXIST "%~dp0skip_install.txt" (
  call "%~dp0removeBatchVariables.bat"
 ) else (
  call current.bat ":_current_cygwin"
  call :_cleanRunInstall 1
 )
)
goto:eof

:_cleanRunInstall
 if "%1"=="1" (
  cd /D "%~dp0"
  if EXIST "site_download_uri_check.txt" (
   call "%_cmdVar%" "type site_download_uri_check.txt" _statusLinkCheckRunInstall
   del /Q site_download_uri_check.txt
  )
  if EXIST "initalize.txt" del /Q initalize.txt
  rm -rf https*
  call "%_instructLine%" /H "Run Install Complete:"
  call "%_instructLine%" /B

  rem delete HOT-GLUE sandbox check file
  if EXIST "%~dp0sandBoxRan.txt" del /Q "%~dp0sandBoxRan.txt" >nul 2>nul

  if "%_runAsScheduledTask%"=="0" (
   call "%_instructLine%" "What Happened?"
   call "%_instructLine%" /B
   pause
  ) else (
   if EXIST "%~dp0install_check.txt" (
    cd /D "%~dp0"
    call "%_cmdVar%" "type install_check.txt" _installCheck
   ) else (
    set "_installCheck=Fail"
   )
   call :_cleanRunInstall 2 & goto:eof
  )
 )
 if "%1"=="2" (
  rem NOTE - check `%_programCurrent%InstructionWork.txt` with a delay of over an hour to ensure install completed
  if "%_installCheck%"=="install_check" (
   set "_installCheck=Fail"
   echo Fail> %_programCurrent%InstructionWork.txt
  ) else if "%_installCheck%"=="Fail" (
   echo Fail> %_programCurrent%InstructionWork.txt
  ) else (
   set "_installCheck=Pass"
   echo Pass> %_programCurrent%InstructionWork.txt
  )
  call :_cleanRunInstall 3 & goto:eof
 )
 if "%1"=="3" (
  if "%_installCheck%"=="Fail" (
   if "%_statusLinkCheckRunInstall%"=="404" (
    call "%~dp0current.bat" --close-out "create:failedInstall-missingSourceLink"
   ) else (
    call "%~dp0current.bat" --close-out "create:failedInstall"
   )
  ) else if "%_statusLinkCheckRunInstall%"=="404" (
   call "%~dp0current.bat" --close-out "create:missingSourceLink"
  )
  call :_cleanRunInstall --close-out & goto:eof
 )
 if "%1"=="--close-out" (
  if "%_runAdditionalCheck%"=="1" (
   call "%~dp0additionalCheck.bat"
  )
  rem notify claude installation test complete
  echo install complete> "%~dp0_installation_is_complete.txt"
  rem clean current all environment variables
  call "%~dp0removeBatchVariables.bat"
  if "%_debugRunAsScheduledTask%"=="1" (
   echo CHECK VARIABLE
   echo:
   echo ---%_installCheck%---
   echo:
   call "%_instructLine%" "What Happened?"
   pause
   set _debugRunAsScheduledTask=
  ) else (
   shutdown /s /t 0
  )
 )
 exit /b
goto:eof