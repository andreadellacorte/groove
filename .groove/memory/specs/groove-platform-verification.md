# Spec: groove platform verification

**Session**: claude/loop-2026-03-07
**Date**: 2026-03-07

---

## Overview

**What**: Define a minimal verification checklist per AI platform to promote a platform's README status from "Unverified" to "Compatible". The `.cursor/skills/` symlinks are wired — the infrastructure exists — but no test session has been run on any non-Claude-Code platform.

**Why**: The groove-vs-groove spec (2F) explicitly requires verification before claiming compatibility. Marking platforms "Compatible" without a test run erodes user trust when they hit issues. This spec defines what "verified" means so the bar is concrete and reproducible.

---

## Verification checklist per platform

A platform is **Compatible** when all of the following pass in a single session on that platform:

| # | Check | Pass criteria |
|---|---|---|
| 1 | Install | `npx skills add andreadellacorte/groove` completes without error |
| 2 | Config | `/groove-admin-config` runs; `.groove/index.md` is written |
| 3 | Install backends | `/groove-admin-install` completes; AGENTS.md updated |
| 4 | Prime | `/groove-utilities-prime` outputs config block and Key Commands |
| 5 | Daily start | `/groove-daily-start` runs; no error; task list shown |
| 6 | Work spec | `/groove-work-spec test` creates a spec file at the configured path |
| 7 | Daily end | `/groove-daily-end` writes a daily log; spec health check runs |
| 8 | Doctor | `/groove-admin-doctor` reports all healthy (or expected gaps only) |

A platform is **Partial** if checks 1–4 pass but later checks fail. Document which checks fail and why.

---

## Platforms to verify

| Platform | Current status | Notes |
|---|---|---|
| Claude Code | Verified | Primary target; all checks pass |
| Cursor | Unverified | `.cursor/skills/` symlinks wired in v0.12.13; needs test session |
| Cline | Unverified | `.agents/skills/` path recognised per spec; not tested |
| Amp | Unverified | Skills directory supported per spec; not tested |

---

## Implementation Steps

1. Run the 8-check checklist on Cursor using the Claude Code model via Cursor's agent interface
2. Document results in a `## Cursor` results section below
3. If all 8 pass: update README platform table to `Compatible`; if partial: update to `Partial` with notes
4. Repeat for Cline and Amp when environments are available
5. Add a `platform:` key to `SKILL.md` frontmatter for skills with known platform-specific behaviour (e.g. path differences)

---

## Results

*(To be filled in after verification runs)*

### Cursor

- Status: Unverified
- Infrastructure: `.cursor/skills/groove-*` symlinks → `.agents/skills/` (added v0.12.13)
- Blocker: No test session run

### Cline

- Status: Unverified
- Infrastructure: `.agents/skills/` path; no `.cline/skills/` equivalent known
- Blocker: No test session run

### Amp

- Status: Unverified
- Infrastructure: `.agents/skills/` path; no `.amp/skills/` equivalent known
- Blocker: No test session run

---

## Constraints

- Never update README to "Compatible" without a passing checklist run documented here
- "Partial" is acceptable and informative — it tells users what works and what doesn't
- Platform verification is a one-time effort per platform per major groove version; re-verify after breaking changes
