# Spec: Mistakes and Lessons

**Session**: claude/loop-2026-03-07
**Date**: 2026-03-07

> **Implementation note (2026-03-07):** The final implementation uses the task backend exclusively (no `mistakes.md` file). Incidents are tracked as bugs under "Groove Memory" → "Mistakes" epic in the configured task backend. The spec below describes the original markdown-file design which was superseded.

---

## Overview

**What**: A structured system that tracks workflow errors made by the agent using a four-step cycle: **Log it → Fix it → Audit it → Summarise it**. When the agent makes a mistake (wrong format, wrong convention, wrong tool, repeated error) and the user corrects it, the agent logs the incident, fixes the root cause in the relevant memory or learned file, identifies the root cause, then resolves the task. `groove-work-compound` processes open incidents at the end of each work cycle; `groove-daily-start` surfaces unresolved incidents as warnings before the day begins.

**Why**: Groove's `learned/` memory captures forward-looking workflow insights from compound sessions, but has no mechanism for backward-looking error capture. Mistakes get corrected verbally, but the correction doesn't persist — so the agent repeats the same class of error across sessions. A dedicated mistake tracking workflow closes this gap: errors get permanently fixed in the underlying memory files, and the incident is preserved with root cause for pattern analysis.

**Source**: Inspired by LifeBandit666's comment on r/ClaudeCode ("I built a persistent AI assistant...") describing their "Mistakes and Lessons" file pattern.

**Scope**: New `groove-utilities-memory-mistakes` skill for explicit incident capture; integration into `groove-work-compound` (process open incidents) and `groove-daily-start` (surface warnings). Requires a configured task backend.

---

## Decisions

| Decision | Choice | Rationale |
|---|---|---|
| File location | `.groove/memory/mistakes.md` | Under user zone (`.groove/`), next to `learned/`; safe from `groove:update` overwrites |
| File structure | Two sections: "Incident Log" (open) + "Resolved" (summary table) | Separates in-progress incidents from closed ones; keeps the file lean by deleting log entries after resolution |
| Trigger | User-initiated during any session OR agent self-detection at compound | Agent can't reliably detect all its own mistakes; user correction is the primary signal. Compound can prompt for any open incidents |
| Root cause requirement | Required for resolution — audit step must identify why the mistake happened | Root cause → permanent fix in memory/learned files; without this, the same class of error recurs |
| Compound integration | At compound, check for open incidents; if any exist, process them before closing the session | Compound is already the "clean up and learn" step; mistakes flow naturally here |
| Daily-start integration | If open incidents exist in the file, show a one-line warning: "N open incident(s) in .groove/memory/mistakes.md — run /groove-work-compound or /groove-utilities-memory-mistakes to resolve" | Keeps the user informed without blocking start |
| Skill | New `groove-utilities-memory-mistakes` for explicit capture; compound handles batch processing | Allows mid-session capture without running a full compound |
| Permanent fix | Root cause fix goes into the relevant `.groove/memory/learned/<topic>.md` file — not just in mistakes.md | The lesson graduates to long-term memory; mistakes.md stays lean |

---

## Implementation Steps

### 1. Define `mistakes.md` file format

File at `.groove/memory/mistakes.md`:

```markdown
# Mistakes and Lessons

## How This File Works

1. **Log it** — Record in Incident Log below when an error is identified
2. **Fix it** — Apply the fix (code, config, file, convention)
3. **Audit it** — Identify root cause; add permanent fix to `.groove/memory/learned/<topic>.md`
4. **Summarise** — Move lesson to Resolved table; delete log entry; keep file lean

## Incident Log

<!-- Active incidents. Delete each entry after audit + summarise is done. -->

<!-- Template:
- **Date**: YYYY-MM-DD
- **What happened**: [one-line description]
- **Root cause**: [why it happened]
- **Fix applied**: [what was changed]
- **Status**: `pending` | `fixing` | `audited`
-->

(Empty — no open incidents)

## Resolved

| Date | Mistake | Root Cause | Permanent Fix | Learned File |
|---|---|---|---|---|
```

### 2. Create `groove-utilities-memory-mistakes` skill

New skill at `skills/groove-utilities-memory-mistakes/SKILL.md`:

- **Trigger**: User says the agent made a mistake, or user explicitly invokes the skill
- **Steps**:
  1. Check `.groove/memory/mistakes.md` exists; create with the above template if not
  2. Ask user to describe the mistake (or infer from context if clear)
  3. Ask for root cause (or propose one based on context; user confirms)
  4. Add entry to Incident Log with `status: pending`
  5. Apply the fix immediately if possible (edit the relevant file, fix the convention)
  6. Update status to `audited` after fix is confirmed
  7. Ask which `learned/<topic>.md` the permanent lesson should go into (suggest a topic)
  8. Append lesson to chosen learned file (create if absent)
  9. Move incident to Resolved table with date, one-line summary, root cause, fix applied, learned file
  10. Delete the log entry

### 3. Update `groove-work-compound`

In `skills/groove-work-compound/SKILL.md`, add a pre-step:

- Before producing the compound actions checklist, check if `.groove/memory/mistakes.md` exists and has entries in "Incident Log"
- If open incidents exist: for each, run the audit → permanent fix → summarise cycle (steps 4–10 above)
- Add to compound checklist: "mistakes.md: N incident(s) resolved → learned/<topic>" (done/pending)
- If no open incidents: skip silently

### 4. Update `groove-daily-start`

In `skills/groove-daily-start/SKILL.md`, add a check after the recent-days review:

- Check if `.groove/memory/mistakes.md` exists and has entries in "Incident Log" (look for lines under `## Incident Log` that are not the template comment or the "Empty" placeholder)
- If open incidents: show a one-line warning inline in the start output:
  `⚠ N open incident(s) in .groove/memory/mistakes.md — resolve at next /groove-work-compound`
- If none or file absent: skip silently — no noise

### 5. Update `groove-utilities-prime`

In `skills/groove-utilities-prime/SKILL.md`, add to Key commands:

```
/groove-utilities-memory-mistakes — log a workflow mistake and resolve it
```

### 6. Update `groove-admin-install`

In `skills/groove-admin-install/SKILL.md`, create `.groove/memory/mistakes.md` from the template during install (alongside the existing memory directory setup). If file already exists: skip (idempotent).

### 7. Bump version and update CHANGELOG

- Bump `skills/groove/SKILL.md` to `0.12.2`
- Add CHANGELOG entry

---

## Edge Cases

| Case | Handling |
|---|---|
| `mistakes.md` doesn't exist | Create on first invocation of `groove-utilities-memory-mistakes`; `groove-work-compound` and `groove-daily-start` skip silently if absent |
| User doesn't want to log a mistake | Skip entirely — the skill is always user-triggered or user-confirmed; no auto-capture |
| Root cause is unclear | Propose a likely root cause based on context; user confirms, corrects, or types "unknown" — log proceeds either way |
| Multiple open incidents at compound | Process all in sequence; each gets its own audit → fix → summarise cycle before the compound checklist is produced |
| Permanent fix target is unclear | Suggest `anti-patterns.md` as default learned topic; user can redirect |
| Mistake was in skills/ code | Skill files are managed by groove:update — note this constraint; user can open an issue or add a note to `learned/anti-patterns.md` for workaround |
| Resolved table grows large | No automatic pruning; user can archive rows manually — this is intentional, the table is a corpus |
| Agent makes a mistake about mistakes.md itself | Log normally; root cause goes into `learned/meta.md` |

---

## Open Questions

- Should `groove-daily-start` read the full incident log or just count open incidents? (Current spec: count only — avoids bloating the start output)
- Should there be a `--list` flag on `groove-utilities-memory-mistakes` to show all open incidents without creating a new one? Likely yes — useful for mid-session status check without triggering the full flow.
- Long-term: could `groove-utilities-prime` surface the last N resolved mistakes as a pre-flight context read? Deferred — depends on the file growing enough to be worth it.
