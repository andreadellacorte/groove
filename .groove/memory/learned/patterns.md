# Patterns

## 2026-03-02

- **Agent push 403: switch gh auth to repo owner.** When the agent runs in an environment where multiple GitHub accounts are logged in (e.g. andreadellacorte-converge and andreadellacorte), `git push` may use the wrong credential and get 403. Run `gh auth switch --user <repo-owner>` (e.g. `andreadellacorte` for this repo); optionally run `gh auth setup-git` so Git uses the active gh account. Then push from the user’s side or re-run push.

## 2026-03-01

- **Test migrations through the system, not manually.** When developing groove itself, keep local `groove-version:` at the previous version, push the migration file, then run `groove update` to exercise it. Applying migration steps by hand before pushing means the migration is never tested through the system — the version already matches on the next `groove update` and the migration is silently skipped.
