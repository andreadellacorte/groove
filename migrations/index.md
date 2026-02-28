# Migration Index

Ordered registry of all groove migrations. Each entry maps a from-version to a to-version with the migration file that handles the transition.

`groove update` reads this file to determine which migrations to run, filters to those between the user's current `groove-version:` and the installed groove version, and runs them in order.

## Format

| From | To | File | Description |
|---|---|---|---|

## Notes

- Migrations are run in table order — order matters
- Each migration must be idempotent (safe to re-run if interrupted)
- After each successful migration, `groove-version:` in `.groove/index.md` is updated to the `To` version
- If the table is empty and versions match, `groove update` reports "already up to date"

## Adding a migration

When releasing a new groove version:
1. Create `migrations/<from>-to-<to>.md` following the outcome/criteria/constraints pattern
2. Add a row to the table above
3. Bump `version:` in `skills/groove/SKILL.md`
