@echo off
REM setEnvironment
::  Set variables relevant to the Operating System, local repo, and local documentation repo.
 
:: OS and terminal
set "_osSetEnvironment=Windows 11"
set "_terminalSetEnvironment=DOS terminal"

:: Directory and files
set "_curDirSetEnvironment=%~dp0"
set "_localRepoSetEnvironment=D:\\Users\\johnh\\Documents\\GitHub\\curl"
set "_localRepoEditFilesEnvironment=docs\\INSTALL.md"
set "_localWebsiteRepoSetEnvironment=D:\\Users\\johnh\\Documents\\GitHub\\curl-www"
set "_localWebsiteRepoEditFilesEnvironment=_download.html"

:: `git` related
set "_branchNameSetEnvironment=patch-curl-cygwin-install"
set "_commitMessageSetEnvironment=INSTALL.md: update cygwin instructions"
