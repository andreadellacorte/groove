# Groove Install

## Outcome

All groove backends are installed in dependency order, groove-wide companion skills are installed, AGENTS.md is primed with groove and backend context, and the repo is ready for use.

## Acceptance Criteria

- All backends installed (task → memory → skills/finder)
- Groove-wide companion skills installed (agent-browser)
- `AGENTS.md` contains up-to-date `<!-- groove:prime:start -->` section
- `AGENTS.md` contains up-to-date `<!-- groove:task:start -->` section (beans prime output, if `tasks: beans`)
- User sees a summary of what was installed and what was written

## Steps

Run in order:

1. If `.groove/index.md` does not exist, run `groove config` to create it
2. `groove skills install` — installs all backends (task → memory → finder)
3. Install groove-wide companion skills:
   - Check presence: `ls .agents/skills/agent-browser/SKILL.md`
   - If absent: `npx skills add https://github.com/vercel-labs/agent-browser --skill agent-browser`
   - Report installed / already-present / failed
4. Scaffold hooks directory:
   - Create `.groove/hooks/` if it does not exist (with a `.gitkeep`)
   - Report created / already-present
5. Apply git strategy — write `.groove/.gitignore` based on `git:` value in `.groove/index.md` (see `commands/config.md` for rules)
6. `groove prime` — writes groove context to `AGENTS.md`
7. If `tasks: beans`: run `beans prime`, write output to `<!-- groove:task:start -->` section of `AGENTS.md`

## Constraints

- Read `.groove/index.md` for `tasks:`, `finder:`, `git:` config before running
- If `.groove/index.md` does not exist, `groove config` is run first (step 1) to create it
- Dependency order for backends must be respected: task → memory → finder → companions
- Each step reports installed / already-present / failed
- `AGENTS.md` update is additive per section — preserve all other content
- If any step fails, report it clearly but continue with remaining steps
- Groove-wide companions are hardcoded here (not read from `skills-lock.json`); backend-specific skills are installed by their respective sub-skill install commands
- Report a final summary:
  ```
  ✓ task backend (beans)
  ✓ memory backend — session dirs ready
  ✓ skills backend (find-skills)
  ✓ companion: agent-browser
  ✓ hooks: .groove/hooks/ ready
  ✓ AGENTS.md updated (groove:prime, groove:task)
  ```
