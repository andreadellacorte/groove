# Daily Help

Display all `daily` commands with descriptions and usage notes.

## Output

Print the following:

---

**groove daily** — start and end rituals

```
/groove daily <command>
```

| Command | Description |
|---|---|
| `start` | Start the workday: review yesterday, create today's daily memory, load tasks, prepare agenda |
| `end` | End the workday: write memory, analyse tasks, commit if configured |

**start** — what it does:
- Reviews yesterday's daily memory file (shows summary; warns if missing or no end section)
- Creates today's daily memory file with start-of-day structure (`memory init daily`)
- Runs `task analyse` to load current task state
- Creates a start task in the configured backend (`tasks != none`)
- Presents task list so you know what to work on

**end** — what it does:
- Writes memory in order: `memory log git` → `memory log daily` → weekly (if last weekday) → monthly (if last weekday)
- Runs `task analyse` for task summary
- Creates an end task (`in-progress`) — you mark it done when finished
- Commits if `git: hybrid` or `git: commit-all`

**Notes:**
- `daily` is a thin orchestrator — it calls `task` and `memory`, does not duplicate their logic
- Archive tasks separately with `/groove task archive` — never run automatically during end
- Memory is written at end only; daily start creates the day file and reviews yesterday

Run `/groove help` for all skills.

---

## Constraints

- Output exactly as shown — do not add or remove sections
- Read `.groove/index.md` to confirm configured `tasks:` and `git:` values; note them if relevant
