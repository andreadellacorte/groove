# groove

Compound engineering workflow skills — daily rhythm, task tracking, memory logs, and the compound engineering loop.

## Skills

| Skill | Commands | Purpose |
|---|---|---|
| `daily` | `startup`, `closeout` | Daily rhythm — bookend the workday |
| `work` | `brainstorm`, `plan`, `work`, `review`, `compound` | Compound engineering loop — reduce rework |
| `task` | `list`, `create`, `update`, `archive`, `analyse`, `install`, `config` | Task tracking (configurable backend) |
| `memory` | `log daily/weekly/monthly/git`, `session start/end/spec/doc/review`, `install` | Log files + session context wrapper |
| `skills` | `find`, `add`, `remove`, `install`, `check` | Skill management — discovery, install, lock file |

## Install

```bash
npx skills add andreadellacorte/groove
```

## Setup

After installing, bootstrap all backends in one command:

```bash
bash scripts/setup.sh
```

This runs `task install`, `memory install`, and `skills install` in dependency order.

## Usage

### Daily rhythm

Start and end the workday with structured rituals.

```bash
/daily startup     # Verify yesterday's closeout, load tasks, prepare agenda
/daily closeout    # Write memory, analyse tasks, create closeout task, commit if configured
```

### Compound engineering loop

Five stages to reduce rework by front-loading clarity and back-loading lessons.

```bash
/work brainstorm   # Clarify scope, surface key decisions and open questions
/work plan         # Research codebase, write concrete implementation plan
/work work         # Execute the plan, track progress in task backend
/work review       # Evaluate output, identify lessons, decide accept/rework
/work compound     # Document lessons, update rules/templates/docs
```

> 80% of the value is in `plan` and `review`. Don't skip them.

### Task management

```bash
/task list         # Show active, ready tasks grouped by status
/task create       # Create task with title, type, parent, status
/task update       # Update task status, body, or metadata
/task archive      # Archive all completed/scrapped tasks (user confirms)
/task analyse      # Summarise tasks by status for closeout/daily memory
/task install      # Install configured task backend
/task config       # Show or update task backend config
```

### Memory

```bash
/memory log daily      # Write daily closeout log to <memory>/daily/YYYY-MM-DD.md
/memory log weekly     # Roll up weekly memory from daily files (last weekday of week)
/memory log monthly    # Roll up monthly memory from daily files (last weekday of month)
/memory log git        # Write git summary to <memory>/git/YYYY-MM-DD-GIT-N.md

/memory session start  # Start session (delegates to configured backend)
/memory session end    # End session
/memory session spec   # Create outcome spec
/memory session doc    # Create documentation
/memory session review # Review current work

/memory install        # Install configured sessions backend
```

### Skill management

```bash
/skills find <query>        # Search for skills by keyword or category
/skills add <owner/repo>    # Install a skill, update skills-lock.json
/skills remove <name>       # Remove a skill, update skills-lock.json
/skills install             # Install all configured backends in dependency order
/skills check               # Check for updates to installed skills
```

## Config

All settings live in `.groove/index.md` frontmatter. Each skill reads from this file. The `.groove/` directory is gitignored — config is local to each checkout.

```yaml
# .groove/index.md
---
tasks: beans               # beans | linear | github | none
sessions: bonfire          # bonfire | none
finder: find-skills        # find-skills | none
memory: .groove/memory/
git: ignore-all            # ignore-all | hybrid | commit-all
guardrails:
  default:
    read-only: false
    require-confirmation: false
  gmail:
    require-confirmation: true
  github:
    require-confirmation: true
---
```

### Config keys

| Key | Default | Values | Purpose |
|---|---|---|---|
| `tasks` | `beans` | `beans \| linear \| github \| none` | Task tracking backend |
| `sessions` | `bonfire` | `bonfire \| none` | Session context backend |
| `finder` | `find-skills` | `find-skills \| none` | Skill discovery backend |
| `memory` | `.groove/memory/` | any path | Base path for log files |
| `git` | `ignore-all` | `ignore-all \| hybrid \| commit-all` | Git commit strategy for memory files |
| `guardrails` | see below | nested object | Per-tool read-only and confirmation settings |

**Git strategies:**
- `ignore-all` — memory files are gitignored (default, keeps memory private)
- `hybrid` — memory files committed during closeout only
- `commit-all` — all changes committed automatically

### Backend ownership

Each skill owns its backend config key and `install` command:

| Skill | Config key | Default backend | Install |
|---|---|---|---|
| `task` | `tasks` | beans | `task install` |
| `memory` | `sessions` | bonfire | `memory install` |
| `skills` | `finder` | find-skills | `skills install` |

## File structure

```
groove/
├── README.md
├── LICENSE
├── CHANGELOG.md
├── scripts/
│   └── setup.sh              # Bootstrap all backends
├── skills-lock.json          # Installed skills record (auto-generated)
└── skills/
    ├── daily/                # Startup + closeout rituals
    ├── work/                 # Compound engineering loop
    ├── task/                 # Backend-agnostic task management
    ├── memory/               # Log files + session wrapper
    └── skills/               # Skill discovery and install
```

Each skill follows [agentskills.io](https://agentskills.io/specification) layout:

```
<skill>/
├── SKILL.md          # Metadata, routing table, bootstrap
├── commands/         # One file per command (outcome-based)
├── templates/        # Output scaffolds with [PLACEHOLDER] values
└── references/       # Backend mappings and reference docs
```

## Memory file structure

```
<memory>/             # default: .groove/memory/
├── daily/
│   └── YYYY-MM-DD.md
├── weekly/
│   └── YYYY-Www.md   # ISO week (e.g. 2026-W09)
├── monthly/
│   └── YYYY-MM.md
└── git/
    └── YYYY-MM-DD-GIT-N.md
```
