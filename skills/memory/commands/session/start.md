# Session Start

## Outcome

A new named session is created. User knows what to work on. Session file is ready for updates throughout the session.

## Acceptance Criteria

- Session file created at `<memory>/sessions/<name>.md`
- Session name is shown to user
- User is asked what to work on this session
- User is given the exact command to end the session

## Constraints

- Read `memory:` from `.groove/index.md` frontmatter for base path (default: `.groove/memory/`)
- Get current branch: `git symbolic-ref --short HEAD 2>/dev/null || echo "main"` (works on repos with no commits)
- Check for existing active sessions: scan `<memory>/sessions/*.md` for files with `status: active` in frontmatter
  - If any active sessions exist, list them by name and ask the user to confirm they want to start a new one (they may have meant `groove memory session resume`)
  - Only proceed if the user confirms
- Parse `$ARGUMENTS` for an optional session name:
  - If provided, use it as-is — abort if that file already exists
  - If not provided, auto-generate: `<branch>-<YYYY-MM-DD>-<N>` where N is the lowest integer (starting at 1) such that `<memory>/sessions/<name>.md` does not already exist
- Get ISO timestamp: `date -u +"%Y-%m-%dT%H:%M:%SZ"` for frontmatter `started:` field
- Create `<memory>/sessions/` directory if it does not exist (also create `specs/` and `docs/` subdirectories)
- Ask user what to work on this session — use their answer as `<GOAL>`
- Create session file from `templates/session.md`, substituting all placeholders
- After creating the file, tell the user: "Session `<name>` started. End with: `groove memory session end <name>`"
