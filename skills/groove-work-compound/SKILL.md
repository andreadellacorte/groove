---
name: groove-work-compound
description: "Document lessons, update rules/templates/docs. Use to capture learnings after review."
license: MIT
allowed-tools: Read Write Edit Glob Grep Bash(git:*) AskUserQuestion
metadata:
  author: andreadellacorte
---

# groove-work-compound

## Scope

**"This conversation" means the full chat thread** (all messages in the same chat where the user invoked compound). Lessons and compound actions come from work done or decided anywhere in that thread.

**In scope:**
- Work done earlier in the same chat: other skill runs (e.g. /ppp-weekly-report, /groove-work-plan), file or bean edits, decisions, review or planning discussion.
- Any bean or work item the user or the thread refers to as part of the workflow (e.g. the epic or task this compound stage belongs to). Use those to ground lessons and actions.

**Not in scope unless the user asks:** Daily memory, weekly summaries, or other docs (e.g. "compound on the whole day").

**If no other work is visible** in the context when compound runs (e.g. the turn only shows the compound request): **ask** which session or work to compound on (e.g. "I only see the compound request. Which session should I compound on — e.g. the PPP run above, or something else?") instead of concluding "no work discussed."

## Outcome

Lessons, root causes, and fixes are documented. Relevant project files are updated (rules, templates, docs, task bodies). A checklist of compound actions with done/pending status is produced.

## Acceptance Criteria

- Lessons are documented with root cause analysis (not just what went wrong, but why)
- Relevant project files are updated: rules files, templates, docs, task bodies
- Checklist is produced with each action marked done or pending
- If user frustration patterns were detected, they are specifically captured
- "No new lessons" is an explicit acceptable outcome — capture it rather than skipping

## Constraints

- Read `tasks:` and `memory:` from `.groove/index.md` to determine backend and memory base path
- **Context window check**: before doing anything else, run `git log --oneline --since="today 00:00" 2>/dev/null | wc -l` to count today's commits; also run `git diff --name-only $(git merge-base HEAD main 2>/dev/null || echo HEAD~10)..HEAD 2>/dev/null | wc -l` to count files changed in this branch. If today_commits > 10 OR changed_files > 20, output a one-line advisory before proceeding: `⚠ Large session (N commits today, N files changed) — context quality may be degraded. Consider closing and resuming in a new session after compounding.` Do not block — compound continues regardless.
- Before producing the compound actions checklist, check if `<memory>/mistakes.md` exists and has entries under "Incident Log" (i.e. not the "(Empty)" placeholder):
  - If open incidents exist: process each using the log → fix → audit → summarise cycle from `/groove-utilities-memory-mistakes` before moving on
  - Add to compound checklist: "mistakes.md: N incident(s) resolved → learned/<topic>" (done/pending)
  - If no open incidents or file absent: skip silently
- Output goes into existing project files — do not create new files unless necessary
- Always run even if it seems like "nothing to capture" — capture that explicitly
- Compound actions checklist must include why each action matters, not just what it is
- If user showed repeated fixes, confusion, or rework: capture the pattern and its trigger
- Create stage task in backend if `tasks != none` via `/groove-utilities-task-create` with a descriptive title so multiple compounds per day are distinct: `YYYY-MM-DD, Compound — <brief topic>` (topic from the work just closed, e.g. release, feature, or session summary). Do not number stages in task titles.
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
- After the workflow learning step, prompt for an optional session rating:
  - Ask: "Rate this session (1–5): how well did the compound loop serve you? (enter to skip)"
  - If the user provides a rating: append to `<memory>/learned/signals.md` under a table; create the file with a header and table header row if it does not exist
  - Format: `| YYYY-MM-DD | <rating>/5 | <one-line context from the session topic> |`
  - If the user skips: do not mention it again
