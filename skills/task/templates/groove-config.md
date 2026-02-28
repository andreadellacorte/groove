# .groove/index.md Template

Scaffold this file at `.groove/index.md` (relative to git root) on first run of any groove skill.

```markdown
---
groove-version: 0.1.0
tasks: beans
sessions: bonfire
finder: find-skills
memory: .groove/memory/
git: ignore-all
guardrails:
  default:
    read-only: false
    require-confirmation: false
---
```

**Config keys:**

| Key | Default | Values | Purpose |
|---|---|---|---|
| `groove-version` | `0.1.0` | semver string | Tracks which groove version this config was last migrated to |
| `tasks` | `beans` | `beans \| linear \| github \| none` | Task tracking backend |
| `sessions` | `bonfire` | `bonfire \| none` | Session context backend |
| `finder` | `find-skills` | `find-skills \| none` | Skill discovery backend |
| `memory` | `.groove/memory/` | any path | Base path for log files |
| `git` | `ignore-all` | `ignore-all \| hybrid \| commit-all` | Git commit strategy |
| `guardrails` | see below | nested object | Per-tool confirmation settings |

**Guardrails:**
- `ignore-all`: memory files are gitignored (default)
- `hybrid`: memory files committed during closeout only
- `commit-all`: all changes committed automatically

**Notes:**
- After creating this file, run `bash scripts/setup.sh` to install all backends
- The `.groove/` directory is gitignored by default — config is local to each checkout
