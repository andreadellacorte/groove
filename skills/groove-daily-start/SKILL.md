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

- Read `.groove/index.md` for `tasks:` and `memory:` config
- **Review previous day:** Read yesterday's file at `<memory>/daily/YYYY-MM-DD.md` (yesterday's date). If it exists, show a short summary (e.g. "Done today" bullets, "Open/Next" carry-forward). If missing or no end section: warn user ("Yesterday had no end logged") — do NOT block start
- **Create new day memory:** Call `/groove-utilities-memory-init-daily` to create today's file at `<memory>/daily/YYYY-MM-DD.md` with a start-of-day structure. If the file already exists, skip (idempotent)
- Call `/groove-utilities-task-analyse` to get current task state
- Create start task via `/groove-utilities-task-create` if `tasks != none` (title `YYYY-MM-DD Start`)
- Do NOT archive tasks during start
- Present task list in a scannable format before the user begins
- After all standard steps: check if `.groove/hooks/start.md` exists
  - If it exists: read the `## Actions` section and execute each item in order; report completion per item
  - If it does not exist: skip silently
