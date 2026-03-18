
### Part II - Exclude Configure Flags

It seems that the config flags in the variable `_configOptionCurrent` from
`map\setConfigVar.bat` are no longer needed, and that the configuration used in
`map\additionalCheck.bat` can be used. The `configure` option(s) used for it:

- `_additionalCheckConfigFlag`


### Part II - Exclude Configure Flags

Make a branch in `_localRepoSetEnvironment`. Call it "_branchNameSetEnvironment". In `_branchNameSetEnvironment` we want to:

#### `git` Instructions 1

- `git checkout master`
- `git checkout -b _branchNameSetEnvironment`
- `git branch --set-upstream-to=upstream/master _branchNameSetEnvironment`
- `git merge upstream/master`

#### Edit Instructions

Then make changes to:

#### `git` Instructions 1

- `git add .`
- `git commit -m "INSTALL.md: update cygwin instructions"`

