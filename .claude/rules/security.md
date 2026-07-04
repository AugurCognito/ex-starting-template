# Security rules

- Never read or print `.env*` contents; reference variable *names* only.
- No `String.to_atom/1` on external input (atom-table exhaustion — sobelow flags it); use `String.to_existing_atom/1`.
- No `:os.cmd`/`System.cmd` with interpolated external input.
- Secrets come from the environment or a secrets manager at runtime — never hardcoded, never in test fixtures with real values.
- New dependency? Justify it in the PR description. When Hex ships cooldown support, `mix hex.config cooldown 3d` becomes mandatory here (see docs/HANDOFF.md).
