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
