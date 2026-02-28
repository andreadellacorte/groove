# Memory Doctor

## Outcome

All memory health checks pass. User knows if the sessions backend and memory file structure are correctly configured and accessible.

## Acceptance Criteria

- Each check is reported with ✓ or ✗
- Each failure includes a specific remediation command
- Checks cover sessions backend, memory path, and directory structure

## Checks (run in order)

1. `.groove/index.md` exists at git root
2. `sessions:` key is present and valid (`bonfire` or `none`)
3. `memory:` key is present and has a valid path
4. If `sessions: none` — report no-op for session checks, continue with memory path checks
5. Sessions backend is installed:
   - `bonfire`: check that bonfire skill files are present
6. Memory base path exists (e.g. `.groove/memory/`)
7. Memory subdirectories exist: `daily/`, `weekly/`, `monthly/`, `git/`

## Remediation hints

| Failure | Remediation |
|---|---|
| `.groove/index.md` missing | `groove task config` (any skill bootstraps config) |
| Backend not installed | `groove memory install` |
| Memory path missing | `groove memory log daily` (will create on first run) |
| Subdirectory missing | `groove memory log daily` (will create on first run) |

## Constraints

- Report all checks even if an early one fails
- Do not attempt to fix issues — report and suggest only
- If `sessions: none`, show that session checks are skipped (not failed)
