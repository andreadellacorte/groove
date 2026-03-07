---
name: groove-utilities-memory-promises
description: "Capture and resolve deferred items from a session ('we'll come back to that'). Use $ARGUMENTS as the promise text, or --list / --resolve N."
license: MIT
allowed-tools: Read Write Edit Glob Bash(beans:*) AskUserQuestion
metadata:
  author: andreadellacorte
---

# groove-utilities-memory-promises

Use $ARGUMENTS as the promise text if provided, or a flag:
- `--list`: show all open promises
- `--resolve <N>`: mark promise N as resolved

## Outcome

Deferred items from a session are captured before they are forgotten, or existing open promises are reviewed and resolved.

## Acceptance Criteria

- New promise captured with date and optional context
- `--list` shows all open promises clearly numbered
- `--resolve N` marks promise N as resolved

## Backend detection

Read `tasks:` from `.groove/index.md`:
- If `tasks: beans` → use **beans mode** (below)
- Otherwise → use **markdown mode** (below)

---

## Beans mode

Promises are stored as beans tasks under a shared "Groove Memory" milestone → "Promises" epic hierarchy. This keeps them organised and out of the main work task list.

### Ensure parent hierarchy

Before any operation, resolve or create the parent epic:

1. Find or create the **Groove Memory** milestone:
   - `beans list -t milestone --search "Groove Memory" -q` — if output is non-empty, use the first ID; otherwise `beans create "Groove Memory" -t milestone` and capture the new ID
2. Find or create the **Promises** epic under that milestone:
   - `beans list -t epic --parent <milestone-id> --search "Promises" -q` — if non-empty, use first ID; otherwise `beans create "Promises" -t epic --parent <milestone-id>` and capture the new ID

Use the Promises epic ID as `<parent-id>` for all promise tasks.

### `--list` (beans)

1. Resolve `<parent-id>` (see above)
2. `beans list --parent <parent-id> -s todo -t task`
3. Display as numbered list: `1. [<id>] <title>` — position number for `--resolve N`, beans ID in brackets
4. If empty: print "No open promises."

### `--resolve <N>` (beans)

1. Resolve `<parent-id>`; run `beans list --parent <parent-id> -s todo -t task`
2. Find the Nth item; if not found: print "No open promise #N" and exit
3. `beans update <id> -s completed`
4. Confirm: "Promise #N resolved."

### Default — add a promise (beans)

1. Resolve `<parent-id>` (see above)
2. Get promise text from $ARGUMENTS if provided; otherwise ask: "What's being deferred?"
3. Optionally ask: "Any context? (enter to skip)"
4. `beans create "<text>" -t task --parent <parent-id> -s todo -p deferred`
5. If context given: `beans update <id> -d "<context>"`
6. Confirm: "Promise captured: [<id>] <text>"

---

## Markdown mode

Uses `<memory>/promises.md` when beans is not configured.

### `--list` (markdown)

1. Read `memory:` from `.groove/index.md`
2. Read `<memory>/promises.md`; if absent, print "No promises file yet — run `/groove-utilities-memory-promises <text>` to add one." and exit
3. Print the Open table; if empty, print "No open promises."

### `--resolve <N>` (markdown)

1. Read `<memory>/promises.md`
2. Find the row with `#` matching N in the Open table; if not found: print "No open promise #N" and exit
3. Move the row to the Resolved table, replacing Context with `Resolved: <today>`
4. Renumber remaining Open rows from 1
5. Write updated file

### Default — add a promise (markdown)

1. Read `memory:` from `.groove/index.md`
2. Check if `<memory>/promises.md` exists; if not, create it with the template below
3. Get promise text from $ARGUMENTS if provided; otherwise ask: "What's being deferred?"
4. Optionally ask: "Any context? (enter to skip)"
5. Append a new row to the Open table; assign next sequential `#`; use today's date
6. Confirm: "Promise #N captured."

## `promises.md` template (markdown mode)

```markdown
# Promises

Deferred items from work sessions — things to come back to.

## Open

| # | Date | Promise | Context |
|---|---|---|---|

## Resolved

| # | Date | Promise | Resolved |
|---|---|---|---|
```

## Constraints

- Read `tasks:` and `memory:` from `.groove/index.md` at the start of every invocation
- Never auto-capture promises without user confirmation — always explicit
- Beans mode: milestone/epic parent hierarchy is idempotent — always check before creating; never create duplicates
- Beans mode: use `-s todo` for open, `-s completed` for resolved; `-p deferred` to signal not active work
- Markdown mode: renumber Open rows after every resolve to keep numbers contiguous
- Do not resolve all promises automatically; resolve one at a time unless user asks for `--resolve-all`
- `--resolve-all` requires confirmation: "Resolve all N open promises?" before proceeding
