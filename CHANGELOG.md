# Changelog

All notable changes to groove will be documented in this file.

## [0.3.1] - 2026-02-28

### Changed
- `groove install` hardcodes groove-wide companion skills (e.g. `agent-browser`) instead of reading from `skills-lock.json`
- Removed `skills-lock.json` from the groove repo — it is user-generated output, not maintained here

### Fixed
- Companion skill pattern clarified: groove-wide in `groove install`, backend-specific in sub-skill install commands

## [0.3.0] - 2026-02-28

### Added
- `groove config` — interactive wizard to create/update `.groove/index.md` with guided defaults
- `groove check` — standalone version check against latest GitHub release
- `groove prime` now checks for new versions once per day (`last-version-check:` in config)
- Git strategy enforcement — `groove install` and `groove config` write `.groove/.gitignore`
- `last-version-check:` config key added to `.groove/index.md`

## [0.2.0] - 2026-02-28

### Added
- `/groove` unified entry point — single skill routing all sub-commands
- `groove help` and per-skill `help` commands
- `groove install` — orchestrates all backend + companion installs
- `groove prime` — writes groove context to `AGENTS.md` (fenced sections)
- `groove doctor` — consolidated health check across all sub-skills, version drift detection
- `groove update` — ordered migration runner (`migrations/` + `migrations/index.md`)
- `task doctor`, `memory doctor`, `skills doctor` sub-skill health checks
- `beans prime` output written to `AGENTS.md` on `task install`
- Bonfire configured to use groove memory paths on `memory install`
- `agent-browser` pre-seeded as companion skill in `skills-lock.json`
- `groove-version:` config key in `.groove/index.md` for migration tracking
- `CONTRIBUTING.md` — versioning, migration, and companion skill guide

### Fixed
- `find-skills` install source corrected to `https://github.com/vercel-labs/skills --skill find-skills`

## [0.1.0] - 2026-02-28

### Added
- Initial release
- `daily` skill — startup and closeout rituals
- `work` skill — compound engineering loop
- `task` skill — backend-agnostic task management
- `memory` skill — log population and session wrapper
- `skills` skill — discovery and lock file management
- `scripts/setup.sh` — bootstrap all backends from config
