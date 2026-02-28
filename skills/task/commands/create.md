# Create Task

## Outcome

A task is created in the configured backend with a title, type, parent reference, and initial status. The task ID is returned for reference. Non-trivial tasks have a rich body with sections, links, and checklists.

## Acceptance Criteria

- Task exists in backend with all required fields populated
- Task ID is shown to user after creation
- Non-trivial tasks (feature work, bugs, plans) have structured body content
- Parent task or epic is set where context suggests one exists

## Constraints

- Read `tasks:` from `.groove/index.md` to determine backend
- If `tasks: none`, no-op with friendly message
- If title not provided in arguments, ask user for title and type before proceeding
- Infer parent from current context (open tasks, recent work) and confirm with user if ambiguous
- Default status is `in-progress` (not `todo`) — tasks are created when work is being done
- Do not auto-mark any task as completed during creation
- Backend mappings:
  - `beans`: `beans create "<title>" -t <type> --parent <id> -s in-progress`
  - `linear`: create issue via linear CLI or MCP with appropriate team/project
  - `github`: `gh issue create --title "<title>" --milestone <milestone>`
- For non-trivial tasks, prompt for body sections: Context, Goal, Acceptance Criteria, Links
- Always echo the created task ID and title back to the user
