# BLUEPRINT — ex-starting-template

Design doc for this repo. The Elixir member of the template family ([ts-starting-template](https://github.com/AugurCognito/ts-starting-template), [py-starting-template](https://github.com/AugurCognito/py-starting-template)): an agent-ready starter where the harness (verification, hooks, CI, slop scanning) is the product and `lib/` is a placeholder. Decisions dated 2026-07-04; versions verified live against hex.pm / `git ls-remote` on that date. Seeded from the mail_sense (Seshat) project's quality stack — the most heavily-gated of the three family seeds.

## Design principles (shared with the twins)

1. **Enforcement over prose.** A convention that isn't executed by a tool is a suggestion agents will ignore.
2. **One verify command, three enforcement points.** `mix precommit` (the seed project's name for it — kept for muscle memory) runs in the Claude Code Stop hook, the lefthook pre-push hook, and CI.
3. **Fast loop / slow gate split.** Per-edit: `mix format` (PostToolUse hook). Per-commit: staged format + secret scan + commit-message check. Per-push/per-stop: full precommit.
4. **No empty scaffolding.** Everything shipped runs against the placeholder code today.
5. **Negative space is explicit** (below).
6. **The code is authoritative.**

## Stack (verified 2026-07-04)

| Layer | Tool | Version | Why |
|---|---|---|---|
| Language | Elixir 1.20 / OTP 29 | `.tool-versions` | 1.20 is officially gradually typed: typed structs through matches, protocol checking, exhaustiveness — all by default, reported as compiler warnings |
| Type strictness | `elixirc_options: [warnings_as_errors: true]` | built-in | The only strictness lever the native checker has; makes type violations fail the build |
| Lint | credo | ~> 1.7 (1.7.19) | strict mode; community default, tracks Elixir releases closely |
| Slop scan | **ex_slop** | ~> 0.4 (0.4.2) | The library that inspired this template family, in its native habitat: ~30 recommended Credo checks (BlanketRescue, TryRescueWithSafeAlternative, FilterNil, NarratorComment, QueryInEnumMap, …) |
| Duplication | ex_dna | ~> 1.5 | AST-level clone detection (`--max-clones 2`), from the seed project's gate |
| Formatter | mix format + **Styler** | ~> 1.11 | Opinionated auto-rewriting as a formatter plugin; intentionally non-configurable (Quokka is the documented fallback if that bites) |
| Security | sobelow | ~> 0.14 | Canonical repo is now sobelow/sobelow (nccgroup/ is a stale mirror). Phoenix-centric but useful on plain Elixir (String.to_atom, traversal, command injection) |
| Dep vulns | mix_audit + `mix hex.audit` | ~> 2.1 | Different advisory sources; both free, run both |
| Coverage | excoveralls | ~> 0.18 | `minimum_coverage: 80.0` fails the build; still the unchallenged standard |
| Property tests | stream_data | ~> 1.3 | Validators/parsers get properties, not just examples |
| Conventional commits | git_ops | ~> 2.10 | Mix-native (Ash-maintained): `check_message` in commit-msg hook, `git_ops.release` for CHANGELOG+version. Beats dragging Node/commitizen into a mix project |
| Git hooks | lefthook | brew binary | No hex wrapper exists (none needed — language-agnostic Go binary); family parity |
| CI | erlef/setup-beam v1.24.1 + actions/cache v6.1.0 | SHA-pinned | `_build` cache MUST key on OTP+Elixir versions (ABI-specific); `deps` only on OS+lockfile |

## The precommit pipeline (`mix precommit`)

```
deps.unlock --check-unused → hex.audit → deps.audit → format --check-formatted
→ compile --warnings-as-errors → credo --strict (with ex_slop) → ex_dna --max-clones 2
→ sobelow --exit → coveralls (≥80%)
```

Cheapest-first, fail-fast. Runs in `:test` env (`def cli`, `preferred_envs`).

## Test convention

Native Elixir mirroring (this is where the family convention came from): `lib/app/foo/bar.ex` → `test/app/foo/bar_test.exs`, `describe "fun/arity"` blocks, `async: true`, tagged-tuple assertions that include the error message.

## Negative space — deliberately NOT included

- **dialyxir** — the native 1.20 type checker covers most real bug-catching; dialyzer's residual value (recursive/parametric types, cross-dep PLT checks) doesn't justify the PLT-caching CI headache for greenfield. The seed project has it pinned to a GitHub PR for OTP 29 compat — that pain is the argument. Add later only if you hit the uncovered type classes.
- **ex_check** — unmaintained since 2024; a hand-rolled alias is smaller and dependency-free.
- **credence** — 0.8 pivoted from checker to auto-rewriter with no stable check task; a gate that rewrites code is not a gate. The seed project's `credence --strict` relies on 0.7-era behavior. Revisit if a check-mode returns.
- **reach / oeditus_credo** — the seed project's remaining plugins need per-project architecture config and cherry-picked check lists; port them from mail_sense's `.credo.exs` when the project has an architecture to enforce.
- **mix_unused** — dead since 2023. Unused *public* function detection is an acknowledged gap (compiler catches private ones via warnings_as_errors).
- **ast-grep** — Elixir is supported first-class, but ex_slop is semantic and idiom-aware where ast-grep is structural; one slop runner is enough. Viable later for cross-language rule sharing across the template family.
- **Hex cooldown** — merged upstream (hexpm/hex#1160, 2026-05-20: `mix hex.config cooldown 3d`) but not in a tagged Hex release yet. Enable the day it ships; until then Renovate's `minimumReleaseAge` is the only supply-chain delay. The one real gap vs the pnpm/uv twins.
- **CodeQL** — no Elixir support; sobelow + credo S-checks are the static-analysis layer.
- **Phoenix/Ecto/OTP processes** — no runtime opinion; the placeholder is a pure library.
