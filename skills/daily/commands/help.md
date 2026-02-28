# Daily Help

Display all `daily` commands with descriptions and usage notes.

## Output

Print the following:

---

**groove daily** — startup and closeout rituals

```
/groove daily <command>
```

| Command | Description |
|---|---|
| `startup` | Start the workday: verify yesterday's closeout, load tasks, prepare agenda |
| `closeout` | End the workday: write memory, analyse tasks, commit if configured |

**startup** — what it does:
- Checks yesterday's daily memory file for a closeout entry (warns if missing, does not block)
- Runs `task analyse` to load current task state
- Creates a startup task in the configured backend (`tasks != none`)
- Presents task list so you know what to work on

**closeout** — what it does:
- Writes memory in order: `memory log git` → `memory log daily` → weekly (if last weekday) → monthly (if last weekday)
- Runs `task analyse` for task summary
- Creates a closeout task (`in-progress`) — you mark it done when finished
- Commits if `git: hybrid` or `git: commit-all`

**Notes:**
- `daily` is a thin orchestrator — it calls `task` and `memory`, does not duplicate their logic
- Archive tasks separately with `/groove task archive` — never run automatically during closeout
- Memory is written at closeout only, not at startup

Run `/groove help` for all skills.

---

## Constraints

- Output exactly as shown — do not add or remove sections
- Read `.groove/index.md` to confirm configured `tasks:` and `git:` values; note them if relevant
