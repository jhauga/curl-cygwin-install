@echo off & title "curl-cygwin-install"
REM install
::  Start installation check for curl install instructions of cygwin.

cd /D "%~dp0"

:: Parameters for running scheduled task
set "_parOneCurlCygwinInstall=%~1"
set "_checkParOneCurlCygwinInstall=-%_parOneCurlCygwinInstall%-"

:: Use `_parOneCurlCygwinInstall` with --delay for delayed task to check install "Pass" or "Fail"
if "%_parOneCurlCygwinInstall%"=="--delay" (
 taskkill /F /FI "imagename eq WindowsSandboxServer.exe"
 if EXIST "sandbox" (
  if EXIST "sandbox\curlInstructionWork.txt" (
   move /Y "sandbox\curlInstructionWork.txt" "curlInstructionWork.txt" >nul 2>nul
  ) else (
   echo Fail> curlInstructionWork.txt
  )
  if EXIST "sandbox\install_log.log" (
   move /Y "sandbox\install_log.log" "install_log.log" >nul 2>nul
   if EXIST "sandbox\curl" move /Y "sandbox\curl" curl >nul 2>nul
  )
  rmdir /S/Q sandbox >nul 2>nul
 ) else (
  echo Fail> curlInstructionWork.txt
 )
 goto _removeBatchVariables
 goto:eof
)
:: For back-to-back calls of scheduled task to HOT-GLUE issue #1
rem HOT-GLUE
tasklist /fi "imagename eq WindowsSandboxServer.exe" | findstr "WindowsSandboxServer.exe" >nul 2>nul
if "%_parOneCurlCygwinInstall%"=="--task-run" (
 if "%ERRORLEVEL%"=="0" (
  if NOT EXIST "sandbox\sandBoxRan.txt" (
   rem if run start sandbox, then sandBoxRan.txt was created
   taskkill /F /FI "imagename eq WindowsSandboxServer.exe"
   TIMEOUT /T 1 >nul 2>nul
   "%~dp0install.bat" %_parOneCurlCygwinInstall%
  )
  exit /b
  goto:eof
 )
)

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
  rem ensure file write completes
  TIMEOUT /T 1 /NOBREAK >nul 2>nul

  rem update with config option
  sed -i -E "0,/(_configOption=).*/{s/(_configOption=).*/\1%_configOption%/}" sandbox\current.bat
  call instructLine /B
  call instructLine /H "INSTRUCTIONS:"
  TIMEOUT /T 1 >nul 2>nul
  call instructLine /B
  call instructLine "When Sandbox Opens, runInstall.bat will execute automatically."
  call instructLine /B
  TIMEOUT /T 3 >nul 2>nul
  call instructLine /H "CONFIGURE SANDBOX:"
  TIMEOUT /T 1 >nul 2>nul
  call instructLine /B
  rem check if installing notepadd++ for debug in sandbox
  if NOT "%_parOneCurlCygwinInstall%"=="--task-run" (
   call :_checkInstallNotepad 1
  ) else (
   rem set Sandbox to shutdown
   sed -i -z -E "s/set \"_runAsScheduledTask=[0-9]/set \"_runAsScheduledTask=1/" sandbox\runInstall.bat
  )
  rem start sandbox, mapping clean sandbox folder
  if NOT EXIST "%~dp0runStartSandbox.wsb" (
   if "%_checkParOneCurlCygwinInstall%"=="--" (
    call instructLine "Something unexpected happened. Exiting batch."
    exit /b
   ) else (
    rem this is primarily for scheduled task as task will be terminated if this recurs over an hour
    if "%_parOneCurlCygwinInstall%"=="--task-run" (
     install.bat %_parOneCurlCygwinInstall%
    )
    exit /b
   )
   goto:eof
  ) else (
   start "" "%~dp0runStartSandbox.wsb"
  )
  rem remove tmp file for windows command line variable
  del tmpFileCygwinInstall.txt
  rem next part of process
  call :_startCygwinInstall 2 & goto:eof
 )
 if "%1"=="2" (
  rem output final notes on process
  if NOT "%_parOneCurlCygwinInstall%"=="--task-run" (
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
  )
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
   if EXIST "sandbox\curl" move /Y "sandbox\curl" curl >nul 2>nul
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
  if "%2"=="--start" (
   rem remove prior runStartSandbox if exists
   if EXIST "runStartSandbox.wsb" (
    del /Q runStartSandbox.wsb >nul 2>nul
    TIMEOUT /T 1 /NOBREAK >nul 2>nul
   )
   copy /Y StartSandbox.wsb runStartSandbox.wsb >nul 2>nul
   rem remove prior sandbox if exists
   if EXIST sandbox rmdir /S/Q sandbox >nul 2>nul
   xcopy /Y/E/I map sandbox >nul 2>nul
   copy /Y cmdVar.bat sandbox\cmdVar.bat >nul 2>nul
   copy /Y instructLine.bat sandbox\instructLine.bat >nul 2>nul
   rem ensure sandbox folder is fully written before proceeding
   if EXIST "sandbox\runInstall.bat" (
    TIMEOUT /T 1 /NOBREAK >nul 2>nul
   )

   if "%_parOneCurlCygwinInstall%"=="--task-run" (
    rem use default
    set "_configOption=--without-ssl"
    call :_prepForNewRun 2 --set-default & goto:eof
   ) else (
    rem if starting procedure, give option to specify config option
    rem select configuration option
    call instructLine "Enter Corresponding DIGIT to Select Config Option:"
    call instructLine /D
    call instructLine "NOTE - press enter to use default --without-ssl option."
    call instructLine /B
    call instructLine /F config-options.txt
    set /P _configOption=
    call instructLine /B

    rem store number of lines in a variable
    FOR /F %%A in ('find /v /c "" ^< config-options.txt') DO set _numberOfOptions=%%A

    rem step 2 - allow batch to process variable change
    call :_prepForNewRun 2 & goto:eof
   )
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
  if "%2"=="--set-default" (
   rem using scheduled task
   call instructLine "Configuration set to %_configOption%"
  ) else (
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
   call instructLine "Do you also want to install Notepad++ for debugging in Sandox?"
   call instructLine "input - yes or no"
   call instructLine /B
   set /P _installNotepad=
   call :_checkInstallNotepad 2 & goto:eof
 )
 if "%1"=="2" (
  call instructLine /B
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
 set _parOneCurlCygwinInstall=
 set _checkParOneCurlCygwinInstall=
 call instructLine "COMPLETE:"
 call instructLine /B
 call instructLine /D
 call instructLine /D
 call instructLine /B
goto:eof