---
name: groove-utilities-memory-promises
description: "Capture and resolve deferred items from a session ('we'll come back to that'). Use $ARGUMENTS as the promise text, or --list / --resolve N."
license: MIT
allowed-tools: Read Write Edit Glob AskUserQuestion
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

- New promise added to Open table in `<memory>/promises.md` with date and context
- `--list` shows all open promises clearly numbered
- `--resolve N` moves the promise to the Resolved table with today's date

## Steps

### `--list`

1. Read `memory:` from `.groove/index.md`
2. Read `<memory>/promises.md`; if absent, print "No promises file yet — run `/groove-utilities-memory-promises <text>` to add one." and exit
3. Print the Open table; if empty, print "No open promises."

### `--resolve <N>`

1. Read `<memory>/promises.md`
2. Find the row with `#` matching N in the Open table
3. If not found: print "No open promise #N" and exit
4. Move the row to the Resolved table, replacing the `Context` column with `Resolved: <today>`
5. Renumber remaining Open rows from 1
6. Write updated file

### Default (add a promise)

1. Read `memory:` from `.groove/index.md`
2. Check if `<memory>/promises.md` exists; if not, create it with the template below
3. Get promise text from $ARGUMENTS if provided; otherwise ask: "What's being deferred?"
4. Optionally ask: "Any context? (enter to skip)" — keeps promise actionable later
5. Append a new row to the Open table; assign the next sequential `#`; use today's date
6. Confirm: "Promise #N captured."

## `promises.md` template

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

- Read `memory:` from `.groove/index.md`; file is at `<memory>/promises.md`
- Never auto-capture promises without user confirmation — always explicit
- Renumber Open rows after every resolve to keep numbers contiguous
- Context column is optional — blank is fine; short is better than long
- Do not resolve all promises automatically; always resolve one at a time unless user explicitly asks for `--resolve-all`
- `--resolve-all` requires confirmation: "Resolve all N open promises?" before proceeding
