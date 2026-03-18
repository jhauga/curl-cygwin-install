
The links you use to test the install are all missing. They are:

## Errors to Resolve

- Website Page: `_siteCurrent`
  - This webpage has a link to download the source code package for the install
- Mirror Link: `_uriCurrent`
  - This webpage is the parent most path to where the source code download was once located
- Mirror Folder: `_siteUriCurrent`
  - This webpage is the folder where the source code download was once located

Using these clues to:

### Search New Download Link URI

- Scrape the domain from `_uriCurrent` and see if you can find a folder with the source code download,
which will end with `_sourceMarkerCurrent`.
- If not found on `_uriCurrent`, then search similar sites for `_programCurrent` source code for Cygwin
  - Make a list of mirror sites, then later replace `LIST_OF_MIRROR_SITES` in this prompt with that list

### After Searching New Download Link URI

- If a new download link was found, then follow "Cygwin `_programCurrent` New Download Link" instructions
- If no link was found, then follow "Cygwin `_programCurrent` Source Code Download Missing" instructions

## Instructions

Depending on the results of the new download link seary, follow one of the instructions below.

### Cygwin `_programCurrent` New Download Link

In sibling repo `_localWebsiteRepoSetEnvironment\..` we want to make an issue. Not a pull request. Instead, dump the issue data in a file.
Call it "_PROPOSED_ISSUE_DATA.md". Write short issue covering the imperatives:

- Repo Page: `_localWebsiteRepoEditFilesEnvironment`
- Website Page: `_siteCurrent`
  - This webpage has the broken link to download the source code package for the install
- Proposed Link:
  - LIST_OF_MIRROR_SITES

### Cygwin `_programCurrent` Source Code Download Missing

In sibling repo `_localWebsiteRepoSetEnvironment\..` we want to make an issue. Not a pull request. Instead, dump the issue data in a file.
Call it "_PROPOSED_ISSUE_DATA.md". Write short issue covering the imperatives:

- Repo Page: `_localWebsiteRepoEditFilesEnvironment`
- Website Page: `_siteCurrent`
  - This webpage has the broken link to download the source code package for the install

State that the download link to the source code is missing, and could not be found in alternative mirror sites:

- LIST_OF_MIRROR_SITES
