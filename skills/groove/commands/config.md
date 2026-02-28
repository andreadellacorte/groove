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
| `sessions` | `bonfire` | `bonfire \| none` | "Which session backend? bonfire persists AI session context between conversations." |
| `finder` | `find-skills` | `find-skills \| none` | "Which skill finder? find-skills lets you search the skills directory." |
| `memory` | `.groove/memory/` | any path | "Where should groove store memory logs? (default: .groove/memory/)" |
| `git` | `ignore-all` | `ignore-all \| hybrid \| commit-all` | "Git strategy for groove files? ignore-all keeps everything local, hybrid commits memory logs, commit-all commits everything." |
| `guardrails.default.require-confirmation` | `false` | `true \| false` | "Require confirmation before groove takes actions? (default: no)" |

After all keys are confirmed:

1. Write `.groove/index.md` with confirmed values and `groove-version: <installed version>`
2. Apply git strategy — write `.groove/.gitignore` (see constraints)
3. Show summary of written config
4. Tell user: "Run `groove install` to install backends."

## Constraints

- If `.groove/index.md` already exists, pre-fill each question with the current value
- If run non-interactively (arguments provided), apply them without prompting: e.g. `groove config tasks=linear git=hybrid`
- Always write `groove-version:` matching the installed version from `skills/groove/SKILL.md`

### Git strategy → `.groove/.gitignore`

After writing `.groove/index.md`, write `.groove/.gitignore` as follows:

**`ignore-all`** (default):
```
*
!.gitignore
```

**`hybrid`** (commit memory logs, ignore session files):
```
memory/sessions/
index.md
```

**`commit-all`** (track everything):
```
# groove git strategy: commit-all
```

- If `.groove/` is listed in the root `.gitignore`, warn the user: "Note: `.groove/` is in your root .gitignore — hybrid and commit-all strategies require removing it."
- Do not modify the root `.gitignore` automatically — flag it for the user to resolve
