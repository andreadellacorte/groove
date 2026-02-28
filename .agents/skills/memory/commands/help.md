# Memory Help

Display all `memory` commands with descriptions and usage notes.

## Output

Print the following, substituting live config values from `.groove/index.md`:

---

**groove memory** — log files and session wrapper

```
/groove memory <command>
```

Current sessions backend: `<sessions value from .groove/index.md>`
Memory path: `<memory value from .groove/index.md>`

**Log commands** — write structured markdown memory files

| Command | Output file |
|---|---|
| `log daily` | `<memory>/daily/YYYY-MM-DD.md` |
| `log weekly` | `<memory>/weekly/YYYY-Www.md` (last weekday of week) |
| `log monthly` | `<memory>/monthly/YYYY-MM.md` (last weekday of month) |
| `log git` | `<memory>/git/YYYY-MM-DD-GIT-N.md` |

**Session commands** — delegate to configured sessions backend

| Command | Description |
|---|---|
| `session start` | Start session, load context |
| `session end` | End session, persist context |
| `session spec` | Create outcome spec |
| `session doc` | Create documentation |
| `session review` | Review current work |

**Other**

| Command | Description |
|---|---|
| `install` | Install configured sessions backend |
| `doctor` | Check sessions backend is configured, installed, and reachable |

**Key rules:**
- Daily log is written at closeout only — never at startup
- "Done today" bullets must be sourced from completed tasks and git diff — not vague summaries
- Weekly/monthly logs roll up from daily files — do not duplicate raw detail
- Session commands are thin wrappers — no reimplementation of backend logic

Run `/groove help` for all skills.

---

## Constraints

- Read `.groove/index.md` and substitute actual `sessions:` and `memory:` values
- If `sessions: none`, note that session commands are no-ops
- If `.groove/index.md` does not exist, show defaults and note config not yet created
