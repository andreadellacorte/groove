# Daily End

## Outcome

The workday is wrapped up: git changes are analysed, memory files are written in order, tasks are analysed, an end task is created, and changes are committed based on per-component git strategy.

## Acceptance Criteria

- Git memory file written at `<memory>/git/YYYY-MM-DD-GIT-N.md`
- Daily memory file written at `<memory>/daily/YYYY-MM-DD.md`
- Weekly memory file written if today is the last weekday of the week
- Monthly memory file written if today is the last weekday of the month
- Tasks are analysed and summary is included in daily memory
- End task is created in configured backend (if `tasks != none`) with status `in-progress`
- Changes committed for any component whose git strategy allows it

## Constraints

- Read `.groove/index.md` for `tasks:`, `memory:`, and `git.*` config
- Memory population order (must follow this sequence):
  1. `memory log git`
  2. `memory log daily`
  3. `memory log weekly` (only if last weekday of week, or explicit request)
  4. `memory log monthly` (only if last weekday of month, or explicit request)
- Call `task analyse` to get task summary for daily memory population
- Create end task via **task** skill if `tasks != none` (title `YYYY-MM-DD End`)
  - User marks this task done when they're finished — do not auto-complete
- Do NOT archive tasks during end — that is user-triggered only
- Git commit strategy (per component):
  - `git.memory: ignore-all` — do not stage memory files
  - `git.memory: hybrid` — stage `<memory>/` files (sessions are gitignored, logs are committed)
  - `git.memory: commit-all` — stage `<memory>/` files
  - `git.tasks: commit-all` — stage `.groove/tasks/` files
  - `git.hooks: commit-all` — stage `.groove/hooks/` files
  - If any files were staged: commit with message `YYYY-MM-DD end`
  - If nothing to stage: skip commit silently
- Last weekday detection: use local calendar date; handle gracefully if run on weekend
- After all standard steps: check if `.groove/hooks/end.md` exists
  - If it exists: read the `## Actions` section and execute each item in order; report completion per item
  - If it does not exist: skip silently
