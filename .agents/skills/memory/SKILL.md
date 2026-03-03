---
name: memory
description: "Daily/weekly/monthly/git log population. Use when: (1) writing daily end log; (2) rolling up weekly/monthly memory; (3) recording git summary. NOT for: task management (use task); compound loop or specs/audit (use work)."
license: MIT
allowed-tools: Bash(git:*) Bash(mkdir:*) Bash(npx:*) Read Write Edit Glob AskUserQuestion
metadata:
  author: andreadellacorte
  version: "0.1.0"
---

<!-- groove:managed — do not edit; changes will be overwritten by groove update -->

# memory

Structured markdown memory files for daily, weekly, monthly, and git logs. Outcome specs and branch review live under **work** (`work:spec`, `work:audit`).

## Git Root Detection

Before running any command, detect the git root:

```bash
git rev-parse --show-toplevel
```

All paths (`memory:` config value, log files) are relative to git root.

## Commands

### Log Commands

| Command | Description |
|---|---|
| `init daily` | Create today's daily memory file with start-of-day structure (called from daily start) |
| `log daily` | Write daily end log to `<memory>/daily/YYYY-MM-DD.md` |
| `log weekly` | Roll up weekly memory from daily files |
| `log monthly` | Roll up monthly memory from daily files |
| `log git` | Write git summary to `<memory>/git/YYYY-MM-DD-GIT-N.md` |

### Other

| Command | Description |
|---|---|
| `install` | Create memory directories (daily, weekly, monthly, git, specs, learned) |

## $ARGUMENTS Routing

| $ARGUMENTS | Action |
|---|---|
| `help` | → `commands/help.md` |
| `doctor` | → `commands/doctor.md` |
| `init daily` | → `commands/init/daily.md` |
| `log daily` | → `commands/log/daily.md` |
| `log weekly` | → `commands/log/weekly.md` |
| `log monthly` | → `commands/log/monthly.md` |
| `log git` | → `commands/log/git.md` |
| `install` | → `commands/install.md` |
| _(empty)_ | → `commands/help.md` |

## Bootstrap

If `.groove/index.md` does not exist, create from `skills/groove/templates/index.md` before proceeding.

If the `memory:` path does not exist, create the full directory structure:

```bash
mkdir -p <memory>/daily <memory>/weekly <memory>/monthly <memory>/git
```

## File Structure

```
<memory>/              # default: .groove/memory/
├── daily/
│   └── YYYY-MM-DD.md
├── weekly/
│   └── YYYY-Www.md
├── monthly/
│   └── YYYY-MM.md
├── git/
│   └── YYYY-MM-DD-GIT-N.md
├── specs/
└── learned/

skills/memory/
├── SKILL.md
├── commands/
│   ├── log/
│   │   ├── daily.md
│   │   ├── weekly.md
│   │   ├── monthly.md
│   │   └── git.md
│   ├── init/
│   │   └── daily.md
│   └── install.md
└── templates/
    └── log/
        ├── daily.md
        ├── weekly.md
        ├── monthly.md
        └── git.md
```
