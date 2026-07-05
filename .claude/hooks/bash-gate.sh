#!/usr/bin/env bash
cmd=$(jq -r '.tool_input.command // empty')
decide() {
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"%s","permissionDecisionReason":"%s"}}' "$1" "$2"
  exit 0
}
case "$cmd" in
  *curl*'| sh'*|*curl*'| bash'*|*curl*'|sh'*|*curl*'|bash'*|*wget*'| sh'*|*wget*'|sh'*)
    decide deny "Piping downloads to a shell is banned. Download to a file, inspect it, then run." ;;
  *'rm -rf /'*|*'rm -rf ~'*|*'rm -fr /'*|*'rm -fr ~'*)
    decide deny "rm -rf on absolute or home paths is banned." ;;
  *'rm -rf'*|*'rm -fr'*)
    decide ask "rm -rf detected — confirm the target is inside this repo and disposable." ;;
  *'git reset --hard'*)
    decide ask "git reset --hard discards uncommitted work — confirm." ;;
  *'git clean -f'*'d'*|*'git clean -fd'*)
    decide ask "git clean -fd deletes untracked files — confirm." ;;
  *sudo*)
    decide deny "sudo is never needed in this repo." ;;
esac
exit 0
