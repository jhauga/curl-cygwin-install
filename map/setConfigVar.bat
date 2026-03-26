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
rem set _packageDependenciesCurrent=--no-admin -q -I -P binutils,gcc-core,libpsl-devel,libtool,perl,make
set _packageDependenciesCurrent=--no-admin -q -I -P binutils,cmake,gcc-core,libpsl-devel,libtool,ninja,perl,libssl-devel,zlib-devel
rem set _packageDependenciesCurrent=--no-admin -q -I -P binutils,cmake,gcc-core,libpsl-devel,libtool,perl,libssl-devel,zlib-devel
:: TEST COMMANDS
set "_runTestCommandCurrent=src\curl"
rem set "_runTestCommandCurrent=src\bin\curl"
set _runTestCommandCurrentA=%_runTestCommandCurrent% --version
set _runTestCommandCurrentB=%_runTestCommandCurrent% --help
set _runTestCommandCurrentC=%_runTestCommandCurrent% http://example.com
set _runTestCommandCurrentD=%_runTestCommandCurrent% -I http://example.com
set _runTestCommandCurrentE=%_runTestCommandCurrent% -H "accept-language: en-US,en;q=0.9" http://example.com
set _runTestCommandCurrentF=%_runTestCommandCurrent% -L http://example.com
set _runTestCommandCurrent_INSTALL_CHECK=%_runTestCommandCurrentD% ^>^> "%~dp0install_check.txt"
:: OPTIONAL
rem Optional if not using configuration like `sh configure`
rem IMPORTANT - if not using, then ensure both `_useConfigOptionCurrent` and `_useConfig` in `install.bat` are 0
rem IMPORTANT - don't duplicate "set _varName=" for the below to variables, sed is used to replace 1st instance in `install.bat`
set _useConfigOptionCurrent=1
set _configOptionCurrent=cmake . -G Ninja -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF
rem set _configOptionCurrent=cmake -S . -B build -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release
set "_useCustomMakeCurrent=1"
set "_customMakeCurrent=ninja"
rem set _customMakeCurrent=cmake --build build ^&^& cmake --install build --prefix src
set "_runAdditionalCheck=0" & rem set to 0 to not run post test
set "_additionalCheckConfigFlag=--without-ssl" & rem used in additionalCheck.bat, and as needed

:: DEBUG FAILURE CONDITIONS
set _forceErrorPackageDependenciesCurrent=--no-admin -q -P perl,make
set _forceErrorConfigOptionCurrent=sh configure --without-ssl
set "_useForceErrorCustomMakeCurrent=0"
set "_forceErrorCustomMakeCurrent=make docs"
