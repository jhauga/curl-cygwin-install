### Part III - Create a new GitHub Issue for Documentation Repo

#### Missing Link Condition

Follow the below condition to determine action moving forward regarding missing source code link for install.

```bash
if EXIST "_localWebsiteRepoSetEnvironment" (
 if EXIST "_localWebsiteRepoSetEnvironment\_PROPOSED_ISSUE_DATA.md" (
  echo Issue related to "_PROPOSED_ISSUE_DATA.md" has been created. Exiting prompt.
  rem Done. Do nothing as issue has been created.
 ) else (
  echo Creating Proposed Issue:
  rem goto `#### Make New issue Task`
 )
) else (
 echo "_localWebsiteRepoSetEnvironment" does not exist. Exiting prompt.
 rem Done. Do nothing as no path to _localWebsiteRepoSetEnvironment
)
```

#### Make New issue Task

In sibling repo `_localWebsiteRepoSetEnvironment` we want to make an issue. Not a pull request. Instead, dump the issue data in a file.
Call it "_PROPOSED_ISSUE_DATA.md". Write short issue covering the imperatives:

- Repo Page: `_localWebsiteRepoEditFilesEnvironment`
- Website Page: `_siteCurrent`
  - This webpage has the broken link to download the source code package for the install
- Proposed Link: `_mirrorSiteDownloadLink`

