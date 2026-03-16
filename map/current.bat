@echo off & title "Sandbox"
REM current
::  Run current script using parameter to call function.
::  NOTE - using _parOneCurrent to call main subroutine as
::         this could be used with additional subroutines to
::         test different builds of curl.
::
:: CONFIGURATION VARIABLES
set "_programCurrent=curl"
set "_siteCurrent=https://curl.se/download.html"
set "_uriCurrent=https://mirrors.kernel.org/sources.redhat.com/cygwin"
set "_siteUriCurrent=%_uriCurrent%/x86_64/release/curl/"
set _extractInstallUriCurrent=curl -s %_siteCurrent%  ^| findstr /R "%_siteUriCurrent%%_programCurrent%-[0-9].*src.tar.xz" ^| head -n 1
set "_packageDependenciesCurrent=binutils,gcc-core,libpsl-devel,libtool,perl,make"
set "_forceErrorPackageDependenciesCurrent=perl,make"
set "_runTestCommandCurrent=src\curl"
set "_useConfigOptionCurrent=1"
set _configOptionCurrent=--without-ssl
set "_useCustomMakeCurrent=0"
set "_customMakeCurrent=make"
rem Optional
set "_customDebugMakeCurrent=0"
set "_debugMakeCurrent=make docs"
:: TEST COMMANDS
set _runTestCommandCurrentA=%_runTestCommandCurrent% --version
set _runTestCommandCurrentB=%_runTestCommandCurrent% --help
set _runTestCommandCurrentC=%_runTestCommandCurrent% http://example.com
set _runTestCommandCurrentD=%_runTestCommandCurrent% -I http://example.com
set _runTestCommandCurrentE=%_runTestCommandCurrent% -H "accept-language: en-US,en;q=0.9" http://example.com
set _runTestCommandCurrentF=%_runTestCommandCurrent% -L http://example.com
set _runTestCommandCurrent_INSTALL_CHECK=%_runTestCommandCurrentD% ^>^> "%~dp0install_check.txt"

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
  rem if called form `linkCheck.bat` and download host links are broken
  if "%_parOneCurrent%"=="--close-out" (
   if "%_statusLinkCheckCurrent%"=="404" (
    echo create:new-foobar-issue> "%~dp0foobar.txt"
   )
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
     call "%_instructLine%" "Using %_configOptionCurrent% to Build %_programCurrent%:"
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
  if "%_debugForceFailSchedCong%"=="0" (
   pkg --no-admin -q -I -P %_packageDependenciesCurrent%
  ) else (
   pkg --no-admin -q -P %_forceErrorPackageDependenciesCurrent%
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
   rem back in sandbox
   cd ..
   cd %_programCurrent%
   if "%_useConfigOptionCurrent%"=="1" (
    sh configure %_configOptionCurrent%
   )
   if "%_debugForceFailSchedTask%"=="0" (
    if "%_useCustomMakeCurrent%"=="1" (
     %_customMakeCurrent%
     %_customMakeCurrent% 2> "%~dp0install_log.log"
    ) else (
     make
     make 2> "%~dp0install_log.log"
    )
   ) else (
    if "%_customDebugMakeCurrent%"=="1" (
     %_debugMakeCurrent%
     %_debugMakeCurrent% 2> "%~dp0install_log.log"
    ) else (
     make docs
     make docs 2> "%~dp0install_log.log"
    )
   )
   if "%_useConfigOptionCurrent%"=="1" (
    rem if make completely failed, then reason for fail is on config
    sh configure %_configOptionCurrent% 2> "%~dp0config_log.log"
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
  rem HERE it is:
  rem %_runTestCommandCurrent% -I http://example.com >> "%~dp0install_check.txt"
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
 set _customDebugMakeCurrent=
 set _debugMakeCurrent=
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
 exit /b
goto:eof
