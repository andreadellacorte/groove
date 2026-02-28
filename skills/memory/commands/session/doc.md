# Session Doc

## Outcome

Documentation is created via the configured `sessions` backend. Delegates entirely to the backend.

## Acceptance Criteria

- Backend doc command is invoked with any provided arguments passed through
- Documentation is created by the backend (location and format determined by backend)
- If backend is not installed, user is warned with a path to resolve it

## Constraints

- Read `sessions:` from `.groove/index.md` frontmatter to determine backend
- If `sessions: bonfire`, invoke `/bonfire doc` — pass through any $ARGUMENTS
- If `sessions: none`, print no-op message
- If backend is configured but not installed, warn and offer to run `memory install`
- Do not implement any doc logic here — thin wrapper only
