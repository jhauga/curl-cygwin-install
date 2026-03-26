@echo off 
REM checkLatest
:: Check latest.txt against latest redirect url.

curl -sI %_checkLatestUrlInstall% | find "Location" | sed "s/Location: //" > data\checkLatest.uri
call "%~dp0..\lib\cmdVar.bat" "type data\latest.uri" _latestRelease
call "%~dp0..\lib\cmdVar.bat" "type data\checkLatest.uri" _checkRelease
del /Q data\checkLatest.uri
