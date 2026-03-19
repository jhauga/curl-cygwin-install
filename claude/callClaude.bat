@echo off 
REM callClaude
::  Run after scheduled task if "callClaude.txt" exists, make prompt from template and pass to claude.

:: Debug variables
set "_debugCallClaude=0" & rem 0 (default), 1 does not call claude-code
set "_debugResetCallClaude=0" & rem 9 (default), 1 resest "callClaude.txt" to `_resetCallClaude`
set "_resetCallClaude=create:failedInstall-missingSourceLink" & rem as needed, only used if `_debugCallClaude` is 1

:: Start call
cd "%~dp0.."

:: Ready all variables for claude code prompt
call claude\setVar.bat
call claude\setEnvironment.bat
call map\setConfigVar.bat
call :_startCallClaude
goto:eof

:_startCallClaude
 if "%_callClaude%"=="--single-point" (
  echo Single-point failure. Exiting %~n0
  exit /b
 )
 rem else
 type "%~dp0template\template.md" > claude\prompt.md
 if "%_createInitial%"=="1" (
  if "%_create_failedInstall%"=="1" (
   type "%~dp0template\create-failedInstall_i.md" >> claude\prompt.md
   type install_log.log >> claude\prompt.md 
   echo ```>> claude\prompt.md
  )
  if "%_useConfigOptionCurrent%"=="1" (
   type "%~dp0template\create-useConfigOptionCurrent.md" >> claude\prompt.md
   type config_log.log >> claude\prompt.md
   echo ```>> claude\prompt.md
  )
  if DEFINED _installDependencies (
   type "%~dp0template\create-dependencies.md" >> claude\prompt.md
  )  
  if "%_create_failedInstall%"=="1" (
   type "%~dp0template\create-goal_i.md" >> claude\prompt.md
   type "%~dp0template\create-failedInstall_ii.md" >> claude\prompt.md
   if "%_create_missingSourceLink%"=="1" (
    type "%~dp0template\create-missingSourceLink.md" >> claude\prompt.md
   )
  ) else if "%_create_missingSourceLink%"=="1" (
   rem missing link and exclude config can be independent and need change
   type "%~dp0template\create-goal_ii.md" >> claude\prompt.md
   type "%~dp0template\create-missingSourceLink.md" >> claude\prompt.md
   sed -i -E "s/^(### Part) I{1,} (-.*)$/\1 I \2/" claude\prompt.md
   if "%_create_excludeConfigFlags%"=="1" (
    type "%~dp0template\create-excludeConfigFlags.md" >> claude\prompt.md
   )
  ) else (
   rem single point in setVar shoule have resolved need for else if
   type "%~dp0template\create-goal_ii.md" >> claude\prompt.md
   type "%~dp0template\create-excludeConfigFlags.md" >> claude\prompt.md
   sed -i -E "s/^(### Part) I{1,} (-.*)$/\1 I \2/" claude\prompt.md   
  )
  
  echo ## Rules>> claude\prompt.md
  if "%_create_failedInstall%"=="1" (
   type "%~dp0template\rules-failedInstall.md" >> claude\prompt.md
   rem this could apply to both exclude and failed install
   if "%_create_missingSourceLink%"=="1" (
    type "%~dp0template\rules-missingSourceLink.md" >> claude\prompt.md
   )
  ) else if "%_create_missingSourceLink%"=="1" (
   type "%~dp0template\rules-missingSourceLink.md" >> claude\prompt.md
   if "%_create_excludeConfigFlags%"=="1" (
    type "%~dp0template\rules-failedInstall.md" >> claude\prompt.md
    sed -i "s/Failed Install Rules/Exclude Config Flag Rules/g" claude\prompt.md
   )
  ) else (
   type "%~dp0template\rules-failedInstall.md" >> claude\prompt.md
  )
  echo: >>claude\prompt.md
  echo ## Closing Note>> claude\prompt.md
  echo: >>claude\prompt.md
  if "%_callClaude%"=="create:failedInstall-missingSourceLink" (
   type "%~dp0template\closing-failedInstall-missingSourceLink.md" >> claude\prompt.md
  ) else if "%_callClaude%"=="create:failedInstall" (
   type "%~dp0template\closing-failedInstall.md" >> claude\prompt.md
  ) else if "%_callClaude%"=="create:missingSourceLink" (
   type "%~dp0template\closing-missingSourceLink.md" >> claude\prompt.md
  ) else (
   rem these are independent, above have own closing sentence
   if "%_create_excludeConfigFlags%"=="1" (
    type "%~dp0template\closing-excludeConfigFlags.md" >> claude\prompt.md
    if "%_create_missingSourceLink%"=="1" (
     type "%~dp0template\closing-missingSourceLink.md" >> claude\prompt.md
     sed -i "s/This works, but /Additionally, /" claude\prompt.md
    )
   ) else (
    if "%_create_missingSourceLink%"=="1" (
     type "%~dp0template\closing-missingSourceLink.md" >> claude\prompt.md
    )
   )
  )
 ) else (
  if "%_check_missingAllLinks%"=="1" (
   type "%~dp0template\check-missingAllLinks.md" >> claude\prompt.md
  )
  if "%_check_installCurrentCloseOut%"=="1" (
   type "%~dp0template\check-installCurrentCloseOut.md" >> claude\prompt.md
  )
  echo: >>claude\prompt.md
  echo ## Closing Note>> claude\prompt.md
  echo: >>claude\prompt.md
  if "%_check_missingAllLinks%"=="1" (
   type "%~dp0template\closing-missingAllLinks.md" >> claude\prompt.md
  )
  if "%_check_installCurrentCloseOut%"=="1" (
   type "%~dp0template\closing-installCurrentCloseOut.md" >> claude\prompt.md
  )
 )
 goto _updateTemplate
goto:eof

:_updateTemplate
 rem sed one at a time, keep easy to read
 sed -i "s/_programCurrent/%_programCurrent%/g" claude\prompt.md
 sed -i "s/_osSetEnvironment/%_osSetEnvironment%/g" claude\prompt.md
 sed -i "s/_terminalSetEnvironment/%_terminalSetEnvironment%/g" claude\prompt.md
 sed -i "s/_createStepsCallClaude/%_createStepsCallClaude%/g" claude\prompt.md
 sed -i "s/_congigureCallClaude/%_congigureCallClaude%/g" claude\prompt.md
 sed -i "s;_localRepoSetEnvironment;%_localRepoSetEnvironment%;g" claude\prompt.md
 sed -i "s/_branchNameSetEnvironment/%_branchNameSetEnvironment%/g" claude\prompt.md
 sed -i "s;_localWebsiteRepoSetEnvironment;%_localWebsiteRepoSetEnvironment%;g" claude\prompt.md
 sed -i "s/_localWebsiteRepoEditFilesEnvironment/%_localWebsiteRepoEditFilesEnvironment%/g" claude\prompt.md
 sed -i "s;_siteCurrent;%_siteCurrent%;g" claude\prompt.md
 sed -i "s;_mirrorSiteDownloadLink;%_mirrorSiteDownloadLink%;g" claude\prompt.md
 sed -i "s;_uriCurrent;%_uriCurrent%;g" claude\prompt.md
 sed -i "s;_siteUriCurrent;%_siteUriCurrent%;g" claude\prompt.md
 sed -i "s/_sourceMarkerCurrent/%_sourceMarkerCurrent%/g" claude\prompt.md
 sed -i "s/_installDependencies/%_installDependencies%/g" claude\prompt.md
 sed -i "s/_commitMessageSetEnvironment/%_commitMessageSetEnvironment%/g" claude\prompt.md
 sed -i "s/_localWebsiteRepoEditFilesEnvironment/%_localWebsiteRepoEditFilesEnvironment%/g" claude\prompt.md
 sed -i "s/_localRepoEditFilesEnvironment/%_localRepoEditFilesEnvironment%/g" claude\prompt.md
 sed -i "s/_additionalCheckConfigFlag/%_additionalCheckConfigFlag%/g" claude\prompt.md
 sed -i "s/_configOptionCurrent/%_configOptionCurrent%/g" claude\prompt.md

 if "%_debugCallClaude%"=="1" (
  echo claude --print --dangerously-skip-permissions ^< claude\prompt.md ^> call-claude.log
  echo DONE:
  echo %_resetCallClaude%>callClaude.txt
 ) else (
  if "%_debugResetCallClaude%"=="1" (
   echo %_resetCallClaude%>callClaude.txt
  )
  (type claude\prompt.md & echo. & echo exit) | claude --dangerously-skip-permissions
 )
goto:eof
