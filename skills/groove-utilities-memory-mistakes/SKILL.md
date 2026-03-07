---
name: groove-utilities-memory-mistakes
description: "Log a workflow mistake, fix its root cause, and graduate the lesson to learned memory. Use when the agent makes an error you want to prevent recurring."
license: MIT
allowed-tools: Read Write Edit Glob Grep Bash(git:*) AskUserQuestion
metadata:
  author: andreadellacorte
---

# groove-utilities-memory-mistakes

Use $ARGUMENTS as the mistake description if provided (e.g. `--list` to show open incidents only).

## Outcome

The workflow mistake is logged, its root cause is fixed in the relevant memory or learned file, and the lesson is graduated to `<memory>/learned/<topic>.md`. The incident is moved to the Resolved table in `mistakes.md`.

## Acceptance Criteria

- Incident is recorded in `.groove/memory/mistakes.md` under "Incident Log"
- Root cause is identified and stated
- Permanent fix is applied to the relevant `.groove/memory/learned/<topic>.md`
- Incident is moved to Resolved table with date, root cause, fix, and learned file reference
- Log entry is deleted after resolution (file stays lean)

## Steps

### If `--list` is passed

- Read `.groove/memory/mistakes.md`; show all entries under "Incident Log" as a numbered list
- If none: print "No open incidents." — done

### Otherwise

1. Read `memory:` from `.groove/index.md` (default: `.groove/memory/`)
2. Check if `<memory>/mistakes.md` exists; if not, create it with the template below
3. If $ARGUMENTS provides a description, use it; otherwise ask: "What mistake did I make? (describe briefly)"
4. Ask: "What's the root cause — why did it happen?" (propose a likely cause from context; user confirms or corrects)
5. Ask: "What fix should be applied?" (propose from context; user confirms or types one)
6. Add an entry to "Incident Log" in `mistakes.md`:
   ```
   - **Date**: YYYY-MM-DD
   - **What happened**: <description>
   - **Root cause**: <root cause>
   - **Fix applied**: <fix>
   - **Status**: `pending`
   ```
7. Apply the fix immediately (edit the relevant file, correct the convention)
8. Update the entry status to `audited`
9. Ask: "Which learned topic should this lesson go into? (e.g. `anti-patterns`, `tools`, `patterns`)" — suggest based on the root cause
10. Append a bullet to `<memory>/learned/<topic>.md` under a `## YYYY-MM-DD` heading (create file with `# <Topic>` heading if absent; create dated heading if absent)
11. Add a row to the Resolved table in `mistakes.md`:
    `| YYYY-MM-DD | <one-line description> | <root cause> | <fix summary> | learned/<topic>.md |`
12. Delete the Incident Log entry (keep file lean)
13. Report: "Incident logged and resolved → learned/<topic>.md"

## `mistakes.md` template

Create at `<memory>/mistakes.md` if it does not exist:

```markdown
# Mistakes and Lessons

## How This File Works

1. **Log it** — Record in Incident Log below when an error is identified
2. **Fix it** — Apply the fix (code, config, file, convention)
3. **Audit it** — Identify root cause; add permanent fix to `.groove/memory/learned/<topic>.md`
4. **Summarise** — Move lesson to Resolved table; delete log entry; keep file lean

## Incident Log

(Empty — no open incidents)

## Resolved

| Date | Mistake | Root Cause | Fix Applied | Learned File |
|---|---|---|---|---|
```

## Constraints

- Read `memory:` from `.groove/index.md` for base path; file is at `<memory>/mistakes.md`
- Never auto-create incidents without user confirmation — always wait for user to describe or confirm the mistake
- Root cause is required before resolving — do not skip the audit step
- If the fix targets a `skills/` file: note that `skills/` is managed by groove:update and changes will be overwritten; redirect the fix to `.groove/memory/learned/anti-patterns.md` with a workaround note
- After resolution, the Incident Log entry must be deleted — do not leave resolved entries in the log section
