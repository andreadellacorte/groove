# Task Help

Display all `task` commands with descriptions and usage notes.

## Output

Print the following, substituting the live `tasks:` value from `.groove/index.md`:

---

**groove task** — backend-agnostic task management

```
/groove task <command>
```

Current backend: `<tasks value from .groove/index.md>`

| Command | Description |
|---|---|
| `list` | Show active, ready tasks grouped by status |
| `create` | Create task with title, type, parent, status |
| `update` | Update task status, body, or metadata |
| `archive` | Archive all completed/scrapped tasks (user confirms) |
| `analyse` | Summarise tasks by status — suitable for closeout and daily memory |
| `install` | Install configured task backend + write beans prime to AGENTS.md |
| `config` | Show or update task backend config |
| `doctor` | Check task backend is configured, installed, and reachable |

**Backends:** `beans` (default) | `linear` | `github` | `none`

**Key rules:**
- Tasks are created with status `in-progress` by default (not `todo`)
- Completion requires a "Summary of Changes" in the task body before marking done
- Archive is always user-triggered — never automatic during closeout

Run `/groove task config <backend>` to change backend.
Run `/groove help` for all skills.

---

## Constraints

- Read `.groove/index.md` and substitute actual `tasks:` value into "Current backend" line
- If `tasks: none`, add a note that all commands are no-ops and show how to enable a backend
- If `.groove/index.md` does not exist, show `beans` as default and note config not yet created
