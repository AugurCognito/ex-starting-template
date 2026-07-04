# Adding a slop check

How to add a check to the ex_slop Credo plugin — and prove it fires before trusting it.

1. `{ExSlop, []}` in `.credo.exs` registers ~31 recommended checks out of the box. Opt-in checks (StepComment, ObviousComment, the credence ports) aren't enabled by default — turn one on by adding an explicit `checks: %{enabled: [...]}` entry. Run `ExSlop.checks/0` in `iex -S mix` to list everything available, recommended and opt-in.

2. Need something ex_slop doesn't cover? Write a custom check: a standard `Credo.Check` module under `lib/checks/`, registered in `.credo.exs`'s `checks: %{enabled: [...]}` list alongside the ex_slop ones.

3. **Plant the failure before trusting it.** Add canonical slop somewhere under `lib/` — e.g. `try/rescue _ -> nil` (BlanketRescue) or a comment starting `# Now we read the file` (NarratorComment; sentence-case matters — lowercase "now we" does not trigger it).

4. Run `mix credo --strict` — it must fail, naming your check. A check you never saw fire is a check you can't trust.

5. Remove the plant, run `mix credo --strict` again — it must pass clean. `mix precommit`'s exit code is nonzero with the plant in place, zero without.

6. Commit the check + (if it encodes a new convention) an entry in `docs/decisions.md`.
