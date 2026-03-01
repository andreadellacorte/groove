# Install Task Backend

## Outcome

The configured task backend is installed and verified reachable. User is informed of what was installed and how to use it.

## Acceptance Criteria

- Backend CLI is available in PATH after install
- User is shown a confirmation with the installed version or a reachability check
- No-op if `tasks: none`
- If `tasks: beans`: `AGENTS.md` contains a `<!-- groove:task:start -->` stub pointing to `beans prime`

## Constraints

- Read `tasks:` from `.groove/index.md` to determine backend
- If `tasks: none`, print friendly no-op message and exit
- Backend install guidance:
  - `beans`: link to https://github.com/hmans/beans for install instructions; verify with `beans version`
  - `linear`: link to https://linear.app/docs/cli for install instructions; verify with `linear --version` or MCP availability
  - `github`: link to https://cli.github.com for install instructions; verify with `gh --version`
- After install, run a simple reachability check (e.g., `beans version` or `gh auth status`)
- If CLI is already installed, report current version and skip install
- If `tasks: beans` and `.beans.yml` does not exist at git root:
  - Derive `[PROJECT_PREFIX]` from the git repo name (last path component of `git remote get-url origin`, uppercased, non-alphanumeric stripped) — e.g. `groove` → `GRV`
  - Scaffold `.beans.yml` from `skills/task/templates/beans-config.md` with the derived prefix
  - Create `.groove/tasks/` directory if it does not exist
  - Report the path written
- If `tasks: beans`: write a minimal stub to `AGENTS.md` at git root:
  - Wrap in `<!-- groove:task:start -->` / `<!-- groove:task:end -->` fenced section
  - Stub content:
    ```
    Task backend: beans — use `/groove task` commands for all task management.
    Run `beans prime` to load the full beans CLI reference.
    ```
  - Replace section if it already exists; append if not; preserve all other `AGENTS.md` content
  - Report the path written
