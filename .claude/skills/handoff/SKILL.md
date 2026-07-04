---
name: handoff
description: Update docs/HANDOFF.md session memory before ending a session mid-task, so the next session (human or agent) continues without re-deriving context.
---

# /handoff — update session memory

Update `docs/HANDOFF.md` so the next session can continue without re-deriving context. Overwrite stale sections; this file describes NOW, not history.

Before writing, sweep `docs/plans/`: any plan whose work is complete gets `status: done` and moves to `docs/plans/archive/`.

Structure to maintain:

```markdown
---
updated: <yyyy-mm-dd>
git_commit: <short sha when written>
branch: <branch>
---

# HANDOFF

## Current state
What works, what's in flight, what's broken. Verified facts only — run `mix precommit` before writing "everything passes".

## In-flight task
Goal, what's done, exact next step (file + action).

## Landmines
Non-obvious constraints discovered this session, with WHY.

## Don't redo
Approaches already tried and rejected, with why.
```

Rules: absolute dates only. Reference code as `file:line`, never pasted code blocks. If nothing is in flight, say so explicitly.
