# Groove Prime

## Outcome

The agent receives full groove workflow context in the conversation — config, key commands, conventions, and constraints. Run at the start of every session before doing any work.

## Acceptance Criteria

- Agent is shown current config values from `.groove/index.md`
- Agent is shown all key commands, conventions, and constraints
- If a newer version of groove is available, agent is notified

## Output format

Output the following to the conversation (do not write to any file):

```
# Groove Workflow Context

groove is installed in this repo. Use `/groove:<skill>:<command>` for all workflow commands.

## Config
tasks:      <tasks value>
memory:     <memory value>
git.memory: <git.memory value>
git.tasks:  <git.tasks value>
git.hooks:  <git.hooks value>

## Key commands
/groove:daily:start           — start the workday
/groove:daily:end             — end the workday
/groove:work:brainstorm       — clarify scope (YAGNI enforced)
/groove:work:plan             — research codebase, write implementation plan
/groove:work:work             — execute the plan
/groove:work:review           — evaluate output, decide accept/rework
/groove:work:compound         — document lessons into existing project files
/groove:task:list             — show active, ready tasks
/groove:task:create           — create a task
/groove:task:analyse         — summarise tasks by status
/groove:memory:log:daily      — write daily end log

## Conventions
- Stage tasks: "YYYY-MM-DD, N. Stage" (e.g. 2026-02-28, 1. Brainstorm)
- Memory logs: <memory value>daily/, weekly/, monthly/, git/
- Task completion requires "Summary of Changes" in body before marking done
- Archive is always user-triggered — never automatic during end
- 80% of compound loop value is in plan and review — do not skip them

## Constraints
- Do not edit files under `skills/` or `.agents/skills/` — managed by groove update, changes will be overwritten
- User zone: `.groove/` is yours — config, hooks, memory, and learned insights are all safe to edit
```

## Version check

Before outputting context, check if `.groove/.cache/last-version-check` does not contain today's date:

1. Read `.groove/.cache/last-version-check` — if absent or not today's date, proceed
2. Fetch latest release from `https://api.github.com/repos/andreadellacorte/groove/releases/latest`
3. If a newer version exists, prepend to the output:
   ```
   ⚠ New version of groove available: v<latest> — run: /groove:update
   ```
4. Write today's date to `.groove/.cache/last-version-check`
5. If the API call fails, skip silently — do not block prime

## Constraints

- Read `.groove/index.md` frontmatter to substitute `tasks:`, `memory:`, and `git.*` placeholders
- Output to conversation only — do not write to AGENTS.md or any other file (except updating `.groove/.cache/last-version-check`)
- Version check runs at most once per day — gate on `.groove/.cache/last-version-check` date
