# curl-cygwin-install

Support repository for [curl](https://github.com/curl/curl) pull request [#17485](https://github.com/curl/curl/pull/17485).

## Instructions for Use:

**IMPORTANT** - ensure Windows supports Sandbox, and the **Windows Sandbox**
feature is on in `Turn Windows features on or off`.

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
   - Download the compressed `curl` for the `cygwin` install
   - `sh configure <_configOption>` is run
   - `make` is run
5. Some `curl` test commands run once the install is complete.
   - You'll be asked "What happened?" followed by a pause when the install
  is done

After the installation is complete temporary files are cleared, leaving the
install folder of curl in the Sandbox folder where this tool was mapped to.
Delete/keep files after install test as needed.

### Automating Run

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
