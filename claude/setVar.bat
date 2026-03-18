@echo off
REM setVar
::  When used with claude-code

if EXIST "mirrorSiteDownloadLink.txt" (
 call cmdVar.bat "type mirrorSiteDownloadLink.txt" _mirrorSiteDownloadLink
)
if EXIST "callClaude.txt" (
 call cmdVar.bat "type callClaude.txt" _callClaude
 type callClaude.txt | find "create:" >nul 2>nul
 call :_errorCheck 1 create initial
) else (
 call :_errorCheck --single-point & goto:eof
)
if EXIST "claude-context.yaml" (
 call cmdVar.bat "yq ".configure_call" claude-context.yaml" _congigureCallClaude
 call cmdVar.bat "yq ".install_dependencies.command" claude-context.yaml" _installDependencies
) else (
 call :_errorCheck --single-point & goto:eof
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
    sed -i "s/%2://" callClaude.txt
    if "%2"=="create" (
     rem specify the next by raw data
     type callClaude.txt | find "failedInstall" >nul 2>nul
     call :_errorCheck 1 %2 failedInstall & goto:eof
    ) else (
     rem specify the next by raw data
     type callClaude.txt | find "missingAllLinks" >nul 2>nul
     call :_errorCheck 1 %2 missingAllLinks & goto:eof
    )
   ) else (
    rem run check sequence
    type callClaude.txt | find "check:" >nul 2>nul
    call :_errorCheck 1 check initial & goto:eof
   )
  ) else (
   set "_%_preVar%_%_varName%=%4"
   if "%3"=="failedInstall" (
    type callClaude.txt | find "missingSourceLink" >nul 2>nul
    call :_errorCheck 1 %2 missingSourceLink & goto:eof
   ) else if "%3"=="missingSourceLink" (
    type callClaude.txt | find "excludeConfigFlags" >nul 2>nul
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
      set "_createStepsCallClaude=1"
     ) else (
      if "%_creaate_excludeConfigFlags%"=="1" (
       set "_createStepsCallClaude=1"
      ) else (
       call :_errorCheck --single-point & goto:eof
      )
     )
    )
   ) else if "%3"=="missingAllLinks" (
    type callClaude.txt | find "installCurrentCloseOut" >nul 2>nul
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
  echo check:installCurrentCloseOut> callClaude.txt
  call cmdVar.bat "type callClaude.txt" _callClaude
 )
goto:eof
