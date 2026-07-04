---
name: plan
description: Write a plan to docs/plans/ before non-trivial work. Use before implementing any multi-file or multi-step task; skip for trivial single-file changes.
---

# /plan — write a plan before non-trivial work

Write a plan to `docs/plans/<yyyy-mm-dd>-<slug>.md` before implementing. If the task is trivial (single file, obvious change), say a plan is overkill and skip this.

Structure:

```markdown
---
date: <yyyy-mm-dd>
git_commit: <short sha when written>
branch: <branch>
topic: <slug>
status: draft
---

# <Task title>

## Goal
One sentence: what exists when this is done.

## Approach
The chosen approach and WHY (one alternative considered and why rejected).

## Steps
Numbered, each independently verifiable, each ending with how to verify it.

## Out of scope
Explicitly what this does NOT change.
```

Rules:

- Absolute dates, never relative. Capture the WHY, not just the WHAT.
- Reference code as `file:line`, never pasted code blocks — pasted code goes stale; references stay checkable.
- Get the plan approved before writing code; set `status: approved` when it is.
- When the work is done, set `status: done` and move the file to `docs/plans/archive/` (the `/handoff` skill also does this sweep).
