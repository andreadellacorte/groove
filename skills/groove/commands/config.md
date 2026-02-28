# Groove Config

## Outcome

`.groove/index.md` is created or updated with values confirmed by the user. The git strategy is applied immediately. User is ready to run `groove install`.

## Acceptance Criteria

- `.groove/index.md` exists with all config keys populated
- Each key was either confirmed by the user or accepted as default
- Git strategy is applied (`.groove/.gitignore` written) before exiting
- User is shown a summary of the final config and told to run `groove install`

## Steps

Walk the user through each config key in order. For each key: show the current value (or default if new), explain what it does, and ask to confirm or change.

### Keys and defaults

| Key | Default | Options | Question to ask |
|---|---|---|---|
| `tasks` | `beans` | `beans \| linear \| github \| none` | "Which task backend? beans tracks tasks as markdown files in your repo." |
| `memory` | `.groove/memory/` | any path | "Where should groove store memory logs? (default: .groove/memory/)" |
| `git.memory` | `ignore-all` | `ignore-all \| hybrid \| commit-all` | "Git strategy for memory logs? ignore-all keeps them local, hybrid commits logs but ignores sessions, commit-all commits everything." |
| `git.tasks` | `ignore-all` | `ignore-all \| commit-all` | "Git strategy for task files (.groove/tasks/)? ignore-all keeps them local, commit-all tracks them in git." |
| `git.hooks` | `commit-all` | `ignore-all \| commit-all` | "Git strategy for hooks (.groove/hooks/)? commit-all shares hooks with the team, ignore-all keeps them local." |

After all keys are confirmed:

1. Write `.groove/index.md` with confirmed values and `groove-version: <installed version>`
2. Apply git strategy — write `.groove/.gitignore` (see constraints)
3. Show summary of written config
4. Tell user: "Run `groove install` to install backends."

## Constraints

- If `.groove/index.md` already exists, pre-fill each question with the current value
- If run non-interactively (arguments provided), apply them without prompting: e.g. `groove config tasks=linear git.memory=hybrid`
- Always write `groove-version:` matching the installed version from `skills/groove/SKILL.md`

### Git strategy → `.groove/.gitignore`

After writing `.groove/index.md`, generate `.groove/.gitignore` from the `git.*` sub-keys:

| Component | Strategy | Entry added to `.groove/.gitignore` |
|---|---|---|
| `git.memory` | `ignore-all` | `memory/` |
| `git.memory` | `hybrid` | `memory/sessions/` |
| `git.memory` | `commit-all` | _(none)_ |
| `git.tasks` | `ignore-all` | `tasks/` |
| `git.tasks` | `commit-all` | _(none)_ |
| `git.hooks` | `ignore-all` | `hooks/` |
| `git.hooks` | `commit-all` | _(none)_ |

Write the generated entries to `.groove/.gitignore`, replacing the file entirely. If no entries are generated (all `commit-all`), write an empty file with a comment: `# groove git strategy: commit-all`.

- If `.groove/` is listed in the root `.gitignore`, warn the user: "Note: `.groove/` is in your root .gitignore — any commit-all strategies require removing it."
- Do not modify the root `.gitignore` automatically — flag it for the user to resolve
