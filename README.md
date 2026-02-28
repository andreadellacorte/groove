# groove

![groove](groove.png)

Compound engineering workflow skills for AI productivity — daily rhythm, task tracking, memory logs, solid tools and compound engineering loop.

```bash
npx skills add andreadellacorte/groove
```

Then bootstrap your backends:

```bash
groove install
```

---

## Skills

| Skill | Commands | Purpose |
|---|---|---|
| `daily` | `startup`, `closeout` | Bookend the workday |
| `work` | `brainstorm`, `plan`, `work`, `review`, `compound` | Reduce rework through structured stages |
| `task` | `list`, `create`, `update`, `archive`, `analyse` | Task tracking — configurable backend |
| `memory` | `log daily/weekly/monthly/git`, `session start/end/spec/doc/review` | Logs + session context |
| `skills` | `find`, `add`, `remove`, `install`, `check` | Skill management |

## Usage

```
/groove daily startup         — start the workday
/groove daily closeout        — end the workday

/groove work brainstorm       — clarify scope
/groove work plan             — write implementation plan
/groove work work             — execute the plan
/groove work review           — evaluate output
/groove work compound         — capture lessons

/groove task list             — show active tasks
/groove task create           — create a task
/groove task analyse          — summarise by status

/groove memory session start  — start session
/groove memory log daily      — write daily closeout log

/groove doctor                — check all backends are healthy
/groove update                — apply pending migrations
```

## Config

Settings live in `.groove/index.md` frontmatter — created on first run.

```yaml
---
groove-version: 0.6.0
tasks: beans               # beans | linear | github | none
memory: .groove/memory/
git:
  memory: ignore-all       # ignore-all | hybrid | commit-all
  tasks: ignore-all        # ignore-all | commit-all
  hooks: commit-all        # ignore-all | commit-all
---
```

The `.groove/` directory is gitignored by default — tune per-component with `git.*` keys.

## Requirements

- Node.js (for `npx skills`)
- Git repository

## License

MIT — [andreadellacorte](https://github.com/andreadellacorte)
