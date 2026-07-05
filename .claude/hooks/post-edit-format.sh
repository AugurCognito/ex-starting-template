#!/usr/bin/env bash
f=$(jq -r '.tool_input.file_path // empty')
case "$f" in
  *.ex | *.exs) ;;
  *) exit 0 ;;
esac
cd "$CLAUDE_PROJECT_DIR" || exit 0
out=$(mix format "$f" 2>&1) && exit 0
echo "mix format failed on $f:" >&2
printf '%s\n' "$out" | head -15 >&2
exit 2
