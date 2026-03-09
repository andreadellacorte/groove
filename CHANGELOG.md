# Changelog

All notable changes to groove will be documented in this file.

## [0.14.0] - 2026-03-09

### ⚠️ Breaking Changes

- **Config restructure** — `.groove/index.md` schema changed:
  - `tasks: beans` → `tasks.backend: beans` (grouped under `tasks:` with `list_limit` and `analyse_limit`)
  - `task.list_limit` / `task.analyse_limit` → `tasks.list_limit` / `tasks.analyse_limit`
  - `recent_memory_days: 5` → `memory.review_days: 5`
  - `memory:` and `specs:` keys removed — paths are now hardcoded to `.groove/memory/` and `.groove/memory/specs/`
- Migration `0.13.0 → 0.14.0` handles all key renames automatically via `/groove-admin-update`

## [0.13.0] - 2026-03-09

### ✨ New Skills

- `groove-admin-claude-statusline` — install a rich single-line Claude Code statusline showing model, repo@branch, token usage, effort level, 5h/7d rate-limit utilisation, and active `/loop` count with next-fire time. Scripts in `scripts/` per Agent Skills spec. Supports `--list` and `--uninstall`.

## [0.12.2] - 2026-03-09

### 🐞 Fixes

- Migration `0.11.7 → 0.12.0` — fixed stale `0.11.6` header in migration file content (filename was already correct).

## [0.12.1] - 2026-03-08

### 🐞 Fixes

- `groove-utilities-task-install` — configure beans `path:` to `.groove/tasks` after `beans init` so the task store lives under groove (aligned with `git.tasks` and `.groove/.gitignore`). Create `.groove/tasks` if needed; migrate any existing `.beans` content. Previously the store stayed at the default `.beans` at repo root.

## [0.12.0] - 2026-03-07

### ✨ New Skills

- `groove-utilities-memory-mistakes` — log a workflow mistake, identify root cause, apply fix, and graduate the lesson to `learned/<topic>.md`. Tracked as bugs in the task backend under "Groove Memory" → "Mistakes" epic.
- `groove-utilities-memory-promises` — capture deferred items as tasks in the backend under "Groove Memory" → "Promises" epic. Supports `--list` and `--resolve N`.
- `groove-utilities-memory-retrospective` — analyse session ratings, recurring mistakes, and learnings over a period (`week` / `month` / `all`). Sparkline-based summary output.
- `groove-utilities-memory-graduate` — promote a stable workflow insight from `learned/<topic>.md` into a permanent `<!-- groove:learned:start -->` section in AGENTS.md.
- `groove-utilities-onboard` — generate `GROOVE.md` contributor onboarding guide at project root with live config values.
- `groove-work-doc` — create "how does X work" reference documentation (Overview, Key Files, How It Works, Gotchas).
- `groove-groovebook-publish` — publish a workflow learning to a configured groovebook repo as a GitHub PR.
- `groove-groovebook-review` — browse and review open learning PRs in the groovebook repo.
- `groove-admin-claude-hooks` — install Claude Code native shell hooks into `.claude/settings.json` — three deterministic hooks: `daily-end-reminder` (Stop), `git-activity-buffer` (PostToolUse/Bash), `block-managed-paths` (PreToolUse/Write+Edit).

### 🔧 Enhanced Skills

- `groove-utilities-prime` — IDENTITY.md support (`.groove/IDENTITY.md` → `## Identity` section); `## Steering` section with six behavioral rules; `specs:` in config display; groovebook section (conditional); all new skills added to Key commands.
- `groove-work-review` — branch-diff analysis — runs `git log` + `git diff <base>...HEAD`; findings categorised as Fix Now / Needs Spec / Create Issues.
- `groove-work-compound` — checks for open mistake incidents in task backend; scans for deferred promises; suggests groovebook publish and memory graduation when appropriate; session rating signal → `learned/signals.md`.
- `groove-daily-start` — warns on open incidents and open promises from task backend (non-blocking).
- `groove-daily-end` — stale spec health check (30+ days); session rating prompt (1–5) → `learned/signals.md`; workflow insights prompt → `learned/<topic>.md`; retrospective hint on Fridays and end of month.
- `groove-utilities-memory-doctor` — checks for `learned/` directory.
- `groove-utilities-memory-install` — scaffolds `learned/` directory on install.
- `groove-admin-help` — all new skills, groovebook section (conditional), `specs:` and `groovebook:` in config block.
- `groove-work-spec` and `groove-work-audit` — read `specs:` from config for spec directory.

### 🐞 Fixes

- `groove-admin-config` — always writes `specs:` and `groovebook:` keys explicitly — no absent-means-default ambiguity.
- `groove-admin-install` — hook scaffolding — creates `start.md` and `end.md` with `## Actions` and commented examples so the hook system is discoverable on first install.
- Migration `0.11.7 → 0.12.0` — creates `learned/` directory; adds `specs:` (required) and `groovebook:` (default `andreadellacorte/groovebook`) to `.groove/index.md` if absent.
- Config template and install defaults — `specs:` always set (required); `groovebook:` default `andreadellacorte/groovebook`.

### 🏛️ Platform

- **Symlink architecture** — `.claude/skills/` and `.cursor/skills/` are now symlinks into `.agents/skills/` — single source of truth, no file duplication. Uses `ln -sfn` (no-dereference). `groove-admin-install` creates them, `groove-admin-update` re-syncs, `groove-admin-doctor` verifies.
- **Claude Code native hooks** — two-layer system — advisory markdown hooks (`.groove/hooks/start.md` / `end.md`) coexist with deterministic shell hooks (`.claude/settings.json`). Installed via `/groove-admin-claude-hooks`.
- **Bash fast-path** — mechanical skills can add a `scripts/` subdirectory per [Agent Skills spec](https://agentskills.io/specification); `bash: true` metadata flag; documented in CONTRIBUTING.md. Reference implementation: `groove-utilities-check/scripts/check.sh`.
- **README overhaul** — full skills table (35+ skills), hooks documentation (both layers), platform compatibility table (Claude Code verified; Cursor/Cline/Amp unverified).
- **Groovebook** — `andreadellacorte/groovebook` repository created with README, CONTRIBUTING, PR template, GitHub Pages.

## [0.11.7] - 2026-03-07

### Fixed
- `groove-utilities-task-archive`: reinstated no-confirmation change in installed skill after `npx skills add` overwrote it with a cached copy.

## [0.11.6] - 2026-03-07

### Changed
- `groove-utilities-task-archive`: removed confirmation prompt — archives immediately without asking.

## [0.11.5] - 2026-03-07

### Added
- Optional `task.list_limit` (default 15) and `task.analyse_limit` (default 30) in `.groove/index.md` for beans backend; task-list and task-analyse read these when present.
- `groove-utilities-task-list`: `scripts/list-tasks-by-priority.sh` for beans — lists active tasks by priority (critical → deferred) up to limit; requires `jq`.
- Migration `0.11.4-to-0.11.5`: adds `task:` block with `list_limit` and `analyse_limit` to existing `.groove/index.md`.

### Changed
- `groove-utilities-task-list` (beans): uses priority script instead of `beans list --json --ready`; output grouped by status (in-progress, todo, blocked).
- `groove-utilities-task-analyse` (beans): uses priority script for active tasks, separate `beans list --status completed/scrapped` for completed/scrapped; respects `task.analyse_limit`.
- `groove-work-compound`: new Scope section — "this conversation" means the full chat thread; in/out of scope clarified; when no other work is visible, ask which session to compound on instead of concluding "no work discussed."

## [0.11.4] - 2026-03-06

### Fixed
- `groove-daily-end`: description and outcome wording no longer mention committing — stale copy from before v0.11.1 was causing agents to commit during daily end despite the constraint having been removed.

## [0.11.3] - 2026-03-06

### Changed
- `groove-admin-install`: calls `groove-admin-config --defaults` on first run — no config prompts during install.
- `groove-admin-config`: `--defaults` flag applies all defaults without prompting; key=value args now use defaults for unspecified keys.
- `groove-utilities-task-install`: beans backend now initialised with `beans init` instead of manual template scaffolding; prefix derived from repo name and written back to the generated `.beans.yml`.
- `groove-daily-start`: skips recent-days review when `<memory>/daily/` is empty (fresh install).

## [0.11.2] - 2026-03-06

### Changed
- Templates moved into their owning skills (`groove-utilities-memory-log-*`, `groove-utilities-task-install`, `groove-work-brainstorm`, `groove-work-plan`, `groove-daily-start`) — no user-facing behaviour change.
- `groove` skill `commands/` directory removed; all routing now goes directly to individual `groove-admin-*` / `groove-utilities-*` skills.

### Removed
- `groove-utilities-memory-init-daily` skill — was an internal step called only from `groove-daily-start`; inlined into that skill.
- Legacy `daily/`, `task/`, `work/`, `memory/` directories under `.agents/skills/` — were template containers with no `SKILL.md`; content already migrated in v0.10.0.

## [0.11.1] - 2026-03-05

### Changed
- `groove-daily-end`: removed in-skill git commit behaviour — no longer stages or commits; use `.groove/hooks/end.md` for commit actions if desired. Constraint "Do NOT archive tasks" replaced with "Do NOT modify tasks during end".
- `groove-daily-start`: constraint "Do NOT archive tasks" replaced with "Do NOT modify tasks during start"; task-analyse call moved to top of Constraints.

## [0.11.0] - 2026-03-04

### Changed
- `groove-daily-start` recent days review now uses **business days** (Mon–Fri) instead of calendar days — weekends are skipped when counting back `recent_memory_days`.
- `groove-daily-start` now shows git activity per day (commit count + titles) alongside memory file status, giving a fuller picture of recent work.
- `recent_memory_days` template description updated to reflect business-day semantics and git context.

### Removed
- `groove-daily-start` no longer creates a startup task bean — the daily memory file is the canonical record of the day.
- `groove-daily-end` no longer creates an end task bean — daily memory captures the closeout.

## [0.10.1] - 2026-03-04

### Added
- 7 individual skills for groove top-level commands: `groove-admin-help`, `groove-admin-config`, `groove-admin-install`, `groove-admin-update`, `groove-admin-doctor` (admin namespace), `groove-utilities-prime`, `groove-utilities-check` (utilities namespace). Each appears as a separate entry in Claude Code's skill picker.
- `recent_memory_days: 5` config key in `.groove/index.md` template — controls how many days of daily memory `groove-daily-start` reviews at startup (default 5).
- `groove-daily-start` now reviews the last `recent_memory_days` days of memory files (presence, start-only vs start+end, one-line context each), replacing the previous yesterday-only check.

### Changed
- `groove` skill description updated to reference `groove-admin-*` and `groove-utilities-*` namespaces.
- `AGENTS.md` session bootstrap updated: `/groove prime` → `/groove-utilities-prime`.
- Internal cross-references updated to new skill names throughout (`/groove-admin-update`, `/groove-admin-install`, etc.).

## [0.10.0] - 2026-03-03

### Added
- 24 individual per-command skills under the `groove-*` namespace: `groove-daily-start`, `groove-daily-end`, `groove-work-brainstorm`, `groove-work-plan`, `groove-work-work`, `groove-work-review`, `groove-work-compound`, `groove-work-spec`, `groove-work-audit`, `groove-utilities-task-list`, `groove-utilities-task-create`, `groove-utilities-task-update`, `groove-utilities-task-archive`, `groove-utilities-task-analyse`, `groove-utilities-task-install`, `groove-utilities-task-config`, `groove-utilities-task-doctor`, `groove-utilities-memory-log-daily`, `groove-utilities-memory-log-weekly`, `groove-utilities-memory-log-monthly`, `groove-utilities-memory-log-git`, `groove-utilities-memory-init-daily`, `groove-utilities-memory-install`, `groove-utilities-memory-doctor`. Each appears as a separate entry in Claude Code's skill picker.

### Removed
- Standalone `daily`, `work`, `task`, `memory` skills — no longer registered as top-level skills. Their command content is now inlined directly into each `groove-*` SKILL.md.
- `commands/` directories under `skills/daily/`, `skills/work/`, `skills/task/`, `skills/memory/` — content moved into per-command SKILL.md files.

### Changed
- `groove` skill now routes only top-level commands (`help`, `install`, `config`, `update`, `check`, `prime`, `doctor`). Sub-skill routing removed.
- Each `groove-*` skill is fully self-contained — no indirection through a parent SKILL.md or separate command files.
- Internal cross-references updated from `groove:skill:command` format to `/groove-skill-name` format.

### Migration
- `groove update` bumps `groove-version:` to `0.10.0`.
- `AGENTS.md` `<!-- groove:task:start -->` stub updated to reference `/groove-utilities-task-*` skills (if still using old format).

## [0.9.4] - 2026-03-03

### Added
- CONTRIBUTING: "Publish release" subsection — tag + GitHub Release for each version so `groove check` / `groove prime` / `groove update` see correct latest; backfill procedure for existing tags.

## [0.9.2] - 2026-03-02

### Changed
- Daily commands renamed: `startup` / `closeout` → `start` / `end`. Use `groove daily start` and `groove daily end`.
- Hook files renamed: `.groove/hooks/startup.md` and `closeout.md` → `start.md` and `end.md`.

### Added
- **Daily start** now reviews yesterday's daily memory (shows summary; warns if missing or no end section) and creates today's daily memory file with a start-of-day structure.
- **memory init daily** — creates today's `<memory>/daily/YYYY-MM-DD.md` with start-of-day template (Plan for today). Called from daily start; at daily end, `memory log daily` appends the closeout sections.

### Migration
- If you have custom `.groove/hooks/startup.md` or `closeout.md`, rename them to `start.md` and `end.md` so the new daily commands run them. No migration script; manual rename only.

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
- Each sub-key independently controls what gets committed during daily end and what `.groove/.gitignore` ignores

### Changed
- `.groove/.gitignore` is now generated from per-component strategies instead of a single flat value
- `git.hooks` defaults to `commit-all` (hooks are team-shareable by default)
- Beans task path changed from `.beans` to `.groove/tasks` — tasks now live inside the groove directory tree
- Daily end commit logic updated to stage per-component based on each `git.*` value

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
- `daily start` and `daily end` execute `.groove/hooks/start.md` / `.groove/hooks/end.md` if present, skip silently if not
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
- `daily` skill — start and end rituals
- `work` skill — compound engineering loop
- `task` skill — backend-agnostic task management
- `memory` skill — log population and session wrapper
- `skills` skill — discovery and lock file management
- `scripts/setup.sh` — bootstrap all backends from config
