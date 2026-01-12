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
set "_parTwoCurrent=%~2"
set "_checkParTwoCurrent=-%_parTwoCurrent%-"

:: Store most recent in variable.
rem curl -s https://curl.se/download.html | findstr "https://mirrors.kernel.org/sources.redhat.com/cygwin/x86_64/release/curl/curl-" | head -n 1 | sed -E "s/^(.*) href=\"(.*)\"(.*)$/\2/" > curl_download_uri.txt
curl -s https://curl.se/download.html | findstr /R "https://mirrors.kernel.org/sources.redhat.com/cygwin/x86_64/release/curl/curl-[0-9].*src.tar.xz" | head -n 1 | sed -E "s/^(.*) href=\"(.*)\"(.*)$/\2/" > curl_download_uri.txt

rem call cmdVar "type curl_download_uri.txt" _curlDownload
rem use variable for cmd tool
call "%_cmdVar%" "type curl_download_uri.txt" _curlDownload
del /Q curl_download_uri.txt

:: Safety condition before beginning process.
if "%_checkParOneCurrent%"=="--" (
 rem assume debugging - add/edit subroutines as needed
 call "%_instructLine%" "Using %_configOption% to Build curl:"
 set "_parOneCurrent=:_curl_cygwin"

 rem start installation
 call :_curl_cygwin 1 & goto:eof
) else (
 if "%_checkParTwoCurrent%"=="--" (
  rem call from step 1
  rem start installation
  call %_parOneCurrent% 1 & goto:eof
 ) else (
  rem call step from parTwo
  rem start installation
  call %_parOneCurrent% %_parTwoCurrent% & rem change subroutine call accoringly - _parOneCurrent has to expand
 )
)
goto:eof

:_curl_cygwin
 if "%1"=="1" (
  rem download makeshift package management executable from cygwin
  call "%_instructLine%" "Preparing to Install Required cygwin Packages:"

  curl https://www.cygwin.com/setup-x86_64.exe -o "C:\cygwin64\bin\pkg.exe"
  cls
  call "%_instructLine%" /H "SEARCH PACKAGES IN CYGWIN SELECT PACKAGES WINDOW:"
  call "%_instructLine%" "IMPORTANT - check install from source."
  call "%_instructLine%" /D
  call "%_instructLine%" /B
  call "%_instructLine%" " binutils"
  call "%_instructLine%" " gcc-core"
  call "%_instructLine%" " libpsl-devel"
  call "%_instructLine%" " libtool"
  call "%_instructLine%" " make"
  call "%_instructLine%" " perl"
  call "%_instructLine%" /B

  rem use condensed name to get packages
  pkg --no-admin -q -I -P binutils,gcc-core,libpsl-devel,libtool,perl,make

  rem next part of process
  call %_parOneCurrent% 2 & goto:eof
 )
 if "%1"=="2" (
  call "%_instructLine%" "Installing curl:"
  mkdir dump
  cd dump

  rem download for cygwin build
  rem use variable from start of process to get most recent
  curl %_curlDownload% -o src.tar.xz

  rem extract files and specify install for curl
  tar -xJf src.tar.xz & rm src.tar.xz
  move curl* tmp
  move tmp\curl-*.tar.xz curl.tar.xz

  rem extract install files for curl
  tar -xJf curl.tar.xz & rm curl.tar.xz
  move curl* ..\curl
  rm -rf tmp

  rem begin install process
  cd ..
  cd curl
  sh configure %_configOption%
  make

  rem next part of process
  call %_parOneCurrent% 3 & goto:eof
 )
 if "%1"=="3" (
  call "%_instructLine%" "Running Basic Commands to Test Install:"
  echo install_check> "install_check.txt"
  src\curl --version
  src\curl --version >> "install_check.txt"
  call :_testCommandSeparator
  src\curl --help
  call :_testCommandSeparator
  src\curl http://example.com
  call :_testCommandSeparator
  src\curl -I http://example.com
  call :_testCommandSeparator
  src\curl -H "accept-language: en-US,en;q=0.9" http://example.com
  call :_testCommandSeparator
  src\curl -L http://example.com
  call "%_cmdVar%" "type install_check.txt" _installCheck
  call :_testCommandSeparator
  goto _removeBatchhVariablesCurrent
 )
goto:eof

:_testCommandSeparator
 call "%_instructLine%" /B
 call "%_instructLine%" /D
 call "%_instructLine%" /B
goto:eof

:: Clean variables from process.
:_removeBatchhVariablesCurrent
 set _parOneCurrent=
 set _checkParOneCurrent=
 set _parTwoCurrent=
 set _checkParTwoCurrent=
 set _configOption=
 set _curlDownload=
 rem move "install_check.txt" to mapped sandbox folder
 make > install_log.log
 move /Y install_log.log "%~dp0install_log.log"
 move /Y "install_check.txt" "%~dp0install_check.txt"
 exit /b
goto:eof
