# ex-starting-template

Agent-ready Elixir starter. Replace `lib/app/` with real code — the harness around it (verification, hooks, CI, slop scanning) is the product. Design rationale and verified versions: [BLUEPRINT.md](BLUEPRINT.md). Siblings: [ts-starting-template](https://github.com/AugurCognito/ts-starting-template), [py-starting-template](https://github.com/AugurCognito/py-starting-template).

## Quick start

```bash
mix deps.get
lefthook install     # brew install lefthook first if missing
mix precommit        # THE definition of done
```

## Enforcement map

| Concern | Tool | Runs at |
|---|---|---|
| Format (+ Styler rewrites) | mix format | on every agent file-edit (hook), pre-commit, precommit |
| Types + warnings | Elixir 1.20 native checker, `warnings_as_errors` | compile step of precommit |
| Lint + AI-slop AST patterns | credo strict + **ex_slop** | precommit, pre-push |
| Duplication | ex_dna | precommit |
| Security static analysis | sobelow | precommit |
| Dep vulnerabilities | mix_audit + hex.audit | precommit |
| Unused lock entries | deps.unlock --check-unused | precommit |
| Tests + 80% coverage floor | ExUnit + excoveralls | precommit |
| Property tests | stream_data | test suite |
| Conventional commits | git_ops | commit-msg hook |
| Secrets | gitleaks | pre-commit (if installed), CI |
| Workflow security | zizmor | CI |

`mix precommit` is the single definition of done, enforced at three points: the Claude Code Stop hook, the lefthook pre-push hook, and CI. Local hooks are bypassable; CI is not.

## Anti-slop

ex_slop (the Credo plugin this whole template family grew out of) runs its recommended ~30 checks inside `mix credo --strict`: blanket rescues, rescue-without-reraise, try/rescue-with-safe-alternative, FilterNil and redundant Enum chains, narrator comments/docs, N+1 queries-in-map, GenServer-as-KV-store. Extend via `.credo.exs` (`ExSlop.checks/0` lists everything, including opt-in ports).

## After instantiating this template (one-time, manual)

- [ ] Rename the app: `:app`/`App` in mix.exs, lib/, test/, `.credo.exs`, config
- [ ] Update `.github/CODEOWNERS` and the git_ops `repository_url` in `config/config.exs`
- [ ] Enable branch protection on `main` (require CI + code-owner review)
- [ ] Enable secret-scanning push protection (repo Settings → Security)
- [ ] Install the Renovate app (config in `.github/renovate.json5`)
- [ ] `brew install gitleaks lefthook` locally
- [ ] When the next Hex release ships cooldown support: `mix hex.config cooldown 3d` (see BLUEPRINT negative space)
- [ ] First release: `mix git_ops.release --initial`
