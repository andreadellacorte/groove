# Daily Startup

## Outcome

The workday is prepared: yesterday's closeout is verified, tasks are consolidated and presented, a startup task is created in the backend (if enabled), and the user knows what to work on.

## Acceptance Criteria

- Yesterday's daily memory file is checked for a closeout entry
- Task list is loaded and presented (grouped by status)
- Startup task created in configured backend (if `tasks != none`)
- User has a clear picture of the day's agenda before starting work

## Constraints

- Read `.groove/index.md` for `tasks:` and `memory:` config
- Check yesterday's daily file at `<memory>/daily/YYYY-MM-DD.md` (yesterday's date)
  - If file exists: scan for "## Done today" or "Closeout" section to confirm closeout happened
  - If file missing or no closeout section: warn user ("Yesterday had no closeout logged") — do NOT block startup
- Call `task analyse` to get current task state
- Call `task create` to create a startup task titled `YYYY-MM-DD Startup` with type `chore`, status `in-progress`
- Do NOT write daily memory at startup — memory write happens at closeout only
- Do NOT archive tasks during startup
- Present task list in a scannable format before the user begins
