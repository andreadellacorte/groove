---
# GRV-dzee
title: 'groove-admin-install: mandatory skills + .claude/skills dir on install'
status: completed
type: task
priority: normal
created_at: 2026-03-22T00:19:17Z
updated_at: 2026-03-22T00:19:39Z
---

Update groove-admin-install skill: ensure companion skills and symlinks are required for successful first install; mkdir .claude/skills; patch version + CHANGELOG.

## Summary of Changes

- `skills/groove-admin-install/SKILL.md`: Steps 4–5 are mandatory for a successful install; explicit verify-after; retry once for `npx skills add`; `mkdir -p .claude/skills` with `.cursor/skills`; single symlink loop for both; acceptance criteria and final summary include platform symlinks.
- `skills/groove/SKILL.md`: version `0.18.8`.
- `CHANGELOG.md`: [0.18.8] entry.
