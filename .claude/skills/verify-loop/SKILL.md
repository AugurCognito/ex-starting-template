---
name: verify-loop
description: Run mix precommit, fix what it finds, repeat until green. Use before claiming any task is done, after multi-file edits, or when CI failed.
---

# Verify loop

1. Run `mix precommit`.
2. On failure, fix the **first** failing gate only, then re-run — gates are ordered cheapest-first, and later failures are often downstream of the first.
3. Interpret gates: `deps.unlock` → remove the dep from mix.lock (`mix deps.unlock --unused`); `format` → run `mix format`; `compile` → warnings are errors here, fix the warning (that includes type-checker warnings — Elixir's native gradual types report through the compiler); `credo`/`ex_slop` → the flagged pattern is banned, restructure, don't `# credo:disable` (that needs human sign-off); `ex_dna` → deduplicate; `sobelow` → real security finding, fix it; `coveralls` → cover the missing branches, especially error paths.
4. Never weaken a gate to pass it (thresholds, disabled checks, and `@moduledoc false` escapes need explicit human sign-off).
5. Green = done. Report which gates initially failed and what changed.
