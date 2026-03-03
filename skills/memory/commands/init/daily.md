# Init Daily

## Outcome

Today's daily memory file is created at `<memory>/daily/YYYY-MM-DD.md` with a start-of-day structure, so the day has a memory file from the beginning. Called from daily start only.

## Acceptance Criteria

- File exists at `<memory>/daily/YYYY-MM-DD.md` with a start-of-day structure (date heading, e.g. "## Plan for today")
- If the file already exists, do nothing (idempotent)
- Directory `<memory>/daily/` is created if missing

## Constraints

- Use `memory:` path from `.groove/index.md` frontmatter for base directory
- Only create if the file does not exist — do not overwrite
- Use template at `templates/log/daily-start.md` for the start-of-day structure
- Called from daily start only; at daily end, `memory log daily` appends the closeout sections to this file
