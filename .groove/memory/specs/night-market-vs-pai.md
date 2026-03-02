# Spec: claude-night-market vs Personal AI Infrastructure (PAI) Comparison

**Session**: main-2026-03-01-2
**Date**: 2026-03-02

---

## Overview

**What**: A systematic comparison of claude-night-market (athola, as of 2026-03-02) against Daniel Miessler's Personal AI Infrastructure (PAI) v4.0.3 across 11 dimensions: architecture, commands, installation, upgrade/migration, memory, workflows, AI agent integration, hooks, config/permissions, security, and observability/community.

**Why**: Both are more ambitious than groove but in different directions. Comparing them directly reveals the trade-offs between a composable plugin marketplace model (night-market) and a fully integrated personal AI OS model (PAI), and surfaces which patterns each could learn from the other.

**Sources**:
- claude-night-market: https://github.com/athola/claude-night-market — 16 plugins, 126 skills, 114 commands, 41 agents
- PAI: https://github.com/danielmiessler/Personal_AI_Infrastructure — v4.0.3, TypeScript/Bun, 338 workflows, 22 hooks, 237 Fabric patterns

---

## 1. Architecture & Model

| Dimension | claude-night-market | PAI |
|---|---|---|
| Type | Plugin marketplace for Claude Code (markdown SKILL.md files) | Full TypeScript/Bun personal AI platform installed to `~/.claude/` |
| Install target | `~/.claude/skills/[author]-[marketplace]-[plugin]/` | `~/.claude/` — entire directory: skills, hooks, agents, memory, tools |
| Core model | 16 independent, selectively installable plugins | Monolithic platform: Skills + Actions + Pipelines + Flows + Hooks + Agents + TELOS |
| Skill format | SKILL.md: YAML frontmatter (when-to-use) + markdown instructions (what-to-do) | SKILL.md: YAML frontmatter (USE WHEN clause) + workflow docs in `Skills/[Name]/Workflows/` |
| Code execution | Markdown instructions only; hooks in JavaScript | TypeScript/Bun — full runtime with HTTP, filesystem, external APIs, CLI tools |
| Plugin manifest | `.claude-plugin/plugin.json` per plugin | No per-plugin manifest; PAI is a single install unit; USER/ for personal extensions |
| Agent definitions | `agents/` directories per plugin; 41 dedicated agents | `agents/` with named personas + ElevenLabs voice IDs; ComposeAgent for on-the-fly composition |
| Dependency model | Plugins declare inter-skill deps (shallow chains) | No inter-plugin deps; PAI is self-contained; Fabric + Actions are internal |

**Note**: night-market's composable model lets users install exactly what they need and keeps each plugin independently updatable. PAI's monolithic model means everything is coherent and deeply integrated but upgrades are coarser.

---

## 2. Commands & Invocation

| Dimension | claude-night-market | PAI |
|---|---|---|
| Total commands | 114 commands across 16 plugins | 338 workflows across 11 skill categories + 237 Fabric patterns |
| Invocation | Explicit slash commands OR auto-invoked by description match | Intent-matched (USE WHEN clause) OR explicit; headless via `bun algorithm.ts` / `bun pai.ts` |
| Auto-discovery | Yes — `attune v1.4.0` enhanced auto-matching; Claude evaluates skill frontmatter | Yes — Claude evaluates USE WHEN clauses; context-driven activation |
| CLI tool | None — runs inside Claude Code only | `bun algorithm.ts` (loop/interactive/status modes) + `bun pai.ts` (actions/pipelines) for headless/scheduled use |
| Keyboard shortcuts | Supported (resume screen preview/rename) | Not described explicitly |
| Naming convention | TitleCase for system skills; no personal skill convention | TitleCase for system skills; `_MYSKILL` for personal skills (never shared) |
| Fabric patterns | Not present | 237 pre-built workflows: extraction, summarization, analysis, creation, security, rating |

---

## 3. Installation

| Dimension | claude-night-market | PAI |
|---|---|---|
| Method | `/plugin marketplace add athola/claude-night-market` or `npx skills add` | `git clone` → `cp -r .claude ~/` → `bash install.sh` |
| Granularity | Selective — install individual plugins from marketplace | Single install (all PAI features bundled); USER/ for personal extensions |
| Bootstrap | Self-contained per plugin; no orchestration step | Shell script installs Bun, Git, Claude Code, and configures identity interactively |
| Post-install setup | None — plugins self-configure | Interactive installer configures `settings.json` (identity, voice, preferences) |
| OS support | Any OS where Claude Code runs | macOS + Linux; Windows not supported (Bun limitation) |
| User/system separation | No hard separation | Explicit USER/ tier overrides SYSTEM/root; USER/ content never synced to public repo |
| Workspace scaffolding | `attune:project-init` detects project type, copies .env, installs deps | Not present — PAI is a global install, not per-project |

---

## 4. Upgrading & Migration

| Dimension | claude-night-market | PAI |
|---|---|---|
| Upgrade method | `/update-plugins` — recommends upgrades by stability metrics; detects orphaned refs | Copy new `Releases/` files + re-run `install.sh`; preserves USER/ |
| Migration system | Not present — backward-compat design avoids breaking changes | Not present — backward-compat design; installer merges settings intelligently |
| Version tracking | Per-plugin version in `plugin.json`; stability metrics (usage freq, failure rate) | `Releases/` snapshots (v2.3 through v4.0.3); settings.json tracks session/file counts |
| Breaking changes | Avoided by design | Avoided by design; USER/ never overwritten |
| CI drift | `/update-ci` reconciles pre-commit hooks and GitHub Actions with code changes | Not present |
| Plugin auditing | `/update-plugins` detects orphaned/missing skill references | Not present |

---

## 5. Memory & Sessions

| Dimension | claude-night-market | PAI |
|---|---|---|
| Session files | Native Claude Code sessions + sanctum git workspace capture before resume | Native Claude Code sessions + `WorkCompletionLearning` hook on SessionEnd |
| Resume | `claude --resume [name]`; `claude --from-pr [number]` — PR-linked sessions | `claude --resume [name]`; no PR-linking mechanism |
| Auto-naming | Explicit by convention (e.g. `debugging-auth-401`); sanctum captures workspace before naming | SessionAutoName hook generates names automatically |
| Memory tiers (explicit) | Not present — implicit in native Claude Code session memory | WORK/ / LEARNING/ / RESEARCH/ / SECURITY/ / STATE/ |
| Hot memory | Native Claude Code session context (in-window) | STATE/ — JSON, fast-access, mutable runtime data |
| Cold memory | Not present as explicit tier | LEARNING/SIGNALS/ — ratings.jsonl, pattern analysis; 30-day session transcript retention |
| Signal capture | pensive tracks command-level failure rates and usage frequency | Automatic — every interaction: ratings, sentiment, success/failure → LEARNING/ |
| Memory search | Hybrid semantic + lexical; auto-compaction on context fill | Hooks aggregate structured signals; full-text search not explicitly described |
| Context compaction | Native Claude Code feature leveraged; sanctum preserves reasoning across compaction | PreCompact hook available (not yet configured) |
| Long-term insights | Not present as explicit tier | LEARNING/SIGNALS/ + `WorkCompletionLearning`; no `learned/` cold tier equivalent |

---

## 6. Workflows

| Dimension | claude-night-market | PAI |
|---|---|---|
| Development loop | attune: brainstorm → plan → work → review → execute | The Algorithm: observe → think → plan → build → execute → verify → learn (7 phases) |
| Enforcement | imbue PreToolUse hook blocks file writes until tests exist | PreToolUse hooks enforce safety; Algorithm phases tracked in PRD frontmatter |
| Task format | Native Claude Code Tasks system | PRD files — YAML frontmatter with atomic ISC criteria, decisions, verification evidence |
| Spec creation | spec-kit plugin; attune:project-init scaffolds requirements | PRD format — binary-testable ISC checkboxes |
| TDD enforcement | imbue: PreToolUse blocks file writes until tests exist | Not present as a dedicated workflow feature |
| Code review | pensive: NASA Power of 10 safety patterns; tracks failure rates per command | Not present as dedicated skill; security review via Fabric patterns |
| Daily rituals | `/catchup` reads recent git history at session start | SessionStart hooks (LoadContext, KittyEnvPersist); no closeout ritual |
| Actions/pipelines | Not present | Atomic Actions + Pipelines + Flows on cron schedule (UNIX pipe model) |
| Fabric patterns | Not present | 237 pre-built workflows (extraction, summarization, analysis, creation, security) |
| Workflow learnings | pensive tracks stability metrics; no explicit user-facing capture ritual | `WorkCompletionLearning` hook captures lessons automatically on every SessionEnd |

---

## 7. AI Agent Integration

| Dimension | claude-night-market | PAI |
|---|---|---|
| AGENTS.md | Full AGENTS.md standard; CLAUDE.md → AGENTS.md migration supported | Full CLAUDE.md / AGENTS.md with `CLAUDE.md.template` |
| Context loading | Progressive Disclosure Architecture — skills auto-discover without loading all documents | Lazy-load by intent — identity/TELOS/system contexts load only when relevant |
| Hook system | PreToolUse hooks (imbue TDD, conserve permissions) | 22 hooks across 8 lifecycle events |
| Allowed-tools | Declared per plugin in `plugin.json` | Three-tier allow/deny/ask for 338 workflows in settings.json |
| Sub-agents | 41 dedicated agents; per-plugin `agents/` directories | Named agents: Serena Blackwood (Architect), Marcus Webb (Engineer), Rook Blackburn (Pentester), Ava Sterling (Claude Researcher), Alex Rivera (Gemini Researcher); ComposeAgent for on-the-fly |
| Model selection | Not present | Explicit tier: Haiku (simple/fast), Sonnet (standard), Opus (complex/strategic); parallelism is first principle |
| Voice integration | Not present | ElevenLabs TTS per named agent; VoiceCompletion hook; context-aware gerunds |
| Push notifications | Not present | ntfy.sh, Discord webhooks, macOS alerts; smart routing for tasks >5 min |
| Cross-tool compat | AGENTS.md + CLAUDE.md; `skrills` syncs Codex ↔ Claude Code | CLAUDE.md / AGENTS.md; no cross-tool sync tool |

---

## 8. Hook System (Detail)

| Dimension | claude-night-market | PAI |
|---|---|---|
| Hook events covered | PreToolUse only | 8 lifecycle events: SessionStart, SessionEnd, UserPromptSubmit, Stop, PreToolUse, PostToolUse, PreCompact |
| Hook count | ~2–3 active (imbue, conserve, + SkillGuard-style) | 22 hooks |
| Implementation language | JavaScript | TypeScript (Bun runtime) |
| SessionStart hooks | Not present | KittyEnvPersist (terminal env), LoadContext (inject dynamic context) |
| SessionEnd hooks | Not present | WorkCompletionLearning, SessionCleanup, RelationshipMemory, UpdateCounts, IntegrityCheck |
| UserPromptSubmit hooks | Not present | RatingCapture, UpdateTabTitle, SessionAutoName |
| PreToolUse hooks | imbue (TDD enforcement), conserve (permission checks) | SecurityValidator, AgentExecutionGuard, SkillGuard |
| PostToolUse hooks | Not present | QuestionAnswered, PRDSync |
| Stop hooks | Not present | LastResponseCache, ResponseTabReset, VoiceCompletion, DocIntegrity, AlgorithmTab |
| Event logging | Not present | Unified `events.jsonl` stream from all 22 hooks |
| Execution model | Not described | Async, non-blocking, fail-graceful; hooks never block Claude Code |

---

## 9. Config & Permissions

| Dimension | claude-night-market | PAI |
|---|---|---|
| Config file | `.claude/settings.json` (hooks); `plugin.json` per plugin | `settings.json` (40 KB) — single source of truth: identity, hooks, permissions, stats |
| Config wizard | Not present | Interactive `install.sh` prompts for identity and preferences |
| Permissions model | Per-plugin `plugin.json` allowed-tools | Three-tier allow/deny/ask for every workflow; 338 entries |
| Identity config | Not present | `daidentity` block: AI name, color, voice, personality traits |
| Stats tracking | Per-command stability metrics (usage freq, failure rate) tracked by pensive | 21 categories, 338 workflows, 1,371 sessions, 2,241 files tracked in settings.json |
| Environment vars | Not present | `.env.example` + PAI_DIR, PROJECTS_DIR, token limits, bash timeouts |

---

## 10. Security

| Dimension | claude-night-market | PAI |
|---|---|---|
| Input validation | Not described | Type-safe APIs; HTTP libraries over CLI to prevent injection; prompt injection defenses |
| Dangerous ops | conserve: PreToolUse permission checks (auto-approve safe, block destructive) | SecurityValidator: blocks internal network access, unvalidated URLs, code from scraped pages |
| AI steering rules | Not present | 11 explicit AISTEERINGRULES.md (surgical precision, verification mandatory, root cause first, etc.) |
| Credential scanning | Not present | TruffleHog (700+ pattern types) |
| Audit trail | Not present | MEMORY/SECURITY/ — tool validation history |
| USER/SYSTEM separation | No hard boundary | Hard separation — USER/ never synced to public repo; personal content always private |

---

## 11. Observability & Community

| Dimension | claude-night-market | PAI |
|---|---|---|
| Status display | Not present | `statusline-command.sh` (70 KB) — 4 responsive modes (nano/micro/mini/normal); context %, git state, rating sparklines, trend direction |
| Event logging | Not present | `events.jsonl` — unified structured event stream from all 22 hooks |
| Signal capture | pensive: command failure rate + usage frequency (passive) | Automatic — ratings, sentiment, success/failure on every interaction; 15-min to monthly averages |
| Discovery | LobeHub, Playbooks.com, MCPMarket, awesome-claude-code | GitHub, Discord, YouTube walkthrough, danielmiessler.com |
| Skill reviews | Public scores (python-testing: 89/100 with detailed community feedback) | Not present |
| Sharing mechanism | PAI Packs (System Skills shareable); no personal skill convention for night-market | PAI Packs; `_MYSKILL` personal skills never shared |
| Community hub | GitHub Discussions + Discord | GitHub Discussions + Discord |
| Cross-tool sync | `skrills` syncs skills between Codex and Claude Code | Not present |

---

## Differentiators

### claude-night-market over PAI

1. **Selective install** — install exactly the plugins needed; PAI is all-or-nothing
2. **Marketplace discoverability** — listed on LobeHub, Playbooks.com, MCPMarket, awesome-claude-code; PAI is GitHub-only
3. **TDD enforcement** — imbue's PreToolUse hook deterministically blocks file writes without tests; PAI has no equivalent
4. **Dedicated code review** — pensive with NASA Power of 10 patterns + command-level failure rate tracking; PAI has no dedicated review skill
5. **CI drift detection** — `/update-ci` reconciles pre-commit hooks and GitHub Actions; PAI has no equivalent
6. **Command-level stability metrics** — pensive tracks failure rates and usage frequency per command; PAI tracks at session level only
7. **Lighter runtime** — markdown-only skills (+ JavaScript hooks); no Bun, no TypeScript; installs on any OS where Claude Code runs
8. **Cross-tool sync** — `skrills` syncs skills between Codex and Claude Code; PAI is Claude Code only
9. **PR-linked sessions** — `claude --from-pr [number]` for context-aware resume; PAI has no PR integration for sessions
10. **Public skill reviews** — community scores with structured feedback; PAI has no equivalent quality signal

### PAI over claude-night-market

1. **Full lifecycle hook coverage** — 22 hooks across 8 events; night-market covers PreToolUse only; SessionEnd capture, UserPromptSubmit, and Stop are absent
2. **Automatic signal capture** — every interaction rated and logged automatically; night-market's pensive is passive/command-level, not session-level
3. **Actions/Pipelines/Flows** — headless, scheduled, composable data pipelines; night-market has no equivalent for automation outside Claude Code sessions
4. **TELOS identity layer** — persistent mission, goals, beliefs, strategies across all sessions; night-market has no user context layer
5. **Fabric pattern library** — 237 pre-built prompt workflows; night-market has no equivalent pattern corpus
6. **Named agent personas with voice** — persistent personalities + ElevenLabs TTS; night-market's 41 agents are role-based but not voice-enabled
7. **Push/voice notifications** — ntfy.sh, Discord, ElevenLabs; smart routing for long tasks; night-market has no notification mechanism
8. **Observability** — statusline with context %, rating sparklines, git state; night-market has no session health visibility
9. **Richer security framework** — SecurityValidator hook + TruffleHog + AISTEERINGRULES.md; night-market's conserve is narrower in scope
10. **Full TypeScript runtime** — HTTP calls, API integrations, cron scheduling; night-market is bounded by Claude Code's built-in tool set

---

## Scope Observation

Both tools are more ambitious than groove but in fundamentally different directions. claude-night-market optimises for **composability and marketability** — a curated set of high-quality, independently installable plugins that stay within Claude Code's markdown skill model, runnable on any OS without a separate runtime. PAI optimises for **completeness and depth** — a full personal AI OS with a TypeScript/Bun runtime, a 22-hook lifecycle, voice integration, data pipelines, named agent personas, and a persistent identity layer.

The right choice between them depends on context:
- **night-market** is the better model for a team-shareable, low-friction, OS-agnostic toolkit that can be adopted selectively
- **PAI** is the better model for a deeply personalised, automation-heavy, solo workflow where the user wants the AI to know who they are and what they're trying to achieve across every session

They are not direct competitors — night-market is a plugin distribution system; PAI is an AI platform. A user could plausibly install night-market plugins inside a PAI setup.
