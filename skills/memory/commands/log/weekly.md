# Log Weekly

## Outcome

`<memory>/weekly/YYYY-Www.md` is created or updated with a roll-up of the week's daily files. Sections cover themes, key outcomes, and learnings — no raw detail duplication.

## Acceptance Criteria

- File exists at `<memory>/weekly/YYYY-Www.md` (ISO week format, e.g. `2026-W09`)
- Themes section identifies recurring topics from daily entries
- Key outcomes section lists significant completions from the week
- Learnings section synthesises patterns and insights across the week
- Content is rolled up from daily files — not duplicated raw detail

## Constraints

- Use `memory:` path from `.groove/index.md` frontmatter
- Only run on the last weekday of the week, or when user explicitly requests
- Roll up from that week's daily files in `<memory>/daily/`
- If no daily files exist for the week, note that and exit gracefully
- Use template at `templates/log/weekly.md` for file structure
- If file already exists, update rather than overwrite
