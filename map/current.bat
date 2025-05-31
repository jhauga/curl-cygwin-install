@echo off & title "Sandbox"
REM current
::  Run current script using parameter to call function.

:: Global variables.
set "_configOption=--without-ssl"
set "_parOneCurrent=%~1"
set "_checkParOneCurrent=-%_parOneCurrent%-"

if "%_checkParOneCurrent%"=="--" (
 echo No Parameter Passed: & rem
 goto _removeBatchhVariablesCurrent
) else (
 call %_parOneCurrent% 1
)
goto:eof

:_curl_cygwin
 if "%1"=="1" (
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
  pkg -P  binutils, gcc-core, libpsl-devel, libtool, perl, make
  call %_parOneCurrent% 2 & goto:eof
 )
 if "%1"=="2" (
  mkdir dump
  cd dump  
  curl https://mirrors.kernel.org/sources.redhat.com/cygwin/x86_64/release/curl/curl-8.13.0-1-src.tar.xz -o src.tar.xz
  tar -xJf src.tar.xz && rm src.tar.xz
  move curl-8.13.0-1.src\curl-8.13.0.tar.xz curl.tar.xz
  tar -xJf curl.tar.xz && rm curl.tar.xz
  move curl-8.13.0 curl
  cd curl
  sh configure %_configOption%
  make
  call %_parOneCurrent% 3 & goto:eof
 )
 if "%1"=="3" (
  src\curl --help
  src\curl http://example.com
  src\curl -I http://example.com
  src\curl -H "accept-language: en-US,en;q=0.9" http://example.com
  src\curl -L http://example.com
  goto _removeBatchhVariablesCurrent
 )
goto:eof

:_removeBatchhVariablesCurrent
 set _parOneCurrent=
 set _checkParOneCurrent=
 exit /b
goto:eof
