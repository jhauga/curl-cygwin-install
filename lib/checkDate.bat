@echo off
REM checkDate
:: Get the current date "DD-MM-YY" format.

:: Define path to current batch.
set "_callRootCheckDate=%~dp0"
set "_callLibraryCheckDate=%~dp0.."
set "_checkDatePath=%~dp0"

set "_parOneCheckDate=%~1"
set "_parTwoCheckDate=%~2"
set "_checkParTwoCheckDate=-%_parTwoCheckDate%-"
set "_parThreeCheckDate=%~3"
set "_checkParThreeCheckDate=-%_parThreeCheckDate%-"

call :_getDefaultDate
goto:eof


:: START EXECUTABLE STATEMENTS
:_getDefaultDate
 FOR /F "TOKENS=1* DELIMS=" %%A IN ('DATE/T') DO set _checkDate=%%A
  
 set _checkDate=%_checkDate:* =%
 set _checkDate=%_checkDate:/=-%
 
 set _checkDate=%_checkDate: =%
 goto _removeBatchVariablesCheckDate
goto:eof
:: END EXECUTABLE STATEMENTS


:: Remove batch variables.
:_removeBatchVariablesCheckDate
 set _callRootCheckDate=
 set _callLibraryCheckDate=
 set _checkDatePath=
 set _parOneCheckDate=
 set _parTwoCheckDate=
 set _checkParTwoCheckDate=
 set _parThreeCheckDate=
 set _checkParThreeCheckDate=
 set _tmpDirCheckDate=
 rem append new variables

 exit /b 
goto:eof 