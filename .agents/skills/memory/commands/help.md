# Memory Help

Display all `memory` commands with descriptions and usage notes.

## Output

Print the following, substituting live config values from `.groove/index.md`:

---

**groove memory** — log files and session tracking

```
/groove memory <command>
```

Memory path: `<memory value from .groove/index.md>`

**Log commands** — write structured markdown memory files

| Command | Output file |
|---|---|
| `log daily` | `<memory>/daily/YYYY-MM-DD.md` |
| `log weekly` | `<memory>/weekly/YYYY-Www.md` (last weekday of week) |
| `log monthly` | `<memory>/monthly/YYYY-MM.md` (last weekday of month) |
| `log git` | `<memory>/git/YYYY-MM-DD-GIT-N.md` |

**Session commands** — named parallel session tracking

| Command | Description |
|---|---|
| `session start [name]` | Start a new named session |
| `session resume [name]` | Resume an existing active session |
| `session end [name]` | End session, capture work done |
| `session spec <topic>` | Create outcome spec |
| `session doc <topic>` | Create documentation |
| `session review` | Review current work |

**Other**

| Command | Description |
|---|---|
| `install` | Create session directories |
| `doctor` | Check memory configuration and directory structure |

**Key rules:**
- Daily log is written at closeout only — never at startup
- "Done today" bullets must be sourced from completed tasks and git diff — not vague summaries
- Weekly/monthly logs roll up from daily files — do not duplicate raw detail
- Sessions are stored as individual files at `<memory>/sessions/<name>.md`
- Auto-naming: `<branch>-<YYYY-MM-DD>-<N>` when no name is provided

Run `/groove help` for all skills.

---

## Constraints

- Read `.groove/index.md` and substitute actual `memory:` value
- If `.groove/index.md` does not exist, show defaults and note config not yet created
