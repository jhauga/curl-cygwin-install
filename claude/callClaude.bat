@echo off
REM callClaude
::  Run after scheduled task if "callClaude.template" exists, make prompt from template and pass to claude.

:: Debug variables
set "_debugCallClaude=0" & rem 0 (default), 1 does not call claude-code
set "_debugResetCallClaude=1" & rem 0 (default), 1 resest "callClaude.template" to `_resetCallClaude`
set "_resetCallClaude=create:failedInstall" & rem as needed, only used if `_debugCallClaude` is 1

:: Start call
cd /D "%~dp0.."

:: Ready all variables for claude code prompt
call claude\setVar.bat
call claude\setEnvironment.bat
call map\setConfigVar.bat
call :_startCallClaude
goto:eof

:_startCallClaude
 if "%_callClaude%"=="--single-point" (
  echo Single-point failure. Exiting %~n0
  scripts\removeBatchVariables.bat
  goto:eof
 )
 rem else
 type "%~dp0template\template.md" > claude\prompt.md
 if "%_createInitial%"=="1" (
  if "%_create_failedInstall%"=="1" (
   type "%~dp0template\create-failedInstall_i.md" >> claude\prompt.md
   type data\install_log.log >> claude\prompt.md
   echo ```>> claude\prompt.md
  )
  if "%_useConfigOptionCurrent%"=="1" (
   type "%~dp0template\create-useConfigOptionCurrent.md" >> claude\prompt.md
   type data\config_log.log >> claude\prompt.md
   echo ```>> claude\prompt.md
  )
  if DEFINED _installDependencies (
   type "%~dp0template\create-dependencies.md" >> claude\prompt.md
  )
  if "%_create_failedInstall%"=="1" (
   type "%~dp0template\create-goal_i.md" >> claude\prompt.md
   type "%~dp0template\create-failedInstall_ii.md" >> claude\prompt.md
   if "%_create_missingSourceLink%"=="1" (
    type "%~dp0template\create-goal_ii.md" >> claude\prompt.md
    type "%~dp0template\create-missingSourceLink.md" >> claude\prompt.md
   )
  ) else if "%_create_missingSourceLink%"=="1" (
   rem missing link and exclude config can be independent and need change
   type "%~dp0template\create-goal_ii.md" >> claude\prompt.md
   type "%~dp0template\create-missingSourceLink.md" >> claude\prompt.md
   sed -E "s/^(### Part) I{1,} (-.*)$/\1 I \2/" claude\prompt.md > claude\prompt.tmp
   move /Y claude\prompt.tmp claude\prompt.md > nul
   if "%_create_excludeConfigFlags%"=="1" (
    type "%~dp0template\create-excludeConfigFlags.md" >> claude\prompt.md
   )
  ) else (
   rem single point in setVar shoule have resolved need for else if
   type "%~dp0template\create-goal_ii.md" >> claude\prompt.md
   type "%~dp0template\create-excludeConfigFlags.md" >> claude\prompt.md
   sed -E "s/^(### Part) I{1,} (-.*)$/\1 I \2/" claude\prompt.md > claude\prompt.tmp
   move /Y claude\prompt.tmp claude\prompt.md > nul
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
    sed "s/Failed Install Rules/Exclude Config Flag Rules/g" claude\prompt.md > claude\prompt.tmp
    move /Y claude\prompt.tmp claude\prompt.md > nul
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
     sed "s/This works, but /Additionally, /" claude\prompt.md > claude\prompt.tmp
     move /Y claude\prompt.tmp claude\prompt.md > nul
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
 call :_updateTemplate 1
goto:eof

:_updateTemplate
 if "%1"=="1" (
  rem pipe one sed, each on new line avoid process overuse
  sed ^
   -e "s/_programCurrent/%_programCurrent%/g" ^
   -e "s/_osSetEnvironment/%_osSetEnvironment%/g" ^
   -e "s/_terminalSetEnvironment/%_terminalSetEnvironment%/g" ^
   -e "s/_createStepsCallClaude/%_createStepsCallClaude%/g" ^
   -e "s/_congigureCallClaude/%_congigureCallClaude%/g" ^
   -e "s;_localRepoSetEnvironment;%_localRepoSetEnvironment%;g" ^
   -e "s/_branchNameSetEnvironment/%_branchNameSetEnvironment%/g" ^
   -e "s;_localWebsiteRepoSetEnvironment;%_localWebsiteRepoSetEnvironment%;g" ^
   -e "s/_localWebsiteRepoEditFilesEnvironment/%_localWebsiteRepoEditFilesEnvironment%/g" ^
   -e "s;_siteCurrent;%_siteCurrent%;g" ^
   -e "s;_mirrorSiteDownloadLink;%_mirrorSiteDownloadLink%;g" ^
   -e "s;_uriCurrent;%_uriCurrent%;g" ^
   -e "s;_siteUriCurrent;%_siteUriCurrent%;g" ^
   -e "s/_sourceMarkerCurrent/%_sourceMarkerCurrent%/g" ^
   -e "s/_installDependencies/%_installDependencies%/g" ^
   -e "s/_commitMessageSetEnvironment/%_commitMessageSetEnvironment%/g" ^
   -e "s/_localRepoEditFilesEnvironment/%_localRepoEditFilesEnvironment%/g" ^
   -e "s/_additionalCheckConfigFlag/%_additionalCheckConfigFlag%/g" ^
   -e "s/_configOptionCurrent/%_configOptionCurrent%/g" ^
   -e "s/_localRepoNameSetEnvironment/%_localRepoNameSetEnvironment%/g" ^
   -e "s/_localRepoPathSetEnvironment/%_localRepoPathSetEnvironment%/g" ^
   -e "s/_packageDependenciesCurrent/%_packageDependenciesCurrent%/g" ^
  claude\prompt.md > claude\prompt.tmp
  move /Y claude\prompt.tmp claude\prompt.md > nul 2>nul

  if "%_debugCallClaude%"=="1" (
   echo type claude\prompt.md ^| claude --print --dangerously-skip-permissions ^> data\call-claude.log
   echo DONE:
   echo %_resetCallClaude%> "data\callClaude.template"
  ) else (
   if "%_debugResetCallClaude%"=="1" echo %_resetCallClaude%> "data\callClaude.template"
   type claude\prompt.md | claude --print --dangerously-skip-permissions > data\call-claude.log
  )
  rem ensure back in repo root after claude call
  cd /D "%~dp0.."
  if EXIST "claude/prompt.tmp" del /Q "claude/prompt.tmp" >nul 2>nul
  call scripts\removeBatchVariables.bat
 )
goto:eof
