# Session End

## Outcome

Session is ended and context is persisted. Delegates entirely to the configured `sessions` backend.

## Acceptance Criteria

- Session backend end command is invoked successfully
- Session state is persisted by the backend
- If backend is not installed, user is warned with a path to resolve it

## Constraints

- Read `sessions:` from `.groove/index.md` frontmatter to determine backend
- If `sessions: bonfire`, invoke `/bonfire end` — pass through any $ARGUMENTS
- If `sessions: none`, print no-op message
- If backend is configured but not installed, warn and offer to run `memory install`
- Do not implement any session logic here — thin wrapper only
