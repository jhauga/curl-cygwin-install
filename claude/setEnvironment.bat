@echo off
REM setEnvironment
::  Set variables relevant to the Operating System, local repo, and local documentation repo.

:: OS and terminal
set "_osSetEnvironment=Windows 11" & rem current Windows OS
set "_terminalSetEnvironment=DOS terminal" & rem what was used - windows command line, Cygwin terminal, powershell, etc..

:: Directory and files
set "_curDirSetEnvironment=%~dp0"
set "_localRepoSetEnvironment=D:\\Users\\johnh\\Documents\\GitHub\\curl" & rem path to local repo of program
set "_localRepoEditFilesEnvironment=docs\\INSTALL.md" & rem path to local repo's install documentation
set "_localWebsiteRepoSetEnvironment=D:\\Users\\johnh\\Documents\\GitHub\\curl-www" & rem path to website repo that builds live website
set "_localWebsiteRepoEditFilesEnvironment=_download.html" & rem page of website repo where link to download is

:: `git` related
set "_localRepoNameSetEnvironment=curl-cygwin-install" & rem this repo name, change as needed
set "_localRepoPathSetEnvironment=D:\\Users\\johnh\\Documents\\GitHub\\curl-cygwin-install"
set "_branchNameSetEnvironment=patch-curl-cygwin-install" & rem branch name for local repo of program
set "_commitMessageSetEnvironment=INSTALL.md: update Cygwin instructions" & rem commit message for proposed install resolution
