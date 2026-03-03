# Spec: groove vs Personal AI Infrastructure (PAI) Comparison

**Session**: main-2026-03-01-2
**Date**: 2026-03-02

---

## Overview

**What**: A systematic comparison of groove v0.8.8 against Daniel Miessler's Personal AI Infrastructure (PAI) v4.0.3 across 13 dimensions: architecture, commands, installation, upgrade/migration, memory, workflows, AI agent integration, config, hooks, security, identity/goals, observability, and community.

**Why**: PAI represents a more ambitious vision — closer to a full personal AI OS (TypeScript/Bun, 22 hooks, pipelines, voice, named agent personas, 237 Fabric patterns, persistent identity). The comparison surfaces what groove could adopt at its own lighter scale, confirms groove's differentiators, and draws a scope boundary between the two tools.

**Sources**:
- groove: `skills/` at v0.8.8, `.groove/index.md`, `AGENTS.md`, `CONTRIBUTING.md`
- PAI: https://github.com/danielmiessler/Personal_AI_Infrastructure v4.0.3 — TypeScript/Bun, 338 workflows, 11 skill categories, 22 hooks

---

## 1. Architecture & Structure

| Dimension | groove | PAI |
|---|---|---|
| Type | Claude Code skill package (markdown SKILL.md files) | Full TypeScript/Bun platform installed to `~/.claude/` |
| Core model | 5 markdown sub-skills: groove, daily, work, task, memory | Skills + Actions + Pipelines + Flows + Hooks + Agents + TELOS |
| Entry point | `/groove` slash command routing all sub-commands | `pai` CLI + slash commands + intent-matched skill activation |
| Skill format | SKILL.md: YAML frontmatter + routing table + constraints block | SKILL.md: YAML frontmatter (USE WHEN clause) + workflow docs |
| Code execution | Bash via allowed-tools (git, gh, beans, npx, mkdir) | TypeScript/Bun — full runtime with HTTP, filesystem, external APIs |
| Companion dirs | `.agents/skills/` (find-skills, agent-browser) | `~/.claude/PAI/`, `~/.claude/MEMORY/`, `~/.claude/hooks/`, `~/.claude/agents/` |
| UNIX philosophy | Not explicitly; routing is hierarchical | Core principle — atomic actions piped through standard interfaces |

**Note**: groove's monolithic markdown design is portable and lightweight — anyone with `npx` can install it without a runtime. PAI requires Bun and runs compiled TypeScript; far more capable but heavier.

---

## 2. Commands & Invocation

| Dimension | groove | PAI |
|---|---|---|
| Total commands | ~26 across 5 sub-skills | 338 workflows across 11 skill categories + 237 Fabric patterns |
| Invocation | Explicit only: `/groove:<skill>:<command>` | Intent-matched ("USE WHEN" clause) OR explicit slash command |
| Auto-discovery | Not present | Yes — Claude evaluates skill frontmatter and auto-triggers by context |
| CLI tool | Not present | `bun algorithm.ts` (Algorithm loop) and `bun pai.ts` (actions/pipelines) for headless/scheduled use |
| Keyboard shortcuts | Not present | Supported (e.g. resume screen with preview and rename) |
| Naming convention | Lowercase, hyphenated sub-commands | System skills: TitleCase; Personal skills: `_MYSKILL` (never shared) |

---

## 3. Installation

| Dimension | groove | PAI |
|---|---|---|
| Method | `npx skills add andreadellacorte/groove` + `/groove:install` | `git clone` + `cp -r .claude ~/` + `bash install.sh` |
| Bootstrap | SKILL-based orchestration — groove install is itself a skill | Shell script installs Bun, Git, Claude Code, configures identity |
| Post-install setup | `groove config` wizard → `.groove/index.md` | Interactive installer configures `settings.json` (identity, voice, preferences) |
| OS support | macOS, Linux | macOS, Linux; Windows not supported |
| Granularity | All-or-nothing (groove ships as a unit) | Single install (all PAI features bundled); USER/ for personal extensions |
| User/system separation | `.groove/` for user state; `skills/` for managed code (never co-located) | Explicit USER/ tier overrides SYSTEM/root; USER/ never synced to public repo |

---

## 4. Upgrading & Migration

| Dimension | groove | PAI |
|---|---|---|
| Upgrade method | `/groove:update` → `npx skills add` + ordered migration runner | Copy new Releases/ files + re-run `install.sh`; preserves USER/ |
| Migration system | Ordered runner: `migrations/index.md` table; `To > local AND To <= installed`; idempotent | Not present — backward-compat design; installer merges settings intelligently |
| Version tracking | Dual: skill `version:` in SKILL.md + user `groove-version:` in `.groove/index.md` | `settings.json` tracks stats (sessions, files, workflows) but not config version |
| Breaking changes | Handled via migrations (config key renames, dir moves, AGENTS.md rewrites) | Avoided by design; USER/ never overwritten |
| Version history | `CHANGELOG.md` + `CONTRIBUTING.md` versioning rules | `Releases/` directory with full version snapshots (v2.3 through v4.0.3) |

---

## 5. Memory & Sessions

| Dimension | groove | PAI |
|---|---|---|
| Session files | Named markdown at `<memory>/sessions/<name>.md` with YAML frontmatter | Native Claude Code sessions + `WorkCompletionLearning` hook on SessionEnd |
| Memory tiers (explicit) | daily / weekly / monthly / git / sessions / learned/ | WORK/ / LEARNING/ / RESEARCH/ / SECURITY/ / STATE/ |
| Hot memory | Not present | STATE/ — JSON, fast-access, mutable runtime data |
| Warm memory | Daily/weekly/monthly logs | WORK/ — project metadata, criteria, decisions |
| Cold memory | learned/ — long-term workflow insights | LEARNING/SIGNALS/ — ratings.jsonl, pattern analysis; 30-day retention on session transcripts |
| Signal capture | Manual — user writes to learned/ | Automatic — every interaction generates ratings, sentiment, success/failure → LEARNING/ |
| Memory search | Not present | Hooks aggregate structured signals; no explicit full-text search described |
| Context compaction | Not addressed | PreCompact hook available (not yet configured) |
| Session naming | Auto: `<branch>-YYYY-MM-DD-N` or explicit | SessionAutoName hook generates names automatically |
| Session resume | Not present (memory session removed) | `claude --resume [name]` native Claude Code; `claude --from-pr [number]` |

---

## 6. Workflows

| Dimension | groove | PAI |
|---|---|---|
| Development loop | 5 stages: brainstorm → plan → work → review → compound | The Algorithm: 7 phases — observe → think → plan → build → execute → verify → learn |
| Enforcement | Advisory — SKILL.md constraints interpreted by Claude | PreToolUse hooks enforce security checks; Algorithm phases tracked in PRD frontmatter |
| Daily rituals | start + end with memory logs, task analysis, git commit | Not present — SessionStart/SessionEnd hooks handle context loading/capture |
| Spec creation | `memory session spec <topic>` → structured markdown spec | PRD format — YAML frontmatter with atomic criteria, decisions, verification evidence |
| Task tracking | Backend-agnostic: beans / linear / github / none | Work registry at `MEMORY/WORK/`; PRD files are task units |
| Workflow learnings | compound detects AI/process lessons → `learned/` | `WorkCompletionLearning` hook captures lessons automatically on every SessionEnd |
| Actions/pipelines | Not present | Atomic Actions + Pipelines + Flows on cron schedule (UNIX pipe model) |
| Fabric patterns | Not present | 237 pre-built workflows: extraction, summarization, analysis, creation, security |
| Code review | Not present | Not present as dedicated skill; security review via Fabric patterns |
| Brainstorm | Templated brainstorm doc | OBSERVE + THINK phases in Algorithm |
| Plan | Templated plan doc + codebase research via Explore agent | PLAN phase; prerequisites, approach, decisions documented |

---

## 7. AI Agent Integration

| Dimension | groove | PAI |
|---|---|---|
| AGENTS.md | Managed bootstrap: 2-line groove:prime stub + 2-line task stub | Full CLAUDE.md / AGENTS.md with `CLAUDE.md.template` |
| Context loading | On-demand via `/groove:prime` | Lazy-load by intent: identity/TELOS/system docs load only when relevant |
| Hook system | Not present | 22 hooks across 8 lifecycle events |
| Managed sections | `<!-- groove:managed -->` prevents agents editing `skills/` | USER/ tier — personal customizations never overwritten by updates |
| Allowed-tools | Per-skill in SKILL.md frontmatter | Three-tier allow/deny/ask for 338 workflows in settings.json |
| Sub-agents | General-purpose Explore agent for plan/spec research | Named agents: Serena Blackwood (Architect), Marcus Webb (Engineer), Rook Blackburn (Pentester), etc.; ComposeAgent for on-the-fly composition |
| Model selection | Not present — uses default model | Explicit tier: Haiku (simple/fast), Sonnet (standard), Opus (complex/strategic); parallelism is first principle |
| Voice integration | Not present | ElevenLabs TTS per agent; VoiceCompletion hook; context-aware gerunds |
| Push notifications | Not present | ntfy.sh, Discord webhooks, macOS alerts; smart routing for tasks >5 min |

---

## 8. Config System

| Dimension | groove | PAI |
|---|---|---|
| Config file | `.groove/index.md` YAML frontmatter | `settings.json` (40 KB) — single source of truth: identity, hooks, permissions, stats |
| Config wizard | `/groove:config` — interactive, guided | Interactive `install.sh` prompts for identity and preferences |
| Git strategy | Per-component: `git.memory`, `git.tasks`, `git.hooks` (ignore-all/hybrid/commit-all) | Not present |
| Task backends | beans / linear / github / none — abstraction layer | Not present — PRD files + WORK/ memory |
| Identity config | Not present | `daidentity` block: AI name, color, voice, personality traits |
| Permissions | allowed-tools per skill in SKILL.md frontmatter | Three-tier allow/deny/ask for every workflow in settings.json |
| Stats tracking | Not present | 21 categories, 338 workflows, 1,371 sessions, 2,241 files tracked |
| Environment vars | Not present | `.env.example` + PAI_DIR, PROJECTS_DIR, token limits, bash timeouts |

---

## 9. Hook System

| Dimension | groove | PAI |
|---|---|---|
| Hooks present | None | 22 hooks across 8 lifecycle events |
| SessionStart | Not present | KittyEnvPersist (terminal env), LoadContext (inject dynamic context) |
| SessionEnd | Not present (session end is a manual command) | WorkCompletionLearning, SessionCleanup, RelationshipMemory, UpdateCounts, IntegrityCheck |
| UserPromptSubmit | Not present | RatingCapture, UpdateTabTitle, SessionAutoName |
| PreToolUse | Not present | SecurityValidator, AgentExecutionGuard, SkillGuard |
| PostToolUse | Not present | QuestionAnswered, PRDSync |
| Stop | Not present | LastResponseCache, ResponseTabReset, VoiceCompletion, DocIntegrity, AlgorithmTab |
| Event logging | Not present | Unified `events.jsonl` stream |
| Execution model | N/A | Async, non-blocking, fail-graceful; hooks never block Claude Code |

---

## 10. Security Framework

| Dimension | groove | PAI |
|---|---|---|
| Input validation | Not present | Type-safe APIs; HTTP libraries over CLI to prevent injection; prompt injection defenses |
| Dangerous ops | Not present | SecurityValidator PreToolUse hook blocks internal network, unvalidated URLs, code from scraped pages |
| AI steering rules | SKILL.md constraints (advisory) | 11 explicit AI Steering Rules (surgical precision, verification mandatory, root cause first, etc.) |
| Credential scanning | Not present | TruffleHog (700+ pattern types) |
| Audit trail | Not present | MEMORY/SECURITY/ — tool validation history |
| USER/SYSTEM sep | Not enforced as hard boundary | Hard separation — USER/ never synced; personal content stays private |

---

## 11. Identity & Goals (TELOS)

| Dimension | groove | PAI |
|---|---|---|
| Present | Not present | Yes — core system; one of six customization levels |
| Files | N/A | 10 markdown files: MISSION, GOALS, PROJECTS, BELIEFS, MODELS, STRATEGIES, NARRATIVES, LEARNED, CHALLENGES, IDEAS |
| Purpose | N/A | Eliminates re-explaining context across sessions; AI continuously references documented identity |
| Integration | N/A | Context routing loads TELOS for strategic planning; identity context loads for content creation |

---

## 12. Observability & Status

| Dimension | groove | PAI |
|---|---|---|
| Status display | Not present | `statusline-command.sh` (70 KB) — 4 responsive modes (nano/micro/mini/normal) |
| Metrics shown | Not present | Context window %, rolling 5h/7d usage, git state, memory counts, rating sparklines, trend direction |
| Event logging | Not present | `events.jsonl` — unified structured event stream from all 22 hooks |
| Signal capture | Manual — user appends to `learned/` | Automatic — every interaction → ratings.jsonl; 15-min/hourly/daily/weekly/monthly averages |

---

## 13. Community & Ecosystem

| Dimension | groove | PAI |
|---|---|---|
| Discovery | `npx skills add andreadellacorte/groove` | GitHub, Discord, YouTube walkthrough, danielmiessler.com; listed widely |
| Contribution | GitHub issues + PRs | Fork → thorough test → PR with examples and evidence |
| Sharing mechanism | groovebook (planned — PR-based commons) | PAI Packs: System Skills shareable; `_MYSKILL` personal skills never shared |
| Sponsorship | GitHub funding (FUNDING.yml) | GitHub sponsorship |
| Community hub | GitHub issues | GitHub Discussions + Discord |

---

## Gaps for Groove

Ordered by likely impact:

1. **No hook system** — PAI's 22 hooks across 8 lifecycle events automate learning capture, security validation, and context loading. Groove has no equivalent; all these actions are manual or advisory.
2. **No automatic signal capture** — PAI captures ratings and success/failure on every interaction → `LEARNING/SIGNALS/`; groove's learned memory requires deliberate user action during compound or session end.
3. **No Actions/Pipelines/Flows** — PAI supports atomic, composable data pipelines with cron scheduling; groove has no headless or scheduled automation.
4. **No identity/goals layer (TELOS)** — PAI carries user identity (mission, beliefs, models, strategies) persistently; groove has no user-context layer that survives across sessions automatically.
5. **No Fabric pattern library** — 237 pre-built extraction/summarization/analysis/creation workflows; groove has no equivalent prompt pattern corpus.
6. **No model selection guidance** — PAI explicitly routes Haiku/Sonnet/Opus by task complexity and encourages parallelism; groove makes no recommendations.
7. **No observability** — PAI's statusline shows context usage, rating sparklines, git state; groove has no visibility into session health or usage patterns.
8. **No named agent personas** — PAI's Serena/Marcus/Rook agents have persistent personalities and voices; groove's sub-agents are generic.
9. **No push/voice notifications** — PAI routes TTS and mobile push for long tasks; groove has no notification mechanism.
10. **No security framework** — PAI's SecurityValidator hook and AI Steering Rules enforce safe behaviour deterministically; groove's constraints are advisory text interpreted by Claude.

---

## Groove Differentiators

Things PAI does not have that groove should preserve:

1. **Explicit migration system** — PAI's installer merges settings manually and avoids breaking changes; groove's ordered migration runner handles config evolution safely across any version gap.
2. **Git strategy per component** — Fine-grained `git.memory/tasks/hooks` control; PAI has no equivalent.
3. **Explicit 5-stage compound loop** — Brainstorm→plan→work→review→compound with per-stage constraints; PAI's Algorithm is similar (7 phases) but groove's stages are more opinionated about _when_ to run each.
4. **Structured daily rituals** — Start/end with daily→weekly→monthly roll-up chain; PAI has no equivalent scheduled end ritual.
5. **Backend-agnostic task layer** — beans / linear / github / none abstraction; PAI ties task tracking to PRD files and WORK/ memory only.
6. **Session spec/doc creation** — `memory session spec` and `memory session doc` produce structured artefacts scoped to the current session; PAI generates PRDs but not session-scoped specs.
7. **groovebook (planned)** — PR-based shared learning commons; no equivalent exists in PAI.
8. **Lightweight, runtime-free install** — `npx skills add` + skill-based orchestration; PAI requires Bun, a shell script, and copying files to `~/.claude/`.

---

## Scope Observation

PAI and groove have genuinely different ambitions. PAI is a personal AI operating system — it has a runtime (TypeScript/Bun), a full hook lifecycle, voice integration, named personas, an identity layer, data pipelines, and a rich observability stack. Groove is a lean, markdown-only engineering workflow companion that runs entirely inside Claude Code's skill system.

The comparison is most useful not as "which is better" but as a map of what PAI patterns groove could adopt at its own lightweight scale — specifically: a minimal hook system for session-end learning capture, a TELOS-lite user context file, and an observability signal (even a simple one) for session quality. The rest of PAI's surface area (pipelines, voice, notifications, Fabric patterns) is outside groove's scope by design.
