@echo off
REM setConfigVar
::  Set the configuration variables for Cygwin installation check.
 
set "_programCurrent=curl"
set "_siteCurrent=https://curl.se/download.html"
set "_uriCurrent=https://mirrors.kernel.org/sources.redhat.com/cygwin"
set "_siteUriCurrent=%_uriCurrent%/x86_64/release/curl/"
set "_sourceMarkerCurrent=src.tar.xz"
set _extractInstallUriCurrent=curl -s %_siteCurrent%  ^| findstr /R "%_siteUriCurrent%%_programCurrent%-[0-9].*%_sourceMarkerCurrent%" ^| head -n 1
rem comment out below if dependencies are not known as it guranatees all dependencies are downloaded
rem set _packageDependenciesCurrent=--no-admin -q -I --build-depends %_programCurrent% 
set _packageDependenciesCurrent=--no-admin -q -I -P binutils,gcc-core,libpsl-devel,libtool,perl,make
set _forceErrorPackageDependenciesCurrent=--no-admin -q -P perl,make
:: TEST COMMANDS
set "_runTestCommandCurrent=src\curl"
set _runTestCommandCurrentA=%_runTestCommandCurrent% --version
set _runTestCommandCurrentB=%_runTestCommandCurrent% --help
set _runTestCommandCurrentC=%_runTestCommandCurrent% http://example.com
set _runTestCommandCurrentD=%_runTestCommandCurrent% -I http://example.com
set _runTestCommandCurrentE=%_runTestCommandCurrent% -H "accept-language: en-US,en;q=0.9" http://example.com
set _runTestCommandCurrentF=%_runTestCommandCurrent% -L http://example.com
set _runTestCommandCurrent_INSTALL_CHECK=%_runTestCommandCurrentD% ^>^> "%~dp0install_check.txt"
:: OPTIONAL
rem Optional if not using `sh configure`
rem IMPORTANT - if not using, then ensure both `_useConfigOptionCurrent` and `_useConfig` in `install.bat` are 0
rem IMPORTANT - don't duplicate "set _varName=" for the below to variables, sed is used to replace 1st instance in `install.bat`
set _useConfigOptionCurrent=1
set _configOptionCurrent=--without-ssl
set _forceErrorConfigOptionCurrent=--without-ssl
set "_useCustomMakeCurrent=0"
set "_customMakeCurrent=make"
set "_useForceErrorCustomMakeCurrent=0"
set "_forceErrorCustomMakeCurrent=make docs"
set "_runAdditionalCheck=0" & rem set to 0 to not run post test
