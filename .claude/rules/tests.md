---
paths:
  - 'test/**/*.exs'
---

# Test rules

- **Mirror the lib/ tree**: the test for `lib/app/foo/bar.ex` lives at `test/app/foo/bar_test.exs` — same relative path, `_test.exs` suffix. Creating a module without its mirror is incomplete work.
- `describe "function_name/arity"` blocks per public function; `async: true` unless the test touches shared state.
- Every test asserts behavior, not implementation. Assert the full tagged tuple (`{:error, "not a semver string:" <> _}`), not just `:error`.
- Cover the failure path of whatever you test — error branches are where agent-written code rots.
- Validators/parsers get a stream_data property test, not just examples.
- No `assert true` placeholders; a test that can't fail is slop.
- Keep coverage ≥ 80% (`minimum_coverage` in mix.exs) — coverage is a floor, not the goal.
