# Install Skill Backends

## Outcome

All configured skill backends are installed in dependency order. The configured `finder` backend is installed last. Each backend is reported as installed, already-present, or failed.

## Acceptance Criteria

- `task install` is run first (task backend)
- `memory install` is run second (sessions backend)
- `finder` backend is installed last
- Each step reports: installed / already-present / failed
- No-op per backend if configured to `none`
- Overall exit is non-zero if any backend failed

## Constraints

- Read `.groove/index.md` for `tasks:`, `sessions:`, and `finder:` config
- Dependency order must be respected: task → memory → finder
- For each backend:
  - If `none`: skip with friendly message
  - If already installed: report version and skip
  - If not installed: install and confirm reachability
- Finder backend install:
  - `find-skills`: run `npx skills add https://github.com/vercel-labs/skills --skill find-skills`; verify by checking find-skills skill is available
- Report a summary table at the end: backend | status | version
