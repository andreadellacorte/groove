---
name: groove-utilities-memory-install
description: "Set up memory backend and configuration."
license: MIT
allowed-tools: Read Write Edit Glob Grep Bash(git:*) AskUserQuestion
metadata:
  author: andreadellacorte
---

# groove-utilities-memory-install

## Outcome

Memory directories are created and ready for use.

## Acceptance Criteria

- `<memory>/daily/`, `<memory>/weekly/`, `<memory>/monthly/`, `<memory>/git/` exist
- `<memory>/specs/` directory exists (outcome specs; used by `/groove-work-spec`)
- `<memory>/learned/` directory exists
- User is shown the initialized paths

## Constraints

- Read `memory:` from `.groove/index.md` frontmatter (default: `.groove/memory/`)
- Create directories if they do not exist:
  ```bash
  mkdir -p <memory>/daily <memory>/weekly <memory>/monthly <memory>/git <memory>/specs <memory>/learned
  ```
- Create `<memory>/promises.md` if it does not exist, using the template from `skills/groove-utilities-memory-promises/SKILL.md`; if it already exists, skip (idempotent)
- Create `<memory>/mistakes.md` if it does not exist, using the template from `skills/groove-utilities-memory-mistakes/SKILL.md`; if it already exists, skip (idempotent)
- Report the initialized paths to user
