---
name: groove-daily-start
description: "Start the workday: review yesterday, create today's daily memory, load tasks, prepare agenda. Use when beginning the day."
license: MIT
allowed-tools: Bash(git:*) Read Write Edit AskUserQuestion
metadata:
  author: andreadellacorte
---

# groove-daily-start

## Outcome

The workday is prepared: yesterday's end is reviewed, today's daily memory file is created, tasks are consolidated and presented, a start task is created in the backend (if enabled), and the user knows what to work on.

## Acceptance Criteria

- Yesterday's daily memory file is reviewed (summary shown; warn if missing or no end section)
- Today's daily memory file is created with a start-of-day structure (if it does not already exist)
- Task list is loaded and presented (grouped by status)
- Start task created in configured backend (if `tasks != none`)
- User has a clear picture of the day's agenda before starting work

## Constraints

- Read `.groove/index.md` for `tasks:`, `memory:`, and `recent_memory_days:` config
- **Review recent days:** Identify the last `recent_memory_days` business days (Mon–Fri) counting back from yesterday (skip Saturday and Sunday). For each date:
  - Check `<memory>/daily/YYYY-MM-DD.md`:
    - `✓ YYYY-MM-DD — start + end logged` if both start-of-day and end sections exist
    - `~ YYYY-MM-DD — start only, no end logged` if only start section present
    - `✗ YYYY-MM-DD — missing` if file does not exist
    - Show a one-line context from the file if present (e.g. first bullet from "Done today" or plan intent)
  - Show git activity: run `git log --oneline --after="YYYY-MM-DD 00:00" --before="YYYY-MM-DD 23:59:59"` — display commit count and first few titles; skip silently if not in a git repo or no commits
  - Do NOT block start if files are missing or incomplete — just report
- **Create new day memory:** Call `/groove-utilities-memory-init-daily` to create today's file at `<memory>/daily/YYYY-MM-DD.md` with a start-of-day structure. If the file already exists, skip (idempotent)
- Call `/groove-utilities-task-analyse` to get current task state
- Create start task via `/groove-utilities-task-create` if `tasks != none` (title `YYYY-MM-DD Start`)
- Do NOT archive tasks during start
- Present task list in a scannable format before the user begins
- After all standard steps: check if `.groove/hooks/start.md` exists
  - If it exists: read the `## Actions` section and execute each item in order; report completion per item
  - If it does not exist: skip silently
