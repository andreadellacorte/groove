# Spec: groove vs claude-night-market Comparison

**Session**: main-2026-03-01-2
**Date**: 2026-03-02

---

## Overview

**What**: A systematic comparison of groove v0.8.8 against claude-night-market (as of 2026-03-02) across nine dimensions: architecture, commands, installation, upgrade/migration, memory, workflows, AI agent integration, config, and community. The purpose is to identify patterns groove can adopt, gaps to address, and differentiators to preserve — informing the roadmap.

**Sources**:
- groove: `skills/` at v0.8.8, `.groove/index.md`, `AGENTS.md`, `CONTRIBUTING.md`
- claude-night-market: https://github.com/athola/claude-night-market — 16 plugins, 126 skills, 114 commands, 41 agents

---

## 1. Architecture & Structure

| Dimension | groove | claude-night-market |
|---|---|---|
| Model | Single skill package (5 sub-skills) installed as a unit via `npx skills add` | Marketplace of 16 independent plugins; selectively installable |
| Entry point | `/groove` slash command routing all sub-commands hierarchically | Per-plugin slash commands; some auto-invocable by description match |
| Skill format | SKILL.md: YAML frontmatter + routing table + constraints block | SKILL.md: YAML frontmatter (when to use) + markdown instructions (what to do) |
| Mirror pattern | `skills/` (source of truth) mirrored to `.agents/skills/` (installed copy) | `plugins/<name>/skills/` installed to `~/.claude/skills/[author]-[marketplace]-[name]/` |
| Agent definitions | None — general-purpose Explore agent used for research | `agents/` directories per plugin; 41 dedicated agents total |
| Hook system | None | `hooks/` — PreToolUse handlers that intercept and block/approve tool calls |
| Plugin manifest | No manifest; SKILL.md frontmatter carries metadata | `.claude-plugin/plugin.json` per plugin with skills, agents, hooks, commands |

**Note**: groove's monolithic design means a user gets everything or nothing. night-market's marketplace model lets users compose exactly what they need — at the cost of no shared orchestration layer.

---

## 2. Commands & Invocation

| Dimension | groove | claude-night-market |
|---|---|---|
| Total commands | ~26 across 5 sub-skills | 114 across 16 plugins |
| Invocation | Explicit only: `/groove <skill> <command>` | Explicit (`/command`) OR auto-invoked when Claude matches task context to skill description |
| Auto-discovery | Not present — user must know and type the command | Yes — `attune v1.4.0` enhanced auto-matching; Claude evaluates skill frontmatter |
| Keyboard shortcuts | Not present | Supported (e.g. resume screen with preview and rename shortcut) |
| Command scope | Compound: one entry point routes everything | Flat: each plugin adds its own namespace; no cross-plugin routing |
| Dependency declaration | Not present at command level | Plugins declare inter-skill dependencies (e.g. `pensive:shared`, `imbue:evidence-logging`) |

---

## 3. Installation

| Dimension | groove | claude-night-market |
|---|---|---|
| Method | `npx skills add andreadellacorte/groove` + `/groove install` | `/plugin marketplace add athola/claude-night-market` or `npx skills add` |
| Granularity | All-or-nothing — groove ships as a unit | Selective — install individual plugins; plugins are self-contained |
| Post-install setup | `/groove install` orchestrates task backend, memory dirs, companions, AGENTS.md | No orchestration step; each plugin self-installs |
| Scaffolding | `groove config` wizard → `.groove/index.md` with guided defaults | `attune:project-init` detects project type and scaffolds config files |
| Companion skills | find-skills, agent-browser (hardcoded in install) | Plugin-declared dependencies in `plugin.json`; shallow chains by design |
| Workspace scaffolding | `groove install` creates `.groove/`, `.groove/hooks/`, `.groove/.cache/` | `attune:project-init` copies `.env`, detects package manager, installs deps |

---

## 4. Upgrading & Migration

| Dimension | groove | claude-night-market |
|---|---|---|
| Upgrade command | `/groove update` — pulls latest via `npx skills add`, applies pending migrations | `/update-plugins` — recommends upgrades based on stability metrics; detects orphaned references |
| Migration system | Ordered runner: `migrations/index.md` table; filter `To > local AND To <= installed`; idempotent per step | Not present — backward-compat design avoids breaking changes entirely |
| Version tracking | Dual: skill `version:` in SKILL.md + user `groove-version:` in `.groove/index.md` | Per-plugin version in `plugin.json`; stability metrics tracked per command (failure rate, usage freq) |
| Breaking changes | Handled via migrations (config key renames, dir moves, AGENTS.md rewrites) | Avoided by design; progressive loading preserves old configs |
| CI drift | Not present | `/update-ci` reconciles pre-commit hooks and GitHub Actions with code changes |
| Self-updating | `groove update` re-reads `update.md` from disk after pull (bootstrapping fix) | Not described |

---

## 5. Memory & Sessions

| Dimension | groove | claude-night-market |
|---|---|---|
| Session files | Named markdown at `<memory>/sessions/<name>.md` with YAML frontmatter | Native Claude Code sessions + sanctum git workspace capture before resume |
| Auto-naming | `<branch>-YYYY-MM-DD-N` when name not provided | Explicit by convention: `debugging-auth-401`, `feature-payment-milestone-2` |
| Resume | `/groove memory session resume` — lists active sessions, user picks | `claude --resume [name]` or `claude --from-pr [number]` — PR-linked sessions |
| Memory tiers | Explicit: daily / weekly / monthly / git / sessions / learned/ | Implicit: session summaries, key results, work logs (no explicit tiers) |
| Learned memory | `.groove/memory/learned/<topic>.md` — cold-tier for workflow insights | Not present as explicit tier |
| Memory search | Not present — files are read manually | Hybrid: semantic (AI embedding) + lexical (keyword); auto-compaction on context fill |
| Context compaction | Not addressed — long sessions may lose synthesis quality | Native Claude Code feature; sanctum preserves reasoning across compaction |
| Multi-session | Parallel named sessions (multiple active at once) | Parallel via git worktrees (sanctum) + PR-linked sessions |

---

## 6. Workflows

| Dimension | groove | claude-night-market |
|---|---|---|
| Compound loop | Explicit 5 stages: brainstorm → plan → work → review → compound | attune: brainstorm → plan → work → review → execute (similar structure; lighter constraints) |
| TDD enforcement | Not present | imbue: PreToolUse hook blocks file writes until tests exist — enforced, not advisory |
| Code review | Not present as built-in | pensive: NASA Power of 10 safety patterns; tracks command usage frequency and failure rates |
| Daily rituals | start (task load, hook) + end (memory logs, git commit, hook) | `/catchup` reads recent git history at session start; no end ritual |
| Spec creation | `memory session spec <topic>` → structured spec file at `sessions/specs/` | spec-kit plugin; `attune:project-init` scaffolds requirements |
| Plan docs | Templated brainstorm + implementation plan with codebase research | spec-kit task breakdown into 2-5 minute resumable chunks |
| Workflow learnings | `work compound` detects AI/process lessons → `.groove/memory/learned/<topic>.md` | pensive tracks failure rates and flags unstable workflows; no explicit capture ritual |
| Frustration detection | `work` SKILL.md: if repeated fixes or rework detected, proactively suggest `work compound` | pensive: stability metrics flag when intervention needed |

---

## 7. AI Agent Integration

| Dimension | groove | claude-night-market |
|---|---|---|
| AGENTS.md | Managed bootstrap: 2-line groove:prime stub + 2-line task stub; full context loaded on-demand | Full AGENTS.md standard support; CLAUDE.md → AGENTS.md migration supported |
| Context loading | On-demand: agent runs `/groove prime` to load workflow context into conversation | Progressive Disclosure Architecture — skills auto-discover without loading all documents |
| Hook system | Not present | PreToolUse hooks: imbue (TDD), conserve (permissions); can block, approve, or modify tool calls |
| Managed sections | `<!-- groove:managed -->` comment prevents agents editing `skills/` or `.agents/skills/` | Not needed — plugins installed to separate dir (`~/.claude/`) from user workspace |
| Allowed-tools | Declared per-skill in SKILL.md frontmatter | Declared per-plugin in `plugin.json` |
| Sub-agents | General-purpose Explore agent for plan/spec codebase research | 41 dedicated agents; each plugin can define `agents/` |
| Multi-AI compat | AGENTS.md (works with Cursor, Zed, Copilot) | AGENTS.md + CLAUDE.md; `skrills` tool syncs skills between Codex and Claude Code |

---

## 8. Config System

| Dimension | groove | claude-night-market |
|---|---|---|
| Config file | `.groove/index.md` YAML frontmatter — single source for all groove config | `.claude/settings.json` for hooks; `plugin.json` per plugin for plugin config |
| Config wizard | `/groove config` — interactive, guided wizard with defaults | Not present |
| Git strategy | Per-component: `git.memory`, `git.tasks`, `git.hooks` (ignore-all / hybrid / commit-all) | Not present |
| Cache | `.groove/.cache/` — always gitignored; `last-version-check` as plain text | Native Claude Code handles session state; no equivalent |
| Task backends | beans / linear / github / none — abstraction layer; CLI mapped in `references/backends.md` | GitHub Issues (minister plugin); no abstraction layer |
| Version in config | `groove-version:` tracks user's config state for migration eligibility | Not present |

---

## 9. Community & Ecosystem

| Dimension | groove | claude-night-market |
|---|---|---|
| Discovery | `npx skills add andreadellacorte/groove` — single install vector | LobeHub, Playbooks.com, MCPMarket, awesome-claude-code — multiple marketplaces |
| Cross-tool compat | AGENTS.md (multi-AI compatible) | AGENTS.md + CLAUDE.md; `skrills` syncs between Codex and Claude Code |
| Skill reviews | Not present | Public scores (python-testing: 89/100 with detailed community feedback) |
| Community feedback | GitHub issues | GitHub Issues + Discussions; community identifies gaps and missing docs |
| Shared learnings | groovebook (planned — PR-based commons) | Not present as a dedicated feature |
| Versioning transparency | CHANGELOG.md; CONTRIBUTING.md with versioning rules | Per-plugin version in plugin.json; stability metrics public |

---

## Gaps for Groove

Ordered by likely impact:

1. **No hook system** — PreToolUse hooks (imbue for TDD, conserve for permissions) are enforcement mechanisms that groove has no equivalent for. Groove's constraints are advisory (in SKILL.md); night-market's can block tool calls before they execute.
2. **No auto-discovery** — groove commands require explicit invocation; night-market auto-triggers by matching task context to skill descriptions. Reduces friction significantly.
3. **No semantic memory search** — groove's memory is plain markdown files read manually; night-market has hybrid semantic+lexical search across session history.
4. **No context compaction awareness** — groove doesn't account for context-window limits; long sessions risk losing synthesis quality in `memory session end` and `work compound`.
5. **No stability metrics** — pensive tracks command failure rates and flags unstable workflows; groove captures learnings manually but has no signal for which patterns are failing.
6. **No CI drift detection** — `/update-ci` reconciles pre-commit hooks and GitHub Actions; groove has no equivalent.
7. **Limited marketplace presence** — groove is not listed on LobeHub/Playbooks.com/MCPMarket; limits reach and discoverability.
8. **All-or-nothing install** — no way to cherry-pick groove sub-skills; night-market's plugin model lets users compose what they need.

---

## Groove Differentiators

Things night-market does not have that groove should preserve and develop:

1. **Robust migration system** — ordered runner with dual versioning (`skill version:` + `groove-version:`) handles config evolution that night-market sidesteps by avoiding breaking changes entirely.
2. **Git strategy per component** — fine-grained control over what gets committed (`git.memory/tasks/hooks`) is unique; useful for teams with different sharing conventions.
3. **Explicit 5-stage compound loop** — more opinionated and constraint-enforcing than attune's lifecycle; the "80% of value in plan and review" insight is baked into the skill.
4. **Learned memory tier** — `.groove/memory/learned/<topic>.md` as an explicit cold-tier for workflow insights with routing from both compound and session end; not present in night-market.
5. **Daily rituals with structured log roll-ups** — start/end with daily→weekly→monthly roll-up chain; no equivalent in night-market.
6. **Config wizard + version tracking** — `/groove config` wizard and `groove-version:` migration gating is more robust than night-market's version management.
7. **groovebook (planned)** — a shared PR-based commons for cross-user workflow learnings; no equivalent exists.

---

## Edge Cases & Observations

- night-market's auto-invocation is a double-edged sword: reduces friction but can trigger unexpected skill loading; groove's explicit model is more predictable.
- groove's SKILL.md constraints are enforced only by the agent's interpretation — no hard enforcement mechanism. night-market's PreToolUse hooks are deterministic.
- night-market's 16-plugin breadth means more surface area for bugs and inconsistencies; groove's focused 5-skill scope is easier to reason about and keep coherent.
- groove's session naming auto-convention (`<branch>-YYYY-MM-DD-N`) is more systematic than night-market's free-form naming; better for git-branch-aligned work.
- groove's `hybrid` git strategy (commit logs, ignore sessions) has no equivalent in night-market — useful for teams where logs are shareable but sessions are private.
