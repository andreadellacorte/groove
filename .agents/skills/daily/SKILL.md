---
name: daily
description: "Daily start and end rituals. Use when: (1) starting the workday; (2) wrapping up the day. NOT for: mid-day task management (use task); compound loop (use work); memory directly (use memory)."
license: MIT
allowed-tools: Bash(git:*) Read Write Edit AskUserQuestion
metadata:
  author: andreadellacorte
---

<!-- groove:managed — do not edit; changes will be overwritten by groove update -->

# daily

Thin orchestrator for the daily rhythm. Bookends the workday by calling `task` and `memory` skills in the right order. Does not duplicate their logic.

## Git Root Detection

Before running any command, detect the git root:

```bash
git rev-parse --show-toplevel
```

All config reads use `.groove/index.md` at git root.

## Commands

| Command | Description |
|---|---|
| `start` | Start the workday: review yesterday, create today's daily memory, load tasks, prepare agenda |
| `end` | End the workday: write memory, analyse tasks, commit if configured |

## $ARGUMENTS Routing

| $ARGUMENTS | Action |
|---|---|
| `help` | → `commands/help.md` |
| `start` | → `commands/start.md` |
| `end` | → `commands/end.md` |
| _(empty)_ | → `commands/help.md` |

## Bootstrap

Reads `.groove/index.md` for config. If not present, create from `skills/groove/templates/index.md` before proceeding.

## Design Note

`daily` is intentionally thin. It sequences calls to `task` and `memory` — it does not re-implement task listing, memory writing, or git analysis. When those skills evolve, `daily` benefits automatically.
