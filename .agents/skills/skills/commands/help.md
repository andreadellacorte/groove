# Skills Help

Display all `skills` commands with descriptions and usage notes.

## Output

Print the following, substituting live config values from `.groove/index.md`:

---

**groove skills** — skill discovery and lock file management

```
/groove skills <command>
```

Current finder backend: `<finder value from .groove/index.md>`

| Command | Description |
|---|---|
| `find <query>` | Search for skills by keyword or category |
| `add <owner/repo>` | Install a skill, update `skills-lock.json` |
| `remove <name>` | Remove a skill, update `skills-lock.json` |
| `install` | Install all configured backends in dependency order |
| `check` | Check for updates to all installed skills |
| `doctor` | Check finder backend is configured and installed |

**Install order** (run by `install`):
```
task install    → task backend (beans | linear | github)
memory install  → sessions backend (bonfire)
skills install  → finder backend (find-skills)
```

**Key rules:**
- `skills-lock.json` is auto-generated output — not the install source of truth
- Name conflicts warn before overwriting — never silent
- `find` requires finder backend; run `skills install` if not yet set up

Run `/groove help` for all skills.

---

## Constraints

- Read `.groove/index.md` and substitute actual `finder:` value
- If `finder: none`, note that `skills find` is a no-op and show how to enable
- If `.groove/index.md` does not exist, show defaults and note config not yet created
