
### Part I - Test Installation Solution

1. In `map/setConfigVar.bat` change one or more of the below variables to the value that
will resolve the failed install:

- `_packageDependenciesCurrent`
- `_configOptionCurrent`
- `_customMakeCurrent`

2. In the _osSetEnvironment _terminalSetEnvironment run:

```batch
:: Ensure that we are ont the current "_localRepoNameSetEnvironment" folder
cd /D "%_localRepoPathSetEnvironment%"
call install.bat --task-run
```

3. After running that command, wait and verify the proposed resolution worked on the Sandbox build

  - When the installation is complete there will be a file named `sandbox/_installation_is_completed.txt`,
 when that is the case, run:

```batch
:: Ensure that we are ont the current "_localRepoNameSetEnvironment" folder
cd /D "%_localRepoPathSetEnvironment%"
call install.bat --delay
```

### Proceed Upon Condition

If there has been a **major** version change i.e. from 1.0.0 to 2.0.0, and the below **quasi-code condition** is true, then continue **this**.process; else do nothing, and continue to next process if next process exist.

#### Quasi-Code Condition

```code
rem first make sure that the Sandbox install has completed.
if EXIST `_localRepoNameSetEnvironment/_programCurrentInstructionWork.txt` (
 if `${cat "_localRepoNameSetEnvironment/_programCurrentInstructionWork.txt"}`=="Pass" (
  rem ensure that we are ont the current "_localRepoNameSetEnvironment" folder
  cd /D "%_localRepoPathSetEnvironment%"
  git add .

  rem now make sure that a major version change has occurred before deterimining how to procede
  if "major version change"=="true" (
   rem now see why install failed
   "@_localRepoPathSetEnvironment\\data\\install_log.log" | {
    rem if the installation failed because of a new dependency
    set _currentDependencies="_packageDependenciesCurrent"
    
    rem remove all options from the value
    set _currentDependencies=%_currentDependencies%.replace(/-[\-a-zA-Z]+/, ""); & rem value should now be formatted like `binutils,gcc-core,libpsl-devel,libtool,perl,make`
    rem if an error like this occurs:
    if ("install_log.log".indexOf("../libtool: eval: line 1890: syntax error near unexpected token `|'") > -1) (
     echo Buggy install.
     call :_checkNextProcess --pass & goto:eof
    ) else (
     rem check error message to see if a new dependency was added
     rem if make error like:
       :: make: *** No rule to make target 'path/to/dependency.h', needed by 'object.o'. Stop.
     rem or make error like:
       :: fatal error: someheader.h: No such file or directory
       :: compilation terminated.
       :: make: *** [Makefile:10: object.o] Error 1
     rem or cmake error like:
       :: CMake Error at /usr/share/cmake-4.2.1/Modules/FindPackageHandleStandardArgs.cmake:290 (message):
       ::   Could NOT find ZLIB (missing: ZLIB_LIBRARY ZLIB_INCLUDE_DIR)
      if ("install_log.log".indexOf(`a common missing dependency error`) > -1) (
       call :_continueThisProcess & goto:eof
      ) else (
       if ("install_log.log".indexOf(`a COMPLETELY new install step was introduced for _programCurrent in new major version release`) > -1 ||
           "config_log.log".indexOf(`a COMPLETELY new configuration step was introduced _programCurrent in new major version release`) > -1) (
       call :_continueThisProcess & goto:eof
       ) else (
       echo Buggy install.
       call :_checkNextProcess --pass & goto:eof
      )
     )
    )
   }
  ) else (
   echo No major version change.
   call :_checkNextProcess --pass & goto:eof
  )
 ) else (
  echo Proposed changes failed.
  call :_checkNextProcess --fail & goto:eof
 )
) else (
 echo Something unexpected happened.
 call :_checkNextProcess --fail & goto:eof
)

:_continueThisProcess
 git commit -m "claude: resolve new majore version failed install"
 goto next(`### Part II - Pull Request Task`)
goto:eof

:_checkNextProcess
 rem only commit if proposed install fix passed
 if "%1"=="--pass" git commit -m "claude: patch failed install"
 if EXIST `## Missing Source Link Process` (
  echo Conitinuing to next process.
  goto next(`# GOAL`)
 ) else (
  echo No further process. Closing process.
  goto end(`### Closing Failed Install Rule`)
  rem do nothing. close call
 )
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

- `_localRepoEditFilesEnvironment` with the bare minimum proposed error resolution in the Cygwin portion of `_localRepoEditFilesEnvironment`
  = Add a list item at the end of the Cygwin install section with the proposed solution to resolve the failed install from **Part I**.

#### `git` Instructions 2

- `git add .`
- `git commit -m "_commitMessageSetEnvironment"`

