---
date: 2026-07-04
git_commit: 112fbf0
branch: main
topic: knowledge-infra-research
status: final
---

# Where should agent-facing knowledge live? (2026 SOTA sweep)

Four-agent research pass (template audit + skills/subagents spec + knowledge-preservation survey + local-search survey), live-verified 2026-07-04. This report is the WHY behind the `docs/` layout and `.claude/skills/` migration landed the same day.

## Answer

There is no converged industry standard for repo knowledge preservation — the strongest, adversarially-verified finding. The few well-evidenced patterns: a flat decision log beats `docs/adr/` (zero of five inspected agent-first repos have one); HumanLayer's dated YAML-frontmatter research files are the best-specified persistence convention; Claude Code merged slash commands into skills; and for code search, grep + agentic exploration beats embeddings/RAG per Anthropic's own engineering posts.

## Evidence

- **Commands → skills**: code.claude.com/docs/en/skills — `.claude/skills/<name>/SKILL.md` and `.claude/commands/<name>.md` both create `/<name>`; skills recommended (supporting files, invocation-control frontmatter, `context: fork`). Skills follow the vendor-neutral agentskills.io spec.
- **No ADR directories**: direct GitHub tree inspection of anthropics/claude-code, ghostty-org/ghostty, tailscale/tailscale, humanlayer/humanlayer, github/spec-kit — zero `docs/adr/`. MADR format alive but tooling stagnant (adr-tools last pushed 2024).
- **No AGENTS.md structural standard**: MSR 2026 paper (arXiv:2510.21413, 466 AGENTS.md files) — no content-structure convergence. AGENTS.md governance moved to the Linux Foundation's Agentic AI Foundation (Dec 2025 press releases; 60k+ repos).
- **Grep beats RAG**: claude.com blog "How Claude Code works in large codebases" (May 2026) and anthropic.com "Effective context engineering" (Sep 2025) — both explicitly reject embedding indexes for staleness; agentic search "outperformed everything, by a lot" (Cherny, May 2025). Corroborating decay: Continue.dev embeddings deprecated, Cody OSS archived.
- **Plans/memory live outside the repo by default**: `~/.claude/plans/` (project-scope `plansDirectory` override has an open bug, anthropics/claude-code#19537); auto-memory machine-local by design (docs; open issues #25947/#36561 request repo-committed memory).
- **Handoff shape**: HumanLayer `thoughts/shared/` convention — dated files, YAML frontmatter (date, git_commit, branch, topic, status), file:line refs not code blocks. Single best-specified example found; no wider standard exists.
- **Explore model**: built-in Explore subagent now inherits the session model (v2.1.198 change) — a project override pinning `model: haiku` restores cheap discovery.

## Implications (all landed 2026-07-04)

- `docs/decisions.md` (flat, append-only) added; ADR directory explicitly rejected.
- `docs/guides/` added with real how-tos only (slop checks, dependency cooldown).
- `.claude/commands/` migrated to `.claude/skills/{plan,report,handoff}/`; output formats gained YAML frontmatter + file:line rule; completed plans archive to `docs/plans/archive/`.
- `.claude/agents/explore.md` override pins exploration to haiku; `code-reviewer` gained `memory: project`.
- Search negative space recorded in `docs/decisions.md`: no semantic index, no committed code map.
- Skill evals deferred (see decisions.md).
