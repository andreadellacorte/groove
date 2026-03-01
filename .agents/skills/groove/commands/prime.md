# Groove Prime

## Outcome

A bootstrap instruction is written to the `<!-- groove:prime:start -->` section of `AGENTS.md` at the git root, telling agents which commands to run at session start and in what order.

## Acceptance Criteria

- `AGENTS.md` exists at git root (created if absent)
- The `<!-- groove:prime:start -->` / `<!-- groove:prime:end -->` section is present and up to date
- Running prime again updates the section in place — does not duplicate it

## Output format

Write the following block to `AGENTS.md`, replacing any existing `<!-- groove:prime:start -->` section:

```
<!-- groove:prime:start -->
**Run at the start of every session, in order:**
1. `/groove prime` — loads groove workflow context into the conversation
2. `beans prime` — loads task backend context into the conversation
<!-- groove:prime:end -->
```

Omit line 2 if `tasks: none`.

## Version check

Before writing `AGENTS.md`, run a version check if `last-version-check:` in `.groove/index.md` is not today's date:

1. Read `last-version-check:` from `.groove/index.md` — if absent or not today's date, proceed
2. Fetch latest release from `https://api.github.com/repos/andreadellacorte/groove/releases/latest`
3. If a newer version exists, prepend a notice to the groove:prime block:
   ```
   ⚠ New version of groove available: v<latest> — run: groove update
   ```
4. Update `last-version-check:` to today's date in `.groove/index.md`
5. If the API call fails, skip silently — do not block prime

## Constraints

- Read `tasks:` from `.groove/index.md` frontmatter to determine whether to include line 2
- If `AGENTS.md` does not exist, create it with only the groove:prime section
- If the section already exists, replace it entirely — do not append
- If the section does not exist, append it to the end of `AGENTS.md`
- Preserve all other content in `AGENTS.md` outside the fenced section
- Version check runs at most once per day — gate on `last-version-check:` date
- Report the path written and confirm success
