# Spec: groove + Claude Code Native Hooks

**Session**: claude/loop-2026-03-07
**Date**: 2026-03-07

---

## Overview

**What**: Claude Code has a native shell hook system configured in `.claude/settings.json` (project-scoped) or `~/.claude/settings.json` (global). Hooks fire at lifecycle events — `PreToolUse`, `PostToolUse`, `Notification`, `Stop`, `SubagentStop` — and run shell commands. This is distinct from groove's `.groove/hooks/start.md` / `end.md` system, which are advisory markdown lists executed by the agent.

**Why**: Claude Code's native hooks run outside the model — they are deterministic, unconditional, and cannot be argued away. groove's markdown hooks depend on the agent reading and following the `## Actions` list, which is advisory. For certain high-value automation (auto-git-memory after commits, session-end reminders) a shell hook is more reliable than an advisory prompt.

**Scope**: A new `groove-admin-claude-hooks` skill that writes and manages Claude Code hook entries in `.claude/settings.json`. Covers three specific high-value integrations. Does not replace groove's markdown hooks — both coexist.

---

## Claude Code Hook System

Hooks are defined in `.claude/settings.json` under a `hooks` key:

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          { "type": "command", "command": "echo 'session ended'" }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": "my-script.sh" }
        ]
      }
    ]
  }
}
```

Events:
| Event | Fires when | Can block? |
|---|---|---|
| `PreToolUse` | Before any tool call | Yes — non-zero exit blocks the call |
| `PostToolUse` | After tool call completes | No |
| `Notification` | Claude sends a notification | No |
| `Stop` | Claude finishes a turn | No |
| `SubagentStop` | A subagent finishes its turn | No |

`matcher` filters by tool name (e.g. `"Bash"`, `"Write"`, `"Edit"`). Hooks receive context via stdin as JSON.

---

## Decisions

| Decision | Choice | Rationale |
|---|---|---|
| Config target | `.claude/settings.json` (project-scoped) | Keeps hooks repo-local, consistent with groove's project-scoped philosophy; team can share via git |
| New skill | `groove-admin-claude-hooks` | Discrete, discoverable; admin namespace fits alongside install/config/update/doctor |
| Scope: Stop hook | Remind about groove-daily-end if workday hours | Highest signal, lowest risk — reminds without blocking |
| Scope: PostToolUse/Bash git commit | Append one-line entry to git memory buffer file | Reliable auto-logging without model intervention |
| Scope: PreToolUse/Write to skills/ | Warn and block edits to managed groove skill files | Deterministic enforcement of the `<!-- groove:managed -->` boundary |
| Does not replace markdown hooks | Both coexist | Markdown hooks are user-defined multi-step actions; Claude Code hooks are system-level triggers |

---

## Hooks to implement

### Hook 1: Stop → daily-end reminder

**Event**: `Stop`
**Command**: Shell script checks current hour; if 16:00–21:00 local time and a `.groove/index.md` is present, prints:

```
groove: end of work hours — consider running /groove-daily-end
```

Output appears in the Claude Code notification area. Non-blocking — purely advisory.

**Why**: Replaces the need to remember to run daily-end. Mirrors PAI's `SessionEnd` hook pattern at groove's scope.

### Hook 2: PostToolUse/Bash git commit → git memory buffer

**Event**: `PostToolUse`, matcher: `Bash`
**Command**: Shell script checks if the Bash tool's `command` input (from stdin JSON) contains `git commit`; if so, appends `YYYY-MM-DD HH:MM | <commit-message-first-line>` to `.groove/.cache/git-activity-buffer.txt` (created if absent).

`groove-utilities-memory-log-git` reads and clears this buffer when writing the git memory file, replacing the current `git log` scan with pre-captured commit events.

**Why**: More reliable than re-scanning git log; captures commits even in long sessions; no model reasoning required.

### Hook 3: PreToolUse/Write or Edit to `.agents/skills/` → block

**Event**: `PreToolUse`, matcher: `Write` and `Edit`
**Command**: Shell script checks the `file_path` from stdin JSON; if it starts with `.agents/skills/groove` or `skills/groove`, exits non-zero with message:

```
groove: blocked — .agents/skills/groove* is managed by groove:update. Edit skills/ source instead and rsync.
```

**Why**: Deterministic enforcement of the managed boundary. Currently advisory-only via SKILL.md comments and AGENTS.md constraints — can be ignored by the model. A PreToolUse hook cannot be overridden.

---

## Implementation Steps

### Phase 1 — `groove-admin-claude-hooks` skill

1. Read `.claude/settings.json` if it exists (default `{}`); parse JSON
2. Ask which hooks to enable (multi-select, default all three):
   - [x] Stop: daily-end reminder
   - [x] PostToolUse/Bash: git activity buffer
   - [x] PreToolUse/Write+Edit: block managed groove paths
3. For each selected hook: write or merge the hook entry into `.claude/settings.json`
4. Write three shell scripts to `.groove/hooks/claude/`:
   - `daily-end-reminder.sh`
   - `git-activity-buffer.sh`
   - `block-managed-paths.sh`
   (groove creates these; user can inspect and edit)
5. Update `.groove/.gitignore` if `git.hooks: ignore-all` to ignore `.groove/hooks/claude/*.sh`
6. Report: hook entries written to `.claude/settings.json`; scripts at `.groove/hooks/claude/`

### Phase 2 — `groove-utilities-memory-log-git` integration

Modify `groove-utilities-memory-log-git` to check `.groove/.cache/git-activity-buffer.txt` first:
- If buffer exists and is non-empty: use its contents as the activity log; clear the file after reading
- If buffer absent: fall back to current `git log` scan

### Phase 3 — `groove-admin-doctor` integration

Add hook health check: verify `.claude/settings.json` has the groove hook entries; if absent, report with remediation `run: /groove-admin-claude-hooks`.

---

## Edge Cases

| Case | Handling |
|---|---|
| `.claude/settings.json` has existing hooks | Merge groove entries; do not overwrite existing user hooks |
| User is not using Claude Code | `.claude/settings.json` may not exist; skill creates it; scripts are inert if never triggered |
| Hook scripts require execute permission | `chmod +x` each script after writing |
| `git-activity-buffer.txt` grows unbounded | `groove-utilities-memory-log-git` clears it after every read; buffer is bounded by daily session length |
| PreToolUse block is too aggressive | Script checks exact path prefix only; false positives are near-zero |
| User disables a hook | Run `/groove-admin-claude-hooks --disable <hook-name>` to remove the entry from settings.json |

---

## Scope Boundary

- **In scope**: `.claude/settings.json` project-level hooks, three specific integrations, `groove-admin-claude-hooks` skill
- **Out of scope**: global `~/.claude/settings.json` hooks (project-scoped is groove's philosophy), hook monitoring/dashboards, hooks for non-Bash tools beyond Write/Edit
- **Future**: Notification hook for PR/CI status (requires external polling — deferred)
