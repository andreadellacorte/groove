# Memory Help

Display all `memory` commands with descriptions and usage notes.

## Output

Print the following, substituting live config values from `.groove/index.md`:

---

**groove memory** — log files

```
/groove:memory:<command>
```

Memory path: `<memory value from .groove/index.md>`

**Log commands** — write structured markdown memory files

| Command | Output file |
|---|---|
| `init:daily` | Create today's `<memory>/daily/YYYY-MM-DD.md` with start-of-day structure (called from daily start) |
| `log:daily` | `<memory>/daily/YYYY-MM-DD.md` |
| `log:weekly` | `<memory>/weekly/YYYY-Www.md` (last weekday of week) |
| `log:monthly` | `<memory>/monthly/YYYY-MM.md` (last weekday of month) |
| `log:git` | `<memory>/git/YYYY-MM-DD-GIT-N.md` |

**Other**

| Command | Description |
|---|---|
| `install` | Create memory directories |
| `doctor` | Check memory configuration and directory structure |

**Key rules:**
- Daily log is written at daily end only — never at daily start; daily start creates the day file via `init:daily`
- "Done today" bullets must be sourced from completed tasks and git diff — not vague summaries
- Weekly/monthly logs roll up from daily files — do not duplicate raw detail

Run `/groove:help` for all skills.

---

## Constraints

- Read `.groove/index.md` and substitute actual `memory:` value
- If `.groove/index.md` does not exist, show defaults and note config not yet created
