@echo off
REM instructLine
::  Output easy to read instructions to the terminal.
::  useage: instructLine [1] [2]
::          [1] = [/B] [/D] [/H] [/I] [instruction]
::          [2] = [instruction] [heading]
::  Parameter              Description
::   /B                     Blank line.
::   /D                     Dash line.
::   /H                     Heading
::   /I                     Instruction line.
::   instruction            Instructions for line.
::   heading                Heading for line.
set "_helpLinesInstructLine=13"

:: Parameter variables.
set "_parOneInstructLine=%~1"
set "_checkParOneInstructLine=-%_parOneInstructLine%-"
set "_parTwoInstructLine=%~2"
set "_checkParTwoInstructLine=-%_parTwoInstructLine%-"
set "_parThreeInstructLine=%~3"
set "_checkParThreeInstructLine=-%_parThreeInstructLine%-"

if "%_parOneInstructLine%"=="-e" (
 rem Get the date with librarty getDate
 notepad++ "%~dp0%~n0.bat"
 goto _removeBatchVariablesInstructLine
)

if "%_parOneInstructLine%"=="-h" (
 call :_makeShiftHelpInstructLine 1 & goto:eof
) else if "%_parOneInstructLine%"=="/?" (
 call :_makeShiftHelpInstructLine 1 & goto:eof
) else if "%_checkParOneInstructLine%"=="--" (
 call :_makeShiftHelpInstructLine 1 & goto:eof
)

call :_startInstructLineConditions 1
goto:eof

:_startInstructLineConditions
 if "%1"=="1" (
  if /i "%_parOneInstructLine%"=="/b" (
   call :_runInstructLine 1 --blank & goto:eof
  ) else if /i "%_parOneInstructLine%"=="/d" (
   call :_runInstructLine 1 --dash & goto:eof
  ) else if /i "%_parOneInstructLine%"=="/f" (
   call :_runInstructLine 1 --file & goto:eof
  ) else if /i "%_parOneInstructLine%"=="/h" (
   call :_runInstructLine 1 --heading & goto:eof
  ) else if /i "%_parOneInstructLine%"=="/i" (
   call :_runInstructLine 1 --instruct & goto:eof
  ) else (
   call :_runInstructLine 1 & goto:eof
  )
 )
 rem else
 goto _removeBatchVariablesInstructLine
goto:eof

:_runInstructLine
 if "%1"=="1" (
  if "%2"=="--blank" (
   echo *                                                                                 *
  ) else if "%2"=="--dash" (
   echo ***********************************************************************************
  ) else if "%2"=="--file" (
   SetLocal EnableDelayedExpansion
   set "_file=%_parTwoInstructLine%"
   goto _instructFileInstructLine
  ) else if "%2"=="--heading" (
   goto _headingLoop
  ) else if "%2"=="--instruct" (
   setlocal EnableDelayedExpansion
   set "_instruct=%_parTwoInstructLine%"
   goto _instructLoop
  ) else (
   setlocal EnableDelayedExpansion
   set "_instruct=%_parOneInstructLine%"
   goto _instructLoop
  )
 )
 rem else
 goto _removeBatchVariablesInstructLine
goto:eof

:_headingLoop
 setlocal EnableDelayedExpansion
 set "_heading=%_parTwoInstructLine%"
 set "_headingLength=0"
 set "_length=82"
 :_loop
  if not "!_heading:~%_headingLength%,1!"=="" (
   set /a _headingLength+=1
   goto :_loop
  )
 set /A _starCount=!_length!-!_headingLength!"
 set "_star=*"

 set "_outHeading="
 FOR /L %%i in (1,1,!_starCount!) do (
  set "_outHeading=!_outHeading!!_star!"
 )
 echo !_heading! !_outHeading!

 endlocal
 goto _removeBatchVariablesInstructLine
goto:eof

:_instructLoop
 set "_instructLength=0"
 set "_length=79"
 :_loop
 if not "!_instruct:~%_instructLength%,1!"=="" (
  set /a _instructLength+=1
  goto :_loop
 )
 set /A _starCount=!_length!-!_instructLength!"
 set /A _totalLength=!_instructLength!+4"

 set "_outInstruct= "
 FOR /L %%i in (1,1,!_starCount!) do (
  set "_outInstruct=!_outInstruct! "
 )
 if "!_totalLength!" LSS "83" (
  echo * !_instruct!!_outInstruct!*
 ) else (
  echo * !_instruct!
 )

 endlocal
 goto _removeBatchVariablesInstructLine
goto:eof

:_instructFileInstructLine
 if NOT EXIST "!_file!" (
  call callLibrary syntaxErr "%~n0" --notExist !_file!
  goto :eof
 )

 FOR /F "usebackq delims=" %%L IN ("!_file!") DO (
  set "_instruct=%%L"
  call :_instructLoop
 )
goto:eof

:_makeShiftHelpInstructLine
 if "%1"=="1" (
 setlocal EnableDelayedExpansion
  FOR /F "tokens=1* delims=:" %%a IN ('findstr /n "^" %~n0.bat') DO (
   if %%a LEQ %_helpLinesInstructLine% (
    set _out=%%b
    if /i "!_out!"=="ECHO is off." (
     echo:
    ) else (
     echo %%b
    )
   )
  )
 )
 endlocal
 goto _removeBatchVariablesInstructLine
goto:eof

:_removeBatchVariablesInstructLine
 set _parOneInstructLine=
 set _checkParOneInstructLine=
 set _parTwoInstructLine=
 set _checkParTwoInstructLine=
 set _parThreeInstructLine=
 set _checkParThreeInstructLine=

 rem append new variables
 set _helpLinesInstructLine=
 set _getDateLib=
goto:eof