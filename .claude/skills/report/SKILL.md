---
name: report
description: Persist investigation findings to docs/reports/. Use when a root cause, benchmark, survey, or decision input was discovered that a future session would otherwise re-derive.
---

# /report — persist findings

Write investigation results to `docs/reports/<yyyy-mm-dd>-<slug>.md` when you discover something worth keeping (root cause, benchmark, survey, decision input).

Structure:

```markdown
---
date: <yyyy-mm-dd>
git_commit: <short sha when written>
branch: <branch>
topic: <slug>
status: final
---

# <Question investigated>

## Answer
Lead with the conclusion in 2-3 sentences.

## Evidence
What was checked, what was found (file:line references, command outputs, URLs).

## Implications
What should change because of this, if anything.
```

Rules: capture the WHY. Cite evidence precisely enough that a skeptic can re-verify — `file:line` references and URLs, never pasted code blocks. Absolute dates only. If the finding decided something, also append the decision to `docs/decisions.md`.
