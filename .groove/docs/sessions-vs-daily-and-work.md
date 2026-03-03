# Sessions vs daily and work

## Why sessions can feel wonky

Groove has three ways to scope “what I’m doing”:

| Concept | Purpose |
|--------|--------|
| **Daily** | Time-bound bookends: start (agenda, tasks) and end (memory, tasks, commit). |
| **Tasks** | What to do — list, create, update, archive. |
| **Sessions** | Named conversation context with start/resume/end and a session file. |

For a single workstream, **daily + tasks + work** is enough: you start the day, work through tasks with the compound loop (brainstorm → plan → work → review → compound), and close out. Sessions add an extra layer (named context, session file) that overlaps with “today’s tasks” and end.

So: **sessions are optional.** Use them only when you need multiple parallel contexts (e.g. two chats, two features) and want a named file per context. For most use, ignore session start/resume/end and rely on daily + tasks + work.

## Where spec and review live

- **Outcome specs** (what to build, decisions, steps, edge cases) are part of the **work** loop — they’re planning artifacts. So `spec` is a **work** command: `groove work spec <topic>`.
- **Branch-level review** (blindspots, fix now / needs spec / create issues) is also **work** — it’s evaluating current work, not just memory. So that lives as `groove work audit`.

Memory keeps: **logs** (daily, weekly, monthly, git) and **session lifecycle** (start/resume/end, and session doc when you want a doc scoped to a named context). Spec and audit live under work.
