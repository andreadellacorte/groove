# Session Resume

## Outcome

An existing active session is loaded. User has context on previous work and knows what to continue.

## Acceptance Criteria

- Session file is found and read
- Context is summarized to user: goal, work done so far, decisions, next steps
- User is asked what to continue working on this session

## Constraints

- Read `memory:` from `.groove/index.md` frontmatter for base path
- Parse `$ARGUMENTS` for an optional session name:
  - If provided, load `<memory>/sessions/<name>.md` directly — abort with error if not found
  - If not provided, list all session files at `<memory>/sessions/` where `status: active`; ask user to pick one — if none active, say "No active sessions found"
- If the selected session has `status: ended`, warn the user: "Session `<name>` has ended. Resume anyway?" — if yes, set `status: active` in frontmatter
- Summarize session context to user:
  - Goal, branch, started date
  - Work done so far (if any)
  - Decisions (if any)
  - Next steps (if any)
- Ask user what to continue working on
