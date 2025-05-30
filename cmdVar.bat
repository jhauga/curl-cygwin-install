@echo off
REM cmdVar
::  Store command output in a variable.

:: Define path to current batch.
set "_callRootCmdVar=%~dp0"

:: Parameter variables.
set "_parOneCmdVar=%~1"
set "_checkParOneCmdVar=-%_parOneCmdVar%-"
set "_parTwoCmdVar=%~2"
set "_checkParTwoCmdVar=-%_parTwoCmdVar%-"

if "%_checkParOneCmdVar%"=="--" ( 
 echo The syntax of the command %~n0 is incorrect.
 set _cmdVar=
 goto _removeBatchVariablesCmdVar
)
call :_startCmdVar 1
goto:eof


:: Start executable
:_startCmdVar
 if "%1"=="1" (
  if EXIST .tmp\ (
   set _tmpFolderPresentCmdVar=1
  ) else (
   set _tmpFolderPresentCmdVar=0
  ) 
  SetLocal EnableDelayedExpansion
  
  goto _makeCmdVar
 )
goto:eof

:_makeCmdVar
 if NOT EXIST ".tmp\%~n0" (
  mkdir .tmp\%~n0
 )
 set _parOneCmdVar=%_parOneCmdVar:'="%
 call :_runCmdVar 1
  
 FOR /F "tokens=*" %%A in (.tmp\%~n0\tempString.txt) DO set _tempCmdVar=!_tempCmdVar!%%A
 echo !_tempCmdVar!> .tmp\%~n0\tempOut.txt
 
 endlocal
 
 type .tmp\%~n0\tempOut.txt > .tmp\%~n0\readyString.txt
 call :_cleanCmdVar 2
 if NOT "%_checkParTwoCmdVar%"=="--" (
  FOR /F "tokens=*" %%A in (.tmp\%~n0\outString.txt) DO set %_parTwoCmdVar%=%%A
  call :_removeBatchVariablesCmdVar 1
 ) else (
  FOR /F "tokens=*" %%A in (.tmp\%~n0\outString.txt) DO set _cmdVar=%%A
  call :_removeBatchVariablesCmdVar 0
 )  
goto:eof

:_runCmdVar
 if "%1"=="1" (
  %_parOneCmdVar%> .tmp\%~n0\temp.txt
  call :_cleanCmdVar
 )
goto:eof

:_cleanCmdVar
 if "%1"=="2" (    
  copy /Y .tmp\%~n0\readyString.txt .tmp\%~n0\outString.txt >NUL
 ) else (  
  type .tmp\%~n0\temp.txt > .tmp\%~n0\tempString.txt
 ) 
goto:eof

:: Remove batch variables.
:_removeBatchVariablesCmdVar
 rem dump variables as needed
 set _callRootCmdVar=
 set _parOneCmdVar=
 set _checkParOneCmdVar=
 set _parTwoCmdVar=
 set _checkParTwoCmdVar=
 
 if "%1"=="1" (
  set _cmdVar=
 )
 
 if EXIST .tmp\%~n0 (
  rmdir /S/Q .tmp\%~n0
 )
 if "%_tmpFolderPresentCmdVar%"=="0" (
  rmdir .tmp >nul 2>nul
 )
 set _tmpFolderPresentCmdVar=
 
 exit /b
goto:eof 