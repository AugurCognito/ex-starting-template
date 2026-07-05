---
updated: 2026-07-06
git_commit: 8b23c4f
branch: main
last_green_verify: 2026-07-06 03:23 — mix precommit
---

# HANDOFF

_No task in flight (2026-07-06). This file is overwritten by `/handoff` when a session ends mid-task. Reference code as `file:line`, never pasted blocks._

## Known landmines

- **Styler is intentionally non-configurable** — it will rewrite code on `mix format` in ways you can't opt out of per-rule. If a rewrite is wrong for a real case, the documented fallback is switching the formatter plugin to Quokka (reads `.credo.exs` to scope rewrites) — a deliberate decision, not a quick edit.
- **`warnings_as_errors` includes the native type checker** — a dependency upgrade or Elixir minor can surface new type warnings that now fail compile. That's the gate working; fix the code.
- **No Hex cooldown yet** — `mix hex.config cooldown 3d` is merged upstream but unreleased (hexpm/hex#1160). Until it ships, a freshly-published malicious package version is resolvable immediately; Renovate's 3-day `minimumReleaseAge` only guards PR-driven bumps, not local `mix deps.get` on a loosened requirement.
- **sobelow warns "cannot find the router"** on this non-Phoenix skeleton — expected noise, it still runs its non-Phoenix checks. Point it at the router when Phoenix arrives.
- **ex_slop's NarratorComment is case-sensitive-ish** — it matches sentence-style starters ("Now we", "Here we", "Let's"); lowercase "now we..." slips through. Don't rely on it alone; the review agent covers intent.
