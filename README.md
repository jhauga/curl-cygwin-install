# curl-cygwin-install
Support repository for [curl](https://github.com/curl/curl) pull request [#17485](https://github.com/curl/curl/pull/17485).

## Instructions for Use:

**IMPORTANT** - ensure Windows supports Sandbox, and the **Windows Sandbox** feature is
on in `Turn Windows features on or off`.

1. Clone or download repo:

`git clone https://github.com/jhauga/curl-cygwin-install.git`

2. Open or navigate to `curl-cygwin-install`, and run or double click `cygwinInstall.bat`,
then read prompt instruction.
3. Focus on Sandbox window, and follow instructions from the prior `cygwinInstall` prompt.
4. The process will begin, and the `cygwin` packages will be installed.
5. Once `cygwin` packages have been installed `sh configure <_configOption>`
(*in* `map\current.bat` *_configOption is set to **--without-ssl** by default*) and `make`
will run, followed by some test commands once the curl install is complete.

After the installation is complete temporary files are cleared, leaving the install folder
of curl in the Sandbox folder where this tool was mapped to. Delete/keep files after install
test as needed.