# Brainstorm

## Outcome

Scope is clarified through dialogue. Key decisions and open questions are surfaced. Output is captured as a brainstorm doc or task in the configured backend.

## Acceptance Criteria

- Scope is clearly defined and deliberately constrained (YAGNI applied)
- Key decisions are listed with rationale
- Open questions are listed (not resolved — resolution happens in plan)
- Output exists either as a brainstorm doc or as a task body in the backend
- Stage task created in backend: `YYYY-MM-DD, 1. Brainstorm`

## Constraints

- Read `tasks:` from `.groove/index.md` to determine backend
- Use template at `templates/brainstorm-doc.md` for doc output
- Enforce YAGNI — scope is deliberately constrained at this stage; push back on scope creep
- Do not start planning implementation here — that belongs in `work plan`
- Ask clarifying questions before finalising scope; do not assume
- If user provides $ARGUMENTS, use as the topic/title for the brainstorm
- Create stage task in backend if `tasks != none`
