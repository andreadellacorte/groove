# Work Help

Display all `work` commands with descriptions and usage notes.

## Output

Print the following:

---

**groove work** — compound engineering loop

```
/groove:work:<command>
```

| Command | Description |
|---|---|
| `brainstorm` | Clarify scope, surface key decisions and open questions |
| `plan` | Research codebase, write concrete implementation plan |
| `work` | Execute the plan, track progress in task backend |
| `review` | Evaluate output, identify lessons, decide accept/rework |
| `compound` | Document lessons, update rules/templates/docs |
| `spec <topic>` | Create outcome spec (overview, decisions, steps, edge cases) |
| `audit` | Review current branch for blindspots; fix now / needs spec / create issues |

**Stage order:** brainstorm → plan → work → review → compound

**spec** — planning artifact; writes to `<memory>/specs/`. Use before or alongside plan.
**audit** — branch-level review (diff vs main, specs); categorizes findings and can trigger fixes or `work spec`.

**brainstorm** — scope clarification, YAGNI enforced. No planning yet.
**plan** — codebase research first, then concrete steps with file paths and function names.
**work** — execution. Warns if no prior plan exists.
**review** — evaluate against the plan. Be thorough: 80% of compound value is here and in plan.
**compound** — document lessons into existing files. Always run, even if "no new lessons".

**Stage tasks** are created in the configured backend:
```
YYYY-MM-DD, 1. Brainstorm
YYYY-MM-DD, 2. Plan
YYYY-MM-DD, 3. Work
YYYY-MM-DD, 4. Review
YYYY-MM-DD, 5. Compound
```

**Frustration detection:** if you find yourself fixing the same thing repeatedly, run `compound` immediately — do not wait for end of session.

Run `/groove:help` for all skills.

---

## Constraints

- Output exactly as shown
- Read `.groove/index.md` to confirm `tasks:` backend; note it if `tasks: none` (stage tasks disabled)
