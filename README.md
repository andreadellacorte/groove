# groove

<p align="center"><img src="groove.png" alt="groove" /></p>

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

| Skill | Purpose |
|---|---|
| `/groove-daily-start` | Start the workday |
| `/groove-daily-end` | End the workday |
| `/groove-work-brainstorm` | Clarify scope through dialogue |
| `/groove-work-plan` | Write implementation plan |
| `/groove-work-exec` | Execute the plan |
| `/groove-work-review` | Evaluate output |
| `/groove-work-compound` | Capture lessons |
| `/groove-work-spec [topic]` | Create outcome spec |
| `/groove-work-audit` | Review branch for blindspots |
| `/groove-utilities-task-list` | List active tasks |
| `/groove-utilities-task-create` | Create a task |
| `/groove-utilities-task-analyse` | Analyse task status |
| `/groove-utilities-memory-log-daily` | Write daily memory log |

## Companions

Companions extend groove and are not listed in the core skills table above. Installed and checked by `groove install` / `groove doctor`:

| Companion | Purpose |
|---|---|
| `find-skills` | Discover and install agent skills |
| `agent-browser` | Browser automation for AI agents |
| `pdf-to-markdown` | Convert PDFs to Markdown (npx-based) |

## Usage

```
/groove-daily-start           — start the workday
/groove-daily-end             — end the workday

/groove-work-brainstorm       — clarify scope
/groove-work-plan             — write implementation plan
/groove-work-exec             — execute the plan
/groove-work-review           — evaluate output
/groove-work-compound         — capture lessons

/groove-utilities-task-list   — show active tasks
/groove-utilities-task-create — create a task
/groove-utilities-task-analyse — summarise by status

/groove-utilities-memory-log-daily — write daily end log

/groove doctor                — check all backends are healthy
/groove update                — apply pending migrations
```

## Config

Settings live in `.groove/index.md` frontmatter — created on first run.

```yaml
---
groove-version: 0.10.0
tasks: beans               # beans | linear | github | none
memory: .groove/memory/
git:
  memory: ignore-all       # ignore-all | hybrid | commit-all
  tasks: ignore-all        # ignore-all | commit-all
  hooks: commit-all        # ignore-all | commit-all
---
```

Per-component `git.*` keys control what gets committed and what `.groove/.gitignore` ignores. Run `groove config` to set up interactively.

## Requirements

- Node.js (for `npx skills`)
- Git repository

## License

MIT — [andreadellacorte](https://github.com/andreadellacorte)
