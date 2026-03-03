# Spec: groove vs groove — Introspective Roadmap

**Session**: main-2026-03-01-2
**Date**: 2026-03-02

---

## Overview

groove v0.8.8 as-is vs groove-as-it-should-be. This spec synthesises three external comparisons (groove vs claude-night-market, groove vs PAI, groove vs bonfire) into a roadmap: what to preserve, what to add, and what to explicitly reject.

**Source specs**:
- `.groove/memory/sessions/specs/groove-vs-night-market.md`
- `.groove/memory/sessions/specs/groove-vs-pai.md`
- `.groove/memory/sessions/specs/groove-vs-bonfire.md`

---

## 1. Confirmed Identity (What groove is and must remain)

Synthesised from scope observations across all three comparisons:

- **A lean, markdown-only engineering workflow companion** — no runtime, no Bun, no TypeScript; portable, lightweight, installs anywhere Claude Code runs
- **Project-scoped, not global** — `.groove/` lives in the repo; PAI-style global installs (`~/.claude/`) are out of scope
- **Opinionated daily rhythm** — the start/end ceremony is a core differentiator; no other compared tool has it
- **Explicit 5-stage compound loop** — the most structured development workflow of any compared tool; "80% of value in plan and review" is baked in
- **Predictable explicit invocation** — `/groove <skill> <command>` is more predictable than auto-discovery; keep it
- **Backend-agnostic task abstraction** — beans/linear/github/none is unique; no other tool has an abstraction layer over task backends

---

## 2. Core Strengths (What to preserve)

| Strength | Signal | Preserve because |
|---|---|---|
| Ordered migration runner with dual versioning | night-market + PAI | Unique; enables safe config evolution across any version gap |
| Per-component git strategy (memory/tasks/hooks) | night-market + PAI + bonfire | Unique; teams need different sharing strategies per component |
| Explicit 5-stage compound loop | night-market + PAI + bonfire | Most opinionated and structured workflow; core value prop |
| Structured daily rituals (start/end) | night-market + PAI + bonfire | No other tool has an explicit daily ceremony |
| Learned memory tier (`learned/<topic>.md`) | night-market + PAI | Unique long-term insight accumulation; no other tool has this cold tier |
| Multi-tier memory roll-ups (daily→weekly→monthly) | night-market + PAI + bonfire | No other tool has this temporal pyramid |
| Config wizard + interactive setup | night-market + PAI | Unique guided configuration; lowers barrier to entry |
| groovebook (planned) | night-market + PAI | No equivalent in any compared tool |

---

## 3. Prioritised Gaps (What to add)

Ordered by signal strength (how many comparisons surfaced it) and alignment with groove's scope.

### Tier 1 — High priority (cross-cutting, in scope)

**A. Context window awareness**

- Bonfire warns at 20K tokens and recommends archiving; PAI has a statusline showing context %; night-market leverages native compaction
- Groove doesn't address this at all — long sessions degrade synthesis quality silently
- **groove-scoped implementation**: In `memory session end` and `work compound`, check git log breadth and session length; if the session started long ago or many files changed, warn: "This session may be approaching context limits — consider closing and resuming in a new session." No hooks needed; can be implemented as a constraint in existing commands.

**B. Blindspot review / branch-diff analysis**

- Bonfire's `/bonfire review` is the sharpest gap: branch-diff-based analysis, findings categorised as Fix Now / Needs Spec / Create Issues with effort estimates; no equivalent in groove
- Groove's `work review` is subjective (evaluate output against plan); it doesn't look at the actual diff
- **groove-scoped implementation**: Add a `groove work review` step that runs `git diff <base>...HEAD` and `git log --oneline <base>..HEAD`; feeds into the review analysis; findings categorised by the same Fix Now / Needs Spec / Create Issues pattern. Fits naturally into the existing `work review` command; no new command needed.

**C. Session health check at end**

- Bonfire's `/bonfire end` checks stale references (broken links, orphaned specs, closed PRs); PAI's SessionEnd hooks clean state
- Groove's `memory session end` only synthesises work done; no health check
- **groove-scoped implementation**: Add to `memory session end` constraints — after updating the session file, check: orphaned spec files (specs in `sessions/specs/` not referenced anywhere), session files with no Work Done section populated, long-running sessions (started >7 days ago). Report findings to user before closing.

**D. Spec/doc path configurability**

- Bonfire's `specs:` and `docs:` config keys let users point to project-level directories
- Groove's paths are fixed at `<memory>/sessions/specs/` and `<memory>/sessions/docs/`
- Users may want specs and docs at `specs/` (project root) for team visibility
- **groove-scoped implementation**: Add `specs:` and `docs:` optional keys to `.groove/index.md`; `memory session spec` and `memory session doc` read these keys; default to current fixed paths if absent. Add to `groove config` wizard.

---

### Tier 2 — Medium priority (single mention, in scope)

**E. TELOS-lite identity file**

- PAI's TELOS (10 files: MISSION, GOALS, PROJECTS, BELIEFS, etc.) eliminates re-explaining context across sessions
- Groove has no user-context layer that survives across sessions
- **groove-scoped implementation**: A single optional `.groove/IDENTITY.md` free-form file; `groove prime` checks for it and includes it in conversation context output if present. No new config key; presence of file = enabled.

**F. Multi-platform documentation**

- Bonfire explicitly tests and documents 20+ compatible platforms; groove says "Claude Code" only
- **groove-scoped implementation**: Low-effort — add a platform compatibility table to README; verify the skill runs on Cursor, Cline, Amp. No version bump needed.

**G. Automatic session rating signal**

- PAI captures ratings on every interaction; pensive tracks failure rates
- Groove captures learnings manually but has no signal for session quality trends
- **groove-scoped implementation**: At `memory session end`, after synthesising work done, prompt: "Rate this session (1–5): how well did the compound loop serve you?" — append to `learned/signals.md` with date. Lightweight; optional; starts building a signal corpus.

---

### Tier 3 — Out of scope (explicitly reject)

| Feature | Seen in | Why out of scope |
|---|---|---|
| Full hook system (22 hooks, TypeScript/Bun) | PAI | Requires runtime; groove is markdown-only; lighter advisory constraints are the groove way |
| Headless CLI / cron pipelines | PAI | Out of groove's scope; groove runs inside Claude Code sessions |
| Fabric pattern library | PAI | 237 patterns is a separate product; groove is about workflow, not content processing |
| Named agent personas + voice | PAI | Requires external APIs (ElevenLabs); out of scope |
| Push notifications | PAI | External infrastructure; out of scope |
| Auto-discovery / intent matching | night-market + PAI | Groove's explicit invocation is a deliberate design choice — more predictable |
| Semantic memory search | night-market | Requires embedding infrastructure; out of scope for markdown-only tool |
| Full marketplace listing | night-market | Discoverability improvement, not a workflow feature |

---

## 4. Scope Boundary Statement

groove is: **a lean, markdown-only, project-scoped, Claude Code engineering workflow companion** — explicit invocation, structured daily rituals, 5-stage compound loop, multi-tier memory, backend-agnostic tasks, no runtime dependency beyond `npx`.

groove is not: a personal AI OS (PAI), a plugin marketplace (night-market), or a pure context persistence tool (bonfire). It occupies the middle ground: more structured than bonfire, more portable than PAI, more cohesive than night-market.

---

## 5. Proposed Version Roadmap

| Version | Feature | Tier |
|---|---|---|
| v0.9.0 | Context window awareness in `session end` + `work compound` | 1A |
| v0.9.1 | Branch-diff analysis in `work review` (Fix Now / Needs Spec / Create Issues) | 1B |
| v0.9.2 | Session health check in `memory session end` (orphaned specs, long-running sessions) | 1C |
| v0.9.3 | Configurable `specs:` and `docs:` paths in `.groove/index.md` | 1D |
| v0.10.0 | TELOS-lite: `.groove/IDENTITY.md` surfaced by `groove prime` | 2E |
| v0.10.1 | Session rating signal → `learned/signals.md` | 2G |
| — | Multi-platform README docs | 2F (no version bump needed) |
