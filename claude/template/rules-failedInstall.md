
### Failed Install Rules

- **DO** run `git commit -m "_commitMessageSetEnvironment"`
  - **DO NOT** run `git push`
- **DO** create a new branch for this task calle `_branchNameSetEnvironment`
  - **DO NOT** edit any existing `git` branches
- **DO** make edit to the file(s) `_localRepoEditFilesEnvironment`
  - **DO NOT** edit any other file(s)

### Closing Failed Install Rule

- After completion, do:

```bash
:: Change back to the root of curl-cygwin-install
cd /D "%~dp0.."
:: Give context of results to a file for scheduled script
:: NOTE - Variable `_programCurrent` is defined in `map\setConfigVar.bat`
type %_programCurrent%InstructionWork.txt | find "Pass"
if "%ERRORLEVEL%"=="0" (echo pass> "claudeResponse.txt" & echo Go to next part of this process ) else (echo fail> "%~dp0claudeResponse.txt" & echo Do nothing else, and end this process)
```

