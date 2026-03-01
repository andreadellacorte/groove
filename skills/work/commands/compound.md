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
- After producing the compound actions checklist, identify any lesson that is about AI workflow,
  agent behaviour, tool usage, or engineering process — not specific to the codebase or product
- If any such lesson is found:
  - Propose: "Workflow learning detected — add to .groove/memory/learned/<suggested-topic>.md?"
  - Suggest a topic name based on the content (e.g. `patterns`, `tools`, `anti-patterns`, `hooks`)
  - Wait for user to confirm, pick a different topic, or skip
  - If confirmed: append the lesson as a bullet under a `## <YYYY-MM-DD>` heading in the file;
    create the file with a `# <Topic>` heading if it does not exist; create the dated heading if absent
  - Add to compound checklist: "workflow learning → .groove/memory/learned/<topic>.md" (done/pending)
- If no workflow lessons, skip this step entirely — no prompt, no noise
