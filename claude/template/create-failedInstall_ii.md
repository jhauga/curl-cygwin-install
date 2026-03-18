
### Part I - Test Installation Solution

1. In `map/setConfigVar.bat` change one or more of the below variables to the value that
will resolve the failed install:

- `_packageDependenciesCurrent`
- `_configOptionCurrent`
- `_customMakeCurrent`

2. In the _osSetEnvironment _terminalSetEnvironment run:

```bash
install.bat --task-run
```

3. After running that command, set a timer

- For every 10 minutes or 600 seconds that pass, run `goto _checkIfComplete`:

```bash
:_checkIfComplete
 ls -1 sandbox ^| find "_installation_is_complete.txt"
 rem when errorlevel is 0, or the file _installation_is_complete.txt exist, go to next step
 if "%ERRORLEVEL%"=="0" ( TIMEOUT /T 5 & goto _checkIfPass & rem go to the next step or step 3 ) else ( TIMEOUT /T 600 & call :_checkIfComplete & goto:eof )
goto:eof
```

3. When the installation is complete there will be a file name `sandbox/_installation_is_completed.txt`,
when that is the case, run:

```bash
:_checkIfPass
 TASKKILL /F /FI "imagename eq WindowsSandboxServer.exe"
 TIMEOUT /T 10
 install.bat --delay
 type curlInstructionWork.txt | find "Pass"
 if "%ERRORLEVEL%"=="0" (echo pass> "%~dp0claudeResponse.txt" & echo Go to next part of this process ) else (echo fail> "%~dp0claudeResponse.txt" & echo Do nothing else, and end this process)
goto:eof
```

### Part II - Pull Request Task

Make a branch in `_localRepoSetEnvironment`. Call it "_branchNameSetEnvironment". In `_branchNameSetEnvironment` we want to:

#### `git` Instructions 1

- `git checkout master`
- `git checkout -b _branchNameSetEnvironment`
- `git branch --set-upstream-to=upstream/master _branchNameSetEnvironment`
- `git merge upstream/master`

#### Edit Instructions

Then make changes to:

- `docs/INSTALL.md` with the bare minimum solution used to resolve the failed install from **Part I**.

#### `git` Instructions 2

- `git add .`
- `git commit -m "INSTALL.md: update cygwin instructions"`

