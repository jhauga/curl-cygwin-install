@echo off 
REM checkLatest
:: Check latest.txt against latest redirect url.

curl -sI %_checkLatestUrlInstall% | find "Location" | sed "s/Location: //" > checkLatest.txt
call cmdVar "type latest.txt" _latestRelease
call cmdVar "type checkLatest.txt" _checkRelease
del /Q checkLatest.txt
