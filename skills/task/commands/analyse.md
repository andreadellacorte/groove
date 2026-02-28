# Analyse Tasks

## Outcome

Tasks are summarised by status. Milestones and epics are summarised. Completed tasks include enough resolution detail for memory population bullets. Output is suitable for closeout and daily memory.

## Acceptance Criteria

- Tasks grouped by status: in-progress, todo/ready, blocked, completed, scrapped
- Milestones/epics show progress (X of Y tasks done)
- Completed tasks include resolution summary (not just title)
- Output contains enough detail to write meaningful daily memory bullets without re-reading tasks

## Constraints

- Read `tasks:` from `.groove/index.md` to determine backend
- If `tasks: none`, no-op with friendly message
- Backend mappings:
  - `beans`: `beans list --json`, then group and summarise by status field
  - `linear`: fetch all assigned issues via linear CLI or MCP, group by state
  - `github`: `gh issue list --state all --assignee @me`, group by label/state
- For completed tasks: include the body's "Summary of Changes" section if present
- If a completed task has no resolution, note that it is missing — do not omit the task
- Output format should be scannable markdown (headers per status group, bullet per task)
