# Review Work

## Outcome

Blindspots and gaps are identified, actionable improvements are offered.

## Acceptance Criteria

Findings are categorized by action:
- **Fix Now**: Trivial effort, fix immediately
- **Needs Spec**: Important, requires planning
- **Create Issues**: Large effort or nice-to-have

## Constraints

- Sanitize topic (if provided) for safe use — strip path separators, special characters, and traversal patterns (`../`)
- Read `memory:` from `.groove/index.md` for base path; reference specs from `<memory>/sessions/specs/`
- Gather context: branch diff, session notes, relevant specs
- Run analysis in isolated context (use general-purpose agent)
- Fall back to direct review if subagent fails
- Present findings with severity and effort estimates
- Execute chosen action: fix directly, create spec via `groove memory session spec <topic>`, or create issues

## Scope Options

- No args: Review current branch vs main
- `--session <name>`: Review work in a specific named session's context
- Topic: Focus on specific area
