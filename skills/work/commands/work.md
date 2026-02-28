# Work

## Outcome

Code, tests, and artifacts are written per the plan. The work task is created/updated in the backend with progress notes. Output is ready for review.

## Acceptance Criteria

- Implementation matches the plan from `work plan`
- Work task body tracks progress with dated notes
- Output (code, tests, docs) is complete enough to hand off to `work review`
- Stage task created/updated in backend: `YYYY-MM-DD, 3. Work`

## Constraints

- Read `tasks:` from `.groove/index.md` to determine backend
- If no prior plan exists, warn the user and ask them to confirm scope before proceeding
- Append progress notes to task body as work proceeds — do not overwrite
- Do not mark task as completed during this stage — that happens after review
- Create stage task in backend if `tasks != none`
