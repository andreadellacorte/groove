# Patterns

## 2026-03-01

- **Test migrations through the system, not manually.** When developing groove itself, keep local `groove-version:` at the previous version, push the migration file, then run `groove update` to exercise it. Applying migration steps by hand before pushing means the migration is never tested through the system — the version already matches on the next `groove update` and the migration is silently skipped.
