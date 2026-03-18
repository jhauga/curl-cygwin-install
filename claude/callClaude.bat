@echo off 
REM callClaude
::  Run after scheduled task if "callClaude.txt" exists, make prompt from template and pass to claude.

:: Debug variables
set "_debugCallClaude=1" & rem 0 (default), 1 does not call claude-code

:: Start call
cd "%~dp0.."

:: Ready all variables for claude code prompt
call claude\setVar.bat
call map\setConfigVar.bat
