@echo off
REM claudeContext
::  Create YAML file for context for claude-code call.

:: Set the debug variables
if NOT DEFINED _debug (
 rem use map debug variables
 call "%~dp0..map\setDebugVar.bat"
 "%~dp0%~n0.bat"
) else (
echo program:%_programCurrent%
echo site:%_siteCurrent%
echo download_root:%_uriCurrent%
echo download_path:%_siteUriCurrent%
echo extact_download-uri:
echo   command: "%_extractInstallUriCurrent%"
echo install_dependencies:
if "%_debugForceErrorDependencies%"=="0" (
echo   command:setup-x86_64.exe %_packageDependenciesCurrent%
) else (
echo   command:setup-x86_64.exe %_forceErrorPackageDependenciesCurrent%
)
if "%_useConfigOptionCurrent%"=="1" (
if "%"_debugForceErrorConfig%"=="0" (
echo configure_call:"%_configOptionCurrent%"
) else (
echo configure_call:"%_forceErrorConfigOptionCurrent%"
)
)
if "%"_debugForceErrorInstall%"=="0" (
if "%_useCustomMakeCurrent%"=="0" (
echo make_call:make
) else (
echo make_call:"%_useCustomMakeCurrent%"
)
) else (
if "%_useForceErrorCustomMakeCurrent%"=="0" (
echo make_call:make
) else (
echo make_call:"%_forceErrorCustomMakeCurrent%"
)
)
echo test_install:
echo   command:%_runTestCommandCurrent%
echo   calls:
echo     - name:A
echo       command: '%_runTestCommandCurrentA%'
echo     - name:B
echo       command: '%_runTestCommandCurrentB%'
echo     - name:C
echo       command: '%_runTestCommandCurrentC%'
echo     - name:D
echo       command: '%_runTestCommandCurrentD%'
echo     - name:E
echo       command: '%_runTestCommandCurrentE%'
echo     - name:F
echo       command: '%_runTestCommandCurrentF%'
echo   log_to_file: "%_runTestCommandCurrent_INSTALL_CHECK%"
)