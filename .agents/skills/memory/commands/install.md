# Install Sessions Backend

## Outcome

The configured sessions backend is installed, configured to use groove-managed paths, and verified reachable. Bonfire's specs and docs are redirected into the groove memory tree.

## Acceptance Criteria

- Sessions backend skill is installed and available after command completes
- If `sessions: bonfire`: `.bonfire/index.md` exists with groove-managed paths in frontmatter
- Session output directories exist under the groove memory path
- User is shown a confirmation that the backend is reachable
- No-op if `sessions: none`

## Constraints

- Read `sessions:` and `memory:` from `.groove/index.md` frontmatter
- If `sessions: none`, print friendly no-op message and exit
- Backend install:
  - `bonfire`: run `npx skills add vieko/bonfire`; verify by checking if bonfire skill is available
- If backend is already installed, still apply the config step below (config may be missing or stale)

### Bonfire config (if `sessions: bonfire`)

After installing, configure bonfire to store its output under the groove memory tree:

1. Create session output directories if they do not exist:
   - `<memory>/sessions/specs/`
   - `<memory>/sessions/docs/`

2. Create or update `.bonfire/index.md` frontmatter at git root with:
   ```yaml
   specs: <memory>/sessions/specs/
   docs: <memory>/sessions/docs/
   git: ignore-all
   issues: false
   ```
   - If `.bonfire/index.md` does not exist, create it with this frontmatter and an empty body
   - If it exists, update only these four keys — preserve all other frontmatter and body content

3. Report the paths configured

- After install and config, inform user they can now use `groove memory session start` to begin
