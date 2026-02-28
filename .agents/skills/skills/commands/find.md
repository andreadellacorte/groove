# Find Skills

## Outcome

Skills are found by keyword or category. Matching skills are shown with name, description, and source repo. Delegates to the configured `finder` backend.

## Acceptance Criteria

- Search results include skill name, description, and `owner/repo` install path
- Results are filtered by the provided keyword or category
- If no results found, user is told clearly (not shown empty output)

## Constraints

- Read `finder:` from `.groove/index.md` frontmatter to determine backend
- If `finder: none`, print no-op message: "Skill discovery is disabled (finder: none). Update .groove/index.md to enable."
- If `finder: find-skills` but find-skills is not installed, warn and offer to run `skills install`
- Pass $ARGUMENTS through to the finder backend as search query
- Do not hardcode skill results — always delegate to finder
