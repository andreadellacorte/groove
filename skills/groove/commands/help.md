# Groove Help

Display a structured overview of all groove skills and their commands.

## Output

Print the following, substituting live config values from `.groove/index.md` where shown:

---

**groove** — compound engineering workflow

```
/groove:help   /groove:prime   /groove:<skill>:<command>
```

**Skills**

| Skill | Purpose |
|---|---|
| `daily` | Bookend the workday |
| `work` | Compound engineering loop |
| `task` | Task tracking |
| `memory` | Log files |

**Quick reference**

```
groove   :help | :install | :config | :update | :check | :prime | :doctor
daily    :help | :start | :end
work     :help | :brainstorm | :plan | :work | :review | :compound | :spec | :audit
task     :help | :list | :create | :update | :archive | :analyse | :install | :config | :doctor
memory   :help | :doctor | :init:daily | :log:daily | :log:weekly | :log:monthly | :log:git | :install
```

**Config** (`.groove/index.md`)

```
tasks:         <value>   — task backend (beans | linear | github | none)
memory:        <value>   — log file path
git.memory:    <value>   — memory commit strategy (ignore-all | hybrid | commit-all)
git.tasks:     <value>   — tasks commit strategy (ignore-all | commit-all)
git.hooks:     <value>   — hooks commit strategy (ignore-all | commit-all)
```

Run `/groove:<skill>:help` for detailed commands and options.

---

## Constraints

- Read `.groove/index.md` and substitute actual configured values into the config block
- If `.groove/index.md` does not exist, show defaults and note that config has not been created yet
- Keep output concise — this is a quick-reference, not a manual
