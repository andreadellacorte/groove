# Log Daily

## Outcome

`<memory>/daily/YYYY-MM-DD.md` is created or updated with a structured closeout entry. The file is written so that the next startup can verify yesterday had a closeout.

## Acceptance Criteria

- File exists at `<memory>/daily/YYYY-MM-DD.md` after command completes
- "Done today" section contains granular multi-level bullets sourced from completed tasks and git diff
- Git section summarises commits and changed files for the day
- Tasks section shows task summary by status
- Learnings section is populated (not blank)
- Open/Next section captures carry-forward items
- If file already exists, content is updated/appended rather than overwritten

## Constraints

- Use `memory:` path from `.groove/index.md` frontmatter for base directory
- Write at closeout only — never called at startup
- "Done today" must be sourced from: completed tasks (date-matched) and `git diff` output — not from incomplete work
- If a completed task has no resolution in its body, ask user for a summary before writing the bullet
- Use template at `templates/log/daily.md` for file structure
- If the directory `<memory>/daily/` does not exist, create it before writing
- Vague entries ("worked on stuff") should trigger a clarification ask before writing
