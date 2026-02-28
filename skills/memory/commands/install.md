# Install Sessions Backend

## Outcome

The configured sessions backend is installed and verified reachable. User is informed of what was installed.

## Acceptance Criteria

- Sessions backend skill is installed and available after command completes
- User is shown a confirmation that the backend is reachable
- No-op if `sessions: none`

## Constraints

- Read `sessions:` from `.groove/index.md` frontmatter to determine backend
- If `sessions: none`, print friendly no-op message and exit
- Backend install:
  - `bonfire`: run `npx skills add vieko/bonfire`; verify by checking if bonfire skill is available
- If backend is already installed, report that and skip install
- After install, inform user they can now use `memory session start` to begin their session
