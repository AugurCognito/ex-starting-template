# Why your new dependency is blocked

Hex has **no released cooldown mechanism yet**. Support was merged upstream 2026-05-20 (hexpm/hex#1160: `mix hex.config cooldown 3d`, `HEX_COOLDOWN`, per-repo excludes; fails open on missing timestamps; locked packages bypass) but is not in a tagged Hex release as of 2026-07-04.

**What actually delays a dependency today**: Renovate's `minimumReleaseAge: '3 days'` in `.github/renovate.json5` — this only guards PR-driven bumps, not a local `mix deps.get` on a loosened requirement or a manually added brand-new package.

**Why**: most Hex/npm-ecosystem supply-chain attacks are caught within hours of a malicious publish. A version's absence of scrutiny is not the same as its safety.

**What to do**:

- The day Hex ships cooldown support, enable it: `mix hex.config cooldown 3d` (the README and BLUEPRINT checklists already carry this item — check it off then).
- Until then, treat any hex release published in the last few days with suspicion.
- Prefer versions more than 3 days old when adding a new dependency or loosening a version floor. If a floor genuinely requires a brand-new release (e.g. a security fix), that's a case to flag to the human rather than quietly work around — do not remove the Renovate cooldown to make an update land.
