# Groove Check

## Outcome

The latest published groove version is compared against the installed version. If a newer version is available, the user is clearly notified with the upgrade command.

## Acceptance Criteria

- Latest tag is fetched from GitHub
- Installed version (from `skills/groove/SKILL.md`) is compared against latest tag
- If behind: user sees "⚠ New version of groove available: v<latest> (installed: v<current>) — run: groove update"
- If up to date: user sees "groove is up to date (v<current>)"
- `last-version-check:` in `.groove/index.md` is updated to today's date after check runs

## Constraints

- Fetch latest release tag from: `https://api.github.com/repos/andreadellacorte/groove/releases/latest`
- If the API call fails (no network, rate limit): skip silently — do not error
- Compare version strings as semver (strip leading `v` before comparing)
- Always update `last-version-check:` in `.groove/index.md` after a successful API call
- If `.groove/index.md` does not exist, skip the date update
