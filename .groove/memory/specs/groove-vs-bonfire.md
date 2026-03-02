# Spec: groove vs bonfire Comparison

**Session**: main-2026-03-01-2
**Date**: 2026-03-02

---

## Overview

**What**: A systematic comparison of groove v0.8.8 against bonfire v5.5.0 (vieko/bonfire) across 11 dimensions: purpose/scope, architecture, commands, installation, config, session/memory model, spec & doc creation, upgrading/migration, AI agent integration, task management, and daily rituals/workflows.

**Historical note**: These tools have a direct relationship — groove v0.4.x used bonfire as its memory backend. Groove v0.5.0 (2026-02-28) removed the bonfire dependency and implemented native multi-session tracking. Bonfire and groove now occupy adjacent but distinct positions: bonfire is a focused session persistence skill; groove is a compound engineering workflow system.

**Sources**:
- bonfire: https://github.com/vieko/bonfire — v5.5.0, 6 commands, single living document model
- groove: https://github.com/andreadellacorte/groove — v0.8.8, 5 sub-skills, ~26 commands

---

## 1. Purpose & Scope

| Dimension | groove | bonfire |
|---|---|---|
| Core purpose | Compound engineering workflow system — structured daily rituals, 5-stage work cycle, multi-tier memory, task management | Session context persistence — "pick up exactly where you left off" |
| Problem solved | Unstructured AI workflows cause rework; learnings fade between sessions and cycles | AI agents are stateless; context is lost between conversations |
| Design philosophy | Structured stages with enforced constraints; compound learning across time horizons | "Commands define outcomes, not procedures" — agents receive success criteria, not steps |
| Scope | 5 sub-skills: groove, daily, work, task, memory | Single skill, single concern |
| Target user | Developer wanting a complete, opinionated productivity system | Developer wanting minimal, zero-dependency context persistence |

**Note**: bonfire's scope is deliberately narrow — it solves one problem elegantly. groove's scope is deliberately broad — it addresses the entire engineering workflow.

---

## 2. Architecture & Structure

| Dimension | groove | bonfire |
|---|---|---|
| Install directory | `.groove/` (project-local config + state) | `.bonfire/` (project-local context + specs + docs) |
| Core artifact | `.groove/index.md` — config only (YAML frontmatter) | `.bonfire/index.md` — living context document (YAML frontmatter + rich markdown content) |
| Sub-directories | `memory/sessions/`, `memory/daily/`, `memory/weekly/`, `memory/monthly/`, `memory/git/`, `tasks/`, `hooks/`, `.cache/` | `specs/`, `docs/` |
| Skill structure | Modular — groove routes to daily, work, task, memory sub-skills | Flat — one skill, 6 command files |
| Companion skills | find-skills, agent-browser (installed by `groove install`) | None — zero dependencies |
| Migrations dir | `skills/groove/migrations/` (7 migration files + index) | Not present |
| File count | ~40+ files across 5 sub-skills | ~20 files |

---

## 3. Commands & Invocation

| Dimension | groove | bonfire |
|---|---|---|
| Total commands | ~26 across 5 sub-skills | 6 |
| Invocation prefix | `/groove <skill> <command>` | `/bonfire <command>` |
| Session start | `groove memory session start` | `/bonfire start` |
| Session end | `groove memory session end` | `/bonfire end` |
| Spec creation | `groove memory session spec <topic>` | `/bonfire spec <topic>` |
| Doc creation | `groove memory session doc <topic>` | `/bonfire doc <topic>` |
| Review | Not present as standalone command | `/bonfire review` — blindspot detection, categorized by Fix Now / Needs Spec / Create Issues |
| Config | `groove config` | `/bonfire config` |
| Daily startup | `groove daily startup` | Not present |
| Daily closeout | `groove daily closeout` | Not present |
| Work stages | `groove work brainstorm/plan/work/review/compound` | Not present |
| Task management | `groove task create/list/update/archive/analyse` | Not present |
| Update/migrate | `groove update` | Not present |
| Health check | `groove doctor` | Not present |
| Context load | `groove prime` | Not present (implicit on `/bonfire start`) |

---

## 4. Installation & Setup

| Dimension | groove | bonfire |
|---|---|---|
| Install command | `npx skills add andreadellacorte/groove` + `/groove install` | `npx skills add vieko/bonfire` |
| Bootstrap required | Yes — `/groove install` orchestrates backends, memory dirs, AGENTS.md, companions | No — auto-initializes `.bonfire/` on first `/bonfire start` |
| Config wizard | `groove config` — interactive, guided | `/bonfire config` — interactive, lightweight |
| Post-install steps | Choose task backend (beans/linear/github/none), configure git strategies, install companions | None — ready immediately |
| Platform compat | Agent Skills-compatible platforms | 20+ platforms (Claude Code, Cursor, Cline, Amp, Junie, OpenCode, OpenHands, Goose, etc.) |
| Dependencies | Node.js; optional: beans, linear CLI, gh CLI | None |

---

## 5. Config System

| Dimension | groove | bonfire |
|---|---|---|
| Config file | `.groove/index.md` — YAML frontmatter only | `.bonfire/index.md` — YAML frontmatter + living content |
| Config keys | `groove-version`, `tasks`, `memory`, `git.memory`, `git.tasks`, `git.hooks` (6 keys) | `specs`, `docs`, `git`, `issues` (4 keys) |
| Version tracking | `groove-version:` tracks config state for migration eligibility | Not present |
| Task backend | `tasks: beans \| linear \| github \| none` | Not present |
| Issues integration | Not present (task backends are separate) | `issues: true \| false` — optional link to GitHub Issues or generic tracker |
| Git strategy | Per-component: `git.memory`, `git.tasks`, `git.hooks` | Single global: `git: ignore-all \| hybrid \| commit-all` |
| Spec/doc paths | Fixed at `<memory>/sessions/specs/` and `<memory>/sessions/docs/` | Configurable: `specs:` and `docs:` keys (can point to project-level dirs) |

---

## 6. Session & Memory Model

| Dimension | groove | bonfire |
|---|---|---|
| Core artifact | Multiple files across tiers | Single living document (`.bonfire/index.md`) |
| Session storage | Individual file per session: `<memory>/sessions/<name>.md` | Updates to single `index.md`; completed work moves to "Recent Sessions" section |
| Memory tiers | daily / weekly / monthly / git / sessions / learned/ | Single document with archival to CLAUDE.md or system docs |
| Hot context | Within the current session file | `index.md` (current state, decisions, next priorities) |
| Cold context | `learned/<topic>.md` — workflow insights | CLAUDE.md or permanent system docs (graduated from index.md) |
| Roll-up | Weekly/monthly logs aggregate from daily/weekly | Not present — mature knowledge moves out of bonfire entirely |
| Signal capture | Manual — user writes to `learned/` via compound or session end prompt | Not present — health check detects stale content at session end |
| Context window management | Not addressed | Warns at 20K tokens; recommends archiving older sessions |
| Multi-session | Parallel named sessions supported | Not explicit — index.md represents one ongoing project context |

**Key difference**: bonfire's `index.md` is a **temporal document** (what happened, what's next) and graduates stable knowledge out to CLAUDE.md. Groove's memory is a **permanent archive** — sessions accumulate and roll up into weekly/monthly logs.

---

## 7. Spec & Doc Creation

Both tools have spec and doc creation — this is the most direct overlap.

| Dimension | groove | bonfire |
|---|---|---|
| Spec command | `groove memory session spec <topic>` | `/bonfire spec <topic>` |
| Doc command | `groove memory session doc <topic>` | `/bonfire doc <topic>` |
| Spec path | `<memory>/sessions/specs/<topic>.md` (fixed) | Configurable via `specs:` key (default `.bonfire/specs/`) |
| Doc path | `<memory>/sessions/docs/<topic>.md` (fixed) | Configurable via `docs:` key (default `.bonfire/docs/`) |
| Spec sections | Overview, Decisions, Implementation Steps, Edge Cases | Overview, Decisions, Implementation Steps, Edge Cases |
| Doc sections | Not fully specified | Overview, Key Files, How It Works, Gotchas |
| Split specs | Recommended for natural seams (parent + child specs) | Recommended for natural seams (same pattern) |
| Index registration | Not linked to session index | Registered in `.bonfire/index.md` |
| Research method | Explore agent for codebase research | Explore agent for codebase research |
| Isolation | Written by general-purpose agent in isolated context | Written in isolated context |
| Topic sanitization | Strip path separators, special chars, traversal patterns | Strip path separators, special chars, traversal patterns (`../`) |

**Note**: The spec and doc formats are nearly identical — both tools converged on the same pattern independently. The main difference is that bonfire links spec/doc back to its living `index.md`; groove treats them as standalone session artefacts.

---

## 8. Upgrading & Migration

| Dimension | groove | bonfire |
|---|---|---|
| Upgrade command | `groove update` — pulls latest via `npx skills add`, applies pending migrations | Not present — `npx skills add vieko/bonfire` re-installs; no migration runner |
| Migration system | Ordered runner: `migrations/index.md` table; filter `To > local AND To <= installed`; idempotent | Not present — backward-compat design; breaking config keys auto-detected on next run |
| Version tracking | Dual: skill `version:` in SKILL.md + user `groove-version:` in `.groove/index.md` | Skill `version:` in SKILL.md only |
| Breaking changes | Handled via migrations (v5.5.0 example: `linear: true/false` → `issues: true/false`) | Config keys auto-migrate on detection (e.g. `linear:` → `issues:` in v5.0.0) |
| CHANGELOG | Yes — every version documented | Yes — CHANGELOG.md maintained |
| Config evolution | Migrations add/rename/remove keys with user data preserved | Auto-detection replaces formal migration |

---

## 9. AI Agent Integration

| Dimension | groove | bonfire |
|---|---|---|
| AGENTS.md | Managed 2-line bootstrap: `Run /groove prime` + `Run beans prime` stubs | Minimal: table of commands + design principles; notes "this repo uses bonfire" |
| Context loading | On-demand: `/groove prime` loads workflow context into conversation | Implicit: `/bonfire start` reads and summarises `index.md` into context |
| Managed sections | `<!-- groove:managed -->` prevents edits to skills/ | Not present |
| Allowed-tools | Per-skill in SKILL.md frontmatter (git, beans, gh, npx, mkdir, etc.) | Bash (git, mkdir, rm), Read, Write, Edit, Glob, Grep, AskUserQuestion |
| Sub-agents | General-purpose Explore agent for plan/spec research | Explore agent for spec/doc/review research; isolated general-purpose agent for writing |
| Hook system | Not present | Not present |
| Platform compat | Agent Skills format (multi-platform) | Agent Skills format (20+ platforms explicitly listed) |

---

## 10. Task Management

| Dimension | groove | bonfire |
|---|---|---|
| Built-in tasks | Yes — `groove task` sub-skill | No |
| Backends | beans (local markdown), linear, github, none | Not applicable |
| Task lifecycle | create, list, update, archive, analyse | Not applicable |
| Issues integration | Via `tasks: github` backend | `issues: true/false` — optional link to tracker; no task CRUD |
| Work stage tasks | Each compound stage creates a named task: `YYYY-MM-DD, N. <Stage>` | Not present |

---

## 11. Daily Rituals & Workflows

| Dimension | groove | bonfire |
|---|---|---|
| Daily startup | `groove daily startup` — load tasks, check yesterday's closeout, run hook | Not present |
| Daily closeout | `groove daily closeout` — write memory logs, git commit per strategy, run hook | Not present |
| Work stages | 5 explicit stages: brainstorm → plan → work → review → compound | Implicit: start → work → end |
| Stage tasks | Each stage creates a task in the configured backend | Not present |
| Review | `groove work review` — evaluate output against plan, identify lessons | `/bonfire review` — blindspot detection on branch diff; Fix Now / Needs Spec / Create Issues |
| Compound/learning | `groove work compound` — update project files, detect workflow learnings | Not present |
| Workflow learnings | compound + session end prompt → `learned/<topic>.md` | Not present; mature knowledge graduates to CLAUDE.md |
| Hooks | `.groove/hooks/startup.md` and `closeout.md` — custom user-defined actions | Not present |

---

## Differentiators

### groove over bonfire

1. **Compound engineering loop** — 5 explicit stages (brainstorm→plan→work→review→compound) with per-stage constraints; bonfire has no equivalent structured workflow
2. **Multi-tier memory** — daily/weekly/monthly roll-up captures knowledge at different timescales; bonfire has a single living document
3. **Task management** — beans/linear/github/none abstraction with full task lifecycle; bonfire has only an optional issues link
4. **Daily rituals** — startup/closeout with hooks, task analysis, git commit; bonfire has no daily ceremony
5. **Workflow learning accumulation** — `learned/<topic>.md` cold tier populated from compound + session end; bonfire has no dedicated long-term insight tier
6. **Formal migration system** — ordered migration runner handles config evolution across any version gap; bonfire auto-detects key changes but has no runner
7. **Per-component git strategy** — independent `git.memory`, `git.tasks`, `git.hooks`; bonfire has a single global strategy
8. **Version tracking** — dual versioning (skill + user config) enables migration eligibility tracking; bonfire tracks skill version only

### bonfire over groove

1. **Zero setup** — auto-initializes on first `/bonfire start`; no bootstrap command, no wizard, no backend selection
2. **Zero dependencies** — no external services, no companion skills, no npm scripts beyond `npx skills add`
3. **Living document model** — `index.md` is a rich temporal artifact with current state, decisions, next priorities; groove's config is YAML-only
4. **Review command** — `/bonfire review` proactively detects blindspots and categorizes findings (Fix Now / Needs Spec / Create Issues); groove has no standalone review for branch diffs
5. **Configurable spec/doc paths** — `specs:` and `docs:` keys can point to project-level directories (not just `.bonfire/`); groove's paths are fixed under `<memory>/sessions/`
6. **Context window awareness** — warns at 20K tokens and recommends cleanup; groove doesn't account for this
7. **Stale reference detection** — `/bonfire end` checks for broken links, orphaned specs, closed PRs; groove has no equivalent health check
8. **Broader platform support** — explicitly tested on 20+ Agent Skills platforms; groove targets Claude Code primarily
9. **Knowledge graduation** — stable knowledge moves from `index.md` to CLAUDE.md; explicit mechanism for keeping context lean
10. **Issues integration in config** — `issues: true/false` provides a direct link to GitHub Issues from within config; groove's github issues backend requires fuller setup

---

## Scope Observation

bonfire and groove share the same foundational pattern (Agent Skills format, markdown-based, git-native, spec/doc creation) but serve different scope. bonfire is a scalpel: minimal, focused, zero-friction session persistence that works on 20+ platforms out of the box. groove is a system: opinionated, compound, structured around daily rituals and multi-stage work cycles.

The most interesting overlap is spec/doc creation — both tools converged on identical format (Overview, Decisions, Implementation Steps, Edge Cases) and identical method (Explore agent + isolated write). The difference is organisational: bonfire registers specs back to the living `index.md`; groove treats them as standalone session artefacts.

groove's `/bonfire review` equivalent gap is worth noting: groove has `work review` (evaluate output against plan) but no equivalent of bonfire's branch-diff-based blindspot detection with effort-categorised findings. That's a distinct and useful capability groove doesn't cover.

The historical arc: groove used bonfire as its memory backend until v0.5.0, then built its own native session system. The systems have since diverged in scope — bonfire stayed focused on persistence, groove grew into a full workflow system.
