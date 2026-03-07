# .groove/index.md Template

Scaffold this file at `.groove/index.md` (relative to git root) on first run of any groove skill.

```markdown
---
groove-version: 0.1.0
tasks: beans
memory: .groove/memory/
recent_memory_days: 5
git:
  memory: ignore-all
  tasks: ignore-all
  hooks: commit-all
# specs: specs/   # optional: override where specs are saved (default: <memory>/specs/)
# groovebook: andreadellacorte/groovebook   # optional: shared learning commons repo
---
```

**Config keys:**

| Key | Default | Values | Purpose |
|---|---|---|---|
| `groove-version` | `0.1.0` | semver string | Tracks which groove version this config was last migrated to |
| `tasks` | `beans` | `beans \| linear \| github \| none` | Task tracking backend |
| `memory` | `.groove/memory/` | any path | Base path for log files |
| `recent_memory_days` | `5` | positive integer | Number of recent business days (Mon–Fri) reviewed at startup, including memory file status and git activity |
| `specs` | _(absent)_ | any path | Override where specs are saved and read; defaults to `<memory>/specs/` when absent |
| `groovebook` | _(absent)_ | `<owner>/<repo>` | Shared learning commons repo; enables `groove-groovebook-publish` and `groove-groovebook-review` |
| `git.memory` | `ignore-all` | `ignore-all \| hybrid \| commit-all` | Git strategy for memory logs |
| `git.tasks` | `ignore-all` | `ignore-all \| commit-all` | Git strategy for task files in `.groove/tasks/` |
| `git.hooks` | `commit-all` | `ignore-all \| commit-all` | Git strategy for hooks in `.groove/hooks/` |
