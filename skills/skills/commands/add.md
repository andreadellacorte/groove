# Add Skill

## Outcome

A skill is installed via `npx skills add <owner/repo>`. `skills-lock.json` is updated with the installed skill's source and metadata. User is informed of what was installed and where.

## Acceptance Criteria

- Skill is installed and available after command completes
- `skills-lock.json` is updated with the new entry
- User is shown what was installed and the install location
- If skill name already exists, user is warned before proceeding

## Constraints

- $ARGUMENTS must include `<owner/repo>` — error if missing
- Run `npx --yes skills add <owner/repo>`
- Before installing, check if a skill with the same name already exists in `skills-lock.json`
  - If conflict: warn user and ask to confirm before overwriting
- After install, update `skills-lock.json`:
  ```json
  {
    "version": 1,
    "skills": {
      "<skill-name>": {
        "source": "<owner/repo>",
        "installedAt": "<ISO timestamp>"
      }
    }
  }
  ```
- If `npx` is not available, error clearly and suggest installing Node.js
