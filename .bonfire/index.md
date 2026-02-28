---
specs: .bonfire/specs/
docs: .bonfire/docs/
git: commit-all
issues: false
---

# Session Context: groove

**Date**: 2026-02-28
**Status**: Active
**Branch**: main

---

## Current State

Building groove — a skill-based workflow system for AI coding agents. Currently integrating bonfire for session context persistence.

---

## Recent Sessions

### Session 1 - 2026-02-28

**Goal**: Add bonfire skill and improve groove doctor

**Accomplished**:
- Added git repo check to `groove doctor` (bonfire depends on git)
- Installed vieko/bonfire v5.0.0 via `npx skills add`
- Added `skills-lock.json` to track installed skills
- Committed all changes

**Decisions**:
- groove doctor checks git repo as its first check, before version checks
- bonfire uses `ignore-all` git strategy (session data stays local)

**Blockers**: None

---

## Next Session Priorities

1. Continue groove development

---

## Key Resources

**Code References**:
- groove doctor: `skills/groove/commands/doctor.md`
- bonfire skill: `.agents/skills/bonfire/`
- skills lockfile: `skills-lock.json`

---

## Codemap

**Entry Points**:
- `skills/groove/` — groove skill definitions
- `.agents/skills/` — installed third-party skills

**Core Components**:
- `skills/groove/commands/` — groove subcommands (doctor, install, update…)
- `skills/memory/` — memory management skill
- `skills/task/` — task management skill
