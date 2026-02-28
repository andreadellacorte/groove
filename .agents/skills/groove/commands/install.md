# Groove Install

## Outcome

All groove backends are installed in dependency order, groove-wide companion skills are installed, AGENTS.md is primed with groove and backend context, and the repo is ready for use.

## Acceptance Criteria

- Task and memory backends installed
- Companion skills installed (find-skills, agent-browser)
- `AGENTS.md` contains up-to-date `<!-- groove:prime:start -->` section
- `AGENTS.md` contains up-to-date `<!-- groove:task:start -->` section (beans prime output, if `tasks: beans`)
- User sees a summary of what was installed and what was written

## Steps

Run in order:

1. If `.groove/index.md` does not exist, run `groove config` to create it
2. Run `task install` — installs the configured task backend (e.g. beans)
3. Run `memory install` — creates session directories
4. Install companion skills:
   - **find-skills**: check `ls .agents/skills/find-skills/SKILL.md`; if absent: `npx skills add https://github.com/nicholasgasior/find-skills --skill find-skills`
   - **agent-browser**: check `ls .agents/skills/agent-browser/SKILL.md`; if absent: `npx skills add https://github.com/vercel-labs/agent-browser --skill agent-browser`
   - Report each as installed / already-present / failed
5. Scaffold hooks directory:
   - Create `.groove/hooks/` if it does not exist (with a `.gitkeep`)
   - Report created / already-present
6. Apply git strategy — write `.groove/.gitignore` from `git.*` sub-keys in `.groove/index.md` (see `commands/config.md` for rules)
7. `groove prime` — writes groove context to `AGENTS.md`
8. If `tasks: beans`: run `beans prime`, write output to `<!-- groove:task:start -->` section of `AGENTS.md`

## Constraints

- Read `.groove/index.md` for `tasks:` and `git.*` config before running
- If `.groove/index.md` does not exist, `groove config` is run first (step 1) to create it
- Dependency order for backends must be respected: task → memory → companions
- Each step reports installed / already-present / failed
- `AGENTS.md` update is additive per section — preserve all other content
- If any step fails, report it clearly but continue with remaining steps
- Companion skills (find-skills, agent-browser) are hardcoded here, not read from any config file
- Report a final summary:
  ```
  ✓ task backend (beans)
  ✓ memory backend — session dirs ready
  ✓ companion: find-skills
  ✓ companion: agent-browser
  ✓ hooks: .groove/hooks/ ready
  ✓ AGENTS.md updated (groove:prime, groove:task)
  ```
