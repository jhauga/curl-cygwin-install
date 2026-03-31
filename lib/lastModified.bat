@echo off
REM lastModified
::  Check the last modified date of a file against current date, then do something.
::
::  Usage: lastModified [1] [2] [3] [4]
::   [1]  =  file path *requires
::   [2]  =  file      *requires
::   [3]  =  specify-action
::   [4]  =  action
::
::  Example
::  > lastModified "sandbox\callClaude.template" callClaude.template --run-script "delay.bat"

set "_parOneLastModified=%~1"
set "_checkParOneLastModified=-%_parOneLastModified%-"
set "_parTwoLastModified=%~2"
set "_checkParTwoLastModified=-%_parTwoLastModified%-"
set "_parThreeLastModified=%~3"                                
set "_checkParThreeLastModified=-%_parThreeLastModified%-"
set "_parFourLastModified=%~4"                                        
set "_checkParFourLastModified=-%_parFourLastModified%-"
set "_parFiveLastModified=%~5"                                        
set "_checkParFiveLastModified=-%_parFiveLastModified%-"
set "_parSixLastModified=%~6"                                        
set "_checkParSixLastModified=-%_parSixLastModified%-"
set "_parSevenLastModified=%~7"                                        
set "_checkParSevenLastModified=-%_parSevenLastModified%-"
set "_parEightLastModified=%~8"                                        
set "_checkParEightLastModified=-%_parEightLastModified%-"
set "_parNineLastModified=%~9"                                        
set "_checkParNineLastModified=-%_parNineLastModified%-"

if "%_checkParTwoLastModified%"=="--" (
 echo Error: %~n0
 echo  - Two parameters are required
 goto _removeBatchVariablesLastModified
) else (
 rem get the current date
 call "%~dp0checkDate.bat"

 rem get the last modified date from parameter one
 if EXIST "%_parOneLastModified%" (
  rem file path relative to where called
  dir /T:W /4 "%_parOneLastModified%" | find "%_parTwoLastModified%" | sed -E -e "s;^([0-9]{2}/[0-9]+{2}/[0-9]{4}) .*$;\1;" -e "s;/;-;g" > _temp_unexpected_name_last_modifided_who_whould_name_a_file_this.txt
  rem store last modified in variable
  call "%~dp0cmdVar.bat" "type _temp_unexpected_name_last_modifided_who_whould_name_a_file_this.txt" _lastModified
  del /Q _temp_unexpected_name_last_modifided_who_whould_name_a_file_this.txt >nul 2>nul
  call :_startLastModified 1
 ) else (
  echo %_parOneLastModified% Does not exist
  goto _removeBatchVariablesLastModified
 )
)
goto:eof

:_startLastModified
 if "%1"=="1" (
  rem do constant post install if last modified date is current date
  if "%_lastModified%"=="%_checkDate%" (
   rem if delayed scheduled call, alwasy move to data folder
   if "%_parOneInstall%"=="--delay" (
    rem for claude or another automated script
    if EXIST "%~dp0..\sandbox\%_parTwoLastModified%" (
     move /Y "%~dp0..\sandbox\%_parTwoLastModified%" "%~dp0..\data\%_parTwoLastModified%"
    )
   )
   if NOT "%_checkParFourLastModified%"=="--" (
    if "%_parThreeLastModified%"=="--run-script" (
     if EXIST "%~dp0..\scripts\%_parFourLastModified%" (
      call "%~dp0..\scripts\%_parFourLastModified%"
     ) else (
      echo Script %_parFourLastModified% does not exist
     )
    ) else (
     echo No mapped action for - %_parThreeLastModified%
     echo Exiting Call
    )
   )
  ) else (
   echo Last modified date is not current date.
   echo Doing nothing.
  )
  goto _removeBatchVariablesLastModified
 )
goto:eof

:_removeBatchVariablesLastModified
 set _parOneLastModified=
 set _checkParOneLastModified=
 set _parTwoLastModified=
 set _checkParTwoLastModified=
 set _parThreeLastModified=
 set _checkParThreeLastModified=
 set _parFourLastModified=
 set _checkParFourLastModified=
 set _parFiveLastModified=
 set _checkParFiveLastModified=
 set _parSixLastModified=
 set _checkParSixLastModified=
 set _parSevenLastModified=
 set _checkParSevenLastModified=
 set _parEightLastModified=
 set _checkParEightLastModified=
 set _parNineLastModified=
 set _checkParNineLastModified=

 rem append new variables

 exit /b
goto:eof