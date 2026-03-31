# Claude Template

Templates build the final `prompt.md` file on a per-task-type basis. All task utilize the starting [`template.md`](template.md) file.

## Per-task-type Basis

- Create something
  - This can be resolved
- Check something
  - This cannot be resolved

## Create Something

Two elements:

1. **Failed Install**
  - Determines headings for **missing source link**
  - Has nested conditions
2. **Missing Source Link**
  - Headings dependent on **failed install**
  - No nested conditions

> [!NOTE]
> The template file `closing-excludeConfigFlags.md` is deprecated.

### Failed Install

- create-failedInstall_i.md
  - install_log.log
- Nested Conditions:
  - create-useConfigOptionCurrent.md
    - config_log.log
  - create-dependencies.md
- create-goal_i.md
- create-failedInstall_ii.md
- rules-failedInstall.md
- Nested Conditions:
  - closing-failedInstall-missingSourceLink.md
  - closing-failedInstall.md
   
### Missing Source Link

- create-goal_ii.md
- create-missingSourceLink.md
- create-excludeConfigFlags.md
- rules-missingSourceLink.md
- closing-missingSourceLink.md

## Check Something

### Install Current Close Out

Something unexpected happened in this repo. Template files to check it:

- check-installCurrentCloseOut.md
- closing-installCurrentCloseOut.md

### Missing All Links

No source download link found on programs site, or the mirrror sites. Template files to check it:

- check-missingAllLinks.md
- closing-missingAllLinks.md
