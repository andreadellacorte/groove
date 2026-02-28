# Changelog

All notable changes to groove will be documented in this file.

## [0.6.0] - 2026-02-28

### Added
- Per-component git strategy: `git:` is now a mapping with `memory:`, `tasks:`, and `hooks:` sub-keys
- Each sub-key independently controls what gets committed during daily closeout and what `.groove/.gitignore` ignores

### Changed
- `.groove/.gitignore` is now generated from per-component strategies instead of a single flat value
- `git.hooks` defaults to `commit-all` (hooks are team-shareable by default)
- Beans task path changed from `.beans` to `.groove/tasks` — tasks now live inside the groove directory tree
- Daily closeout commit logic updated to stage per-component based on each `git.*` value

### Removed
- `finder:` config key — skill discovery uses `npx skills` / skills.sh directly; no config key needed
- `sessions:` config key — fully removed (was already unused since 0.5.0)

### Migration

Run `groove update` to apply the `0.5.3 → 0.6.0` migration automatically:
1. Converts flat `git: <value>` to `git.memory/tasks/hooks` sub-keys (all inherit old value)
2. Removes obsolete `finder:` and `sessions:` keys
3. Regenerates `.groove/.gitignore` from new sub-keys
4. Updates `.beans.yml` to use `path: .groove/tasks`; creates `.groove/tasks/` directory

## [0.5.3] - 2026-02-28

### Fixed
- `skills install`: removed stale `sessions:` config read; updated memory step description (no longer a "sessions backend")
- `groove install`: added explicit `ls .agents/skills/agent-browser/SKILL.md` check so the agent doesn't improvise presence checks using the wrong path

## [0.5.2] - 2026-02-28

### Fixed
- `groove install` no longer references bonfire as memory backend; summary line updated to "memory backend — session dirs ready"
- `groove prime` AGENTS.md template: removed `sessions:` config line; updated session start description; added `session resume` to key commands

## [0.5.1] - 2026-02-28

### Fixed
- Moved `migrations/` into `skills/groove/migrations/` so migrations are included when groove is installed via `npx skills add` — previously `groove update` always reported "no migration path found"
- Updated `memory help` to list `session resume` and remove bonfire references

## [0.5.0] - 2026-02-28

### Added
- `groove memory session resume [name]` — resume an existing active session; lists active sessions if no name given
- Native multi-session tracking: sessions stored as individual files at `<memory>/sessions/<name>.md`
- Auto-naming for sessions: `<branch>-<YYYY-MM-DD>-<N>` when no name provided
- Session template at `skills/memory/templates/session.md`
- `groove doctor` now checks that the current directory is a git repo (bonfire and session management depend on it)

### Changed
- `groove memory session start/end` rewritten — now support named parallel sessions; `end` accepts `[name]` and prompts if absent
- `groove memory session spec/doc/review` implemented directly in groove (no longer delegated to bonfire)
- `groove memory install` simplified — creates session directories only, no external backend
- `groove memory doctor` checks session directory structure instead of bonfire backend

### Removed
- Bonfire session backend — the `sessions:` config key in `.groove/index.md` is no longer read
- Bonfire skill dependency

### Migration

Run `groove update` to apply the `0.4.0 → 0.5.0` migration automatically:
- Removes the obsolete `sessions:` key from `.groove/index.md`
- Creates `<memory>/sessions/specs/` and `<memory>/sessions/docs/` directories

If you had bonfire installed, remove it: `npx skills remove bonfire`

## [0.4.0] - 2026-02-28

### Added
- User-defined daily hooks — `groove install` creates `.groove/hooks/` (with `.gitkeep`)
- `daily startup` and `daily closeout` execute `.groove/hooks/startup.md` / `.groove/hooks/closeout.md` if present, skip silently if not
- Hook templates at `skills/daily/templates/hooks/` document the format

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
