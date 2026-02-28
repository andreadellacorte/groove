# Remove Skill

## Outcome

A skill is removed via `npx skills remove`. The entry is removed from `skills-lock.json`. User confirms before removal.

## Acceptance Criteria

- Skill is no longer installed after command completes
- Entry is removed from `skills-lock.json`
- User confirmed removal before it happened

## Constraints

- $ARGUMENTS must include `<skill-name>` — error if missing
- Show user what will be removed and ask for confirmation before proceeding
- Run `npx skills remove <skill-name>`
- After removal, update `skills-lock.json` to remove the entry
- If skill is not in `skills-lock.json`, warn user but still attempt removal (may have been installed manually)
- If `npx` is not available, error clearly and suggest installing Node.js
