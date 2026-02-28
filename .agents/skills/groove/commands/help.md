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
| `memory` | Log files + session tracking |
| `skills` | Skill management |

**Quick reference**

```
groove   install | config | update | check | prime | doctor | help
daily    startup | closeout | doctor
work     brainstorm | plan | work | review | compound | doctor
task     list | create | update | archive | analyse | install | config | doctor
memory   log daily | log weekly | log monthly | log git
         session start | session resume | session end
         session spec | session doc | session review
         install | doctor
skills   find | add | remove | install | check | doctor
```

**Config** (`.groove/index.md`)

```
tasks:         <value>   — task backend (beans | linear | github | none)
memory:        <value>   — log file path
git.memory:    <value>   — memory commit strategy (ignore-all | hybrid | commit-all)
git.tasks:     <value>   — tasks commit strategy (ignore-all | commit-all)
git.hooks:     <value>   — hooks commit strategy (ignore-all | commit-all)
```

Run `/groove <skill> help` for detailed commands and options.

---

## Constraints

- Read `.groove/index.md` and substitute actual configured values into the config block
- If `.groove/index.md` does not exist, show defaults and note that config has not been created yet
- Keep output concise — this is a quick-reference, not a manual
