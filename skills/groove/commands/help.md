# Groove Help

Display a structured overview of all groove skills and their commands.

## Output

Print the following, substituting live config values from `.groove/index.md` where shown:

---

**groove** — compound engineering workflow

```
/groove   /groove help   /groove prime   /groove update   /groove doctor
```

**Daily**

| Skill | Purpose |
|---|---|
| `/groove-daily-start` | Start the workday |
| `/groove-daily-end` | End the workday |

**Work**

| Skill | Purpose |
|---|---|
| `/groove-work-brainstorm` | Clarify scope through dialogue |
| `/groove-work-plan` | Write implementation plan |
| `/groove-work-exec` | Execute the plan |
| `/groove-work-review` | Evaluate output |
| `/groove-work-compound` | Capture lessons |
| `/groove-work-spec [topic]` | Create outcome spec |
| `/groove-work-audit` | Review branch for blindspots |

**Utilities — Tasks**

| Skill | Purpose |
|---|---|
| `/groove-utilities-task-list` | List active tasks |
| `/groove-utilities-task-create` | Create a task |
| `/groove-utilities-task-update` | Update a task |
| `/groove-utilities-task-archive` | Archive a task |
| `/groove-utilities-task-analyse` | Analyse task status |
| `/groove-utilities-task-install` | Set up task backend |
| `/groove-utilities-task-config` | Configure task backend |
| `/groove-utilities-task-doctor` | Check task backend health |

**Utilities — Memory**

| Skill | Purpose |
|---|---|
| `/groove-utilities-memory-log-daily` | Write daily log entry |
| `/groove-utilities-memory-log-weekly` | Roll up weekly log |
| `/groove-utilities-memory-log-monthly` | Roll up monthly log |
| `/groove-utilities-memory-log-git` | Record git activity |
| `/groove-utilities-memory-init-daily` | Initialise today's memory file |
| `/groove-utilities-memory-install` | Set up memory backend |
| `/groove-utilities-memory-doctor` | Check memory backend health |

**Config** (`.groove/index.md`)

```
tasks:         <value>   — task backend (beans | linear | github | none)
memory:        <value>   — log file path
git.memory:    <value>   — memory commit strategy (ignore-all | hybrid | commit-all)
git.tasks:     <value>   — tasks commit strategy (ignore-all | commit-all)
git.hooks:     <value>   — hooks commit strategy (ignore-all | commit-all)
```

---

## Constraints

- Read `.groove/index.md` and substitute actual configured values into the config block
- If `.groove/index.md` does not exist, show defaults and note that config has not been created yet
- Keep output concise — this is a quick-reference, not a manual
