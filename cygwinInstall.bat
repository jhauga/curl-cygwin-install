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
call :_prepForNewRun 1 start

:: Start process for Sandbox.
call :_startCygwinInstall 1 & goto:eof

:: Main subroutine of procedure.
:_startCygwinInstall
 if "%1"=="1" (
  rem update with current path
  sed -i -E -e "s/(<HostFolder>)(.*)(<\/HostFolder>)/\1%_curDir%\\sandbox\3/" -e "s/-:-/\\/g" runStartSandbox.wsb
  
  rem update with config option
  sed -i -E "0,/(_configOption=).*/{s/(_configOption=).*/\1%_configOption%/}" sandbox\current.bat
  
  echo When Sandbox Opens, open the mapped folder and double click "runInstall.bat". & rem
  echo * Do you also want to install Notepad++ for debugging in Sandox?
  echo * input - yes or no
  echo:
  set /P _installNotepad=
  call :_checkInstallNotepad 1
  echo:
  
  rem start sandbox, mapping clean sandbox folder
  runStartSandbox.wsb
  
  rem remove tmp file for windows command line variable
  del tmpFileCygwinInstall.txt

  rem next part of process
  call :_startCygwinInstall 2 & goto:eof
 )
 if "%1"=="2" (
  rem output final notes on process
  echo Wait for Sandbox Process to Finish, then Press Enter to Close this Window:       & rem
  echo  NOTE - closing after Sandbox session has ended will remove temp files of build. & rem
  echo  NOTE - the entire install process should take around 15 minutes.                & rem
  echo  NOTE - if needed delete runStartSandbox.wsb and sandbox folder after install.  & rem
  echo:
  pause
  echo Delay of 15 seconds for Sandbox Task to Close
  Timeout 15 >nul 2>nul
  echo
  rem next part of process
  call :_startCygwinInstall 3 & goto:eof
 )
 if "%1"=="3" (
  rem if no sandbox process, delete folders used for build, keeping install
  echo Cleaning Sandbox: & rem
  
  rem ensure sandbox is not running
  tasklist /fi "imagename eq WindowsSandboxServer.exe" | findstr "WindowsSandboxServer.exe" >nul 2>nul
  if ERRORLEVEL 1 (
   if EXIST "sandbox\curl" move "sandbox\curl" curl >nul 2>nul
   call :_prepForNewRun 1 close
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
  if "%2"=="start" copy /Y StartSandbox.wsb runStartSandbox.wsb >nul 2>nul
  
  rem remove prior sandbox if exists
  if EXIST sandbox rmdir /S/Q sandbox >nul 2>nul
  if "%2"=="start" (
   xcopy /E/I map sandbox >nul 2>nul
   copy /Y cmdVar.bat sandbox\cmdVar.bat >nul 2>nul
  )
  
  rem if starting procedure, give option to specify config option
  if "%2"=="start" (
   rem select configuration option
   echo Enter Corresponding DIGIT to Select Config Option:
   echo ***************************************************
   echo NOTE - press enter to use default --without-ssl option.
   echo:
   type config-options.txt
   echo:
   set /P _configOption=
   
   rem store number of lines in a variable
   FOR /F %%A in ('find /v /c "" ^< config-options.txt') DO set _numberOfOptions=%%A
   
   rem step 2 - allow batch to process variable change
   call :_prepForNewRun 2 & goto:eof
  ) else (
   rem remove variables for process
   goto _removeBatchVariables
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
    echo Incorrect Input - Using Default --without-ssl & rem
    set "_configOption=--without-ssl"
   )
  )
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
 echo Removing Variables from Process: & rem
 set _curDir=
 set _configOption=
 set _numberOfOptions=
goto:eof