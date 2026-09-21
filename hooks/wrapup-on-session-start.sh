#!/usr/bin/env bash
# wrapup-on-session-start.sh
#
# Fired by Claude Code's SessionStart hook. Looks for the most recent wrapup in
# this repo and tells Claude to offer it, rather than reading it outright.
#
# A hook cannot prompt the user. All it can do is inject text into the session.
# The offer itself is Claude acting on that text, so treat it as a nudge rather
# than a guarantee.
#
# Install: see README.md. Hook input arrives as JSON on stdin.

set -euo pipefail

# Don't inject into the headless run that SessionEnd starts to write a wrapup.
[ -z "${WRAPUP_RUNNING:-}" ] || exit 0

payload="$(cat)"
cwd="$(printf '%s' "$payload" | jq -r '.cwd // empty')"

cd "${cwd:-$PWD}" || exit 0
[ -d docs/wrapup ] || exit 0

# Most recently modified wrapup. BSD and GNU stat disagree on flags, so sort by
# name instead — the filenames start YYYY-MM-DD-HHMM, so lexical order is
# chronological order.
latest="$(ls -1 docs/wrapup/*.md 2>/dev/null | sort | tail -n 1)"
[ -n "$latest" ] || exit 0

# Pull the H1 for a one-line description. Everything else stays on disk until
# the user actually asks for it.
title="$(grep -m1 '^# ' "$latest" | sed 's/^# //')"
date="$(grep -m1 '^\*\*Date\*\*:' "$latest" | sed 's/^\*\*Date\*\*: //')"

context="A wrapup from the previous session in this repository exists at \
${latest} — \"${title}\", dated ${date:-unknown}.

Before starting work, ask the user whether they want to review it. Ask once, in \
one short line. Do not read the file unless they say yes, and do not mention it \
again if they decline."

# additionalContext is appended to the session's context at startup.
jq -n --arg ctx "$context" '{
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    additionalContext: $ctx
  }
}'

exit 0
