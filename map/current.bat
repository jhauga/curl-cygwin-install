@echo off & title "Sandbox"
REM current
::  Run current script using parameter to call function.
::  NOTE - using _parOneCurrent to call main subroutine as
::         this could be used with additional subroutines to
::         test different builds of curl.
::
:: CONFIGURATION VARIABLES -----------------------------------------------------------------------------------------------------------------------
if NOT DEFINED _programCurrent (
 call "%~dp0setConfigVar.bat"
)

:: Global variables.
set "_parOneCurrent=%~1"
set "_checkParOneCurrent=-%_parOneCurrent%-"
set "_parTwoCurrent=%~2"
set "_checkParTwoCurrent=-%_parTwoCurrent%-"
set "_parThreeCurrent=%~2"
set "_checkParThreeCurrent=-%_parThreeCurrent%-"

call :_startCurrent 1
goto:eof

:_startCurrent
 if "%1"=="1" (
  rem called from `linkCheck.bat` or end of `runInstall.bat`
  if "%_parOneCurrent%"=="--close-out" (
   rem don't overwrite error result
   rem error results:
   rem  - create:
   rem    - failedInstall      = the install failt, but no broken links
   rem    - missingSourceLink  = the link from site is broken
   rem    - excludeConfigFlags = the hot-glue config options can be excluded
   rem  - check:
   rem    - missingAllLinks        = unable test install, look into it and find download links
   rem    - installCurrentCloseOut = unexpected in this script, look into it
   if NOT EXIST "%~dp0callClaude.txt" (
    if NOT "%_checkParTwoCurrent%"=="--" (
     echo %_parTwoCurrent%> "%~dp0callClaude.txt"
    ) else (
     echo check:installCurrentCloseOut> "%~dp0callClaude.txt"
    )
   )
   goto _removeBatchhVariablesCurrent
  ) else if "%_parOneCurrent%"=="--delay" (
   call "%~dp0claudeContext.bat" > claude-context.yaml
   sed -i "s/'/ --q-- /g" claude-context.yaml
   sed -i -E -e "s/^(.{1,}:) .(.*).$/\1 \2/" -E -e "s;^( {0,}[a-zA-Z]+:)(.);\1 \2;" -E -e "s/^( {1,}- [a-zA-Z]+:)(.)/\1 \2/" -E -e "s/^([a-zA-Z_]+:)(.)/\1 \2/" -E -e "s/([a-zA-Z_]+:) {2,}(.)/\1 \2/" claude-context.yaml
   sed -i -e "s/--q--/'/g" -e "s/ '/'/g" -e "s/' / '/g" claude-context.yaml
   goto _removeBatchhVariablesCurrent
  ) else (
   rem store most recent in variable.
   if NOT DEFINED _current (
    rem set first call helper variable
    rem IMPORTANT - only define here
    set "_firstCallCurrent=1"
    rem her _extractInstallUriCurrent is:
    rem curl -s https://curl.se/download.html ^| findstr /R "https://mirrors.kernel.org/sources.redhat.com/cygwin/x86_64/release/curl/curl-[0-9].*src.tar.xz" ^| head -n 1

    rem CONFIG-EDIT--_extractInstallUriCurrent--CALL
    %_extractInstallUriCurrent% > pipedExtractInstallUriCurrent.txt
    sed -i -E "s/^.* href=.(.*)\".*$/\1/" pipedExtractInstallUriCurrent.txt
    
    type pipedExtractInstallUriCurrent.txt > %_programCurrent%_download_uri.txt
    rem use variable for cmd tool
    call "%_cmdVar%" "type %_programCurrent%_download_uri.txt" _current
   )
   rem safety condition before beginning process.
   if "%_checkParOneCurrent%"=="--" (
    rem assume debugging - add/edit subroutines as needed
    if "%_useConfigOptionCurrent%"=="1" (
     call "%_instructLine%" "Using Configuration to Build %_programCurrent%:"
    )
    set "_parOneCurrent=:_current_cygwin"

    rem start installation
    call :_current_cygwin 1 & goto:eof
   ) else (
    if "%_checkParTwoCurrent%"=="--" (
     rem call from step 1
     rem start installation
     call %_parOneCurrent% 1 & goto:eof
    ) else (
     rem change subroutine call accoringly i.e.
     rem  - _parOneCurrent has to expand
     rem  - call step from parTwo to start installation
     call %_parOneCurrent% %_parTwoCurrent% & goto:eof
    )
   )
  )
 )
goto:eof

:_current_cygwin
 if "%1"=="1" (
  rem download makeshift package management executable from cygwin
  call "%_instructLine%" "Preparing to Install Required cygwin Packages:"

  curl https://www.cygwin.com/setup-x86_64.exe -o "C:\cygwin64\bin\pkg.exe"
  call "%_instructLine%" /H "INSTALLING PACKAGES FROM CYGWIN:"
  call "%_instructLine%" /D
  call "%_instructLine%" /B
  call "%_instructLine%" " %_packageDependenciesCurrent%"
  call "%_instructLine%" /B

  rem use condensed name to get packages
  if "%_debugForceErrorDependencies%"=="0" (
   pkg %_packageDependenciesCurrent%
  ) else (
   pkg %_forceErrorPackageDependenciesCurrent%
  )

  rem next part of process
  call %_parOneCurrent% 2 & goto:eof
 )
 if "%1"=="2" (
  if DEFINED _firstCallCurrent (
   rem IMPORTANT - keep undefined here
   set _firstCallCurrent=
   call "%_instructLine%" "Checking Download Link:"
   curl -sI %_current% | sed -n "s/^HTTP[^ ]* \([0-9][0-9][0-9]\).*/\1/p" > statusLinkCheckCurrent.txt
   call "%_cmdVar%" "type statusLinkCheckCurrent.txt" _statusLinkCheckCurrent
   call %_parOneCurrent% --status-check & goto:eof
  ) else (
   call "%_instructLine%" "Installing %_programCurrent%:"
   mkdir dump
   cd dump
   rem download for cygwin build
   rem use variable from start of process to get most recent
   curl %_current% -o src.tar.xz

   rem extract files and specify install for program
   tar -xJf src.tar.xz & rm src.tar.xz
   move %_programCurrent%* tmp
   move tmp\%_programCurrent%-*.tar.xz %_programCurrent%.tar.xz

   rem extract install files for program
   tar -xJf %_programCurrent%.tar.xz & rm %_programCurrent%.tar.xz
   move %_programCurrent%* ..\%_programCurrent%
   rm -rf tmp

   rem begin install process
   rem in sandbox\curl
   cd ..\%_programCurrent%
   if "%_useConfigOptionCurrent%"=="1" (
    if "%_debugForceErrorConfig%"=="0" (
     %_configOptionCurrent%
    ) else (
     rem force fail to test automated task
     %_forceErrorConfigOptionCurrent%
    )
   )
   if "%_debugForceErrorInstall%"=="0" (
    if "%_useCustomMakeCurrent%"=="1" (
     %_customMakeCurrent%
     if "%_debugCreateLogs%"=="1" %_customMakeCurrent% 2> "%~dp0install_log.log"
    ) else (
     make
     if "%_debugCreateLogs%"=="1" make 2> "%~dp0install_log.log"
    )
   ) else (
    if "%_useForceErrorCustomMakeCurrent%"=="1" (
     %_forceErrorCustomMakeCurrent%
     if "%_debugCreateLogs%"=="1" %_forceErrorCustomMakeCurrent% 2> "%~dp0install_log.log"
    ) else (
     make docs
     if "%_debugCreateLogs%"=="1" make docs 2> "%~dp0install_log.log"
    )
   )
   if "%_useConfigOptionCurrent%"=="1" (
    rem if make completely failed, then reason for fail is on config
    if "%_debugForceErrorConfig%"=="0" (
     if "%_debugCreateLogs%"=="1" %_configOptionCurrent% 2> "%~dp0config_log.log"
    ) else (
     if "%_debugCreateLogs%"=="1" %_forceErrorConfigOptionCurrent% 2> "%~dp0config_log.log"
    )
   )
   rem next part of process
   call %_parOneCurrent% 3 & goto:eof
  )
 )
 if "%1"=="3" (
  call "%_instructLine%" "Running Basic Commands to Test Install:"
  %_runTestCommandCurrentA%
  call :_testCommandSeparator
  %_runTestCommandCurrentB%
  call :_testCommandSeparator
  %_runTestCommandCurrentC%
  call :_testCommandSeparator
  %_runTestCommandCurrentD%
  call :_testCommandSeparator
  %_runTestCommandCurrentE%
  call :_testCommandSeparator
  %_runTestCommandCurrentF%
  call :_testCommandSeparator
  echo install_check> "%~dp0install_check.txt"
  rem expands to:
  rem curl -I http://example.com >> "%~dp0install_check.txt"
  %_runTestCommandCurrent_INSTALL_CHECK%
  goto _removeBatchhVariablesCurrent
 )
 if "%1"=="--status-check" (
  if "%_statusLinkCheckCurrent%"=="404" (
   rem checked in scheduled task example:
   rem  if EXIST "site_download_uri_check.txt" commandVar _site_download_uri_check
   rem  if "%_site_download_uri_check%"=="404" call :_linkError
   echo %_statusLinkCheckCurrent%> "%~dp0site_download_uri_check.txt"

   rem call linkCheck to see if install still works
   "%~dp0linkCheck.bat"
   goto:eof
  ) else (
   rem call again as link not 404
   call %_parOneCurrent% 2 & goto:eof
  )
 )
goto:eof

:_testCommandSeparator
 call "%_instructLine%" /B
 call "%_instructLine%" /D
 call "%_instructLine%" /B
goto:eof

:: Clean variables from process.
:_removeBatchhVariablesCurrent
 set _programCurrent=
 set _siteCurrent=
 set _uriCurrent=
 set _siteUriCurrent=
 set extractInstallUriCurrent=
 set _packageDependenciesCurrent=
 set _forceErrorPackageDependenciesCurrent=
 set _runTestCommandCurrent=
 set _useConfigOptionCurrent=
 set configOptionCurrent=
 set _useCustomMakeCurrent=
 set _customMakeCurrent=
 set _useForceErrorCustomMakeCurrent=
 set _forceErrorCustomMakeCurrent=
 set _runTestCommandCurrentA=
 set _runTestCommandCurrentB=
 set _runTestCommandCurrentC=
 set _runTestCommandCurrentD=
 set _runTestCommandCurrentE=
 set _runTestCommandCurrentF=
 set _runTestCommandCurrent_INSTALL_CHECK=
 set _parOneCurrent=
 set _checkParOneCurrent=
 set _parTwoCurrent=
 set _checkParTwoCurrent=
 set _parThreeCurrent=
 set _checkParThreeCurrent=
 set _configOptionCurrent=
 set _current=
 rem append new variables
 set _firstCallCurrent=
 set _forceErrorConfigOptionCurrent=
 exit /b
goto:eof
