# Daily Closeout

## Outcome

The workday is wrapped up: git changes are analysed, memory files are written in order, tasks are analysed, a closeout task is created, and changes are committed if the git strategy requires it.

## Acceptance Criteria

- Git memory file written at `<memory>/git/YYYY-MM-DD-GIT-N.md`
- Daily memory file written at `<memory>/daily/YYYY-MM-DD.md`
- Weekly memory file written if today is the last weekday of the week
- Monthly memory file written if today is the last weekday of the month
- Tasks are analysed and summary is included in daily memory
- Closeout task is created in configured backend (if `tasks != none`) with status `in-progress`
- Changes committed if `git: hybrid` or `git: commit-all`

## Constraints

- Read `.groove/index.md` for `tasks:`, `memory:`, and `git:` config
- Memory population order (must follow this sequence):
  1. `memory log git`
  2. `memory log daily`
  3. `memory log weekly` (only if last weekday of week, or explicit request)
  4. `memory log monthly` (only if last weekday of month, or explicit request)
- Call `task analyse` to get task summary for daily memory population
- Call `task create` to create closeout task titled `YYYY-MM-DD Closeout` with type `chore`, status `in-progress`
  - User marks this task done when they're finished — do not auto-complete
- Do NOT archive tasks during closeout — that is user-triggered only
- Git commit strategy:
  - `ignore-all`: do not commit (memory is gitignored)
  - `hybrid`: commit memory files and any unstaged changes
  - `commit-all`: commit all changes including non-memory files
- Last weekday detection: use local calendar date; handle gracefully if run on weekend
- After all standard steps: check if `.groove/hooks/closeout.md` exists
  - If it exists: read the `## Actions` section and execute each item in order; report completion per item
  - If it does not exist: skip silently
