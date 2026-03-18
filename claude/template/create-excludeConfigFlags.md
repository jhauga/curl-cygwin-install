It seems that the config flags in the variable `_configOptionCurrent` from
`map\setConfigVar.bat` are no longer needed, and that the configuration used in
`map\additionalCheck.bat` can be used. So for this we want to achive this
process in _createStepsCallClaude part:

## Part I

Make a branch in `_localRepoSetEnvironment`. Call it "_branchNameSetEnvironment". In `_branchNameSetEnvironment` we want to:

#### `git` Instructions

- `git checkout -b _branchNameSetEnvironment`
- `git fetch upstream/master`
- `git merge upstream/master`

Then make changes to:

- `docs/INSTALL.md` excluding the need to add the additonal configuration options
