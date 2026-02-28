# Check Skill Updates

## Outcome

Each skill in `skills-lock.json` is checked for updates. Out-of-date skills are listed with current vs latest version.

## Acceptance Criteria

- All skills in `skills-lock.json` are checked
- Out-of-date skills show: skill name, current version, latest version
- Up-to-date skills are listed but clearly not flagged
- If `skills-lock.json` is empty or missing, report that and exit gracefully

## Constraints

- Run `npx skills check` to perform the version check
- Read `skills-lock.json` to know which skills to check
- If `skills-lock.json` does not exist, inform user and suggest running `skills add` to populate it
- If no updates available, say so explicitly — do not show empty output
- If `npx` is not available, error clearly and suggest installing Node.js
- Do not auto-update — report only; let user decide to run `skills add <owner/repo>` per skill
