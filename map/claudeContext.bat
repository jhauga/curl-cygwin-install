@echo off
REM claudeContext
::  Create YAML file for context for claude-code call.

echo program:%_programCurrent%
echo site:%_siteCurrent%
echo download-root:%_uriCurrent%
echo download-path:%_siteUriCurrent%
echo extact-download-uri:
echo   command: "%_extractInstallUriCurrent%"
echo install-dependencies:
echo   command:setup-x86_64.exe %_packageDependenciesCurrent%
echo test-install:
echo   command:%_runTestCommandCurrent%
echo   calls:
echo     - name:A
echo       command:%_runTestCommandCurrentA%
echo     - name:B
echo       command:%_runTestCommandCurrentB%
echo     - name:C
echo       command:%_runTestCommandCurrentC%
echo     - name:D
echo       command:%_runTestCommandCurrentD%
echo     - name:E
echo       command:%_runTestCommandCurrentE%
echo     - name:F
echo       command:%_runTestCommandCurrentF%
echo     - log-to-file: "%_runTestCommandCurrent_INSTALL_CHECK%"
if "%_useConfigOptionCurrent%"=="1" (
echo configure-call:sh configure %_configOptionCurrent%
)
if "%_useCustomMakeCurrent%"=="1" (
echo make-call:%_useCustomMakeCurrent%
) else (
echo make-call:make
)
