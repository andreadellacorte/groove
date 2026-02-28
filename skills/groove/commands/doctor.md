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

- Run `task doctor`, `memory doctor`, `skills doctor` in sequence
- Also check `AGENTS.md` for presence of `<!-- groove:prime:start -->` and `<!-- groove:task:start -->` sections
- Collect all results before printing — do not interleave output with check progress
- Each `✗` item must include a concrete remediation command on the same line
- Exit with a clear "all healthy" message if no issues found
- Do not attempt to auto-fix issues — report only
