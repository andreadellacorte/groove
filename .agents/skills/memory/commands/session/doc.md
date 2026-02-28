# Create Documentation

## Outcome

Reference documentation that helps developers understand a system or feature.

## Acceptance Criteria

Doc file contains:
- **Overview**: What it is and why it matters
- **Key Files**: Important files with their roles
- **How It Works**: Conceptual explanation of flow/behavior
- **Gotchas**: Edge cases, pitfalls, things to watch out for

## Constraints

- Sanitize topic for use as filename — strip path separators, special characters, and traversal patterns (`../`)
- Read `memory:` from `.groove/index.md` for base path; save doc to `<memory>/sessions/docs/`
- Research codebase first (use Explore agent)
- No user interview needed — code is the source of truth
- Write doc in isolated context (use general-purpose agent)
- Verify all required sections exist before completing
- Document what code actually does, not assumptions

## Quality Signals

- File paths are accurate and exist
- Explanations match actual code behavior
- Gotchas reflect real issues found in code
