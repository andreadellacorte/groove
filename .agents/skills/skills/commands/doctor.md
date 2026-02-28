# Skills Doctor

## Outcome

All skill management health checks pass. User knows if the finder backend and skills lock file are correctly configured.

## Acceptance Criteria

- Each check is reported with ✓ or ✗
- Each failure includes a specific remediation command
- Checks cover finder backend and lock file

## Checks (run in order)

1. `.groove/index.md` exists at git root
2. `finder:` key is present and valid (`find-skills` or `none`)
3. If `finder: none` — report no-op for finder checks and exit (all green for finder)
4. Finder backend is installed:
   - `find-skills`: check that find-skills skill is available
5. `skills-lock.json` exists at git root
6. `npx` is available (`npx --version`)

## Remediation hints

| Failure | Remediation |
|---|---|
| `.groove/index.md` missing | `groove task config` (any skill bootstraps config) |
| Finder not installed | `groove skills install` |
| `skills-lock.json` missing | `groove skills add <owner/repo>` (will create on first add) |
| `npx` not available | Install Node.js from https://nodejs.org |

## Constraints

- Report all checks even if an early one fails
- Do not attempt to fix issues — report and suggest only
- If `finder: none`, show that finder checks are skipped (not failed)
