# groove

<p align="center"><img src="groove.png" alt="groove" /></p>

Compound engineering workflow skills for AI productivity — daily rhythm, task tracking, memory logs, solid tools and compound engineering loop.

```bash
npx skills add andreadellacorte/groove
```

Then bootstrap your backends:

```bash
/groove-admin-install
```

---

## Skills

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
| `/groove-work-doc [topic]` | Document how a component works |

**Utilities — Tasks**

| Skill | Purpose |
|---|---|
| `/groove-utilities-task-list` | List active tasks |
| `/groove-utilities-task-create` | Create a task |
| `/groove-utilities-task-update` | Update a task |
| `/groove-utilities-task-archive` | Archive a completed task |
| `/groove-utilities-task-analyse` | Analyse task status |
| `/groove-utilities-task-install` | Set up task backend |
| `/groove-utilities-task-config` | Configure task backend |
| `/groove-utilities-task-doctor` | Health check task backend |

**Utilities — Memory**

| Skill | Purpose |
|---|---|
| `/groove-utilities-memory-log-daily` | Write daily memory log |
| `/groove-utilities-memory-log-weekly` | Roll up weekly log from daily entries |
| `/groove-utilities-memory-log-monthly` | Roll up monthly log from weekly entries |
| `/groove-utilities-memory-log-git` | Record git activity in memory |
| `/groove-utilities-memory-install` | Set up memory backend |
| `/groove-utilities-memory-doctor` | Health check memory backend |
| `/groove-utilities-memory-mistakes` | Log and resolve workflow mistakes |
| `/groove-utilities-memory-promises` | Capture and resolve deferred items |
| `/groove-utilities-memory-retrospective [week\|month\|all]` | Analyse ratings, mistakes, and learnings |
| `/groove-utilities-memory-graduate [topic]` | Promote a stable lesson to AGENTS.md permanently |

**Utilities — Session**

| Skill | Purpose |
|---|---|
| `/groove-utilities-prime` | Load workflow context into conversation |
| `/groove-utilities-check` | Check if a newer version is available |
| `/groove-utilities-onboard` | Generate GROOVE.md contributor onboarding guide |

**Admin**

| Skill | Purpose |
|---|---|
| `/groove-admin-install` | Install backends and bootstrap AGENTS.md |
| `/groove-admin-config` | Create or update `.groove/index.md` |
| `/groove-admin-update` | Pull latest and apply migrations |
| `/groove-admin-help` | Show all commands with live config |
| `/groove-admin-doctor` | Run all health checks |

**Groovebook** *(opt-in — requires `groovebook:` in config)*

| Skill | Purpose |
|---|---|
| `/groove-groovebook-publish` | Publish a workflow learning to the shared commons |
| `/groove-groovebook-review` | Browse and review open learning PRs |

## Companions

Companions extend groove and are not listed in the core skills table above. Installed and checked by `/groove-admin-install` / `/groove-admin-doctor`:

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
/groove-utilities-memory-mistakes  — log a workflow mistake
/groove-utilities-memory-promises  — capture a deferred item

/groove-utilities-prime       — load workflow context
/groove-admin-doctor          — check all backends are healthy
/groove-admin-update          — apply pending migrations
```

## Config

Settings live in `.groove/index.md` frontmatter — created on first run by `/groove-admin-config`.

```yaml
---
groove-version: 0.12.15
tasks: beans               # beans | linear | github | none
memory: .groove/memory/
recent_memory_days: 5      # days of daily memory to review at startup
specs: .groove/memory/specs/  # where specs are saved; set to specs/ for project-root visibility
groovebook:                # owner/repo of shared learning commons; leave blank to disable
git:
  memory: ignore-all       # ignore-all | hybrid | commit-all
  tasks: ignore-all        # ignore-all | commit-all
  hooks: commit-all        # ignore-all | commit-all
---
```

Per-component `git.*` keys control what gets committed and what `.groove/.gitignore` ignores.

**Identity file**: create `.groove/IDENTITY.md` with free-form context (mission, goals, active projects) — `groove-utilities-prime` reads it and injects it into every session automatically.

## Hooks

groove has a lightweight markdown hook system — no runtime required. Two lifecycle points are available:

| Hook file | Trigger |
|---|---|
| `.groove/hooks/start.md` | End of `/groove-daily-start` |
| `.groove/hooks/end.md` | End of `/groove-daily-end` |

Each hook file has a `## Actions` section. groove reads and executes each action in order when the hook fires. `/groove-admin-install` scaffolds both files with commented examples.

Example `.groove/hooks/end.md`:

```markdown
# Hook: Session End

## Actions

- Run `git push` to push today's commits
```

Hooks follow the `git.hooks` git strategy — set `commit-all` to share hooks with the team, `ignore-all` to keep them local.

## Platform compatibility

groove runs inside any AI coding assistant that supports Claude Code-style slash commands (`.claude/skills/` or `.agents/skills/` directories).

| Platform | Status | Notes |
|---|---|---|
| Claude Code | Verified | Primary target; fully tested |
| Cursor | Unverified | Skills directory format compatible; not tested |
| Cline | Unverified | `.agents/skills/` path recognised; not tested |
| Amp | Unverified | Skills directory supported; not tested |

## Requirements

- Node.js (for `npx skills`)
- Git repository

## License

MIT — [andreadellacorte](https://github.com/andreadellacorte)
