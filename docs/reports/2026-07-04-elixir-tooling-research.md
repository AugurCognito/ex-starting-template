# Elixir agent-harness tooling — research snapshot, 2026-07-04

Live-verified (hex.pm + `git ls-remote`) on 2026-07-04. Why the stack in BLUEPRINT.md looks the way it does; re-verify before copying into a new context.

## The dialyzer question (the big call)

Elixir 1.20 (2026-06-03) is officially "a gradually typed language": guard-based inference, pattern-match refinement, occurrence typing, typed structs propagating through matches, protocol dispatch checking, exhaustiveness — all on by default, zero annotations, reported as compiler warnings. `warnings_as_errors: true` is the strictness lever (no separate strict flag exists). Not yet covered: recursive types, parametric types, explicit signatures.

dialyxir 1.4.7 (Nov 2025, slowing cadence) still adds value only for those uncovered classes plus cross-dep PLT checks. Community consensus (Elixir Forum "Are you using Dialyzer in 2026?") is cautious abandonment for greenfield. Dropping it deletes the PLT-caching CI complexity entirely — the seed project (mail_sense) has dialyxir pinned to a GitHub PR for OTP 29 compat, which is the pain in one sentence.

## Verified versions

| Tool | Version | Note |
|---|---|---|
| Elixir / OTP | 1.20.2 / 29.0.3 latest; template pins 1.20.0-otp-29 / 29.0.2 (= seed project, locally tested) | |
| credo | 1.7.19 | no "Credo 2" exists |
| **ex_slop** | 0.4.2 | ~40 checks; plugin default registers ~31 "recommended". README's own install snippet says `~> 0.1` — stale, pin `~> 0.4` |
| ex_dna | ~> 1.5 | AST clone detection |
| styler | 1.11.0 | adobe/elixir-styler; intentionally non-configurable; Quokka (SmartRent fork) is the configurable fallback |
| sobelow | 0.14.1 | canonical repo moved to sobelow/sobelow — nccgroup/ is a stale mirror stuck at 0.13 |
| mix_audit | 2.1.5 | + built-in `mix hex.audit` (different advisory sources, run both) |
| excoveralls | 0.18.5 | `minimum_coverage` fails the build |
| stream_data | 1.3.0 | active (OTP 29 fixes June 2026); still unchallenged |
| git_ops | 2.10.0 | zachdaniel/git_ops, active; `check_message` + `release`. gitlint is dead (2023) |
| erlef/setup-beam | v1.24.1 `54075bcc5e249e4758d363f27d099f55d843f124` | |
| actions/cache | v6.1.0 `55cc8345863c7cc4c66a329aec7e433d2d1c52a9` | `_build` key MUST include OTP+Elixir versions; `deps` only OS+mix.lock |

## Empirical findings from the build (not in any docs)

- **credence 0.8.1 has no check task.** `~> 0.7` resolves to 0.8.x, where credence pivoted to an auto-rewriter (Syntax/Semantic/Pattern rounds); the `mix credence --strict` gate the seed project runs is 0.7-era. Dropped from the template: a gate that rewrites code is not a gate.
- **ex_slop check-matching is literal.** NarratorComment matches sentence-style starters ("Now we", "Here we", "Let's") — lowercase variants slip through. BlanketRescue fires on `try/rescue _ -> nil` blocks; the acceptance test had to use canonical forms. Planted-slop verification: NarratorComment, BlanketRescue, TryRescueWithSafeAlternative, FilterNil all confirmed firing; `mix precommit` exit 8 with plant, 0 without.
- **ExSlop plugin default ≠ all checks**: `{ExSlop, []}` registers the ~31 recommended checks; StepComment/ObviousComment and the opt-in credence ports need explicit `checks.enabled` entries.

## Supply chain — the honest gap

Hex cooldown (equivalent of pnpm `minimumReleaseAge` / uv `exclude-newer`) was **merged 2026-05-20 (hexpm/hex#1160)**: `mix hex.config cooldown 3d`, `HEX_COOLDOWN`, per-repo excludes; fails open on missing timestamps; locked packages bypass. **Not in a tagged Hex release as of 2026-07-04.** Enable the day it ships. Until then only Renovate's `minimumReleaseAge: 3 days` delays anything.

## Other notes

- ex_check: unmaintained since 2024 — hand-rolled `precommit` alias instead. VibeKit (elixir-vibe/vibe_kit, v0.1.5) wires a similar alias via Igniter but is too young (~25 stars) to depend on; watch it.
- No knip equivalent: unused public functions are an acknowledged gap (mix_unused dead since 2023; compiler + warnings_as_errors catches private ones).
- ast-grep supports Elixir first-class (tree-sitter-elixir, 47 node kinds) — unused here since ex_slop is semantic and idiom-aware; relevant later for cross-language rule sharing across the template family.
- Renovate's `mix` manager fully supports hex deps + lockFileMaintenance.
- CodeQL: no Elixir support — CI has no CodeQL workflow, deliberately.
