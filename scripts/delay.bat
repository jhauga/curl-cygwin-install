@echo off
REM delay
::  Script for second call to `install.bat` with `--delay` for when tool is used in a schedulted task.

call "%~dp0claudeContext.bat" > data\claude-context.yaml
sed -i "s/'/ --q-- /g" data\claude-context.yaml
sed -i -E -e "s/^(.{1,}:) .(.*).$/\1 \2/" -E -e "s;^( {0,}[a-zA-Z]+:)(.);\1 \2;" -E -e "s/^( {1,}- [a-zA-Z]+:)(.)/\1 \2/" -E -e "s/^([a-zA-Z_]+:)(.)/\1 \2/" -E -e "s/([a-zA-Z_]+:) {2,}(.)/\1 \2/" data\claude-context.yaml
sed -i -e "s/--q--/'/g" -e "s/ '/'/g" -e "s/' / '/g" data\claude-context.yaml
