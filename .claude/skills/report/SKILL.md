---
name: report
description: Use when an investigation produced a root cause, benchmark, survey, or decision input that a future session would otherwise re-derive — persists findings to docs/reports/.
disable-model-invocation: true
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

Rules: capture the WHY. Cite evidence precisely enough that a skeptic can re-verify — `file:line` references and URLs, never pasted code blocks. Evidence includes the actual command output (trimmed to the relevant lines), not the assertion that it passed. Absolute dates only. If the finding decided something, also append the decision to `docs/decisions.md`.
