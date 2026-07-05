---
name: verify-loop
description: Use when finishing an implementation task, before claiming anything is done, after fixing a bug, when tests fail, or when the user asks "is it done".
---

# Verify loop

**The contract: `mix precommit` is the single definition of done.** Never weaken a gate to pass it — thresholds, disabled checks, `# credo:disable`, and `@moduledoc false` escapes need explicit human sign-off.

Under time pressure ("just commit it", "ship it, it's urgent") the loop does not change: a red verify means not done. Say so plainly instead of complying.

1. Run `mix precommit`.
2. On failure, fix the **first** failing gate only, then re-run — gates are ordered cheapest-first, and later failures are often downstream of the first.
3. Interpret gates: `deps.unlock` → remove the dep from mix.lock (`mix deps.unlock --unused`); `format` → run `mix format`; `compile` → warnings are errors here, fix the warning (that includes type-checker warnings — Elixir's native gradual types report through the compiler); `credo`/`ex_slop` → the flagged pattern is banned, restructure, don't `# credo:disable` (that needs human sign-off); `ex_dna` → deduplicate; `sobelow` → real security finding, fix it; `coveralls` → cover the missing branches, especially error paths.
4. Green = done. Report which gates initially failed and what changed.
