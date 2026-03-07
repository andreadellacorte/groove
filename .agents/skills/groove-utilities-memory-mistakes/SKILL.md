---
name: groove-utilities-memory-mistakes
description: "Log a workflow mistake, fix its root cause, and graduate the lesson to learned memory. Use when the agent makes an error you want to prevent recurring."
license: MIT
allowed-tools: Read Write Edit Glob Grep Bash(git:*) Bash(beans:*) AskUserQuestion
metadata:
  author: andreadellacorte
---

# groove-utilities-memory-mistakes

Use $ARGUMENTS as the mistake description if provided (e.g. `--list` to show open incidents only).

## Outcome

The workflow mistake is logged, its root cause is fixed in the relevant memory or learned file, and the lesson is graduated to `<memory>/learned/<topic>.md`. The incident is closed.

## Acceptance Criteria

- Incident is recorded with root cause and fix
- Permanent fix applied to `.groove/memory/learned/<topic>.md`
- Incident marked resolved

## Backend detection

Read `tasks:` from `.groove/index.md`:
- If `tasks: beans` → use **beans mode** for incident tracking; still write audit trail to `mistakes.md`
- Otherwise → use **markdown mode** exclusively

---

## Beans mode

Incidents are stored as beans bugs under a shared "Groove Memory" milestone → "Mistakes" epic.

### Ensure parent hierarchy

Before any operation, resolve or create the parent epic:

1. Find or create the **Groove Memory** milestone:
   - `beans list -t milestone --search "Groove Memory" -q` — if non-empty, use first ID; otherwise `beans create "Groove Memory" -t milestone`
2. Find or create the **Mistakes** epic under that milestone:
   - `beans list -t epic --parent <milestone-id> --search "Mistakes" -q` — if non-empty, use first ID; otherwise `beans create "Mistakes" -t epic --parent <milestone-id>`

### `--list` (beans)

1. Resolve `<parent-id>`
2. `beans list --parent <parent-id> -t bug -s in-progress`
3. Display as numbered list: `1. [<id>] <title>`
4. If empty: print "No open incidents."

### Log and resolve an incident (beans)

1. Resolve `<parent-id>`
2. Get description from $ARGUMENTS or ask: "What mistake did I make?"
3. Ask: "Root cause — why did it happen?" (propose from context; user confirms)
4. Ask: "What fix should be applied?" (propose; user confirms)
5. `beans create "<description>" -t bug --parent <parent-id> -s in-progress`
6. Apply the fix immediately (edit the relevant file)
7. Ask: "Which learned topic? (e.g. `anti-patterns`, `tools`)" — suggest based on root cause
8. Append lesson to `<memory>/learned/<topic>.md` under `## YYYY-MM-DD` heading
9. `beans update <id> -s completed`
10. Write one row to Resolved table in `<memory>/mistakes.md` (create file with header if absent):
    `| YYYY-MM-DD | <description> | <root cause> | <fix summary> | learned/<topic>.md |`
11. Report: "Incident resolved → learned/<topic>.md"

---

## Markdown mode

Uses `<memory>/mistakes.md` exclusively when beans is not configured.

### `--list` (markdown)

- Read `<memory>/mistakes.md`; show all entries under "Incident Log" as a numbered list
- If none: print "No open incidents."

### Log and resolve an incident (markdown)

1. Read `memory:` from `.groove/index.md`; check if `<memory>/mistakes.md` exists; create with template below if not
2. If $ARGUMENTS provides description, use it; otherwise ask: "What mistake did I make?"
3. Ask: "Root cause — why did it happen?" (propose from context; user confirms)
4. Ask: "What fix should be applied?" (propose; user confirms)
5. Add entry to "Incident Log":
   ```
   - **Date**: YYYY-MM-DD
   - **What happened**: <description>
   - **Root cause**: <root cause>
   - **Fix applied**: <fix>
   - **Status**: `pending`
   ```
6. Apply the fix immediately
7. Update entry status to `audited`
8. Ask: "Which learned topic? (e.g. `anti-patterns`, `tools`)"
9. Append lesson to `<memory>/learned/<topic>.md`
10. Add row to Resolved table; delete Incident Log entry
11. Report: "Incident resolved → learned/<topic>.md"

## `mistakes.md` template

```markdown
# Mistakes and Lessons

## How This File Works

1. **Log it** — Record when an error is identified
2. **Fix it** — Apply the fix
3. **Audit it** — Identify root cause; add fix to `learned/<topic>.md`
4. **Summarise** — Move to Resolved; delete log entry

## Incident Log

(Empty — no open incidents)

## Resolved

| Date | Mistake | Root Cause | Fix Applied | Learned File |
|---|---|---|---|---|
```

## Constraints

- Read `tasks:` and `memory:` from `.groove/index.md`
- Never auto-create incidents without user confirmation
- Root cause is required before resolving — do not skip the audit step
- Beans mode: parent hierarchy is idempotent — always check before creating
- Beans mode: still write audit trail row to `mistakes.md` Resolved table even when using beans
- If the fix targets a `skills/` file: note that `skills/` is managed by groove:update; redirect fix to `learned/anti-patterns.md`
- Markdown mode: delete Incident Log entry after resolution — keep file lean
- If Resolved table exceeds 50 rows: move oldest 25 to `<memory>/mistakes-archive.md` (append, create with same header if absent), delete from `mistakes.md`
