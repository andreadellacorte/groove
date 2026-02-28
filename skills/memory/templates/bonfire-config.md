# .bonfire/index.md Template

Scaffold this file at `.bonfire/index.md` when configuring bonfire as the sessions backend. Redirects bonfire's output into the groove memory tree.

```markdown
---
specs: .groove/memory/sessions/specs/
docs: .groove/memory/sessions/docs/
git: ignore-all
issues: false
---
```

**Notes:**
- Replace path values with the actual `memory:` value from `.groove/index.md` if it differs from the default
- `git: ignore-all` keeps session files out of version control (matches groove's default git strategy)
- `issues: false` disables bonfire's issue tracking (groove's `task` skill handles tasks)
- Body of `.bonfire/index.md` is managed by bonfire — do not overwrite it during config updates
