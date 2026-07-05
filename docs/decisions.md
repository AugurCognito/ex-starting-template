# Decisions

Append-only log of decisions made after the template's birth (birth decisions live in `BLUEPRINT.md`). One dated entry per decision: context, decision, why. Append at the bottom; never rewrite old entries — if a decision is reversed, add a new entry that says so.

---

## 2026-07-04 — Flat decision log, not `docs/adr/`

Per-decision ADR files were considered and rejected: zero of five inspected agent-first repos (claude-code, ghostty, tailscale, humanlayer, spec-kit) use an ADR directory, and ADR tooling is stagnating. One flat append-only file is cheaper to maintain and easier for an agent to load whole. Evidence: `docs/reports/2026-07-04-knowledge-infra-research.md`.

## 2026-07-04 — Slash commands migrated to skills

Claude Code merged slash commands into skills (`.claude/skills/<name>/SKILL.md` creates `/<name>`); skills are the recommended form (supporting-file dirs, frontmatter invocation control). `.claude/commands/` deleted; `/plan`, `/report`, `/handoff` names unchanged.

## 2026-07-04 — Search policy: grep + Explore, nothing else

No semantic/embedding index, no committed code map, no search MCP server. Anthropic's own engineering guidance (May 2026 blog, Sep 2025 context-engineering post) found agentic grep outperforms RAG for code navigation, and committed maps go stale. The `Explore` agent override pins discovery to haiku. Revisit only if the repo outgrows what grep can navigate.

## 2026-07-04 — Skill evals deferred

The skill-creator eval pattern (`evals.json`, blind A/B) was considered for `/plan`, `/report`, `/handoff`, `verify-loop`. Deferred: these skills are procedure documents, not behavior worth benchmarking, and an eval harness nobody runs is scaffolding. Revisit when a skill's *triggering* becomes unreliable.

## 2026-07-04 — Completed plans archive to `docs/plans/archive/`

Plans are kept, not deleted, after execution (`status: done`, moved by the `/handoff` sweep) — cheap, and preserves the WHY for future sessions. Claude Code's own plan storage stays machine-local (`~/.claude/plans/`), so repo-visible plans must be written by convention.

## 2026-07-06 — Harness SOTA upgrade

- Bash deny-lists demoted to defense-in-depth: current docs call argument-constrained Bash patterns fragile (wrappers, compound commands bypass them); command gating now lives in a PreToolUse hook (`.claude/hooks/bash-gate.sh`) plus the OS sandbox with a hex.pm/github.com network allowlist.
- Stop hook hardened (`.claude/hooks/stop-verify.sh`): honors `stop_hook_active` (infinite-loop guard), short-circuits on an unchanged worktree fingerprint (`.git/claude-last-green`), and emits failures-only capped output — full logs destroy the model's context.
- SessionStart injection added (`.claude/hooks/session-context.sh`): re-grounds branch/dirty-state/definition-of-done after startup, clear, and compaction — adherence decays within-session, not with file shape, per the 2026 factorial study.
- Skills rewritten to trigger-first ("Use when…") descriptions; handoff/report/audit marked `disable-model-invocation` (human-timed rituals).
- `/audit` weekly drift-and-slop sweep added (plan drift, handoff currency, decision contradictions, doc/code drift, slop trend).
- Mutation testing (audit category 6) deferred for this repo: no maintained Elixir mutation tool exists — muzak last released 2022-12, exavier 2020-11, mutation 2017-01 (hex.pm, checked 2026-07-06). Revisit if a maintained tool appears.
