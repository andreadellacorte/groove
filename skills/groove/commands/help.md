# Groove Help

Display a structured overview of all groove skills and their commands.

## Output

Print the following, substituting live config values from `.groove/index.md` where shown:

---

**groove** — compound engineering workflow

```
/groove <skill> <command>
```

**Skills**

| Skill | Purpose |
|---|---|
| `daily` | Bookend the workday |
| `work` | Compound engineering loop |
| `task` | Task tracking |
| `memory` | Log files + session wrapper |
| `skills` | Skill management |

**Quick reference**

```
daily    startup | closeout
work     brainstorm | plan | work | review | compound
task     list | create | update | archive | analyse | install | config
memory   log daily | log weekly | log monthly | log git
         session start | session end | session spec | session doc | session review | install
skills   find | add | remove | install | check
```

**Config** (`.groove/index.md`)

```
tasks:    <value>   — task backend (beans | linear | github | none)
sessions: <value>   — session backend (bonfire | none)
finder:   <value>   — skill finder (find-skills | none)
memory:   <value>   — log file path
git:      <value>   — commit strategy (ignore-all | hybrid | commit-all)
```

Run `/groove <skill> help` for detailed commands and options.

---

## Constraints

- Read `.groove/index.md` and substitute actual configured values into the config block
- If `.groove/index.md` does not exist, show defaults and note that config has not been created yet
- Keep output concise — this is a quick-reference, not a manual
