# groove

Compound engineering workflow skills — daily rhythm, task tracking, memory logs, and the compound engineering loop.

## Skills

| Skill | Commands | Purpose |
|---|---|---|
| `daily` | `startup`, `closeout` | Daily rhythm — bookend the workday |
| `work` | `brainstorm`, `plan`, `work`, `review`, `compound` | Compound engineering loop |
| `task` | `list`, `create`, `update`, `archive`, `analyse`, `install`, `config` | Task tracking (configurable backend) |
| `memory` | `log daily/weekly/monthly/git`, `session start/end/spec/doc/review`, `install` | Log files + session context wrapper |
| `skills` | `find`, `add`, `remove`, `install`, `check` | Skill management — discovery, install, lock file |

## Install

```bash
npx skills add andreadellacorte/groove
```

## Setup

After installing, run the setup script to install all configured backends:

```bash
bash scripts/setup.sh
```

## Usage

### Daily rhythm

```bash
/daily startup     # Start the workday: verify yesterday's closeout, load tasks, prepare agenda
/daily closeout    # End the workday: write memory, analyse tasks, commit if configured
```

### Compound engineering loop

```bash
/work brainstorm   # Clarify scope through dialogue, surface key decisions
/work plan         # Research codebase, write concrete implementation plan
/work work         # Execute the plan, track progress in task backend
/work review       # Evaluate output, identify lessons, decide accept/rework
/work compound     # Document lessons, update rules/templates/docs
```

### Task management

```bash
/task list         # Show active, ready tasks from configured backend
/task create       # Create task with title, type, parent, status
/task update       # Update task status, body, or metadata
/task archive      # Archive all completed/scrapped tasks (user confirms)
/task analyse      # Summarise tasks by status for closeout/daily memory
/task install      # Install configured task backend
/task config       # Show or update task backend config
```

### Memory

```bash
/memory log daily      # Write daily closeout log
/memory log weekly     # Roll up weekly memory from daily files
/memory log monthly    # Roll up monthly memory from daily files
/memory log git        # Write git summary to memory
/memory session start  # Start session (delegates to configured backend)
/memory session end    # End session
/memory session spec   # Create outcome spec
/memory session doc    # Create documentation
/memory session review # Review current work
/memory install        # Install configured sessions backend
```

### Skill management

```bash
/skills find     # Search for skills by keyword or category
/skills add      # Install a skill via npx skills add
/skills remove   # Remove a skill
/skills install  # Install configured finder backend
/skills check    # Check for updates to installed skills
```

## Config

All settings live in `.groove/index.md` frontmatter. Each skill reads from this file.

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

| Key | Values | Purpose |
|---|---|---|
| `tasks` | `beans \| linear \| github \| none` | Task tracking backend |
| `sessions` | `bonfire \| none` | Session context backend |
| `finder` | `find-skills \| none` | Skill discovery backend |
| `memory` | path string | Base path for log files |
| `git` | `ignore-all \| hybrid \| commit-all` | Git commit strategy for memory files |
| `guardrails` | nested object | Per-tool read-only and confirmation settings |

### Backend ownership

Each skill owns its backend config key and `install` command:

| Skill | Config key | Default backend |
|---|---|---|
| `task` | `tasks` | beans |
| `memory` | `sessions` | bonfire |
| `skills` | `finder` | find-skills |
