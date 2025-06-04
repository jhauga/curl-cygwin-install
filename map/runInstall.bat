@echo off & title "runInstall"
REM runInstall
::  Run install of winget, then install current script

cd /D "%~dp0"

if NOT EXIST initalize.txt (
 echo Installing winget: & rem
 powershell.exe -ExecutionPolicy Bypass -File "C:\Users\WDAGUtilityAccount\Desktop\sandbox\install-winget.ps1"
 echo ready > initalize.txt
 runInstall.bat
) else (
 rem check if notepad set for install
 if EXIST "install_notepad.txt" (
  winget install Notepad++.Notepad++ --source winget
  del /Q install_notepad.txt
 )
 echo Installing cygwin: & rem
 winget install cygwin.cygwin --source winget
 
 echo Setting Temp Path for Session: & rem
 set PATH=C:\cygwin64\bin\;%PATH%
 
 echo Setting User Path to Include cygwin: & rem
 setx PATH "C:\cygwin64\bin\;%PATH%"
 
 call current.bat ":_curl_cygwin"
 call :_cleanRunInstall 1
)
goto:eof

:_cleanRunInstall
 if "%1"=="1" (  
  cd "%~dp0"
  del initalize.txt
  rm -rf https*
  echo Run Install Complete: & rem
  echo:
  echo What Happened?
  pause
 )
 exit /b
goto:eof