@echo off
REM configInstall
::  Set configuration variables to start the Sandbox installation to check if
::  installation using Cygwin installs latest version of a program.

set "_programInstall=curl"

rem configure install
set "_useConfig=0" & rem 1 uses this config or select menu without `--task-run`
set "_configTool=sh configure"
set "_defaultConfig=--without-ssl --disable-shared"

rem check uri daily for version change
set "_dailyCheckInstall=1" & rem 1 (default), 0 to NOT check if url of latest.txt has changed
set "_scheduledTaskMessage=current" & rem change to value for scheduled task to check;
rem                                       here - if file is current, then do nothing
set "_checkLatestUrlInstall=https://github.com/%_programInstall%/%_programInstall%/releases/latest"
