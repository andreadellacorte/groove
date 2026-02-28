# Groove Update

## Outcome

All pending migrations are applied to the user's local groove state in version order. `.groove/index.md` reflects the current installed groove version. AGENTS.md is refreshed.

## Acceptance Criteria

- `groove-version:` in `.groove/index.md` matches `version:` in `skills/groove/SKILL.md` after update
- Each pending migration was applied in order
- `groove-version:` updated after each successful migration (partial progress is recoverable)
- `groove prime` re-run after all migrations complete (AGENTS.md reflects any config changes)
- If already up to date, reports clearly and exits

## Steps

1. Run `npx skills add andreadellacorte/groove --yes` — pulls latest groove skill files and refreshes the lock entry (more reliable than `npx skills update` which requires a pre-populated folder hash)
2. Read `groove-version:` from `.groove/index.md` — if key absent, assume `0.1.0` and write it
3. Read installed version from `version:` in `skills/groove/SKILL.md`
4. If versions match: report "groove is up to date (v<version>)" and exit
5. Read `migrations/index.md` — parse the migration table
6. Filter rows where `From` >= local version and `To` <= installed version, in table order
7. If no migrations found but versions differ: update `groove-version:` in `.groove/index.md` directly to the installed version and report "no state migrations needed — version bumped to v<version>"
8. For each pending migration:
   a. Report "Applying <from> → <to>: <description>"
   b. Read and execute the migration file
   c. Update `groove-version:` in `.groove/index.md` to the `To` version
   d. Report "✓ <from> → <to> applied"
9. Run `groove prime` to refresh AGENTS.md
10. Report summary: N migrations applied, now at v<version>

## Constraints

- Never skip a migration — apply every step in sequence even if from/to seem far apart
- Update `groove-version:` after each individual migration, not only at the end
- If a migration fails: stop, report the failure and current version, do not continue
- Do not modify skill files — `npx skills update` handles that; this command only migrates local state
- Local state includes: `.groove/index.md` config keys, memory directory structure, AGENTS.md sections
- Each migration file is idempotent — if re-run after partial failure, it should be safe
