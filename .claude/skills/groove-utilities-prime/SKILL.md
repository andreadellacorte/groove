---
name: groove-utilities-prime
description: "Load groove workflow context into the conversation. Run at the start of every session."
license: MIT
allowed-tools: Read Write Edit Glob Grep Bash(git:*) Bash(beans:*) Bash(gh:*) Bash(linear:*) Bash(npx:*) Bash(mkdir:*) AskUserQuestion
metadata:
  author: andreadellacorte
---

<!-- groove:managed — do not edit; changes will be overwritten by groove update -->

# groove-utilities-prime

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

groove is installed in this repo. Use `/groove-*` skills for all workflow commands.

## Config
tasks:      <tasks value>
memory:     <memory value>
specs:      <specs value, or "(default: <memory>/specs/)" if absent>
git.memory: <git.memory value>
git.tasks:  <git.tasks value>
git.hooks:  <git.hooks value>

## Key commands
/groove-daily-start           — start the workday
/groove-daily-end             — end the workday
/groove-work-brainstorm       — clarify scope (YAGNI enforced)
/groove-work-plan             — research codebase, write implementation plan
/groove-work-exec             — execute the plan
/groove-work-review           — evaluate output, decide accept/rework
/groove-work-compound         — document lessons into existing project files
/groove-work-spec             — create outcome spec (what to build)
/groove-work-doc              — create reference doc (how it works)
/groove-utilities-task-list   — show active, ready tasks
/groove-utilities-task-create — create a task
/groove-utilities-task-analyse — summarise tasks by status
/groove-utilities-memory-log-daily — write daily end log
/groove-utilities-memory-promises       — capture or resolve deferred items
/groove-utilities-memory-mistakes        — log a mistake and resolve it
/groove-utilities-memory-retrospective  — analyse ratings, mistakes, and learnings over a period

## Conventions
- Stage tasks: "YYYY-MM-DD, <Stage>" (no numbers; e.g. 2026-02-28, Brainstorm; 2026-02-28, Compound — topic)
- Memory logs: <memory value>daily/, weekly/, monthly/, git/
- Task completion requires "Summary of Changes" in body before marking done
- Archive is always user-triggered — never automatic during end
- 80% of compound loop value is in plan and review — do not skip them

## Steering
- Fix root causes, not symptoms — if a workaround is needed, note the root cause anyway
- YAGNI — only make changes directly requested or clearly necessary; no unrequested refactors
- Verify before acting on shared state — confirm before push, PR creation, or destructive ops
- Smallest diff that solves the problem — prefer editing one file over touching five
- When blocked, ask rather than brute-force — retrying the same failing action wastes context
- Read before editing — understand existing code before proposing changes to it

## Constraints
- Do not edit files under `skills/` or `.agents/skills/` — managed by groove update, changes will be overwritten
- User zone: `.groove/` is yours — config, hooks, memory, and learned insights are all safe to edit
```

If `groovebook:` is set in `.groove/index.md`, append to the output:

```
## Groovebook
groovebook: <groovebook value>
/groove-groovebook-publish — publish a learning to the shared commons
/groove-groovebook-review  — browse and review open learning PRs
```

## Version check

Before outputting context, check if `.groove/.cache/last-version-check` does not contain today's date:

1. Read `.groove/.cache/last-version-check` — if absent or not today's date, proceed
2. Fetch latest release from `https://api.github.com/repos/andreadellacorte/groove/releases/latest`
3. If a newer version exists, prepend to the output:
   ```
   ⚠ New version of groove available: v<latest> — run: /groove-admin-update
   ```
4. Write today's date to `.groove/.cache/last-version-check`
5. If the API call fails, skip silently — do not block prime

## Identity context

After outputting the main context block, check if `.groove/IDENTITY.md` exists:

- If it exists: read it and append its contents to the output under a `## Identity` section header
- If it does not exist: skip silently — no prompt, no hint

The identity section is free-form — output the file contents verbatim. This gives the agent persistent user context (mission, goals, projects, beliefs) across sessions without re-explaining each time.

## Constraints

- Read `.groove/index.md` frontmatter to substitute `tasks:`, `memory:`, and `git.*` placeholders
- Output to conversation only — do not write to AGENTS.md or any other file (except updating `.groove/.cache/last-version-check`)
- Version check runs at most once per day — gate on `.groove/.cache/last-version-check` date
