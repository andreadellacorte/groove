# Groove Prime

## Outcome

A concise groove context prompt is written to the `<!-- groove:prime:start -->` section of `AGENTS.md` at the git root. Any AI agent working in the repo will automatically have groove context without needing to run prime each session.

## Acceptance Criteria

- `AGENTS.md` exists at git root (created if absent)
- The `<!-- groove:prime:start -->` / `<!-- groove:prime:end -->` section is present and up to date
- Section content reflects current `.groove/index.md` config values
- Running prime again updates the section in place — does not duplicate it

## Output format

Write the following block to `AGENTS.md`, replacing any existing `<!-- groove:prime:start -->` section:

```
<!-- groove:prime:start -->
# Groove Workflow Context

groove is installed in this repo. Use `/groove <skill> <command>` for all workflow commands.

## Config
tasks:    <tasks value>
sessions: <sessions value>
memory:   <memory value>
git:      <git value>

## Key commands
/groove daily startup         — start the workday
/groove daily closeout        — end the workday
/groove work brainstorm       — clarify scope (YAGNI enforced)
/groove work plan             — research codebase, write implementation plan
/groove work work             — execute the plan
/groove work review           — evaluate output, decide accept/rework
/groove work compound         — document lessons into existing project files
/groove task list             — show active, ready tasks
/groove task create           — create a task
/groove task analyse          — summarise tasks by status
/groove memory session start  — start session (delegates to <sessions value>)
/groove memory log daily      — write daily closeout log
/groove skills add            — install a skill

## Conventions
- Stage tasks: "YYYY-MM-DD, N. Stage" (e.g. 2026-02-28, 1. Brainstorm)
- Memory logs: <memory value>daily/, weekly/, monthly/, git/
- Task completion requires "Summary of Changes" in body before marking done
- Archive is always user-triggered — never automatic during closeout
- 80% of compound loop value is in plan and review — do not skip them
<!-- groove:prime:end -->
```

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

- Read `.groove/index.md` frontmatter to substitute all `<value>` placeholders
- If `AGENTS.md` does not exist, create it with only the groove:prime section
- If the section already exists, replace it entirely — do not append
- If the section does not exist, append it to the end of `AGENTS.md`
- Preserve all other content in `AGENTS.md` outside the fenced section
- Version check runs at most once per day — gate on `last-version-check:` date
- Report the path written and confirm success
