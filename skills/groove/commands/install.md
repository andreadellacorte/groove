# Groove Install

## Outcome

All groove backends are installed in dependency order, AGENTS.md is primed with groove and backend context, and the repo is ready for use.

## Acceptance Criteria

- All backends installed (task → memory → skills/finder)
- `AGENTS.md` contains up-to-date `<!-- groove:prime:start -->` section
- `AGENTS.md` contains up-to-date `<!-- groove:task:start -->` section (beans prime output, if `tasks: beans`)
- User sees a summary of what was installed and what was written

## Steps

Run in order:

1. `groove skills install` — installs all backends (task → memory → finder)
2. `groove prime` — writes groove context to `AGENTS.md`
3. If `tasks: beans`: run `beans prime`, write output to `<!-- groove:task:start -->` section of `AGENTS.md`

## Constraints

- Read `.groove/index.md` for `tasks:`, `sessions:`, `finder:` config before running
- If `.groove/index.md` does not exist, create from template first (prompt user for preferences)
- Dependency order for backends must be respected: task → memory → finder
- Each step reports installed / already-present / failed
- `AGENTS.md` update is additive per section — preserve all other content
- If any backend fails, report it clearly but continue with remaining steps
- Report a final summary:
  ```
  ✓ task backend (beans)
  ✓ memory backend (bonfire)
  ✓ skills backend (find-skills)
  ✓ AGENTS.md updated (groove:prime, groove:task)
  ```
