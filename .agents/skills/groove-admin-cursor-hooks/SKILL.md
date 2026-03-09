---
name: groove-admin-cursor-hooks
description: "Install groove's Cursor native hooks into .cursor/hooks.json. Enables compaction-safe re-priming, session-end reminders, git activity capture, and managed-path protection."
license: MIT
allowed-tools: Read Write Edit Glob Bash(git:*) Bash(mkdir:*) Bash(chmod:*) Bash(python3:*) AskUserQuestion
metadata:
  author: andreadellacorte
---

<!-- groove:managed — do not edit; changes will be overwritten by groove update -->

# groove-admin-cursor-hooks

Install groove's Cursor native hooks. These run outside the model — deterministic, unconditional — and complement groove's advisory markdown hooks (`.groove/hooks/start.md`, `end.md`).

Use `--disable <hook>` to remove a specific hook. Use `--list` to show current status.

## Outcome

Selected hooks are registered in `.cursor/hooks.json` and shell scripts are written to `.groove/hooks/cursor/`. Hooks fire automatically on Cursor lifecycle events without any model involvement.

## Available hooks

| Name | Event | Matcher | What it does |
|---|---|---|---|
| `context-reprime` | `sessionStart` | — | Reads `.groove/index.md` and outputs full prime context as `additional_context` — ensures workflow context is loaded after every session start and compaction |
| `daily-end-reminder` | `stop` | — | If hour is 16–21 local time and `.groove/index.md` exists, prints a reminder to run `/groove-daily-end` |
| `git-activity-buffer` | `postToolUse` | `Shell` | If the command contains `git commit`, appends a timestamped line to `.groove/.cache/git-activity-buffer.txt` |
| `block-managed-paths` | `preToolUse` | `Write` | If `file_path` starts with `.agents/skills/groove` or `skills/groove`, exits with code 2 to block the write with an explanatory message |

## Steps

### `--list`

Read `.cursor/hooks.json` if it exists. Report which groove hooks are registered and which scripts exist in `.groove/hooks/cursor/`. Exit.

### `--disable <hook>`

Remove the named hook's entry from `.cursor/hooks.json` (leave the script in place). Report removed / not found. Exit.

### Default (install)

1. Ask which hooks to enable (default: all four):
   ```
   Which hooks to install? (all / comma-separated: context-reprime, daily-end-reminder, git-activity-buffer, block-managed-paths)
   Press enter for all.
   ```

2. Read `.cursor/hooks.json` if it exists; parse as JSON (default `{"version": 1, "hooks": {}}`). Never discard existing non-groove entries.

3. Create `.groove/hooks/cursor/` directory if absent. Make each script executable (`chmod +x`).

4. For each selected hook: write the shell script and merge the hook entry into `.cursor/hooks.json`.

5. Write `.cursor/hooks.json` with the merged result.

6. Report summary:
   ```
   ✓ context-reprime     — sessionStart hook → .groove/hooks/cursor/context-reprime.sh
   ✓ daily-end-reminder  — stop hook → .groove/hooks/cursor/daily-end-reminder.sh
   ✓ git-activity-buffer — postToolUse/Shell hook → .groove/hooks/cursor/git-activity-buffer.sh
   ✓ block-managed-paths — preToolUse/Write hook → .groove/hooks/cursor/block-managed-paths.sh
   ✓ .cursor/hooks.json updated
   ```

## Shell script templates

Write these verbatim to `.groove/hooks/cursor/`. Never overwrite an existing script without showing a diff and confirming.

### `context-reprime.sh`

```bash
#!/usr/bin/env bash
# groove: sessionStart hook — inject workflow context after session start / compaction
if [ -f ".groove/index.md" ]; then
  # Extract key config values from frontmatter
  echo '{"additional_context": "groove: run /groove-utilities-prime to load workflow context. This ensures conventions, config, and CLI reference are available in this session."}'
else
  echo '{"additional_context": "groove: .groove/index.md not found — run /groove-admin-install to set up groove."}'
fi
```

### `daily-end-reminder.sh`

```bash
#!/usr/bin/env bash
# groove: stop hook — remind about /groove-daily-end during work hours
hour=$(date +%H)
if [ -f ".groove/index.md" ] && [ "$hour" -ge 16 ] && [ "$hour" -le 21 ]; then
  echo "groove: end of work hours — consider running /groove-daily-end"
fi
```

### `git-activity-buffer.sh`

```bash
#!/usr/bin/env bash
# groove: postToolUse/Shell hook — buffer git commits for memory log
input=$(cat)
command=$(echo "$input" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))" 2>/dev/null)
if echo "$command" | grep -q "git commit"; then
  msg=$(echo "$command" | grep -oP '(?<=-m ")[^"]+' | head -1)
  mkdir -p .groove/.cache
  echo "$(date '+%Y-%m-%d %H:%M') | ${msg:-<no message>}" >> .groove/.cache/git-activity-buffer.txt
fi
```

### `block-managed-paths.sh`

```bash
#!/usr/bin/env bash
# groove: preToolUse/Write hook — block edits to managed groove paths
input=$(cat)
path=$(echo "$input" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('file_path',''))" 2>/dev/null)
if echo "$path" | grep -qE '^(\.agents/skills/groove|skills/groove)'; then
  echo "groove: blocked — '$path' is managed by groove update. Edit under skills/ and rsync to .agents/skills/." >&2
  exit 2
fi
```

## `.cursor/hooks.json` template

Merge these into the `hooks` key. Preserve all other keys.

```json
{
  "version": 1,
  "hooks": {
    "sessionStart": [
      {
        "command": "bash .groove/hooks/cursor/context-reprime.sh"
      }
    ],
    "stop": [
      {
        "command": "bash .groove/hooks/cursor/daily-end-reminder.sh"
      }
    ],
    "postToolUse": [
      {
        "matcher": "Shell",
        "command": "bash .groove/hooks/cursor/git-activity-buffer.sh"
      }
    ],
    "preToolUse": [
      {
        "matcher": "Write",
        "command": "bash .groove/hooks/cursor/block-managed-paths.sh"
      }
    ]
  }
}
```

When merging: if a `hooks` key already exists, append groove entries to the relevant event arrays. Do not create duplicates — check if a groove command entry already exists before appending.

## Constraints

- Never overwrite non-groove entries in `.cursor/hooks.json`
- Never overwrite an existing script without diff + confirmation
- Scripts use `python3` to parse JSON stdin — if python3 is absent, skip that hook and warn
- `block-managed-paths` uses exit code 2 (Cursor's convention to block the tool use)
- After install: remind the user that hooks take effect on the next Cursor session restart
- `.groove/hooks/cursor/` follows the `git.hooks` git strategy from `.groove/index.md`
- Create `.cursor/` directory if it does not exist
