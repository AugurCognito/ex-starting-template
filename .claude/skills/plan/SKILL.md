---
name: plan
description: Use when starting any multi-file or multi-step task, when the user asks to plan a feature, or before implementing anything non-trivial. Skip for changes describable in one sentence.
---

# /plan — write a plan before non-trivial work

Write a plan to `docs/plans/<yyyy-mm-dd>-<slug>.md` before implementing. If the task is trivial (single file, obvious change), say a plan is overkill and skip this.

**Step 0 — interview the human first.** Ask targeted questions (AskUserQuestion) until assumptions about scope, constraints, and acceptance are surfaced; only then draft.

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

## Acceptance criteria
3–7 lines, `WHEN <condition> THE SYSTEM SHALL <behavior>`, each mappable to a test.

## Risk tier
low / medium / high blast-radius — dictates how hard the human reviews the resulting diff.

## Steps
Markdown checkboxes (`- [ ]`), each independently verifiable, each ending with how to verify it.

## Out of scope
Explicitly what this does NOT change.
```

Rules:

- Absolute dates, never relative. Capture the WHY, not just the WHAT.
- Reference code as `file:line`, never pasted code blocks — pasted code goes stale; references stay checkable.
- Get the plan approved before writing code; set `status: approved` when it is.
- The implementer MUST tick each `- [ ]` checkbox in the plan file as the step lands — that is the machine-readable resume state.
- Work touching unfamiliar code: first produce a one-page research doc at `docs/plans/<date>-<slug>-research.md` (read-only subagents do the digging), and get it skimmed by the human before drafting the plan — a bad research line is the cheapest error to catch.
- When the work is done, set `status: done` and move the file to `docs/plans/archive/` (the `/handoff` skill also does this sweep).
