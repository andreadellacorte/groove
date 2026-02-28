# Log Monthly

## Outcome

`<memory>/monthly/YYYY-MM.md` is created or updated with a roll-up of the month's daily files. Sections cover themes, key outcomes, and learnings at monthly scope.

## Acceptance Criteria

- File exists at `<memory>/monthly/YYYY-MM.md` after command completes
- Themes section identifies major recurring topics from the month
- Key outcomes section lists significant completions and milestones
- Learnings section synthesises patterns and insights across the month
- Content is rolled up from daily files — not duplicated raw detail

## Constraints

- Use `memory:` path from `.groove/index.md` frontmatter
- Only run on the last weekday of the month, or when user explicitly requests
- Roll up from that month's daily files in `<memory>/daily/`
- If no daily files exist for the month, note that and exit gracefully
- Use template at `templates/log/monthly.md` for file structure
- If file already exists, update rather than overwrite
