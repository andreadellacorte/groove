# Initialize Sessions

## Outcome

Session directories are created and ready for use.

## Acceptance Criteria

- `<memory>/sessions/specs/` directory exists
- `<memory>/sessions/docs/` directory exists
- `<memory>/learned/` directory exists
- User is shown the initialized paths

## Constraints

- Read `memory:` from `.groove/index.md` frontmatter (default: `.groove/memory/`)
- Create directories if they do not exist:
  ```bash
  mkdir -p <memory>/sessions/specs <memory>/sessions/docs <memory>/learned
  ```
- Report the initialized paths to user
- Inform user they can now run `groove memory session start`
