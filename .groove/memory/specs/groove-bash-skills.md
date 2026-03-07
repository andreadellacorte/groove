# Spec: groove bash-native skills (platformisation concern)

**Session**: claude/loop-2026-03-07
**Date**: 2026-03-07

---

## Overview

**What**: Some groove skills are purely mechanical — they read a config key, run a shell command, write a line to a file. These do not require the model at all. Converting them to bash scripts makes them faster, deterministic, platform-portable, and immune to model interpretation drift.

**Why**:
- Pure markdown skills depend on the agent reading, understanding, and following instructions. For mechanical operations (version check, buffer flush, git log write) this is wasteful and unreliable.
- Bash scripts run instantly — no model round-trip. For utilities called inside loops or hooks, this matters.
- Platform portability: a bash script works identically on Claude Code, Cursor, Cline, and Amp; a markdown skill depends on each platform's agent interpreting it correctly.
- This is an ongoing platformisation concern: as groove matures, the line between "skills that need the model" and "skills that don't" should be explicit and enforced.

**Scope**: Identify which skills are pure-mechanical candidates; define the hybrid pattern (bash fast-path + markdown fallback); add a new `bash:` field to SKILL.md frontmatter for documentation; implement the highest-value conversions.

---

## Decisions

| Decision | Choice | Rationale |
|---|---|---|
| Conversion target | Skills that do no reasoning — only read config, run a command, write a file | Preserves the model for skills that need synthesis or judgment |
| Pattern | `SKILL.sh` alongside `SKILL.md` in the same directory | Platform invokes bash first if present; falls back to SKILL.md if not |
| Frontmatter flag | Add `bash: true` to SKILL.md frontmatter as documentation | Makes the fast-path explicit for tooling and future skill-runner logic |
| Markdown fallback | Always kept — bash script is an optimisation, not a replacement | Ensures skills work on platforms where bash is unavailable |
| Scope boundary | Do NOT convert skills that prompt the user, synthesise memory, or require codebase reasoning | Those are model tasks; bash can't do them |

---

## Candidate skills for bash conversion

### Tier 1 — Pure mechanical (highest value)

| Skill | Why bash is sufficient |
|---|---|
| `groove-utilities-check` | Reads installed version from SKILL.md, fetches GitHub releases API, compares semver — pure shell |
| `groove-utilities-memory-log-git` | Runs `git log`, formats output, appends to a file — pure shell |
| `groove-admin-doctor` | Runs a checklist of file/dir existence checks — pure shell (report formatting needs model; could be hybrid) |
| `groove-utilities-memory-doctor` | Same — file existence checks, report format |

### Tier 2 — Hybrid (bash for setup, model for content)

| Skill | Bash handles | Model handles |
|---|---|---|
| `groove-utilities-memory-log-daily` | Create file, write frontmatter, populate git/task counts | Synthesise "Work Done" narrative from session context |
| `groove-admin-update` | `npx skills add`, version compare, migration dispatch | Running each migration (migrations are markdown) |
| `groove-utilities-task-list` | `beans list` or `gh issue list` call | Formatting and prioritisation advisory |

### Tier 3 — Keep as markdown (model required)

Skills that inherently need synthesis: `groove-work-brainstorm`, `groove-work-plan`, `groove-work-review`, `groove-work-compound`, `groove-daily-start`, `groove-daily-end`, `groove-utilities-prime`, all groovebook skills.

---

## Implementation Steps

### Phase 1 — Pattern and frontmatter

1. Define the `bash:` frontmatter field in `skills/groove/templates/index.md` documentation — optional boolean, default false.
2. Document the convention in `CONTRIBUTING.md`: if `SKILL.sh` exists alongside `SKILL.md`, the bash script is the fast-path; `SKILL.md` remains the fallback and the source of truth for what the skill does.
3. Add `SKILL.sh` to the rsync pattern in skill-sync documentation.

### Phase 2 — Implement `groove-utilities-check` bash fast-path

`groove-utilities-check/scripts/check.sh`:
```bash
#!/usr/bin/env bash
# groove-utilities-check — compare installed vs latest GitHub release
set -euo pipefail
installed=$(grep 'version:' "$(dirname "$0")/../../groove/SKILL.md" | head -1 | grep -oP '[\d.]+')
latest=$(curl -sf https://api.github.com/repos/andreadellacorte/groove/releases/latest \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['tag_name'].lstrip('v'))" 2>/dev/null || echo "")
if [ -z "$latest" ]; then
  echo "groove-utilities-check: could not reach GitHub (offline?)"
  exit 0
fi
if [ "$installed" = "$latest" ]; then
  echo "groove is up to date (v$installed)"
else
  echo "groove update available: v$installed → v$latest — run /groove-admin-update"
fi
```

### Phase 3 — Implement `groove-utilities-memory-log-git` bash fast-path

`groove-utilities-memory-log-git/SKILL.sh`:
```bash
#!/usr/bin/env bash
# groove-utilities-memory-log-git — append today's git activity to memory
set -euo pipefail
memory=$(grep 'memory:' .groove/index.md | head -1 | awk '{print $2}' | tr -d '"')
memory="${memory:-.groove/memory}"
date=$(date '+%Y-%m-%d')
n=1
while [ -f "${memory}/git/${date}-GIT-${n}.md" ]; do n=$((n+1)); done
outfile="${memory}/git/${date}-GIT-${n}.md"
mkdir -p "${memory}/git"
# Check buffer first
buffer=".groove/.cache/git-activity-buffer.txt"
if [ -f "$buffer" ] && [ -s "$buffer" ]; then
  activity=$(cat "$buffer")
  > "$buffer"  # clear buffer
else
  activity=$(git log --oneline --since="$(date -v-1d '+%Y-%m-%d' 2>/dev/null || date -d 'yesterday' '+%Y-%m-%d')" 2>/dev/null || echo "(no commits)")
fi
cat > "$outfile" <<EOF
---
date: $date
---
# Git Activity — $date

$activity
EOF
echo "groove: git memory written → $outfile"
```

### Phase 4 — `groove-admin-doctor` hybrid

Doctor is a checklist — bash can run all the checks and report pass/fail. The markdown skill becomes the fallback for platforms without bash. Add `SKILL.sh` that runs all checks and exits 0 if healthy, non-zero if any check fails. Output is parseable by CI.

---

## Edge Cases

| Case | Handling |
|---|---|
| Platform does not support bash | SKILL.md fallback is always present |
| `python3` not available in SKILL.sh | Graceful degradation — bash scripts that need JSON parsing check for python3 first |
| SKILL.sh and SKILL.md diverge | SKILL.md is source of truth; SKILL.sh is optimisation; document this explicitly in CONTRIBUTING.md |
| Windows users | Bash scripts run via Git Bash or WSL; note in platform compatibility table |
| `date -v` vs `date -d` (macOS vs Linux) | Use portable `date` idioms or check `$OSTYPE` |

---

## Scope Boundary

- **In scope**: Tier 1 and Tier 2 candidates; `bash:` frontmatter field; CONTRIBUTING.md convention; rsync pattern update
- **Out of scope**: Rewriting all skills as bash; removing markdown skills; custom skill runner infrastructure
- **Ongoing concern**: Every new mechanical skill should be evaluated for bash fast-path at creation time, not retroactively
