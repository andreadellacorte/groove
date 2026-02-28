# Install Task Backend

## Outcome

The configured task backend is installed and verified reachable. User is informed of what was installed and how to use it.

## Acceptance Criteria

- Backend CLI is available in PATH after install
- User is shown a confirmation with the installed version or a reachability check
- No-op if `tasks: none`
- If `tasks: beans`: `AGENTS.md` contains an up-to-date `<!-- groove:task:start -->` section with `beans prime` output

## Constraints

- Read `tasks:` from `.groove/index.md` to determine backend
- If `tasks: none`, print friendly no-op message and exit
- Backend install guidance:
  - `beans`: link to https://github.com/andreadellacorte/beans for install instructions; verify with `beans --version`
  - `linear`: link to https://linear.app/docs/cli for install instructions; verify with `linear --version` or MCP availability
  - `github`: link to https://cli.github.com for install instructions; verify with `gh --version`
- After install, run a simple reachability check (e.g., `beans list` or `gh auth status`)
- If CLI is already installed, report current version and skip install
- If `tasks: beans`: run `beans prime`, capture output, and write it to `AGENTS.md` at git root:
  - Wrap in `<!-- groove:task:start -->` / `<!-- groove:task:end -->` fenced section
  - Replace section if it already exists; append if not; preserve all other `AGENTS.md` content
  - Report the path written
