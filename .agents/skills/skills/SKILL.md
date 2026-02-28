---
name: skills
description: "Skill discovery, installation, and lock file management. Use when: (1) finding new skills (find); (2) installing a skill (add); (3) removing a skill (remove); (4) bootstrapping all backends (install); (5) checking for updates (check). NOT for: task management (use task); memory (use memory)."
license: MIT
allowed-tools: Bash(npx:*) Read Write Edit AskUserQuestion
metadata:
  author: andreadellacorte
  version: "0.1.0"
---

# skills

Manages agent skill extensions — discovery, installation, and lock file maintenance. Everything is a skill: workflow skills (like groove itself), integration skills, and capability skills are all managed the same way.

## Git Root Detection

Before running any command, detect the git root:

```bash
git rev-parse --show-toplevel
```

`skills-lock.json` is at git root.

## Commands

| Command | Description |
|---|---|
| `find` | Search for skills by keyword or category |
| `add <owner/repo>` | Install a skill via `npx skills add` |
| `remove <name>` | Remove a skill and update lock file |
| `install` | Install configured finder backend + run all skill installs in order |
| `check` | Check for updates to all installed skills |

## $ARGUMENTS Routing

| $ARGUMENTS | Action |
|---|---|
| `help` | → `commands/help.md` |
| `doctor` | → `commands/doctor.md` |
| `find` | → `commands/find.md` |
| `add <owner/repo>` | → `commands/add.md` |
| `remove <name>` | → `commands/remove.md` |
| `install` | → `commands/install.md` |
| `check` | → `commands/check.md` |
| _(empty)_ | → `commands/help.md` |

## Backend Pattern

Each groove skill that wraps an external backend owns its own config key and `install` command:

| Skill | Config key | Default backend |
|---|---|---|
| `task` | `tasks` | beans |
| `memory` | `sessions` | bonfire |
| `skills` | `finder` | find-skills |

`skills install` coordinates all installs in dependency order: task → memory → skills/finder.

## Design Note

`skills-lock.json` is auto-generated output — a record of installed skills. It is not the install source of truth (that lives in `.groove/index.md` config keys). Think of it like `package-lock.json` vs `package.json`.
