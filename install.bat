@echo off
REM install
::  Start installation check for a program install instructions of cygwin.
::
::  useage: install [1]
::   [1] = [--task-run] [--delay]
::
::  Options               Description
::   --task-run            Pass if running with an automated task.
::   --delay               Extract log data and results of the install.
::
::  Configuration
::   - Change the variable `_programInstall` to the value of the program being installed
::
:: CONFIGURATION VARIABLE
set "_programInstall=curl"
set "_useConfig=0"
set "_configTool=sh configure"
set "_defaultConfig=--without-ssl --disable-shared"
set "_dailyCheckInstall=1" & rem check if url of latest.txt has changed
set "_checkLatestUrlInstall=https://github.com/%_programInstall%/%_programInstall%/releases/latest"

:: For makseshift help
set "_helpLinesInstall=19"

:: Start install check.
title "%_programInstall%-cygwin-install"
cd /D "%~dp0"

:: Parameters for running scheduled task
set "_debugTaskRunInstall=0" & rem 0 (default), 1 install notepad++ with --task-run
set "_parOneInstall=%~1"
set "_checkParOneInstall=-%_parOneInstall%-"

:: Check for help option
if "%_parOneInstall%"=="-h" (
 call :_makeShiftHelpInstall 1 & goto:eof
) else if "%_parOneInstall%"=="--help" (
 call :_makeShiftHelpInstall 1 & goto:eof
) else if "%_parOneInstall%"=="/?" (
 call :_makeShiftHelpInstall 1 & goto:eof
)

:: Use `_parOneInstall` with --delay for delayed task to check install "Pass" or "Fail"
if "%_parOneInstall%"=="--delay" (
 taskkill /F /FI "imagename eq WindowsSandboxServer.exe"
 if EXIST "sandbox" (
  if EXIST "sandbox\%_programInstall%InstructionWork.txt" (
   move /Y "sandbox\%_programInstall%InstructionWork.txt" "%_programInstall%InstructionWork.txt" >nul 2>nul
  ) else (
   echo Fail> "%_programInstall%InstructionWork.txt"
  )
  if EXIST "sandbox\install_log.log" (
   move /Y "sandbox\install_log.log" "data\install_log.log" >nul 2>nul
  )
  if EXIST "sandbox\config_log.log" (
   move /Y "sandbox\config_log.log" "data\config_log.log" >nul 2>nul
  )
  if EXIST "sandbox\%_programInstall%" (
   move /Y "sandbox\%_programInstall%" "%_programInstall%" >nul 2>nul
  )
  if EXIST "sandbox\mirrorSiteDownloadLink.uri" (
   move /Y "sandbox\mirrorSiteDownloadLink.uri" "data\mirrorSiteDownloadLink.uri"
  )
  if EXIST "sandbox\callClaude.template" (
   rem for claude or another automated script
   move /Y "sandbox\callClaude.template" "data\callClaude.template"
   
   rem get more context for claude call
   call scripts\delay.bat
  )
  rmdir /S/Q sandbox >nul 2>nul
 ) else (
  echo Fail> "%_programInstall%InstructionWork.txt"
 )
 goto _removeBatchVariables
 goto:eof
)
:: For back-to-back calls of scheduled task to HOT-GLUE issue #1
rem HOT-GLUE
tasklist /fi "imagename eq WindowsSandboxServer.exe" | findstr "WindowsSandboxServer.exe" >nul 2>nul
if "%_parOneInstall%"=="--task-run" (
 if "%ERRORLEVEL%"=="0" (
  if NOT EXIST "sandbox\sandBoxRan.txt" (
   rem if run start sandbox, then sandBoxRan.txt was created
   taskkill /F /FI "imagename eq WindowsSandboxServer.exe"
   TIMEOUT /T 1 >nul 2>nul
   "%~dp0install.bat" %_parOneInstall%
  )
  exit /b
  goto:eof
 )
)

:: Process to ensure path is correct for config.
cd> tmpFileCygwinInstall.txt
sed -i "s/\\/-:-/g" tmpFileCygwinInstall.txt

:: Store current directory in variable - see cmdVar.bat
call lib\cmdVar "type tmpFileCygwinInstall.txt" _curDir
:: Remove tmp file for windows command line variable
del /Q tmpFileCygwinInstall.txt

:: Check if the latest url is different.
if "%_dailyCheckInstall%"=="1" (
 rem check latest url
 call scripts\checkLatest.bat
 call :_checkLatestInstall 1
 goto:eof
)
:: Remove prior config if exists.
call :_prepForNewRun 1 --start

:: Start process for Sandbox.
call :_startCygwinInstall 1
goto:eof

:: Main subroutine of procedure.
:_startCygwinInstall
 if "%1"=="1" (
  rem update with current path
  sed -i -E -e "s/(<HostFolder>)(.*)(<\/HostFolder>)/\1%_curDir%\\sandbox\3/" -e "s/-:-/\\/g" runStartSandbox.wsb
  rem ensure file write completes
  TIMEOUT /T 1 /NOBREAK >nul 2>nul

  rem update with config option
  if "%_useConfig%"=="1" (
   rem use all configuration as set here
   sed -i -E "0,/(_useConfigOptionCurrent=).*/{s/(_useConfigOptionCurrent=).*/\1%_useConfig%/}" sandbox\current.bat
   sed -i -E "0,/(_configOptionCurrent=).*/{s/(_configOptionCurrent=).*/\1%_configOption%/}" sandbox\current.bat
  )
  call lib\instructLine /B
  call lib\instructLine /H "INSTRUCTIONS:"
  TIMEOUT /T 1 >nul 2>nul
  call lib\instructLine /B
  call lib\instructLine "When Sandbox Opens, runInstall.bat will execute automatically."
  call lib\instructLine /B
  TIMEOUT /T 3 >nul 2>nul
  call lib\instructLine /H "CONFIGURE SANDBOX:"
  TIMEOUT /T 1 >nul 2>nul
  call lib\instructLine /B
  rem check if installing notepadd++ for debug in sandbox
  if NOT "%_parOneInstall%"=="--task-run" (
   call :_checkInstallNotepad 1
  ) else (
   rem set Sandbox to shutdown
   sed -i -z -E "s/set \"_runAsScheduledTask=[0-9]/set \"_runAsScheduledTask=1/" sandbox\runInstall.bat
   if "%_debugTaskRunInstall%"=="1" (
    set "_installNotepad=yes"
    call :_checkInstallNotepad 2
   )
  )
  rem start sandbox, mapping clean sandbox folder
  if NOT EXIST "%~dp0runStartSandbox.wsb" (
   if "%_checkParOneInstall%"=="--" (
    call lib\instructLine "Something unexpected happened. Exiting batch."
    exit /b
   ) else (
    rem this is primarily for scheduled task as task will be terminated if this recurs over an hour
    if "%_parOneInstall%"=="--task-run" (
     install.bat %_parOneInstall%
    )
    exit /b
   )
   goto:eof
  ) else (
   start "" "%~dp0runStartSandbox.wsb"
  )
  rem next part of process
  call :_startCygwinInstall 2 & goto:eof
 )
 if "%1"=="2" (
  rem output final notes on process
  if NOT "%_parOneInstall%"=="--task-run" (
   call lib\instructLine /B
   call lib\instructLine "Wait for Sandbox Process to Finish, then Press Enter to Close this Window:"
   call lib\instructLine /B
   TIMEOUT /T 4 >nul 2>nul
   call lib\instructLine /H "IMPORTANT"
   call lib\instructLine "NOTE - closing after Sandbox session has ended will remove temp files of build."
   call lib\instructLine "NOTE - the entire install process should take around 15 minutes."
   call lib\instructLine "NOTE - if needed delete runStartSandbox.wsb and sandbox folder after install."
   call lib\instructLine /B
   call lib\instructLine /D
   call lib\instructLine /B
   pause
   call lib\instructLine "Delay of 15 seconds to ensure Sandbox task is closed."
   Timeout 15 >nul 2>nul
   call lib\instructLine /B
  )
  rem next part of process
  call :_startCygwinInstall 3 & goto:eof
 )
 if "%1"=="3" (
  rem if no sandbox process, delete folders used for build, keeping install
  call lib\instructLine "Cleaning Sandbox:"
  call lib\instructLine /B
  rem ensure sandbox is not running
  tasklist /fi "imagename eq WindowsSandboxServer.exe" | findstr "WindowsSandboxServer.exe" >nul 2>nul
  if ERRORLEVEL 1 (
   if EXIST "sandbox\%_programInstall%" move /Y "sandbox\%_programInstall%" "%_programInstall%" >nul 2>nul
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
   copy /Y lib\cmdVar.bat sandbox\cmdVar.bat >nul 2>nul
   copy /Y lib\instructLine.bat sandbox\instructLine.bat >nul 2>nul
   
   rem ensure sandbox folder is fully written before proceeding
   if EXIST "sandbox\runInstall.bat" (
    TIMEOUT /T 1 /NOBREAK >nul 2>nul
   )

   rem check context of this call, use `--task-run` for automation
   if "%_parOneInstall%"=="--task-run" (
    if "%_useConfig%"=="1" (
     rem use default
     set "_configOption=%_configTool% %_defaultConfig%"
     call :_prepForNewRun 2 --set-default & goto:eof
    )
   ) else (
    rem if starting procedure, give option to specify config option
    rem select configuration option
    if "%_useConfig%"=="1" (
     if EXIST "config-options.txt" (
      call lib\instructLine "Enter Corresponding DIGIT to Select Config Option:"
      call lib\instructLine /D
      call lib\instructLine "NOTE - press enter to use default --without-ssl option."
      call lib\instructLine /B
      call lib\instructLine /F config-options.txt
      set /P _configOption=
      call lib\instructLine /B

      rem store number of lines in a variable
      FOR /F %%A in ('find /v /c "" ^< config-options.txt') DO set _numberOfOptions=%%A
     ) else (
      set _configOption=
     )
     rem step 2 - allow batch to process variable change
     call :_prepForNewRun 2 & goto:eof
    )
    rem else do nothing
   )
  ) else (
   rem ensure program folder was moved
   if EXIST "%_programInstall%" (
    if "%_parOneInstall%"=="--task-run" (
     set _delCurlInstall=y
    ) else (
     call lib\instructLine "Delete %_programInstall% folder from Sandbox install?"
     call lib\instructLine " y or n "
     call lib\instructLine /B
     set /P _delCurlInstall=
    )
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
   call lib\instructLine "Configuration set to %_configOption%"
  ) else (
   rem define config option per input
   if NOT DEFINED _configOption (
    set "_configOption=%_configTool% %_defaultConfig%"
   ) else (
    rem ensure that correct digit was input
    echo %_configOption% | findstr /R [1-%_numberOfOptions%] >nul 2>nul
    if "%ERRORLEVEL%"=="0" (
     rem store appriopriate option in variable from input digit
     type config-options.txt | findstr "%_configOption%" | sed -E "s/^(%_configOption:~0,1%%)(.*)$/\2/" > _tmp-config-opt.txt

     rem check if curl as `--disable-shared --enable-static` has to be appended
     if "%_programInstall%"=="curl" (
      rem ensure single space before `--`
      echo  --disable-shared --enable-static>> _tmp-config-opt.txt
     )
     call lib\cmdVar "type _tmp-config-opt.txt" _configOption

     rem remove temp file
     del /Q _tmp-config-opt.txt >nul 2>nul
    ) else (
     call lib\instructLine "Incorrect Input - Using Default --without-ssl"
     set "_configOption=%_configTool% %_defaultConfig%"
    )
   )
  )
 )
 if "%1"=="--close" (
  if /i "%_delCurlInstall%"=="y" (
   rmdir /s/q "%_programInstall%"
  )
  goto _removeBatchVariables
 )
goto:eof

:_checkInstallNotepad
 if "%1"=="1" (
   call lib\instructLine "Do you also want to install Notepad++ for debugging in Sandox?"
   call lib\instructLine "input - yes or no"
   call lib\instructLine /B
   set /P _installNotepad=
   call :_checkInstallNotepad 2 & goto:eof
 )
 if "%1"=="2" (
  call lib\instructLine /B
  if /i "%_installNotepad%"=="yes" (
   echo yes> "sandbox\install_notepad.txt"
  )
 )
goto:eof

:_checkLatestInstall
 if "%1"=="1" (
  if "%_latestRelease%"=="%_checkRelease%" (
   echo No new release. Exiting task.
   if "%_parOneInstall%"=="--task-run" (
    goto _removeBatchVariables
   ) else (
    call :_checkLatestInstall 2 & goto:eof
   )
  ) else (
   echo %_checkRelease%> data\latest.uri
   call :_checkLatestInstall 2 & goto:eof
  )
 )
 if "%1"=="2" (
  rem resume call as normal
  rem remove prior config if exists.
  call :_prepForNewRun 1 --start

  rem start process for Sandbox.
  call :_startCygwinInstall 1 & goto:eof
 )
goto:eof

:_makeShiftHelpInstall
 if "%1"=="1" (
  head -n %_helpLinesInstall% "%~dp0%~n0.bat" | sed 1d | sed -e "s/:://" -e "s/REM//" -E -e "s/^set/ set/"
  set _helpLinesInstall=
  goto _removeBatchVariables
 )
goto:eof

:_removeBatchVariables
 if DEFINED _helpLinesInstall (
  call lib\instructLine /B
  call lib\instructLine "Removing Variables from Process:"
  call lib\instructLine /B
  call lib\instructLine "COMPLETE:"
  call lib\instructLine /B
  call lib\instructLine /D
  call lib\instructLine /D
  call lib\instructLine /B
 )
 set _programInstall=
 set _useConfig=
 set _configTool=
 set _defaultConfig=
 set _helpLinesInstall=
 set _curDir=
 set _configOption=
 set _numberOfOptions=
 set _debugTaskRunInstall=
 set _parOneInstall=
 set _checkParOneInstall=
 set _checkRelease=
 set _closeOutInstall=
 set _dailyCheckInstall=
 set _delCurlInstall=
 set _installNotepad=
 set _latestRelease=
 set _checkLatestUrlInstall=
goto:eof
