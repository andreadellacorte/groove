# List Tasks

## Outcome

A consolidated view of active, ready tasks from the configured backend is displayed to the user. Blocked and in-progress tasks are clearly distinguished. Output is suitable for startup context.

## Acceptance Criteria

- Tasks are shown grouped by status (in-progress, ready/todo, blocked)
- Blocked tasks show what they are waiting on
- In-progress tasks are listed first
- Output is concise enough to scan at a glance

## Constraints

- Read `.groove/index.md` frontmatter to determine `tasks:` backend
- If `tasks: none`, print a friendly no-op message and exit
- Backend mappings:
  - `beans`: run `beans list --json --ready`, parse and format output
  - `linear`: use linear CLI or MCP to fetch assigned, active issues
  - `github`: run `gh issue list --assignee @me --state open`
- If backend CLI is not installed or unreachable, error clearly with install hint (see `commands/install.md`)
- Do not modify any tasks during list
