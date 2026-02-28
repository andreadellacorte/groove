# Contributing to groove

## Versioning

groove uses [semantic versioning](https://semver.org). The version lives in two places:

- `skills/groove/SKILL.md` — `metadata.version` — the installed skill version
- `.groove/index.md` — `groove-version:` — the user's local config version (managed by `groove update`)

### When to bump the version

| Change type | Version bump | Migration required |
|---|---|---|
| New skill command or behaviour | `minor` (0.1.0 → 0.2.0) | Only if `.groove/index.md` changes |
| Config key added to `.groove/index.md` | `minor` | Yes |
| Config key renamed or removed | `minor` | Yes |
| Memory directory structure changed | `minor` | Yes |
| Bug fix, wording, constraint tweak | `patch` (0.1.0 → 0.1.1) | No |
| Breaking change to a command's behaviour | `major` (0.1.0 → 1.0.0) | Yes |
| README, CONTRIBUTING, docs only | none | No |

### How to bump

1. Update `metadata.version` in `skills/groove/SKILL.md`
2. Add an entry to `CHANGELOG.md`
3. If a migration is needed, write it (see below)

---

## Writing a migration

A migration handles changes to the user's local groove state — `.groove/index.md` config keys, memory directory structure, AGENTS.md sections. It does **not** update skill files (`npx skills update` handles that).

### When a migration is needed

- A new key is added to `.groove/index.md` (migration sets the default)
- A key is renamed or removed (migration renames/removes it)
- A new directory is required under `<memory>/` (migration creates it)
- An AGENTS.md section changes structure (migration rewrites it)

### Migration file format

Create `skills/groove/migrations/<from>-to-<to>.md` following the outcome/criteria/constraints pattern:

```markdown
# Migration: <from> → <to>

## Outcome
<what the user's local state looks like after this migration runs>

## Acceptance Criteria
- bullet list of verifiable end states

## Constraints
- Each step must be idempotent (safe to re-run if interrupted)
- Only modify .groove/index.md, memory directories, and AGENTS.md
- Do not modify skill files
- After each distinct change, note what was changed
```

### Register the migration

Add a row to `skills/groove/migrations/index.md`:

```markdown
| 0.1.0 | 0.2.0 | 0.1.0-to-0.2.0.md | Description of what changes |
```

Order matters — rows are applied top to bottom.

---

## Commit conventions

```
feat:  new command, new skill behaviour, new config key
fix:   bug fix or incorrect constraint
chore: version bump, changelog, docs, refactor with no behaviour change
```

When shipping a versioned change, the commit message should include the version:

```
feat(0.2.0): add browser config key and agent-browser companion
```

---

## Adding a companion skill

Companion skills are hardcoded in install commands — not tracked in `skills-lock.json` (which is user-generated output). There are two kinds:

- **Groove-wide companions** (e.g. `agent-browser`) — add an explicit `npx skills add` step in `skills/groove/commands/install.md`
- **Backend-specific companions** (e.g. `bonfire` for memory, `beans` for task, `find-skills` for skills) — add the install step in the relevant sub-skill's `commands/install.md`

To add a groove-wide companion:
1. Add a step in `skills/groove/commands/install.md` under "Install groove-wide companion skills"
2. Update `README.md` if the companion is user-facing
3. No version bump required unless a new config key is added

---

## File structure reference

```
groove/
├── CONTRIBUTING.md          ← you are here
├── CHANGELOG.md             ← update on every versioned release
└── skills/
    └── groove/
        ├── SKILL.md         ← bump metadata.version here
        └── migrations/
            ├── index.md     ← register new migrations here
            └── <from>-to-<to>.md   ← one file per version step
```

> Migrations live inside `skills/groove/` so they are installed alongside the skill via `npx skills add`.
