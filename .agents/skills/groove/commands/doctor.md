# Groove Doctor

## Outcome

All groove sub-skill health checks are run and a consolidated summary is reported. User knows exactly what is working, what is misconfigured, and what action to take for any failure.

## Acceptance Criteria

- `task doctor`, `memory doctor`, and `skills doctor` are all run
- Results are shown per sub-skill with pass/fail per check
- Overall status is shown: all healthy, or N issues found
- Each failure includes a specific remediation action

## Output format

```
groove doctor
─────────────────────────────────────
groove
  ✓ git repo: detected
  ✓ groove-version: 0.1.0
  ✓ installed version: 0.1.0
  ✓ up to date

task
  ✓ .groove/index.md present
  ✓ tasks: beans
  ✓ beans installed (v0.x.x)
  ✓ .beans.yml present
  ✓ beans reachable

memory
  ✓ sessions: bonfire
  ✓ bonfire installed
  ✓ memory path exists (.groove/memory/)

skills
  ✓ finder: find-skills
  ✓ find-skills installed
  ✓ skills-lock.json present

AGENTS.md
  ✓ groove:prime section present
  ✗ groove:task section missing — run: groove install

─────────────────────────────────────
1 issue found. Run the suggested commands above to fix.
```

## Constraints

- Run git repo check first, then version check, then `task doctor`, `memory doctor`, `skills doctor` in sequence
- Git repo check:
  - Run `git rev-parse --is-inside-work-tree` in the current directory
  - If it succeeds: `✓ git repo: detected`
  - If it fails: `✗ git repo: not a git repository — groove requires a git repo (bonfire depends on it)`
- Version check:
  - Read `groove-version:` from `.groove/index.md` (if absent, treat as `0.1.0`)
  - Read `version:` from `skills/groove/SKILL.md`
  - If they differ: `✗ groove-version (<local>) behind installed (<installed>) — run: groove update`
- Also check `AGENTS.md` for presence of `<!-- groove:prime:start -->` and `<!-- groove:task:start -->` sections
- Collect all results before printing — do not interleave output with check progress
- Each `✗` item must include a concrete remediation command on the same line
- Exit with a clear "all healthy" message if no issues found
- Do not attempt to auto-fix issues — report only
