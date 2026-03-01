<!-- groove:prime:start -->
# Groove Workflow Context

groove is installed in this repo. Use `/groove <skill> <command>` for all workflow commands.

## Config
tasks:      beans
memory:     .groove/memory/
git.memory: commit-all
git.tasks:  commit-all
git.hooks:  commit-all

## Key commands
/groove daily startup         — start the workday
/groove daily closeout        — end the workday
/groove work brainstorm       — clarify scope (YAGNI enforced)
/groove work plan             — research codebase, write implementation plan
/groove work work             — execute the plan
/groove work review           — evaluate output, decide accept/rework
/groove work compound         — document lessons into existing project files
/groove task list             — show active, ready tasks
/groove task create           — create a task
/groove task analyse          — summarise tasks by status
/groove memory session start  — start session
/groove memory session resume — resume an existing session
/groove memory log daily      — write daily closeout log
/groove skills add            — install a skill

## Conventions
- Stage tasks: "YYYY-MM-DD, N. Stage" (e.g. 2026-02-28, 1. Brainstorm)
- Memory logs: .groove/memory/daily/, weekly/, monthly/, git/
- Task completion requires "Summary of Changes" in body before marking done
- Archive is always user-triggered — never automatic during closeout
- 80% of compound loop value is in plan and review — do not skip them

## Constraints
- Do not edit files under `skills/` or `.agents/skills/` — managed by groove update, changes will be overwritten
- User zone: `.groove/` is yours — config, hooks, memory, and learned insights are all safe to edit
<!-- groove:prime:end -->

<!-- groove:task:start -->
Task backend: beans — use `/groove task` commands for all task management.
Run `beans prime` if you need the full beans CLI reference.
<!-- groove:task:end -->
