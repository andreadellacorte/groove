# Migration Index

Ordered registry of all groove migrations. Each entry maps a from-version to a to-version with the migration file that handles the transition.

`groove update` reads this file to determine which migrations to run. It selects all rows where `To` > local `groove-version:` AND `To` <= installed version, then runs them in table order. The `From` field is informational only — it does not gate execution, so migrations apply correctly across any version gap.

## Format

| From | To | File | Description |
|---|---|---|---|
| 0.2.0 | 0.3.0 | 0.2.0-to-0.3.0.md | Add `last-version-check:` config key; write `.groove/.gitignore` from git strategy |
| 0.4.0 | 0.5.0 | 0.4.0-to-0.5.0.md | Remove `sessions:` config key; create session directories for native multi-session tracking |
| 0.5.3 | 0.6.0 | 0.5.3-to-0.6.0.md | Split flat `git:` into `git.memory/tasks/hooks` sub-keys; remove `finder:` and `sessions:`; move beans tasks to `.groove/tasks/` |
| 0.8.2 | 0.8.3 | 0.8.2-to-0.8.3.md | Move `last-version-check:` out of `index.md` into `.groove/.cache/last-version-check`; create `.cache/` directory; gitignore `.cache/*` |
| 0.8.3 | 0.8.4 | 0.8.3-to-0.8.4.md | Rewrite AGENTS.md sections to v0.8.x format: 2-line groove:prime bootstrap and 2-line groove:task stub |
| 0.8.6 | 0.8.7 | 0.8.6-to-0.8.7.md | Remove redundant beans prime line from groove:prime bootstrap in AGENTS.md |

## Notes

- Migrations are run in table order — order matters
- Each migration must be idempotent (safe to re-run if interrupted)
- After each successful migration, `groove-version:` in `.groove/index.md` is updated to the `To` version
- If the table is empty and versions match, `groove update` reports "already up to date"

## Adding a migration

See [CONTRIBUTING.md](../CONTRIBUTING.md) for the full versioning and migration guide.

Quick steps:
1. Create `migrations/<from>-to-<to>.md` following the outcome/criteria/constraints pattern
2. Add a row to the table above
3. Bump `metadata.version` in `skills/groove/SKILL.md`
4. Add an entry to `CHANGELOG.md`
