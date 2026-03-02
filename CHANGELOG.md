# Changelog

All notable changes to groove will be documented in this file.

## [0.9.1] - 2026-03-02

### Fixed
- `groove update` now verifies installed skill version against GitHub `releases/latest` after `npx skills add`; if the add step left an older version on disk (cached or default branch), the user is warned and told to run `npx skills add andreadellacorte/groove@v<latest> --yes` then update again — avoids falsely reporting "up to date" when a newer release exists

## [0.9.0] - 2026-03-02

### Migration
- Migration `0.8.9 → 0.9.0`: remove obsolete `.agents/skills/skills` directory (the former skills wrapper skill removed in 0.7.0; new installs never had it, existing installs are now cleaned up)

## [0.8.9] - 2026-03-02

### Migration
- Migration `0.8.8 → 0.8.9`: move spec files from `<memory>/sessions/specs/` to `<memory>/specs/`

### Added
- **pdf-to-markdown** — embedded companion skill: convert PDFs to Markdown (npx-based, no local node_modules). Installed and checked by `groove install` / `groove doctor`.

## [0.8.8] - 2026-03-01

### Changed
- `groove:task` stub wording: "Run `beans prime` to load the full beans CLI reference" (imperative, not conditional)

## [0.8.7] - 2026-03-01

### Fixed
- `groove:prime` bootstrap no longer mentions `beans prime` — that's already covered by the `groove:task` section; each section now covers its own domain without overlap
- Migration `0.8.6 → 0.8.7` removes the redundant line from existing `AGENTS.md` files

## [0.8.6] - 2026-03-01

### Fixed
- `groove update` now re-reads `commands/update.md` from disk after `npx skills add` completes — ensures the agent executes the latest update logic when the update command itself has changed between versions

## [0.8.5] - 2026-03-01

### Fixed
- `groove update` migration filter now uses `To > local version AND To <= installed version` — the `From` field is informational only and no longer gates execution; migrations now apply correctly across any version gap (e.g. 0.7.1 → 0.8.5 now runs all 0.8.x migrations)

## [0.8.4] - 2026-03-01

### Fixed
- Migration `0.8.3 → 0.8.4` rewrites both AGENTS.md sections to the v0.8.x format — existing installs that ran `groove install` before v0.8.1 no longer need manual AGENTS.md cleanup

### Migration

Run `groove update` — the `0.8.3 → 0.8.4` migration rewrites:
- `<!-- groove:prime:start -->` → 2-line session bootstrap
- `<!-- groove:task:start -->` → 2-line beans stub

## [0.8.3] - 2026-03-01

### Changed
- `last-version-check:` moved out of `.groove/index.md` into `.groove/.cache/last-version-check` (plain text file) — cache data no longer lives in the config file
- `.groove/.cache/` directory is now created by `groove install` with a `.gitkeep`; its contents are always gitignored regardless of git strategy
- `groove prime` and `groove check` read/write `.groove/.cache/last-version-check` instead of the `index.md` key
- `groove config` always appends `.cache/*` / `!.cache/.gitkeep` to `.groove/.gitignore`

### Migration

Run `groove update` — the `0.8.2 → 0.8.3` migration will:
1. Create `.groove/.cache/` with `.gitkeep`
2. Move any existing `last-version-check:` value to `.groove/.cache/last-version-check`
3. Remove `last-version-check:` from `.groove/index.md`
4. Append cache gitignore rules to `.groove/.gitignore`

## [0.8.2] - 2026-03-01

### Fixed
- `groove prime` now outputs workflow context to the conversation only — it no longer writes to `AGENTS.md`
- `groove install` now owns the `<!-- groove:prime:start -->` bootstrap section in `AGENTS.md` directly, rather than delegating to `groove prime`
- `groove update` no longer calls `groove prime` after migrations — AGENTS.md bootstrap is static and managed by install/migrations only

### Migration

No config changes. No action needed.

## [0.8.1] - 2026-03-01

### Fixed
- `groove prime` now writes a 2-line bootstrap instruction to `AGENTS.md` instead of embedding the full workflow context — agents load context on demand by running `/groove prime` at session start
- `task install` now writes a minimal 2-line stub to `AGENTS.md` instead of the full `beans prime` output — full beans reference available via `beans prime` on demand
- `groove install` step 8 removed — it was calling `beans prime` directly, bypassing the stub written by `task install` in step 2

### Migration

No config changes. If you ran `groove install` or `groove prime` on v0.8.0, re-run the following to update your `AGENTS.md` to the new format:
```
groove prime
groove task install
```

## [0.8.0] - 2026-03-01

### Added
- `<!-- groove:managed -->` comment in all five skill `SKILL.md` files — signals to agents that these files are owned by `groove update` and must not be edited directly
- `## Constraints` section in the `groove prime` block template — emitted into `AGENTS.md` on every `groove prime` run; instructs agents not to edit `skills/` or `.agents/skills/`, and clarifies that `.groove/` is the user zone
- `<memory>/learned/` directory — created by `groove memory install` alongside session dirs; serves as the cold/long-term tier for workflow insights
- Workflow learning routing in `work compound` — after the compound checklist, detects lessons about AI workflow, agent behaviour, or engineering process and (if confirmed) appends them to `.groove/memory/learned/<topic>.md`; skips silently if no workflow lessons found
- Optional learned memory prompt in `memory session end` — after closing a session, asks "Any workflow insights to capture?" and writes to `.groove/memory/learned/<topic>.md` if user provides a topic

### Changed
- `AGENTS.md` updated (re-primed) to include the new `## Constraints` section

## [0.7.2] - 2026-02-28

### Fixed
- `groove update`: no longer warns "no migration path found" when versions differ but no migration is registered — patch releases with no config changes now correctly bump `groove-version:` directly

## [0.7.1] - 2026-02-28

### Fixed
- `groove install`: corrected `find-skills` install URL (`nicholasgasior/find-skills` → `vercel-labs/skills --skill find-skills`)
- `task install`: corrected beans repo URL (`andreadellacorte/beans` → `hmans/beans`) and version command (`--version` → `beans version`)

## [0.7.0] - 2026-02-28

### Removed
- `skills/skills` wrapper skill — removed entirely; it provided no meaningful value without an access-control layer
- All `skills *` routing from `groove` SKILL.md (`skills help`, `skills find`, `skills add`, `skills remove`, `skills install`, `skills check`, `skills doctor`)

### Changed
- `groove install`: replaces `groove skills install` call with direct steps — runs `task install`, `memory install`, then installs `find-skills` and `agent-browser` via `npx skills` directly
- `groove doctor`: replaces `skills doctor` delegation with a direct **companions** check — verifies `find-skills` and `agent-browser` are present in `.agents/skills/`
- `groove help`: removed `skills` from the skills table and quick reference

## [0.6.1] - 2026-02-28

### Fixed
- Moved `.groove/index.md` template from `skills/task/templates/groove-config.md` to `skills/groove/templates/index.md` — it belongs to groove core, not the task skill
- Removed `guardrails.default.require-confirmation` config key — it was never read by any skill
- Updated all bootstrap references across task, daily, and memory skills

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
