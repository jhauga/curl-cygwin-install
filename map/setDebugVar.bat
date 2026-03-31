@echo off
REM setDebug
::  Used to determine conditions for functionality testing.

:: Debug in Sandbox.
set "_debug=0"                       & rem default (0) 1 run debugging in sandbox
set "_debugStep=1"                   & rem default (1) [1-9] call step in subroutine
set "_debugRemoveDump=0"             & rem default (0) 1 deletes dump

: Debug task schedule actions.
set "_debugRunAsScheduledTask=0"     & rem 0 (default), 1 does not shutdown sandbox
set "_debugCreateLogs=1"             & rem 1 (default), 0 does not create log files

:: Debug failure actions.
set "_debugForceErrorDependencies=0" & rem 0 (default), 1 fail with dependencies
set "_debugForceErrorConfig=0"       & rem 0 (default), 1 fail at config
set "_debugForceErrorInstall=0"      & rem 0 (default), 1 fail at install
