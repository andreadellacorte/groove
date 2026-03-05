# Anti-patterns

## 2026-03-04

- Don't create task beans as day-boundary markers (Start/End). A task bean is for actionable work; a "YYYY-MM-DD Start" bean that will never be actioned is just noise. Use the daily memory file as the record of the day.
- Don't open a PR for refinements before confirming the design direction is right. In this session, a PR to enrich startup bean content was opened and closed in the same session because the next message revealed the bean model itself was wrong. One question — "do you want the bean at all?" — would have avoided the churn.
- Don't create PRs for local workflow changes unless explicitly asked. Commits to main are sufficient for personal tooling that doesn't need review.
- Don't use a patch bump for behaviour changes. New or removed skill behaviour is a `minor` bump per CONTRIBUTING.md — check the versioning table before bumping.
