# curl-cygwin-install

Support repository for [curl](https://github.com/curl/curl) pull request [#17485](https://github.com/curl/curl/pull/17485).

This may **possibly** be edidted to and run to check different [**Cygwin**](https://www.cygwin.com/) program installations. To do so see [specify installation to check](#specify-installation-to-check).

## Instructions for Use:

**IMPORTANT** - ensure Windows supports Sandbox, and the **Windows Sandbox**
feature is on in `Turn Windows features on or off`.

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
      - Send a personl notification that the script ran

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
file `curlInstructionWork.txt` will be placed from `sandbox` folder, or created;
if the process failed altogether. It will simply say if the install was a "Pass",
or a "Fail".

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
   - Intall the dependencies using `cygwin` setup file
   - Download the compressed `curl` or specified program for the `cygwin` install
   - `sh configure <_configOption>` is run
   - `make` is run
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
curl https://www.cygwin.com/setup-x86_64.exe -o "C:\cygwin64\bin\pkg.exe"
set PATH=%PATH%;C:\cygwin64\bin\
```
> [!NOTE]
> You can ignore these if manually testing another install

#### III. Install Dependencies

```bash
# This guarantees all dependencies are downloaded
pkg --no-admin -q -I --build-depends curl
# If dependencies are known, then run like this
pkg --no-admin -q -I -P binutils,gcc-core,libpsl-devel,libtool,perl,make
```

#### IV. Install Program `curl`

> [!NOTE]
> Mind version numbering.

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
sh configure --without-ssl --disable-shared --enable-static
make
```

## Specify Installation to Check

> [!NOTE]
> You should have a **VERY** solid understanding of Windows batch scripts before configurring this repository to check the installation status of another Cygwin program.

To do so edit the following:

- **`install.bat`**
  - Change `_programInstall` to program name
  - Change `_useConfig` to 1 if the program requires a `sh configure` call before `make`
    - **NOTE** - mainly set configuration here if you want to use menu selection from `config-options.txt`
    - **NOTE** - this will change the configuration in `map\current.bat` config variables
    - Set to 0 if `map\current.bat` configuration is to be used
  - Change `_defaultConfig` to options to use for `sh configure` call
    - **NOTE** - set to `_none_used_` if only `sh configure` is used
- **`config-options.txt`**
  - Change to viable configuration options if the install use a configure call
- **`map\current.bat`**
  - Change `_programCurrent` to program name
  - Change `_siteCurrent` to the URL where instructions are
  - Chage `_uriCurrent` to the URI where of main path where download files are
  - Change `_extractInstallUriCurrent` to command to extract download URL
    - Around line 50 edit pipe as needed, below the comment is `rem CONFIG-EDIT--_extractInstallUriCurrent--CALL`
  - Change `_siteUriCurrent` to the URL that the site with instructions points download to
  - Change `_extractInstallUriCurrent` to the command that will get the download link from site
  - Chnage `_packageDependenciesCurrent` to installation dependencies
  - Change `_forceErrorPackageDependenciesCurrent` to some dependencies (*to debug on-fail*)
  - Change `_runAdditionalCheck` to 1 to run additional test, using `map\additionalCheck.bat`
    - **NOTE** - `map\additionalCheck.bat` is completely as needed
  - **TEST COMMANDS**
    - Change `_runTestCommandCurrent` to the test command, or path to test command to use with the below configurred variaables i.e. `src\curl`
      - Change `_runTestCommandCurrentA` to `%_runTestCommandCurrent% --option` i.e. `%_runTestCommandCurrent% --help`
      - Change `_runTestCommandCurrentB` to `%_runTestCommandCurrent% --option`
      - Change `_runTestCommandCurrentC` to `%_runTestCommandCurrent% --option`
      - Change `_runTestCommandCurrentD` to `%_runTestCommandCurrent% --option`
      - Change `_runTestCommandCurrentE` to `%_runTestCommandCurrent% --option`
      - Change `_runTestCommandCurrentF` to `%_runTestCommandCurrent% --option`
      - Change `_runTestCommandCurrent_INSTALL_CHECK` to command to output something for automation script
  - **Optional**
    - If any configruation is needed then change `_useConfigOptionCurrent` to 1
      - **NOTE** - if `_useConfig` in `install.bat` is 1, then this will be changed from that
      - **NOTE** - you'll probable want to check the config call in `map\current.bat`
      - Change `_configOptionCurrent` to configuration options
        - **NOTE** - set to `_none_used_` if only `sh confgirue` is used
    - Set `_useCustomMakeCurrent` to 1 if using anything other than `make` to install program
    - Change `_customMakeCurrent` to custom `make` call
      - Set `_customDebugMakeCurrent` to 1 for debug make call
      - Change `_debugMakeCurrent` to a debug `make` call
