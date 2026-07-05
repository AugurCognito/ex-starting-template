#!/usr/bin/env bash
input=$(cat)
[ "$(printf '%s' "$input" | jq -r '.stop_hook_active // false')" = "true" ] && exit 0
cd "$CLAUDE_PROJECT_DIR" || exit 0
fingerprint=$({ git rev-parse HEAD; git status --porcelain; git diff; git diff --cached; } 2>/dev/null | shasum | cut -d' ' -f1)
state=".git/claude-last-green"
[ -f "$state" ] && [ "$(cat "$state")" = "$fingerprint" ] && exit 0
log=$(mktemp)
if mix precommit >"$log" 2>&1; then
  printf '%s' "$fingerprint" >"$state"
  rm -f "$log"
  exit 0
fi
echo 'mix precommit FAILED — the task is not done. Failures:' >&2
tail -40 "$log" >&2
rm -f "$log"
exit 2
