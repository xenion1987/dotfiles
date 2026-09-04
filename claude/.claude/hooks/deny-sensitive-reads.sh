#!/usr/bin/env bash
# PreToolUse guard for the Bash tool.
#
# The permissions.deny entries in settings.json are matched per tool, so
# Read(**/.envrc) does not stop `cat .envrc` run through Bash. This hook closes
# that gap: it inspects the command line and refuses when it references a file
# that is meant to stay unread.
#
# Exit codes: 0 = allow, 2 = block (stderr is shown to Claude).
#
# This is defence in depth, not a sandbox. It matches on the literal command
# text, so an indirect path (a variable, a glob, base64) still gets through.

set -uo pipefail

payload="$(cat)"

if command -v jq >/dev/null 2>&1; then
    cmd="$(printf '%s' "$payload" | jq -r '.tool_input.command // empty')"
else
    cmd="$payload"
fi

[ -z "$cmd" ] && exit 0

for token in $cmd; do
    # strip surrounding quotes and trailing punctuation, then take the basename
    token="${token//\"/}"
    token="${token//\'/}"
    base="${token##*/}"
    base="${base%%;}"

    # templates and samples are safe by definition
    case "$base" in
        *example*|*sample*|*.template) continue ;;
    esac

    case "$base" in
        .env|.env.*|.envrc|.envrc.*|\
        .vault_password*|vault_password*|\
        id_rsa|id_rsa.*|id_ed25519|id_ed25519.*|id_ecdsa|id_ecdsa.*|id_dsa|id_dsa.*|\
        *.pem|*.key|*.gpg|*.p12|*.pfx|\
        credentials|secure.yml|secure.yaml)
            cat >&2 <<MSG
Blocked by PreToolUse hook: the command references '$token'.

Files of this kind are denied for the Read tool in ~/.claude/settings.json, and
this hook applies the same rule to Bash. Do not work around it with another
reader (head, sed, grep, python, source).

If you need something from this file, ask the user to provide the specific value,
or ask them to permit this one command explicitly.
MSG
            exit 2
            ;;
    esac
done

exit 0
