# AGENTS.md

Single source of truth for AI coding agents. `CLAUDE.md` imports this file; Codex, Cursor, Copilot, and Gemini read it natively. Keep it under 200 lines.

## What This Is

An agent-ready Elixir starter. Replace `lib/app/` with real code; the harness around it (verification, hooks, CI, slop scanning) is the product.

## Commands

```bash
mix deps.get         # install deps
mix precommit        # THE definition of done: deps hygiene + audits + format + compile
                     #   (warnings-as-errors) + credo/ex_slop + ex_dna + sobelow + coveralls
mix test             # tests only, TDD loop
mix format           # format (also runs on every file edit via hooks)
mix git_ops.release  # conventional-commit-driven version bump + CHANGELOG (when releasing)
```

## Definition of Done

A task is **not complete** until `mix precommit` passes. No exceptions. The Stop hook, pre-push hook, and CI all run it — a claim of "done" with a failing precommit will be caught three times.

## Conventions

1. **The code is authoritative.** Read the current source before acting. When a doc disagrees with the code, the code wins — then fix the doc.
2. **No fallback mechanisms.** They hide real failures. No blanket `rescue` returning nil (ex_slop rejects it); return tagged tuples for expected failures; let unexpected ones crash — that's the BEAM way.
3. **Less code beats more code.** Rewrite existing modules over adding parallel ones. No GenServer where a module + data structure works (start with functions; reach for processes only for real concurrency/state lifecycles).
4. **Every public function has a @spec** with precise unions, not `term()`/`map()`. Compiler warnings are errors — including the native type checker's.
5. **Comments state constraints the code cannot express** — never what the next line does. ex_slop rejects narrator comments and boilerplate @doc.
6. **Don't self-QA claims.** "It works" means `mix precommit` passed; behavior claims need the human to verify real output.
7. **Conventional commits** (`feat:`, `fix:`, `chore:`, …) — enforced by git_ops in the commit-msg hook.
8. **Absolute dates in docs** (2026-07-04, never "yesterday").
9. **Throwaway output goes in `scratch/`** (gitignored) — never the repo root.
10. **Secrets live in `.env`** (gitignored); commit only `.env.example` with placeholders. Never read or print `.env*` contents. Sandbox note: repo settings enable the OS sandbox with a package-registry network allowlist; set credential-path denies (~/.ssh, ~/.aws) in your USER settings — repo settings cannot.
11. **When compacting, preserve**: the active plan file path, the list of modified files, and the verify command.

## Architecture

- `lib/app.ex` — public surface; `lib/app/` — internals (rename per project). `test/` **mirrors the lib/ tree**: `lib/app/foo/bar.ex` → `test/app/foo/bar_test.exs`. 80% coverage floor.
- Slop layer: **ex_slop** as a Credo plugin (`.credo.exs`) — ~30 checks against LLM-slop patterns (blanket rescues, redundant Enum chains, narrator comments), plus ex_dna for AST-level duplication.
- `docs/` — `decisions.md` (append-only decision log) · `guides/` (how-tos) · `plans/` + `plans/archive/` (dated plans, kept after execution) · `reports/` (dated research) · `HANDOFF.md` (session memory).
- Gates: lefthook (`lefthook.yml`) locally, `.github/workflows/ci.yml` in CI. Local hooks are bypassable; CI is not.

## Finding Things

Grep/Glob plus the `Explore` agent (pinned to haiku) — that's the whole search stack. No semantic index, no committed code map; deliberate, see `docs/decisions.md`. Subagents read, the main thread writes — delegating implementation fragments context; delegate searches and reviews only.

## What Does NOT Exist (yet)

No Phoenix, no Ecto/database, no OTP application processes (pure library skeleton), no runtime deps, no Docker, no release automation beyond git_ops. Don't scaffold any of these speculatively (YAGNI) — add them when a task requires them, and update this section when you do. When real deps arrive, wire `mix usage_rules.sync` to auto-maintain dep guidance here.

## Session Workflow

- Long task? Plan first (`/plan` skill → `docs/plans/`): interview the human on scope/constraints/acceptance, write a research doc first for unfamiliar code, then draft.
- Weekly: run `/audit` — drift and slop sweep.
- Ending a session mid-task? Update `docs/HANDOFF.md` (`/handoff` skill — also archives completed plans).
- Found something non-obvious? Record it (`/report` skill) or update this file — with the WHY, not just the WHAT.
- Made a call the code can't express (tool choice, rejected approach, policy)? Append it to `docs/decisions.md`.
- Blocked install or writing a new slop check? `docs/guides/` first.
