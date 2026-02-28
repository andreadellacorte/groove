# .groove/index.md Template

Scaffold this file at `.groove/index.md` (relative to git root) on first run of any groove skill.

```markdown
---
groove-version: 0.1.0
last-version-check: ""
tasks: beans
memory: .groove/memory/
git:
  memory: ignore-all
  tasks: ignore-all
  hooks: commit-all
---
```

**Config keys:**

| Key | Default | Values | Purpose |
|---|---|---|---|
| `groove-version` | `0.1.0` | semver string | Tracks which groove version this config was last migrated to |
| `last-version-check` | `""` | ISO date string | Date of last GitHub version check — used to gate once-per-day check in `groove prime` |
| `tasks` | `beans` | `beans \| linear \| github \| none` | Task tracking backend |
| `memory` | `.groove/memory/` | any path | Base path for log files |
| `git.memory` | `ignore-all` | `ignore-all \| hybrid \| commit-all` | Git strategy for memory logs |
| `git.tasks` | `ignore-all` | `ignore-all \| commit-all` | Git strategy for task files in `.groove/tasks/` |
| `git.hooks` | `commit-all` | `ignore-all \| commit-all` | Git strategy for hooks in `.groove/hooks/` |
