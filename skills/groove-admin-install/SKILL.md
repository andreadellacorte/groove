---
name: groove-admin-install
description: "Install groove backends, companions, and AGENTS.md bootstrap. Run once per repo."
license: MIT
allowed-tools: Read Write Edit Glob Grep Bash(git:*) Bash(beans:*) Bash(gh:*) Bash(linear:*) Bash(npx:*) Bash(mkdir:*) AskUserQuestion
metadata:
  author: andreadellacorte
---

<!-- groove:managed — do not edit; changes will be overwritten by groove update -->

# groove-admin-install

## Outcome

All groove backends are installed in dependency order, groove-wide companion skills are installed, AGENTS.md contains the session bootstrap, and the repo is ready for use.

## Acceptance Criteria

- Task and memory backends installed
- Companion skills installed (find-skills, agent-browser, pdf-to-markdown)
- `AGENTS.md` contains the `<!-- groove:prime:start -->` session bootstrap
- `AGENTS.md` contains a `<!-- groove:task:start -->` stub (if `tasks.backend: beans`)
- User sees a summary of what was installed and what was written

## Steps

Run in order:

1. If `.groove/index.md` does not exist, run `/groove-admin-config --defaults` to create it with all defaults (no prompts)
2. Run `/groove-utilities-task-install` — installs the configured task backend (e.g. beans)
3. Run `/groove-utilities-memory-install` — creates memory directories
4. Install companion skills:
   - **find-skills** (downloaded): check `ls .agents/skills/find-skills/SKILL.md`; if absent: `npx skills add https://github.com/vercel-labs/skills --skill find-skills`
   - **agent-browser** (downloaded): check `ls .agents/skills/agent-browser/SKILL.md`; if absent: `npx skills add https://github.com/vercel-labs/agent-browser --skill agent-browser`
   - **pdf-to-markdown** (embedded): check `ls .agents/skills/pdf-to-markdown/SKILL.md`; if absent: `npx skills add andreadellacorte/groove --skill pdf-to-markdown`
   - Report each as installed / already-present / failed
5. Sync platform skill directories via symlinks:
   - For each directory in `.agents/skills/` that starts with `groove`:
     - Create `.claude/skills/<name>` as a symlink → `../../.agents/skills/<name>` if not already a symlink
     - Create `.cursor/skills/<name>` as a symlink → `../../.agents/skills/<name>` if `.cursor/skills/` exists and entry is not already a symlink
   - Create `.cursor/skills/` if it does not exist (future-proof; no-op if Cursor is not in use)
   - Run: `for skill in .agents/skills/groove*; do name=$(basename "$skill"); ln -sfn "../../.agents/skills/$name" ".claude/skills/$name"; done`
   - Run: `mkdir -p .cursor/skills && for skill in .agents/skills/groove*; do name=$(basename "$skill"); ln -sfn "../../.agents/skills/$name" ".cursor/skills/$name"; done`
   - Note: use `ln -sfn` (no-dereference) — `ln -sf` on an existing directory symlink follows the symlink and creates a nested symlink inside the target directory
   - Report: "✓ platform symlinks updated (.claude/skills/, .cursor/skills/)"
6. Scaffold hooks and cache directories:
   - Create `.groove/hooks/` if it does not exist
   - Create `.groove/.cache/` if it does not exist (with a `.gitkeep`)
   - If `.groove/hooks/start.md` does not exist, create it with:
     ```markdown
     # Hook: Session Start

     Runs automatically at the end of `/groove-daily-start`.
     Add items to `## Actions` to automate session-start tasks.

     ## Actions

     <!-- Add actions here, one per line. Examples:
     - Run `git fetch --all` to refresh remote refs
     - Print "Good morning — groove is ready"
     -->
     ```
   - If `.groove/hooks/end.md` does not exist, create it with:
     ```markdown
     # Hook: Session End

     Runs automatically at the end of `/groove-daily-end`.
     Add items to `## Actions` to automate session-end tasks.

     ## Actions

     <!-- Add actions here, one per line. Examples:
     - Run `git push` to push today's commits
     - Print "Session closed — see you tomorrow"
     -->
     ```
   - Report hooks: created / already-present
7. Apply git strategy — write `.groove/.gitignore` from `git.*` sub-keys in `.groove/index.md` (see `/groove-admin-config` for rules)
8. Write the session bootstrap to `AGENTS.md`:
   - Replace any existing `<!-- groove:prime:start -->` / `<!-- groove:prime:end -->` section with:
     ```
     <!-- groove:prime:start -->
     **Run at the start of every session:**
     `/groove-utilities-prime` — loads groove workflow context into the conversation
     <!-- groove:prime:end -->
     ```
   - If section absent, append to end of `AGENTS.md`; preserve all other content
9. `/groove-utilities-task-install` already wrote the `<!-- groove:task:start -->` stub in step 2 — no additional AGENTS.md write needed here

## Constraints

- Read `.groove/index.md` for `tasks.backend` and `git.*` config before running
- If `.groove/index.md` does not exist, `/groove-admin-config` is run first (step 1) to create it
- Dependency order for backends must be respected: task → memory → companions
- Each step reports installed / already-present / failed
- `AGENTS.md` update is additive per section — preserve all other content
- If any step fails, report it clearly but continue with remaining steps
- Companion skills (find-skills, agent-browser, pdf-to-markdown) are hardcoded here, not read from any config file
- Report a final summary:
  ```
  ✓ task backend (beans)
  ✓ memory backend — memory dirs ready
  ✓ companion: find-skills
  ✓ companion: agent-browser
  ✓ companion: pdf-to-markdown
  ✓ hooks: .groove/hooks/ ready
  ✓ AGENTS.md updated (groove:prime, groove:task)
  ```
