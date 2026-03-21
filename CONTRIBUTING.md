# Contributing to groove

## `skills/` vs `.agents/skills/` (read this first)

- **Canonical source for changes is `skills/`.** Edit skill content, migrations, and scripts only under `skills/<skill-name>/`.
- **`.agents/skills/` in this repo** is the same layout as after `npx skills add andreadellacorte/groove` — a checked-in snapshot for reference and tooling. **Do not hand-edit it in pull requests.** Skills reference `.agents/skills/` paths because that is where agents load scripts in real projects; that does not mean you edit `.agents/` directly when changing behaviour — you edit `skills/` and ship a release.
- **Refreshing `.agents/skills/groove*` after a release:** use **`/groove-admin-update`** from the **groove repository root** (same as any project: e.g. `scratch/groove` when you have the repo cloned). That skill runs `npx skills add andreadellacorte/groove --yes`, applies pending migrations to local `.groove/`, and re-syncs platform symlinks — the supported path for updating installed skills. **Do not** use manual `rsync` from `skills/` to `.agents/skills/` as a substitute; it bypasses the install path and can drift from what users get.
- **When to run it:** only **after** the new version is the GitHub **`releases/latest`** target (tag + GitHub Release published). Until then, `npx skills add` may still resolve to the previous release.
- **Companion skills** (`find-skills`, `agent-browser`, `pdf-to-markdown`) exist only under `.agents/skills/` in this repo; updating groove via `groove-admin-update` does not remove them.

See `skills/groove-admin-update/SKILL.md` for the full step list.

## Bash fast-path skills

Some groove skills are purely mechanical — they read a config key, call an API, write a line. These do not need the model. A `scripts/` subdirectory alongside `SKILL.md` marks a skill as having a bash fast-path.

### Convention

Per the [Agent Skills specification](https://agentskills.io/specification), scripts go in a `scripts/` subdirectory alongside `SKILL.md`:

```
groove-utilities-check/
├── SKILL.md          # Source of truth — always present, always the fallback
└── scripts/
    └── check.sh      # Bash fast-path — identical outcome, no model round-trip
```

The agent tries the bash script first:
```
bash .agents/skills/<skill-name>/scripts/<script>.sh
```
If it exits 0: report its stdout and stop. If it exits non-zero or bash is unavailable: fall through to SKILL.md steps.

### Frontmatter flag

Mark skills with a bash fast-path using `bash: true` in SKILL.md metadata:
```yaml
metadata:
  author: andreadellacorte
  bash: true
```

### When to add scripts/

- The skill does no user prompting, no synthesis, no codebase reasoning
- It reads config, calls an external command or API, writes a file
- It would produce identical output on every run given the same inputs

### When NOT to add scripts/

- The skill prompts the user (`AskUserQuestion`)
- The skill synthesises content from session context (daily logs, compound learnings)
- The skill requires reading and reasoning about arbitrary files

### Reference implementation

`groove-utilities-check/scripts/check.sh` — version check against GitHub releases API.

---

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

### Publish release

`groove check`, `groove prime`, and `groove update` use GitHub's `releases/latest` API as the source of truth for "latest version". A tag alone does not create a release; without a release, version checks can be wrong or fail. After bumping, publish both a tag and a GitHub Release:

1. Commit and push.
2. Create and push the tag: `git tag vX.Y.Z` then `git push origin vX.Y.Z`.
3. Create a GitHub Release for that tag: **Releases → Draft a new release**, choose the tag, paste the relevant CHANGELOG section as release notes, publish. Or: `gh release create vX.Y.Z --notes "<paste from CHANGELOG>"`.
4. **Sync committed `.agents/skills/groove*` in this repository** so it matches what users install: from the groove repo root, run **`/groove-admin-update`** (installs via `npx skills add`, applies migrations, refreshes symlinks). Then commit and push any updates under `.agents/skills/groove*`. This step comes **after** the GitHub Release exists so `releases/latest` matches the new tag.

Release notes: copy from `CHANGELOG.md` from `## [X.Y.Z]` down to (but not including) the next `## [`.

**Backfilling existing tags:** If you have tags that never got a GitHub Release, create a release for each: list tags without a release (e.g. compare `gh release list` with `git tag -l 'v*'`), then for each missing one run `gh release create <tag> --notes "<paste from CHANGELOG>"` or use the Releases UI. Do them in ascending version order (oldest first) so the highest version is published last and becomes `releases/latest`.

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

Companion skills are not listed in the core surface (help table, prime, main README Skills table). They are hardcoded in install and doctor — not tracked in `skills-lock.json` (which is user-generated output).

Companions can be **downloaded** (third-party, `npx skills add <url>`) or **embedded** (in-repo under `.agents/skills/<name>/`). In both cases: do not add to the main help table, prime, or main README Skills table; do add to install (and doctor); optionally document in the README "Companions" section.

**Groove-wide companions** (e.g. `agent-browser`, `find-skills`, `pdf-to-markdown`) — add an explicit step in `skills/groove/commands/install.md` and a check in `skills/groove/commands/doctor.md`:
- **Downloaded:** step is `npx skills add <url> --skill <name>` when absent
- **Embedded:** step is `npx skills add andreadellacorte/groove --skill <name>` when absent (skill lives in this repo)

**Backend-specific companions** (e.g. `bonfire` for memory, `beans` for task) — add the install step in the relevant sub-skill's `commands/install.md`.

To add a groove-wide companion:
1. Add a step in `skills/groove/commands/install.md` under "Install companion skills" and a check in `skills/groove/commands/doctor.md` under "Companions check"
2. Add a row to the "Companions" section in `README.md` if user-facing
3. No version bump required unless a new config key is added

---

## File structure reference

```
groove/
├── CONTRIBUTING.md          ← you are here
├── CHANGELOG.md             ← update on every versioned release
├── skills/                  ← edit here only (canonical)
│   └── groove/
│       ├── SKILL.md         ← bump metadata.version here
│       └── migrations/
│           ├── index.md     ← register new migrations here
│           └── <from>-to-<to>.md   ← one file per version step
└── .agents/skills/          ← refreshed via /groove-admin-update after publish — do not hand-edit in PRs
```

> Migrations live inside `skills/groove/` so they are installed alongside the skill via `npx skills add`.
