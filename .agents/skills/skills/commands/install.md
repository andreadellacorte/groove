# Install Skill Backends

## Outcome

All configured skill backends are installed in dependency order. Each backend is reported as installed, already-present, or failed.

## Acceptance Criteria

- `task install` is run first (task backend)
- `memory install` is run second (creates session directories)
- Each step reports: installed / already-present / failed
- No-op per backend if configured to `none`
- Overall exit is non-zero if any backend failed

## Constraints

- Read `.groove/index.md` for `tasks:` config
- Dependency order must be respected: task → memory
- For each backend:
  - If `none`: skip with friendly message
  - If already installed: report version and skip
  - If not installed: install and confirm reachability
- Report a summary table at the end: backend | status | version
