# Session Start

## Outcome

Session is started and context is loaded. User knows what to work on. Delegates entirely to the configured `sessions` backend.

## Acceptance Criteria

- Session backend is invoked successfully
- User receives context from the backend (previous session state, open work, agenda)
- If backend is not installed, user is warned with a path to resolve it

## Constraints

- Read `sessions:` from `.groove/index.md` frontmatter to determine backend
- If `sessions: bonfire`, invoke `/bonfire start` — pass through any $ARGUMENTS
- If `sessions: none`, print no-op message: "Session management is disabled (sessions: none). Update .groove/index.md to enable."
- If backend is configured but not installed, warn and offer to run `memory install`
- Do not implement any session logic here — this is a thin wrapper only
