@echo off
:: linkCheck
:: Called if the regular expression to download source curl gets a 404.
::
::  - debug-mode
::  - Check that 404 is registreing, and then i.e. call-claude-code
::  - by purposely switching the downloadUrlPath to not get download link.

set "_debugLinkCheck=0" & rem 0 (default), 1 run debug mode

rem NOTE - `_uriCurrent` is set in `current.bat` like:
rem set "_uriCurrent=https://mirrors.kernel.org/sources.redhat.com/cygwin"
rem set "_siteUriCurrent=%_uriCurrent%/x86_64/release/curl"

if "%_debugLinkCheck%"=="0" (
 set "_downloadUrlPathLinkCheck=%_uriCurrent%/src/release/%_programCurrent%/"
) else (
 set "_downloadUrlPathLinkCheck=%_siteUriCurrent%"
)
call :_linkUpdateCheck A 1a
goto:eof

:_linkUpdateCheck
 if /i "%1"=="A" (
  if "%2"=="1a" (
   curl -s %_downloadUrlPathLinkCheck% | findstr /R "%_programCurrent%-[0-9].*src.tar.xz" > checkSrcDownloads.txt
   type checkSrcDownloads.txt | findstr /R "%_programCurrent%-[0-9]+"
   call :_linkUpdateCheck --error-check A 1b & goto:eof
  )
  if "%2"=="1b" (
   type checkSrcDownloads.txt | findstr /R "%_programCurrent%-[0-9]+" | head -n 1 | sed -E "s/^<a href=.(.{1,}).>[a-z]+.*$/\1/" > srcDownloads.txt
   find /c /v "" srcDownloads.txt | sed -E -e "s/\-{1,} //" -E -e "s/^[a-zA-Z\.:]+ //" > countLines.txt
   call "%_cmdVar%" "type countLines.txt" _countLinesLinkCheck
   call :_linkUpdateCheck --constant 1 A & goto:eof
  )
 )
 if /i "%1"=="B" (
  if "%2"=="1" (
   curl -s %_downloadUrlPathLinkCheck% | findstr /R "%_programCurrent%-[0-9].*src.tar.xz" | sed -E "s/^<a href=.(.{1,}).>[a-z]+.*$/\1/" > srcDownloads.txt
   find /c /v "" srcDownloads.txt | sed -E -e "s/\-{1,} //" -E -e "s/^[a-zA-Z\.:]+ //" > countLines.txt
   call "%_cmdVar%" "type countLines.txt" _countLinesLinkCheck
   call :_linkUpdateCheck --constant 1 B & goto:eof
  )
 )
 if "%1"=="--constant" (
  if "%2"=="1" (
   set /A "_countLinesLinkCheck=%_countLinesLinkCheck% - 1"
   call :_linkUpdateCheck --constant 2 %3 & goto:eof
  )
  if "%2"=="2" (
   if "%_countLinesLinkCheck%"=="-1" (
    call :_linkUpdateCheck --constant constant-error-check %3 & goto:eof
   ) else if "%_countLinesLinkCheck%"=="0" (
    call "%_cmdVar%" "type srcDownloads.txt" _downloadUrlDownloadLinkCheck
   ) else (
    type srcDownloads.txt | sed 1,%_countLinesLinkCheck%d > downloadUrlDownloadLinkCheck.txt
    call "%_cmdVar%" "type downloadUrlDownloadLinkCheck.txt" _downloadUrlDownloadLinkCheck
   )
   call :_linkUpdateCheck --constant 3 %3 & goto:eof
  )
  if "%2"=="3" (
   set "_downloadUrlDownloadLinkCheck=%_downloadUrlPathLinkCheck%%_downloadUrlDownloadLinkCheck%"
   call :_linkUpdateCheck --constant 4 %3 & goto:eof
  )
  if "%2"=="4" (
   curl -sI %_downloadUrlDownloadLinkCheck% | sed -n "s/^HTTP[^ ]* \([0-9][0-9][0-9]\).*/\1/p" > statusLinkCheck.txt
   call "%_cmdVar%" "type statusLinkCheck.txt" _statusLinkCheck
   call :_linkUpdateCheck --constant 5 %3 & goto:eof
  )
  if "%2"=="5" (
   if "%_statusLinkCheck%"=="404" (
    call :_linkUpdateCheck --constant constant-error-check %3 & goto:eof
   ) else (
    rem ensure `_firstCallCurrent` is undefined
    echo -------------------------------------------------------------------------------------------
    echo:
    echo %_downloadUrlDownloadLinkCheck%
    echo:
    echo -------------------------------------------------------------------------------------------
    echo -------------------------------------------------------------------------------------------
    set _firstCallCurrent=
    set "_current=%_downloadUrlDownloadLinkCheck%"
    call "%~dp0current.bat" ":_current_cygwin" 2
    goto _removeBatchVariablesLinkCheck
   )
  )
  if "%2"=="constant-error-check" (
   if /i "%3"=="a" (
    call :_linkUpdateCheck --set-b & goto:eof
   ) else (
    rem UPDATE NEEDED
    call :_linkUpdateCheck --call-claude & goto:eof
   )
  )
 )
 if "%1"=="--error-check" (
  if "%ERRORLEVEL%"=="0" (
   call :_linkUpdateCheck %2 %3  & goto:eof
  ) else (
   call :_linkUpdateCheck --set-b & goto:eof
  )
 )
 if "%1"=="--set-b" (
  if "%_debugLinkCheck%"=="1" (
   set "_downloadUrlPathLinkCheck=%_siteUriCurrent%"
  ) else (
   set "_downloadUrlPathLinkCheck=%_uriCurrent%/src/release/%_programCurrent%/"
  )
  call :_linkUpdateCheck B 1 & goto:eof
 )
 if "%1"=="--call-claude" (
  call "%~dp0current.bat" --close-out "check:missingAllLinks"
  goto _removeBatchVariablesLinkCheck
 )
goto:eof

:_removeBatchVariablesLinkCheck
 set _countLinesLinkCheck=
 set _downloadUrlDownloadLinkCheck=
 set _downloadUrlPathLinkCheck=
 set _downloadUrlPathReleaseLinkCheck=
 set _statusLinkCheck=
goto:eof
