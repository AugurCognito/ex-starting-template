#!/usr/bin/env bash
cd "$CLAUDE_PROJECT_DIR" || exit 0
echo "Branch: $(git branch --show-current 2>/dev/null || echo '?')"
dirty=$(git status --porcelain 2>/dev/null | head -15)
[ -n "$dirty" ] && printf 'Uncommitted changes:\n%s\n' "$dirty"
echo "Definition of done: mix precommit must pass. Session memory: docs/HANDOFF.md."
plan=$(ls -t docs/plans/*.md 2>/dev/null | grep -v archive | head -1)
[ -n "$plan" ] && echo "Most recent plan: $plan"
exit 0
