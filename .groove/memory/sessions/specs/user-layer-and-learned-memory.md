# Spec: User Layer and Learned Memory

## Overview

Three additions to make groove's user/core boundary explicit and give workflow learnings a permanent home:

1. **Don't-edit boundary** — communicates to agents that `skills/` is managed and must not be edited
2. **Learned memory** — `.groove/memory/learned/<topic>.md` as the long-term workflow insight tier
3. **Compound routing** — `work compound` and `session end` route workflow learnings to learned files

These features are tightly coupled: the boundary clarification defines what the user zone is, learned memory defines where workflow insights live within that zone, and compound routing defines how insights get there.

---

## Decisions

**D1: Don't-edit mechanism**

- Rejected: directory restructuring — too breaking; changes paths across all existing grooves
- Chosen: add a `<!-- groove:managed — do not edit; updated by groove update -->` HTML comment as the first line of the markdown body (after the closing `---` of frontmatter) of every `SKILL.md` in `skills/`; add a Constraints section to the `<!-- groove:prime:start -->` block written to `AGENTS.md` by `skills/groove/commands/prime.md`

Note on placement: HTML comments before frontmatter may confuse YAML parsers. The comment goes as the first line of the markdown body, after the closing `---` of frontmatter, not above it.

**D2: Learned memory structure**

- Rejected: single `LEARNED.md` — becomes unwieldy as topics accumulate
- Chosen: topic-scoped files at `.groove/memory/learned/<topic>.md`. No fixed schema — growing markdown bullet lists under dated headings. Common topics: `patterns.md`, `anti-patterns.md`, `tools.md`, `hooks.md`. Files are created on demand, not pre-scaffolded. User names topics freely.

**D3: Compound routing**

- Rejected: auto-detect and route silently — too magic; user loses visibility and control
- Chosen: at the end of `work compound` (`skills/work/commands/compound.md`), if any lesson relates to AI workflow, agent behaviour, tool usage, or engineering process (not specific to the codebase), the agent explicitly proposes: "Workflow learning detected — add to `.groove/memory/learned/<suggested-topic>.md`?" User confirms, picks a different topic, or skips.

**D4: Session end and learned memory**

- After capturing work done, decisions, and next steps, `session end` (`skills/memory/commands/session/end.md`) adds an optional prompt: "Any workflow insights from this session to capture in learned memory? Name a topic (e.g. `patterns`, `tools`) or press enter to skip"
- If user provides a topic and content, append to `.groove/memory/learned/<topic>.md` (create if absent)

---

## Steps

### 1. Don't-edit notice in SKILL.md files

Add `<!-- groove:managed — do not edit; updated by groove update -->` as the first line of the markdown body (after the closing `---` of frontmatter) of every `SKILL.md` in:

- `skills/daily/`
- `skills/work/`
- `skills/task/`
- `skills/memory/`
- `skills/groove/`

This is advisory only — `groove update` will overwrite skill files regardless. The comment makes the boundary visible to agents reading the file.

### 2. Update groove prime output

In `skills/groove/commands/prime.md`, add a Constraints section inside the `<!-- groove:prime:start -->` block written to `AGENTS.md`:

```markdown
## Constraints
- Do not edit files under `skills/` or `.agents/skills/` — they are managed by groove update and changes will be overwritten
- User zone: `.groove/` is yours — config, hooks, memory, and learned insights are all safe to edit
```

This section appears alongside the existing Key commands and Conventions sections in the prime block.

### 3. Create `.groove/memory/learned/` on memory install

In `skills/memory/commands/install.md`, add `mkdir -p <memory>/learned` to the install step, where `<memory>` is the path resolved from the `memory:` config key (default: `.groove/memory`).

Report the path created alongside the existing `sessions/specs/` and `sessions/docs/` output.

### 4. Update `work compound`

In `skills/work/commands/compound.md`, after the existing compound actions checklist, add:

- Identify any lesson captured in the session that is about AI workflow, agent behaviour, tool usage, or engineering process — not specific to the codebase or product
- If any such lesson is found: propose adding to `.groove/memory/learned/<topic>.md` — suggest a topic name based on the content; wait for user to confirm, pick a different topic, or skip
- If confirmed: append the lesson as a bullet under a `## <YYYY-MM-DD>` heading in the chosen file; create the file with a `# <Topic>` heading if it does not exist; create the `## <YYYY-MM-DD>` heading if it does not exist in the file
- Add to the compound stage checklist: "workflow learning → `.groove/memory/learned/<topic>.md`" marked done or pending

### 5. Update `session end`

In `skills/memory/commands/session/end.md`, after setting `status: ended` in the session file, add an optional step:

- Ask: "Any workflow insights from this session to capture in learned memory? Name a topic (e.g. `patterns`, `tools`) or press enter to skip"
- If the user provides a topic and content: append to `.groove/memory/learned/<topic>.md` under a `## <YYYY-MM-DD>` heading; create the file with a `# <Topic>` heading if it does not exist

---

## Edge Cases

- **Learned file doesn't exist**: create on first write with `# <Topic>\n` as the opening line, then append the dated heading and bullet
- **User edits a skill file anyway**: advisory only — `groove update` will overwrite it; the `<!-- groove:managed -->` comment in the file and the Constraints section in `AGENTS.md` make this explicit in advance
- **No workflow lessons in compound session**: skip the learned prompt entirely — no noise if there is nothing to route
- **Compound runs on a non-groove project**: same behaviour — the `.groove/memory/learned/` path is derived from the `memory:` config key; if `.groove/` does not exist the step is skipped gracefully
- **Topic naming**: free-form, lowercase, hyphenated (e.g. `anti-patterns`, `tool-usage`) — agent suggests a name, user can rename or override
- **`<!-- groove:managed -->` comment placement**: must go after the closing `---` of frontmatter, as the first line of the markdown body, to avoid breaking YAML frontmatter parsers
