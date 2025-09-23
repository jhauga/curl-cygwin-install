@echo off & title "cygwinInstall"
REM cygwinInstall
::  Set the path for InstallWinget.wsb

cd /D "%~dp0"

:: Process to ensure path is correct for config.
cd> tmpFileCygwinInstall.txt
sed -i "s/\\/-:-/g" tmpFileCygwinInstall.txt

:: Store current directory in variable - see cmdVar.bat
call cmdVar "type tmpFileCygwinInstall.txt" _curDir

:: Remove prior config if exists.
call :_prepForNewRun 1 --start

:: Start process for Sandbox.
call :_startCygwinInstall 1 & goto:eof

:: Main subroutine of procedure.
:_startCygwinInstall
 if "%1"=="1" (
  rem update with current path
  sed -i -E -e "s/(<HostFolder>)(.*)(<\/HostFolder>)/\1%_curDir%\\sandbox\3/" -e "s/-:-/\\/g" runStartSandbox.wsb
  
  rem update with config option
  sed -i -E "0,/(_configOption=).*/{s/(_configOption=).*/\1%_configOption%/}" sandbox\current.bat
  call instructLine /B
  call instructLine /H "INSTRUCTIONS:"
  TIMEOUT /T 1 >nul 2>nul
  call instructLine /B
  call instructLine "When Sandbox Opens, open the mapped folder and double click "runInstall.bat"."
  call instructLine /B
  TIMEOUT /T 5 >nul 2>nul
  call instructLine /H "CONFIGURE SANDBOX:"
  TIMEOUT /T 1 >nul 2>nul
  call instructLine /B
  call instructLine "Do you also want to install Notepad++ for debugging in Sandox?"
  call instructLine "input - yes or no"
  call instructLine /B
  set /P _installNotepad=
  call :_checkInstallNotepad 1
  call instructLine /B
  
  rem start sandbox, mapping clean sandbox folder
  runStartSandbox.wsb
  
  rem remove tmp file for windows command line variable
  del tmpFileCygwinInstall.txt

  rem next part of process
  call :_startCygwinInstall 2 & goto:eof
 )
 if "%1"=="2" (
  rem output final notes on process
  call instructLine /B
  call instructLine "Wait for Sandbox Process to Finish, then Press Enter to Close this Window:"
  call instructLine /B
  TIMEOUT /T 4 >nul 2>nul
  call instructLine /H "IMPORTANT"
  call instructLine "NOTE - closing after Sandbox session has ended will remove temp files of build." 
  call instructLine "NOTE - the entire install process should take around 15 minutes."
  call instructLine "NOTE - if needed delete runStartSandbox.wsb and sandbox folder after install."   
  call instructLine /B
  call instructLine /D
  call instructLine /B
  pause
  call instructLine "Delay of 15 seconds to ensure Sandbox task is closed."
  Timeout 15 >nul 2>nul
  call instructLine /B
  rem next part of process
  call :_startCygwinInstall 3 & goto:eof
 )
 if "%1"=="3" (
  rem if no sandbox process, delete folders used for build, keeping install
  call instructLine "Cleaning Sandbox:"
  call instructLine /B
  rem ensure sandbox is not running
  tasklist /fi "imagename eq WindowsSandboxServer.exe" | findstr "WindowsSandboxServer.exe" >nul 2>nul
  if ERRORLEVEL 1 (
   if EXIST "sandbox\curl" move "sandbox\curl" curl >nul 2>nul
   call :_prepForNewRun 1 --close
  ) else (
   rem remove variables for process
   goto _removeBatchVariables
  )
  
  exit /b
 )
goto:eof

:: Support subroutines.
:_prepForNewRun
 if "%1"=="1" (
  rem remove prior runStartSandbox if exists
  if EXIST runStartSandbox.wsb del /Q runStartSandbox.wsb >nul 2>nul
  if "%2"=="--start" copy /Y StartSandbox.wsb runStartSandbox.wsb >nul 2>nul
  
  rem remove prior sandbox if exists
  if EXIST sandbox rmdir /S/Q sandbox >nul 2>nul
  if "%2"=="--start" (
   xcopy /E/I map sandbox >nul 2>nul
   copy /Y cmdVar.bat sandbox\cmdVar.bat >nul 2>nul
   copy /Y instructLine.bat sandbox\instructLine.bat >nul 2>nul
  )
  
  rem if starting procedure, give option to specify config option
  if "%2"=="--start" (
   rem select configuration option
   call instructLine "Enter Corresponding DIGIT to Select Config Option:"
   call instructLine /D
   call instructLine "NOTE - press enter to use default --without-ssl option."
   call instructLine /B
   call instructLine /F config-options.txt
   call instructLine /B
   set /P _configOption=
   
   rem store number of lines in a variable
   FOR /F %%A in ('find /v /c "" ^< config-options.txt') DO set _numberOfOptions=%%A
   
   rem step 2 - allow batch to process variable change
   call :_prepForNewRun 2 & goto:eof
  ) else (
   rem ensure curl was moved
   if EXIST "curl" (
    call instructLine "Delete curl folder from Sandbox install?"
    call instructLine " y or n "
    call instructLine /B
    set /P _delCurlInstall=
    call :_prepForNewRun --close & goto:eof
   ) else (
    rem remove variables for process
    goto _removeBatchVariables
   )
  )
 )
 if "%1"=="2" (
  rem define config option per input
  if NOT DEFINED _configOption (
   set "_configOption=--without-ssl"
  ) else (
   rem ensure that correct digit was input
   echo %_configOption% | findstr /R [1-%_numberOfOptions%] >nul 2>nul
   if "%ERRORLEVEL%"=="0" (
    rem store appriopriate option in variable from input digit
    type config-options.txt | findstr "%_configOption%" | sed -E "s/^(%_configOption:~0,1%%)(.*)$/\2/" > _tmp-config-opt.txt
    call cmdVar "type _tmp-config-opt.txt" _configOption
    
    rem remove temp file
    del /Q _tmp-config-opt.txt >nul 2>nul
   ) else (
    call instructLine "Incorrect Input - Using Default --without-ssl"
    set "_configOption=--without-ssl"
   )
  )
 )
 if "%1"=="--close" (
  if /i "%_delCurlInstall%"=="y" (
   rmdir /s/q curl
  )
  goto _removeBatchVariables
 )
goto:eof

:_checkInstallNotepad
 if "%1"=="1" (
  if /i "%_installNotepad%"=="yes" (
   echo yes> "sandbox\install_notepad.txt"
  )
 )
goto:eof

:_removeBatchVariables
 call instructLine /B
 call instructLine "Removing Variables from Process:"
 call instructLine /B
 set _curDir=
 set _configOption=
 set _numberOfOptions=
 call instructLine "COMPLETE:"
 call instructLine /B
 call instructLine /D
 call instructLine /D
 call instructLine /B
goto:eof