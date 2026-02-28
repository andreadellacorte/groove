# Compound

## Outcome

Lessons, root causes, and fixes are documented. Relevant project files are updated (rules, templates, docs, task bodies). A checklist of compound actions with done/pending status is produced.

## Acceptance Criteria

- Lessons are documented with root cause analysis (not just what went wrong, but why)
- Relevant project files are updated: rules files, templates, docs, task bodies
- Checklist is produced with each action marked done or pending
- If user frustration patterns were detected, they are specifically captured
- "No new lessons" is an explicit acceptable outcome — capture it rather than skipping

## Constraints

- Read `tasks:` from `.groove/index.md` to determine backend
- Output goes into existing project files — do not create new files unless necessary
- Always run even if it seems like "nothing to capture" — capture that explicitly
- Compound actions checklist must include why each action matters, not just what it is
- If user showed repeated fixes, confusion, or rework: capture the pattern and its trigger
- Stage task created in backend: `YYYY-MM-DD, 5. Compound`
- Create stage task in backend if `tasks != none`
