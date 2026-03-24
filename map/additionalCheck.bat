@echo off 
REM additionalCheck
::  As needed sctipt to check any additional thing.
::
::  Edit as needed.
::  Here to see if `--disable-shared --enable-static` can be excluded.

cd "%~dp0curl"
make clean
sh configure %_additionalCheckConfigFlag%
make

:: This does the check
echo install_check> install_check.txt
src\curl -I http://example.com >> install_check.txt

call "%_cmdVar%" "type install_check.txt" _additionalCheck
call :_runAdditionalCheck 1
goto:eof

:_runAdditionalCheck
 if "1"=="1" (
  if NOT "%_additionalCheck%"=="install_check" (
   if EXIST "callClaude.template" (
    sed -i -E "s/^(.*)$/\1-excludeConfigFlags/" callClaude.template
   ) else (
    echo create:excludeConfigFlags> callClaude.template
   )
  )
 )
goto:eof