@echo off
REM setVar
::  When used with claude-code

:: Debug variables, use to force set all claude variables.
:: Debug values for `_debugCallClaude`
::  create:failedInstall-missingSourceLink
::  create:failedInstall
::  create:missingSourceLink
::  check:missingAllLinks
::  check:installCurrentCloseOut
set "_debugSetVar=0" & rem 0 (default), 1 sets debug mode
set "_debug_callClaude=check:missingAllLinks" & rem as needed, requires _debugSetVar be 1
set "_debug__createStepsCallClaude=1" & rem 0 or 1; as needed, requires _debugSetVar be 1
set "_debug_create=0" & rem 0 or 1; as needed, requires _debugSetVar be 1
set "_debug_check=1" & rem 0 or 1; as needed, requires _debugSetVar be 1
set "_debug_create_failedInstall=0" & rem as needed, requires _debugSetVar be 1
set "_debug_create_missingSourceLink=0" & rem as needed, requires _debugSetVar be 1
set "_debug_create_excludeConfigFlags=1" & rem as needed, requires _debugSetVar be 1
set "_debug_check_missingAllLinks=1" & rem as needed, requires _debugSetVar be 1
set "_debug_check_installCurrentCloseOut=1" & rem as needed, requires _debugSetVar be 1

if "%_debugSetVar%"=="1" (
 call :_setDebugVar 1
) else (
 if EXIST "data\mirrorSiteDownloadLink.uri" (
  call lib\cmdVar.bat "type data\mirrorSiteDownloadLink.uri" _mirrorSiteDownloadLink
 )
 if EXIST "data\callClaude.template" (
  call lib\cmdVar.bat "type data\callClaude.template" _callClaude
  type data\callClaude.template | find "create:" >nul 2>nul
  call :_errorCheck 1 create initial
 ) else (
  call :_errorCheck --single-point & goto:eof
 )
 if EXIST "data\claude-context.yaml" (
  call lib\cmdVar.bat "yq ".configure_call" data\claude-context.yaml" _congigureCallClaude
  call lib\cmdVar.bat "yq ".install_dependencies.command" data\claude-context.yaml" _installDependencies
 ) else (
  call :_errorCheck --single-point & goto:eof
 )
 set _preVar=
 set _varName=
)
goto:eof

:_errorCheck
 if "%1"=="1" (
  set "_preVar=%2"
  set "_varName=%3"
  if "%2"=="create" (
   if "%ERRORLEVEL%"=="0" (
    call :_errorCheck 2 %2 %3 1 & goto:eof
   ) else (
    call :_errorCheck 2 %2 %3 0 & goto:eof
   )
  ) else if "%2"=="check" (
   if "%ERRORLEVEL%"=="0" (
    call :_errorCheck 2 %2 %3 1 & goto:eof
   ) else (
    call :_errorCheck 2 %2 %3 0 & goto:eof
   )
  ) else (
   call :_errorCheck --single-point & goto:eof
  )
 )
 if "%1"=="2" (
  if "%3"=="initial" (
   set "_%_preVar%Initial=%4"
   if "%4"=="1" (
    sed -i "s/%2://" data\callClaude.template
    if "%2"=="create" (
     rem specify the next by raw data
     type data\callClaude.template | find "failedInstall" >nul 2>nul
     call :_errorCheck 1 %2 failedInstall & goto:eof
    ) else (
     rem specify the next by raw data
     type data\callClaude.template | find "missingAllLinks" >nul 2>nul
     call :_errorCheck 1 %2 missingAllLinks & goto:eof
    )
   ) else (
    if "%2"=="check" (
     call :_errorCheck --single-point & goto:eof
    ) else (
     rem run check sequence
     type data\callClaude.template | find "check:" >nul 2>nul
     call :_errorCheck 1 check initial & goto:eof
    )
   )
  ) else (
   set "_%_preVar%_%_varName%=%4"
   if "%3"=="failedInstall" (
    type data\callClaude.template | find "missingSourceLink" >nul 2>nul
    call :_errorCheck 1 %2 missingSourceLink & goto:eof
   ) else if "%3"=="missingSourceLink" (
    type data\callClaude.template | find "excludeConfigFlags" >nul 2>nul
    call :_errorCheck 1 %2 excludeConfigFlags & goto:eof
   ) else if "%3"=="excludeConfigFlags" (
    if "%_create_failedInstall%"=="1" (
     if "%_create_missingSourceLink%"=="1" (
      set "_createStepsCallClaude=3"
     ) else (
      set "_createStepsCallClaude=2"
     )
    ) else (
     if "%_create_missingSourceLink%"=="1" (
      if "%_creaate_excludeConfigFlags%"=="1" (
       set "_createStepsCallClaude=2"
      ) else (
       set "_createStepsCallClaude=1"
      )
     ) else (
      if "%_creaate_excludeConfigFlags%"=="1" (
       set "_createStepsCallClaude=1"
      ) else (
       call :_errorCheck --single-point & goto:eof
      )
     )
    )
   ) else if "%3"=="missingAllLinks" (
    type data\callClaude.template | find "installCurrentCloseOut" >nul 2>nul
    call :_errorCheck 1 %2 installCurrentCloseOut & goto:eof
   ) else if "%3"=="installCurrentCloseOut" (
    if "%_check_missingAllLinks%"=="1" (
     set "_createStepsCallClaude=1"
    ) else if "%_check_installCurrentCloseOut"=="1" (
     set "_createStepsCallClaude=1"
    ) else (
     call :_errorCheck --single-point & goto:eof
    )
   ) else (
    call :_errorCheck --single-point & goto:eof
   )
  ) 
 )
 if "%1"=="--single-point" (
  echo %1> data\callClaude.template
  call lib\cmdVar.bat "type data\callClaude.template" _callClaude
 )
goto:eof

:_setDebugVar
 if "%1"=="1" (
  set "_callClaude=%_debug_callClaude%"
  set "_createStepsCallClaude=%_debug__createStepsCallClaude%"
  if "%_debug_create%"=="1" (
   set "_createInitial=1"
   set "_checkInitial=0"
   set "_create_failedInstall=%_debug_create_failedInstall%"
   set "_create_missingSourceLink=%_debug_create_missingSourceLink%"
   set "_create_excludeConfigFlags=%_debug_create_excludeConfigFlags%"
  ) else (
   set "_createInitial=0"
   set "_checkInitial=1"
   set "_check_missingAllLinks=%_debug_check_missingAllLinks%"
   set "_check_installCurrentCloseOut=%_debug_check_installCurrentCloseOut%"
  )
 )
goto:eof