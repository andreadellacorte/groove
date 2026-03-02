# Spec: groovebook

**Session**: main-2026-03-01-2
**Date**: 2026-03-02

---

## Overview

**What**: groovebook is a shared GitHub repository acting as a commons for groove workflow learnings. Groove users publish compound-session insights there as PRs; other users (humans and agents) review and comment; merged learnings accumulate into a versioned corpus. A GitHub Pages site renders the corpus for human browsing. The feature is opt-in per project via `.groove/index.md`.

**Why**: The compound loop captures learnings at the individual level (`.groove/memory/learned/`), but there is no cross-user signal. Every groove user re-discovers the same anti-patterns. groovebook makes learnings social using primitives already well-supported by `gh` — PRs and PR reviews — rather than Discussions, which require GraphQL and have less ergonomic CLI coverage.

**Scope**: Config key in groove index, a publish command (opens a PR to the groovebook repo), a review command (lists and comments on open PRs), and the groovebook repo structure itself (corpus layout, GitHub Pages, PR templates). Does not cover moderation tooling or CI beyond what `gh` provides out of the box.

---

## Decisions

| Decision | Choice | Rationale |
|---|---|---|
| Opt-in config | `groovebook: <owner>/<repo>` key in `.groove/index.md`; absent = disabled | Single key, presence means enabled; users can point to their own fork or the canonical repo |
| Hosting | Dedicated public repo (e.g. `andreadellacorte/groovebook`), separate from groove core | Keeps the corpus independent of groove releases; forkable by communities |
| Publishing mechanism | PR to `groovebook` repo — agent branches, writes a file, opens PR | `gh pr create` is fully supported; diff is the deliberation surface; merge = acceptance |
| Community engagement | PR review via `gh pr review` and `gh pr comment` | No GraphQL needed; agents can participate natively; reviewers can approve, comment, request changes |
| Corpus format | `learned/<topic>/<YYYY-MM-DD>-<slug>.md` per PR | One learning per file; topic grouping mirrors groove's `learned/` structure; easy to browse |
| Feedback to groove | PR author or maintainer opens a separate PR to groove `skills/` referencing the groovebook PR | Keeps groove and groovebook changes independent; groovebook PR body links to groove PR |
| Public display | GitHub Pages on the groovebook repo, rendering `learned/` as a browsable site | Zero infrastructure; auto-publishes on merge; no custom backend |
| Repo vs. groove core | Separate repo | Groove core stays lean; groovebook is an opt-in companion, not a built-in dependency |

---

## Implementation Steps

### Phase 1 — groovebook repo

1. Create `andreadellacorte/groovebook` as a public GitHub repository
2. Create directory structure:
   ```
   learned/
     README.md          # explains the corpus, how to contribute
   .github/
     PULL_REQUEST_TEMPLATE.md
   README.md
   CONTRIBUTING.md
   ```
3. Write `PULL_REQUEST_TEMPLATE.md` — fields: **Summary** (one sentence), **Context** (what triggered this), **Learning** (the insight), **Groove skill area** (e.g. compound, migrations, prime)
4. Write `CONTRIBUTING.md` — how to publish via groove, how to review, how to propose a learning back to groove skills
5. Configure GitHub Pages to serve `learned/` (Jekyll with default theme, or a minimal `_config.yml` pointing at `learned/`)

### Phase 2 — groove config key

6. Add `groovebook:` key to `skills/groove/templates/index.md` (commented out / absent by default):
   ```yaml
   # groovebook: andreadellacorte/groovebook
   ```
7. Add `groovebook:` to `groove config` wizard as an optional step: "Point to a groovebook repo? (leave blank to skip)"
8. Document the key in `groove help` output and README
9. All groovebook commands read the key at runtime; if absent, they print a one-line setup hint and exit cleanly

### Phase 3 — publish command

10. Add `groovebook` to groove's routing table in `skills/groove/SKILL.md`:
    - `groove groovebook publish` → `skills/groove/commands/groovebook/publish.md`
    - `groove groovebook review` → `skills/groove/commands/groovebook/review.md`
    - `groove groovebook help` → `skills/groove/commands/groovebook/help.md`
11. Write `skills/groove/commands/groovebook/publish.md`:
    - **Input**: a learning (text) — taken from last compound output, from a `.groove/memory/learned/` file, or typed directly
    - **Steps**:
      1. Check `groovebook:` key is present in `.groove/index.md`; exit with setup hint if not
      2. Check `gh auth status`; fail fast with `gh auth login` if not authenticated
      3. Prompt user to confirm or edit the learning text: one-sentence summary + body
      4. Show preview; prompt to redact any repo-specific context (file paths, internal names)
      5. Prompt for topic (e.g. `patterns`, `tools`, `anti-patterns`) and skill area
      6. Generate slug from summary; construct branch name `learning/<YYYY-MM-DD>-<slug>`
      7. Fork or use existing fork; create branch; write `learned/<topic>/<YYYY-MM-DD>-<slug>.md`
      8. Open PR via `gh pr create --repo <groovebook> --title "<summary>" --body "<formatted body using template>"`
      9. Print PR URL
12. Hook `work compound` — after the workflow learning step, add: "Learning captured locally. Publish to groovebook? Run `groove groovebook publish`."
13. Mirror to `.agents/skills/groove/commands/groovebook/`

### Phase 4 — review command

14. Write `skills/groove/commands/groovebook/review.md`:
    - Lists open learning PRs: `gh pr list --repo <groovebook> --state open`
    - Lets user pick a PR to review; shows diff and body
    - Prompts for reaction: approve, comment, or request changes — executed via `gh pr review`
    - Optionally suggests opening a companion PR to groove `skills/` if the learning warrants a skill change

---

## Edge Cases

| Case | Handling |
|---|---|
| `groovebook:` key absent | Commands exit with: "groovebook is not configured. Add `groovebook: <owner>/<repo>` to `.groove/index.md` to enable." |
| Not authenticated with `gh` | `gh auth status` check at start; fail fast with `gh auth login` instruction |
| Learning contains repo-specific context | Publish shows preview with explicit redact prompt before opening PR |
| groovebook repo does not exist or is inaccessible | `gh repo view <groovebook>` check; fail with clear message |
| Fork already exists | `gh` handles idempotently; branch creation will fail if already present — generate unique suffix |
| User wants to publish to their own private groovebook | Fully supported — set `groovebook:` to their private repo; all commands use that value |
| Learning is rejected (PR closed without merge) | No automated action; PR thread holds the rationale; user can revise and re-open |
| Groovebook `learned/` corpus diverges from user's `.groove/memory/learned/` | Intentional — groovebook is cross-user/cross-project; personal learned is private |

---

## Open Questions

- Should the publish command fork the groovebook repo into the user's GitHub account, or require them to be a collaborator? Fork is more open; collaborator keeps the corpus cleaner.
- Should `groove groovebook review` be agent-driven (agent reads PRs and synthesises a recommendation) or just a thin wrapper around `gh pr list` + `gh pr view`? Start thin; agent-driven review is a natural next step.
- Long-term: could `groove prime` surface relevant groovebook learnings during session start (e.g. via `gh pr list --label accepted`)? Deferred — depends on a stable label/merge convention first.
- GitHub Pages rendering: static listing of markdown files is fine to start; a curated index page per topic would improve browsability — worth a small CI step to auto-generate `learned/README.md` on merge.
