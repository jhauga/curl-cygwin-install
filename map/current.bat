@echo off & title "Sandbox"
REM current
::  Run current script using parameter to call function.
::  NOTE - using _parOneCurrent to call main subroutine as
::         this could be used with additional subroutines to
::         test different builds of curl.
 
:: Global variables.
set _configOption=--without-ssl
set "_parOneCurrent=%~1"
set "_checkParOneCurrent=-%_parOneCurrent%-"

:: Safety condition before beginning process.
if "%_checkParOneCurrent%"=="--" (
 echo No Parameter Passed: & rem
 goto _removeBatchhVariablesCurrent
) else (
 echo Using %_configOption% to Build curl:
 call %_parOneCurrent% 1
)
goto:eof

:_curl_cygwin
 if "%1"=="1" (
  rem download makeshift package management executable from cygwin
  echo Preparing to Install Required cygwin Packages: & rem
  
  curl https://www.cygwin.com/setup-x86_64.exe -o "C:\cygwin64\bin\pkg.exe"
  cls
  echo SEARCH PACKAGES IN CYGWIN SELECT PACKAGES WINDOW:
  echo *************************************************
  echo:
  echo binutils
  echo gcc-core
  echo libpsl-devel
  echo libtool
  echo perl
  echo make
  echo:
  
  rem use condensed name to get packages
  pkg -P binutils -P gcc-core -P libpsl-devel -P libtool -P perl -P make
  
  rem next part of process
  call %_parOneCurrent% 2 & goto:eof
 )
 if "%1"=="2" (
  echo Installing curl: & rem
  mkdir dump
  cd dump
  
  rem download for cygwin build
  curl https://mirrors.kernel.org/sources.redhat.com/cygwin/x86_64/release/curl/curl-8.13.0-1-src.tar.xz -o src.tar.xz
  
  rem extract files and specify install for curl
  tar -xJf src.tar.xz && rm src.tar.xz
  move curl-8.13.0-1.src\curl-8.13.0.tar.xz curl.tar.xz
  
  rem extract install files for curl
  tar -xJf curl.tar.xz && rm curl.tar.xz
  move curl-8.13.0 curl
  
  rem begin install process
  cd curl
  sh configure %_configOption%
  make
  
  rem next part of process
  call %_parOneCurrent% 3 & goto:eof
 )
 if "%1"=="3" (
  echo Running Basic Commands to Test Install: & rem
  src\curl --help
  src\curl http://example.com
  src\curl -I http://example.com
  src\curl -H "accept-language: en-US,en;q=0.9" http://example.com
  src\curl -L http://example.com
  goto _removeBatchhVariablesCurrent
 )
goto:eof

:: Clean variables from process.
:_removeBatchhVariablesCurrent
 set _configOption=
 set _parOneCurrent=
 set _checkParOneCurrent=
 
 exit /b
goto:eof
