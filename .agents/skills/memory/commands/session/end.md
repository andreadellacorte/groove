# Session End

## Outcome

The named session is captured and closed. Work done, decisions, and next steps are recorded in the session file.

## Acceptance Criteria

- Session file `<memory>/sessions/<name>.md` is updated with work done, decisions, next steps
- Session `status` is set to `ended` in frontmatter
- User sees a summary of what was captured

## Constraints

- Read `memory:` from `.groove/index.md` frontmatter for base path
- Parse `$ARGUMENTS` for an optional session name:
  - If provided, use `<memory>/sessions/<name>.md` directly — abort with error if not found
  - If not provided, list all session files at `<memory>/sessions/` where `status: active`; ask user to pick one — if none active, say "No active sessions found"
- Synthesize work done from:
  - `git log --oneline --since="<started>"` where `<started>` is the `started:` value from session frontmatter
  - Conversation context (what was discussed and accomplished this session)
- Update the session file in place:
  - Populate `## Work Done` with a concise bullet-point summary
  - Populate `## Decisions` with key decisions made (skip section if none)
  - Populate `## Next Steps` with remaining work or follow-ups (skip section if none)
  - Set `status: ended` in frontmatter
- Do not delete the session file — keep it for historical reference
