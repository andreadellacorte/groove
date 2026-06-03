#!/usr/bin/env bash
# groove release — one command to bump, changelog, commit, tag, and publish.
#
# Keeps the three version surfaces in lockstep so they can never drift:
#   - skills/groove/SKILL.md   (metadata.version)
#   - git tag                  (vX.Y.Z)
#   - GitHub Release           (releases/latest — source of truth for groove check/update)
#
# Usage:
#   scripts/release.sh <patch|minor|major|X.Y.Z> [--dry-run] [--allow-branch]
#   scripts/release.sh release-only [--dry-run]   # publish the release for an already-pushed tag (recovery)
#   scripts/release.sh backfill [--dry-run]       # create releases for tags that lack one, ascending
#
# Maintainers only: run from the andreadellacorte/groove repo root. See CONTRIBUTING.md.

set -euo pipefail

REPO="andreadellacorte/groove"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SKILL="${ROOT}/skills/groove/SKILL.md"
CHANGELOG="${ROOT}/CHANGELOG.md"

die() { echo "release: $*" >&2; exit 1; }
info() { echo "release: $*"; }

# ---- argument parsing -------------------------------------------------------
DRY_RUN=0
ALLOW_BRANCH=0
MODE=""
ARG=""
for a in "$@"; do
  case "$a" in
    --dry-run)      DRY_RUN=1 ;;
    --allow-branch) ALLOW_BRANCH=1 ;;
    backfill|release-only) MODE="$a" ;;
    patch|minor|major)     MODE="bump"; ARG="$a" ;;
    [0-9]*.[0-9]*.[0-9]*)  MODE="explicit"; ARG="$a" ;;
    -*) die "unknown flag: $a" ;;
    *)  die "unknown argument: $a" ;;
  esac
done
[ -n "$MODE" ] || die "usage: release.sh <patch|minor|major|X.Y.Z|release-only|backfill> [--dry-run] [--allow-branch]"

run() {
  # Execute, or just print, depending on dry-run.
  if [ "$DRY_RUN" -eq 1 ]; then echo "  [dry-run] $*"; else "$@"; fi
}

# ---- shared preconditions ---------------------------------------------------
[ -f "$SKILL" ] || die "cannot find skills/groove/SKILL.md — run from the groove repo root"
[ -d "${ROOT}/.git" ] || die "not a git repo — run from the groove repo root"
[ -f "$CHANGELOG" ] || die "cannot find CHANGELOG.md"
command -v git >/dev/null     || die "git not available"
command -v gh >/dev/null      || die "gh (GitHub CLI) not available"
command -v python3 >/dev/null || die "python3 not available"
gh auth status >/dev/null 2>&1 || die "gh is not authenticated — run: gh auth login"

cd "$ROOT"

current=$(sed -n "s/^[[:space:]]*version:[[:space:]]*[\"']\([^\"']*\)[\"'].*/\1/p" "$SKILL" | head -1)
[ -n "$current" ] || die "could not read metadata.version from skills/groove/SKILL.md"

# ---- helpers (python3 for semver + changelog surgery) -----------------------
semver_next() { # <current> <patch|minor|major>  ->  next version
  python3 - "$1" "$2" <<'PY'
import sys
cur, kind = sys.argv[1], sys.argv[2]
a, b, c = (int(x) for x in cur.split("."))
if   kind == "patch": c += 1
elif kind == "minor": b, c = b + 1, 0
elif kind == "major": a, b, c = a + 1, 0, 0
print(f"{a}.{b}.{c}")
PY
}

semver_gt() { # returns 0 if $1 > $2
  python3 - "$1" "$2" <<'PY'
import sys
def t(v): return tuple(int(x) for x in v.split("."))
sys.exit(0 if t(sys.argv[1]) > t(sys.argv[2]) else 1)
PY
}

extract_notes() { # <version>  ->  prints the CHANGELOG section body for that version
  VERSION="$1" python3 - "$CHANGELOG" <<'PY'
import os, re, sys
version = os.environ["VERSION"]
lines = open(sys.argv[1], encoding="utf-8").read().splitlines()
out, capture = [], False
for ln in lines:
    m = re.match(r"^## \[([^\]]+)\]", ln)
    if m:
        if capture:           # reached the next section -> stop
            break
        capture = (m.group(1) == version)
        continue
    if capture:
        out.append(ln)
print("\n".join(out).strip())
PY
}

promote_unreleased() { # <version> <date>  -> rewrites CHANGELOG in place; fails if no usable notes
  VERSION="$1" RELDATE="$2" python3 - "$CHANGELOG" <<'PY'
import os, re, sys
version, date, path = os.environ["VERSION"], os.environ["RELDATE"], sys.argv[1]
text = open(path, encoding="utf-8").read()
lines = text.splitlines()

def section_body(idx):
    body = []
    for ln in lines[idx+1:]:
        if re.match(r"^## \[", ln):
            break
        body.append(ln)
    return body

def has_content(body):
    # Non-empty if any line carries text beyond blank lines / subsection headers.
    return any(ln.strip() and not ln.lstrip().startswith("###") for ln in body)

unrel = next((i for i, ln in enumerate(lines)
              if re.match(r"^## \[Unreleased\]", ln, re.I)), None)
existing = next((i for i, ln in enumerate(lines)
                 if re.match(rf"^## \[{re.escape(version)}\]", ln)), None)

if unrel is not None:
    if not has_content(section_body(unrel)):
        sys.exit("release: ## [Unreleased] has no notes — add changelog entries before releasing")
    lines[unrel] = f"## [Unreleased]\n\n## [{version}] - {date}"
elif existing is not None:
    # No Unreleased section, but the version header already exists: stamp/normalise its date.
    lines[existing] = f"## [{version}] - {date}"
    if not has_content(section_body(existing)):
        sys.exit(f"release: ## [{version}] has no notes — add changelog entries before releasing")
else:
    sys.exit(f"release: no ## [Unreleased] or ## [{version}] section in CHANGELOG.md — add notes first")

open(path, "w", encoding="utf-8").write("\n".join(lines) + "\n")
PY
}

# ---- mode: backfill ---------------------------------------------------------
if [ "$MODE" = "backfill" ]; then
  git fetch --tags --quiet || true
  released=$(gh release list -L 500 --repo "$REPO" 2>/dev/null | awk '{print $1}' | sort)
  missing=$(comm -23 <(git tag -l 'v*' | sort) <(echo "$released") | sort -V)
  [ -n "$missing" ] || { info "no tags missing a release — nothing to backfill"; exit 0; }
  info "tags missing a GitHub release (ascending):"
  while IFS= read -r tag; do
    [ -n "$tag" ] || continue
    ver="${tag#v}"
    notes=$(extract_notes "$ver")
    [ -n "$notes" ] || notes="Release $tag"
    echo "  - $tag"
    run gh release create "$tag" --repo "$REPO" --title "$tag" --notes "$notes"
  done <<< "$missing"
  info "backfill complete"
  exit 0
fi

# ---- determine target version ----------------------------------------------
if [ "$MODE" = "release-only" ]; then
  target="$current"   # publish the release for the current SKILL.md version's tag
else
  if [ "$MODE" = "bump" ]; then
    target=$(semver_next "$current" "$ARG")
  else
    target="$ARG"
  fi
  semver_gt "$target" "$current" || die "target v$target is not greater than current v$current"
fi
tag="v${target}"
reldate=$(date +%F)

# ---- mode: release-only (recovery) -----------------------------------------
if [ "$MODE" = "release-only" ]; then
  git rev-parse "$tag" >/dev/null 2>&1 || die "tag $tag does not exist locally — run a normal release instead"
  if gh release view "$tag" --repo "$REPO" >/dev/null 2>&1; then
    die "release $tag already exists"
  fi
  notes=$(extract_notes "$target")
  [ -n "$notes" ] || die "no CHANGELOG notes found for $target"
  info "publishing release $tag from existing tag"
  echo "----- notes -----"; echo "$notes"; echo "-----------------"
  run gh release create "$tag" --repo "$REPO" --title "$tag" --notes "$notes"
  info "done"
  exit 0
fi

# ---- full release: preconditions -------------------------------------------
# In --dry-run these warn instead of aborting, so a preview works at any time.
precond() { if [ "$DRY_RUN" -eq 1 ]; then echo "release: [dry-run] would abort: $*" >&2; else die "$*"; fi; }

branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$branch" != "main" ] && [ "$ALLOW_BRANCH" -eq 0 ]; then
  precond "on branch '$branch', not 'main' — pass --allow-branch to override"
fi
if ! git diff --quiet || ! git diff --cached --quiet; then
  precond "working tree has uncommitted changes — commit or stash first"
fi
git rev-parse "$tag" >/dev/null 2>&1 && precond "tag $tag already exists locally — use 'release-only' to publish it"
if git ls-remote --exit-code --tags origin "$tag" >/dev/null 2>&1; then
  precond "tag $tag already exists on origin"
fi
git fetch --quiet origin "$branch" || true
if [ -n "$(git rev-list "HEAD..origin/${branch}" 2>/dev/null)" ]; then
  precond "local '$branch' is behind origin/${branch} — pull first"
fi

info "releasing v$current -> v$target  (tag $tag, $reldate)"

# ---- step 1: bump SKILL.md --------------------------------------------------
if [ "$DRY_RUN" -eq 1 ]; then
  echo "  [dry-run] bump skills/groove/SKILL.md:  version: \"$current\"  ->  \"$target\""
else
  python3 - "$SKILL" "$current" "$target" <<'PY'
import re, sys
path, old, new = sys.argv[1], sys.argv[2], sys.argv[3]
text = open(path, encoding="utf-8").read()
new_text, n = re.subn(rf'(version:\s*["\']){re.escape(old)}(["\'])', rf'\g<1>{new}\g<2>', text, count=1)
if n != 1:
    sys.exit(f"release: expected exactly one version: \"{old}\" line in SKILL.md, found {n}")
open(path, "w", encoding="utf-8").write(new_text)
PY
fi

# ---- step 2: changelog promote + extract notes ------------------------------
if [ "$DRY_RUN" -eq 1 ]; then
  echo "  [dry-run] promote CHANGELOG:  ## [Unreleased]  ->  ## [$target] - $reldate"
  notes=$(extract_notes "$target")
  if [ -z "$notes" ]; then
    # Dry-run preview when notes live under an Unreleased heading.
    notes=$(VERSION="Unreleased" python3 -c '
import os,re,sys
v=os.environ["VERSION"]; lines=open(sys.argv[1],encoding="utf-8").read().splitlines()
out=[];cap=False
for ln in lines:
    m=re.match(r"^## \[([^\]]+)\]",ln)
    if m:
        if cap: break
        cap=(m.group(1).lower()==v.lower()); continue
    if cap: out.append(ln)
print("\n".join(out).strip())' "$CHANGELOG")
  fi
else
  promote_unreleased "$target" "$reldate"
  notes=$(extract_notes "$target")
  [ -n "$notes" ] || die "extracted empty release notes for $target after promotion"
fi
echo "----- release notes -----"; echo "${notes:-(none)}"; echo "-------------------------"

# ---- steps 3-5: commit, tag, push, release ----------------------------------
run git add "$SKILL" "$CHANGELOG"
run git commit -m "chore(release): $tag"
run git push origin "$branch"
run git tag "$tag"
run git push origin "$tag"
run gh release create "$tag" --repo "$REPO" --title "$tag" --notes "$notes"

if [ "$DRY_RUN" -eq 1 ]; then
  info "dry-run complete — no changes made"
else
  url=$(gh release view "$tag" --repo "$REPO" --json url -q .url 2>/dev/null || echo "")
  info "released $tag  ${url}"
fi
