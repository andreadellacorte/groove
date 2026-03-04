---
name: groove
description: "Groove engineering workflow system. Top-level entry point. Use groove-daily-*, groove-work-*, groove-utilities-*, groove-admin-* for all workflow and admin commands."
license: MIT
allowed-tools: Read Write Edit Glob Grep Bash(git:*) Bash(beans:*) Bash(gh:*) Bash(linear:*) Bash(npx:*) Bash(mkdir:*) AskUserQuestion
metadata:
  author: andreadellacorte
  version: "0.10.1"
---

<!-- groove:managed — do not edit; changes will be overwritten by groove update -->

# groove

Groove engineering workflow system. Top-level entry point for setup, config, and meta-commands.

## $ARGUMENTS Routing

| $ARGUMENTS | Action |
|---|---|
| `help` | → `commands/help.md` |
| `install` | → `commands/install.md` |
| `config` | → `commands/config.md` |
| `update` | → `commands/update.md` |
| `check` | → `commands/check.md` |
| `prime` | → `commands/prime.md` |
| `doctor` | → `commands/doctor.md` |
| _(empty)_ | → `commands/help.md` |
