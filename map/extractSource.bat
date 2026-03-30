@echo off
REM extractSource
::  Commands to extract the source files from the download.

call "%_instructLine%" "Extracting the source download."
if EXIST "%~dp0dump" rmdir /S/Q "%~dp0dump" >nul 2>nul
mkdir "%~dp0dump"
cd "%~dp0dump"

rem download for cygwin build
rem use variable from start of process to get most recent
curl %_current% -o src.tar.xz

rem extract files and specify install for program
tar -xJf src.tar.xz & rm src.tar.xz
move %_programCurrent%-* %_programCurrent%

rem check that the tar.xz has been downloaded
if EXIST "%_programCurrent%\%_programCurrent%-*.tar.xz" (
 move %_programCurrent%\%_programCurrent%-*.tar.xz %_programCurrent%.tar.xz

 rem extract install files for program
 tar -xJf %_programCurrent%.tar.xz & rm %_programCurrent%.tar.xz
 move %_programCurrent%-* ..\%_programCurrent%
 rm -rf %_programCurrent%
) else (
 rem check that the source files have been downloaded
 if /i NOT EXIST "%_programCurrent%\make*" (
  call :_readyLinkCheck & goto:eof
 ) else (
  rem xcopy has to be used as Sandbox won't allow move permission here
  xcopy /E/I/Y %_programCurrent% ..\%_programCurrent%
  rmdir /S/Q %_programCurrent%
 )
)
rem begin install process
rem in sandbox\curl
cd ..\%_programCurrent%
rem rem clear log uri of link used for download
echo %_current%> "%~dp0USED_DOWNLOAD.uri"
rem output the link that was used
call "%~dp0outLinkCheck.bat" %_current% %~n0
goto:eof

:_readyLinkCheck
 cd ..
 rmdir /S/Q dump
goto:eof
