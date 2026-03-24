# curl-cygwin-install

Automated tool that builds and tests `curl` from source inside a [**Windows Sandbox**](https://learn.microsoft.com/en-us/windows/security/application-security/application-isolation/windows-sandbox/windows-sandbox-overview) using [**Cygwin**](https://www.cygwin.com/). Designed to verify that the Cygwin installation instructions on [curl.se](https://curl.se/download.html) produce a working build. Can be run manually or as a scheduled task with automated error resolution via Claude Code.

Support repository for:

- `curl` pull request [#17485](https://github.com/curl/curl/pull/17485)
- `curl` pull request [#20995](https://github.com/curl/curl/pull/20995)


This may **possibly** be edited to run and check different [**Cygwin**](https://www.cygwin.com/) program installations. To do so see [specify installation to check](#specify-installation-to-check).

## Prerequisites

- Windows 10/11 with **Windows Sandbox** feature enabled in `Turn Windows features on or off`

## Instructions for Use

### Automating Run

This task is designed to be run in 3 scheduled increments:

- `install.bat --task-run`
  - Handled in this repo
  - Check install and `curl.se` download link is up-to-date
- `install.bat --delay`
  - Handled in this repo
  - Get the results of the install and status of `curl.se` download link
- `check-results-script`
  - Handled in an external script
  - Use Examples:
    - If the install failed, then use:
      - `config_log.log` to check for clues
      - `install_log.log` to check for clues
    - If the install passed, then good:
      - Do nothing
      - Send a personal notification that the script ran

#### Automating Instructions

1. Clone or download repo:

```bash
git clone https://github.com/jhauga/curl-cygwin-install.git
```

2. Set scheduled script to `curl-cygwin-install\install.bat`, and pass
parameter in configuration `--task-run`.
   - **IMPORTANT** - if `--task-run` is not passed the process will pause
3. Set a delayed scheduled script for an hour later to `curl-cygwin-install\install.bat`,
and pass parameter in configuration `--delay`.
   - **IMPORTANT** - if `--delay` is not passed the process will pause

After the delayed task is run the `sandbox` folder will be deleted, and the
file `curlInstructionWork.txt` (*or %_programCurrent%InstructionWork.txt*) will
be placed from `sandbox` folder, or created; if the process failed altogether.
It will simply say if the install was a "Pass", or a "Fail".

#### Automated Install Error Resolution

In a scheduled task add `call claude\callClaude.bat` at the end to have Claude code look into the error relative to the error context after `install --delay` has been run.

> [!NOTE]
> Ensure `claude\setEnvironment.bat` have been updated accordingly.

##### Last Line of Scheduled Script

```bash
call claude\callClaude.bat
```

### Manual Run

1. Clone or download repo:

```bash
git clone https://github.com/jhauga/curl-cygwin-install.git
```

2. Open or navigate to `curl-cygwin-install`, and run or double click
`install.bat`, then read prompt instruction.
3. The process should begin automatically in the Sandbox window.
4. The process will take close to 15 minutes to complete, and consists of:
   - Install `winget`
   - Use `winget` to install `cygwin`
   - Install the dependencies using `cygwin` setup file
   - Download the compressed `curl` or specified program for the `cygwin` install
   - Configure the build (`sh configure` or `cmake` depending on configuration)
   - Build the program (`make` or `ninja` depending on configuration)
5. Some `curl` or specified program test commands run once the install is complete.
   - You'll be asked "What happened?" followed by a pause when the install
  is done

After the installation is complete temporary files are cleared, leaving the
install folder of curl in the Sandbox folder where this tool was mapped to.
Delete/keep files after install test as needed.

### Bare Run

Just the essential copy/paste snippets. Just complete step **I** and **II**, then any `cygwin` program's installation can be tested.

#### I. Install `winget`

```bash
$progressPreference = 'silentlyContinue'
Write-Host "Installing WinGet PowerShell module from PSGallery..."
Install-PackageProvider -Name NuGet -Force | Out-Null
Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery | Out-Null
Write-Host "Using Repair-WinGetPackageManager cmdlet to bootstrap WinGet..."
Repair-WinGetPackageManager
Write-Host "Done."
```

#### II. Install `cygwin`

```bash
winget install cygwin.cygwin --source winget
curl https://www.cygwin.com/setup-x86_64.exe -o "C:\cygwin64\bin\setup-x86_64"
set PATH=%PATH%;C:\cygwin64\bin\
```
> [!NOTE]
> You can ignore these if manually testing another install

#### III. Install Dependencies

> [!NOTE]
> Option B **Using `ninja`** is recommended as it is MUCH faster.

**i. Option A - Using `make`**

```bash
# This guarantees all dependencies are downloaded if using `make` to install
setup-x86_64 --no-admin -q -I --build-depends curl

# If dependencies are known, then run like this
setup-x86_64 --no-admin -q -I -P binutils,gcc-core,libpsl-devel,libtool,perl,make
```

**ii. Option B - Using `ninja`**

```bash
setup-x86_64 --no-admin -q -I -P binutils,cmake,gcc-core,libpsl-devel,libtool,ninja,perl,libssl-devel,zlib-devel
```

#### IV. Install Program `curl`

> [!NOTE]
> Mind version numbering.

**Download and Extract Source**

```bash
mkdir dump & cd dump
curl https://mirrors.kernel.org/sources.redhat.com/cygwin/src/release/curl/curl-8.19.0-1-src.tar.xz -o src.tar.xz
tar -xJf src.tar.xz & rm src.tar.xz
move curl* tmp
move tmp\curl-*.tar.xz curl.tar.xz
tar -xJf curl.tar.xz & rm curl.tar.xz
move curl* ..\curl
rm -rf tmp
cd ..\curl
```

**ii. Option A - Using `make`**

```bash
sh configure --without-ssl --disable-shared
make
```

**ii. Option B - Using `ninja`**

```bash
cmake . -G Ninja -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF
ninja
```

## Specify Installation to Check

> [!NOTE]
> You should have a **VERY** solid understanding of Windows batch scripts before configuring this repository to check the installation status of another Cygwin program.

To do so edit the following:

- **`install.bat`**
  - Change `_programInstall` to program name
  - Change `_useConfig` to 1 if the program requires a configuration like `sh configure`; call before `make`
    - **NOTE** - mainly set configuration here if you want to use menu selection from `config-options.txt`
    - **NOTE** - this will change the configuration in `map\setConfigVar.bat` config variables
    - Set to 0 if `map\setConfigVar.bat` configuration is to be used
  - Change `_configTool` to the name of the configuration tool e.g. `sh configure`, `cmake`, etc...
  - Change `_defaultConfig` to full configuration call with options to use for the installation
  - Change `_dailyCheckInstall` to 1 if checking URL for latest release
    - This allows task to be run on a daily schedule
  - Change `_checkLatestUrlInstall` to the URL to check for latest release
- **`config-options.txt`**
  - Change to viable configuration options if the install use a configure call
- **`map\setConfigVar.bat`**
  - Change `_programCurrent` to program name
  - Change `_siteCurrent` to the URL where instructions are
  - Change `_uriCurrent` to the URI of the main path where download files are
  - Change `_extractInstallUriCurrent` to command to extract download URL
    - Around line 50 edit pipe as needed, below the comment is `rem CONFIG-EDIT--_extractInstallUriCurrent--CALL`
  - Change `_siteUriCurrent` to the URL that the site with instructions points download to
  - Change `_sourceMarkerCurrent` to the ending characters and extension of source code download i.e. `src.tar.xz`
  - Change `_extractInstallUriCurrent` to the command that will get the download link from site
  - Change `_packageDependenciesCurrent` to installation dependencies
  - Change `_forceErrorPackageDependenciesCurrent` to some dependencies (*to debug on-fail*)
  - Change `_runAdditionalCheck` to 1 to run additional test, using `map\additionalCheck.bat`
    - **NOTE** - `map\additionalCheck.bat` is completely as needed
  - **TEST COMMANDS**
    - Change `_runTestCommandCurrent` to the test command, or path to test command to use with the below configured variables e.g. `src\curl`
      - Change `_runTestCommandCurrentA` to `%_runTestCommandCurrent% --option` e.g. `%_runTestCommandCurrent% --help`
      - Change `_runTestCommandCurrentB` to `%_runTestCommandCurrent% --option`
      - Change `_runTestCommandCurrent...` to `%_runTestCommandCurrent% --option`
      - Change `_runTestCommandCurrent_INSTALL_CHECK` to command to output something for automation script
  - **Optional**
    - If any configuration is needed then change `_useConfigOptionCurrent` to 1
      - **NOTE** - if `_useConfig` in `install.bat` is 1, then this will be changed from that
      - **NOTE** - you'll probably want to check the config call in `map\setConfigVar.bat`
      - Change `_configOptionCurrent` to configuration options
        - **NOTE** - set to `_none_used_` if only `sh configure` is used
    - Set `_useCustomMakeCurrent` to 1 if using anything other than `make` to install program
    - Change `_customMakeCurrent` to custom `make` call
      - Set `_useForceErrorCustomMakeCurrent` to 1 for debug make call
      - Change `_forceErrorCustomMakeCurrent` to a debug `make` call

## Project Layout

Overview of the repository structure, the purpose of each folder, and description of each file.

### Root Files

| File | Purpose |
|------|---------|
| `install.bat` | Main entry point. Orchestrates the full installation check process inside a Windows Sandbox. Accepts `--task-run` and `--delay` parameters for scheduled automation. |
| `task.bat` | Opens the VS Code workspace for this project. |
| `zipFilesCall.bat` | Utility to zip files for backup or distribution. |
| `StartSandbox.wsb` | Windows Sandbox configuration with a template `_PATH_` placeholder for the mapped folder. Used by `install.bat` to generate a sandbox. |
| `runStartSandbox.wsb` | Windows Sandbox configuration with a hardcoded mapped folder path. Runs `runInstall.bat` on sandbox logon. |
| `config-options.txt` | Menu of `configure` SSL/TLS options (e.g. `--with-openssl`, `--without-ssl`) selectable during install. |
| `_dump.txt` | Scratch/log file for recording troubleshooting notes. |
| `README.md` | This file. |

### `map/`

Core installation logic that runs **inside** the Windows Sandbox.

| File | Purpose |
|------|---------|
| `runInstall.bat` | Sandbox entry point. Installs `winget`, then `cygwin`, sets the PATH, and calls `current.bat` to build the program. Collects pass/fail results. |
| `current.bat` | Drives the actual build steps for the current program: downloads dependencies, extracts source, runs configure/cmake, runs make/ninja, and executes test commands. |
| `setConfigVar.bat` | Defines all configuration variables for the program being checked — download URLs, dependencies, test commands, configure/make options, and debug overrides. |
| `setDebugVar.bat` | Debug toggle variables that control sandbox behavior: force dependency/config/install failures, skip shutdown, enable/disable logging. |
| `linkCheck.bat` | Checks if the Cygwin mirror download path returns a valid source link. Detects 404s that indicate an outdated or missing package version. |
| `additionalCheck.bat` | Optional post-install script. Rebuilds with alternate config flags to test if certain options (e.g. `--without-ssl`) can be excluded. |
| `install-winget.ps1` | PowerShell script that bootstraps `winget` via the NuGet provider and `Microsoft.WinGet.Client` module. |
| `install_check.txt` | Output file written by test commands. Used to determine if the install passed or failed. |

### `scripts/`

Helper scripts called by the main process.

| File | Purpose |
|------|---------|
| `checkLatest.bat` | Compares `data\latest.uri` against the GitHub releases redirect URL to detect new versions. |
| `delay.bat` | Called with `install.bat --delay`. Generates the `data\claude-context.yaml` file from `claudeContext.bat` output and sanitizes it with `sed`. |
| `claudeContext.bat` | Outputs a YAML-formatted summary of the current installation context (program, URLs, dependencies, configure call, make call, test commands). |

### `claude/`

Automated error resolution via Claude Code, triggered after a scheduled install run.

| File | Purpose |
|------|---------|
| `callClaude.bat` | Main Claude integration script. Reads `callClaude.template` to determine what action is needed, assembles `prompt.md` from template fragments, performs variable substitution with `sed`, and invokes Claude Code. |
| `setVar.bat` | Parses `callClaude.template` and `claude-context.yaml` to set variables that control which prompt sections and rules are included. |
| `setEnvironment.bat` | Defines OS, terminal, local repo paths, branch name, and commit message variables used in prompt generation. |
| `prompt.md` | Generated prompt file (assembled at runtime from templates). Not committed. |
| `prompt.md.template` | Reference copy of the prompt template structure. |
| `template/` | Markdown fragments that are concatenated to build `prompt.md`. Includes goal sections, rules, closing notes, and check/create variants for different error scenarios. |

### `lib/`

Shared utility scripts.

| File | Purpose |
|------|---------|
| `cmdVar.bat` | Stores the output of a command into a batch variable. Used throughout the project for dynamic variable assignment. |
| `instructLine.bat` | Prints formatted instruction lines, headings, dividers, and blank lines to the terminal for readable output. |

### `data/`

Runtime data files generated during execution.

| File | Purpose |
|------|---------|
| `latest.uri` | Stores the last-known latest release URL from GitHub. Used by `checkLatest.bat` for comparison. |

Other files such as `claude-context.yaml`, `install_log.log`, and `config_log.log` are generated at runtime and may appear here after a run.

### `logs/`

Archived log files from previous runs (e.g. `configure-error-03-19-26.log`).

### `support/`

Supporting reference files (e.g. screenshots, images used for troubleshooting).

### `curl/`

Local copy of the curl source tree. Present for reference and used during builds inside the sandbox.
