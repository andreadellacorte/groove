# Task Backend Reference

Full CLI mapping for each supported backend. Used by all task commands to translate operations to the correct CLI calls.

## beans (default)

- **CLI:** `beans`
- **Config:** `.beans.yml` at git root (owned by beans, not groove)
- **Install:** https://github.com/andreadellacorte/beans

| Operation | Command |
|---|---|
| list | `beans list --json --ready` |
| create | `beans create "<title>" -t <type> --parent <id> -s in-progress` |
| update status | `beans update <id> -s <status>` |
| update body | `beans update <id> -d "<body>"` |
| archive | `beans archive` (archives all completed/scrapped) |
| analyse | `beans list --json` → group by status field |

**Notes:**
- `archive` archives all completed/scrapped tasks at once — no single-task option
- Task types: `task`, `bug`, `feature`, `chore`, `epic`, `milestone`
- Statuses: `todo`, `in-progress`, `blocked`, `done`, `scrapped`

---

## linear

- **CLI:** `linear` or MCP
- **Install:** https://linear.app/docs/cli

| Operation | Command |
|---|---|
| list | `linear issue list --assignee=me --state=started,unstarted` |
| create | `linear issue create --title "<title>" --team <team> --project <project>` |
| update status | `linear issue update <id> --state <state>` |
| update body | `linear issue update <id> --description "<body>"` |
| archive | `linear issue archive --filter state=completed` |
| analyse | `linear issue list --assignee=me --all` → group by state |

**Concepts:**
- Task = Issue
- Epic = Project
- Milestone = Cycle

---

## github

- **CLI:** `gh issue`
- **Install:** https://cli.github.com

| Operation | Command |
|---|---|
| list | `gh issue list --assignee @me --state open` |
| create | `gh issue create --title "<title>" --body "<body>" --milestone <milestone>` |
| update status | `gh issue close <number>` or label change |
| update body | `gh issue edit <number> --body "<body>"` |
| archive | `gh issue close` for resolved issues (no native archive) |
| analyse | `gh issue list --assignee @me --state all` → group by state/labels |

**Notes:**
- Task = Issue
- Epic = Milestone (no native sub-issue hierarchy without GitHub Projects)
- No native blocked/in-progress states — use labels

---

## none

All task commands no-op gracefully. Print a friendly message indicating task tracking is disabled.

```
Task tracking is disabled (tasks: none in .groove/index.md).
To enable, run: /task config <backend>
```
