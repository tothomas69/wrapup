#!/usr/bin/env bash
# wrapup-on-session-end.sh
#
# Fired by Claude Code's SessionEnd hook. The session that just ended is gone,
# so this starts a short headless run that reads that session's transcript and
# writes the wrapup file.
#
# Install: see README.md. Hook input arrives as JSON on stdin.

set -euo pipefail

# ---------------------------------------------------------------------------
# 0. Recursion guard.
#    The headless run started below is itself a Claude Code session. When it
#    finishes it fires SessionEnd, which fires this hook again. Without this
#    check that loops forever. The variable is exported into the child, so the
#    child's own hook sees it and exits.
# ---------------------------------------------------------------------------
[ -z "${WRAPUP_RUNNING:-}" ] || exit 0

# ---------------------------------------------------------------------------
# 1. Read the hook payload.
#    SessionEnd gives us the transcript path and the working directory. We need
#    both: the transcript because the headless run below will create its own
#    (newer) transcript and we must not recap that one, and the cwd because the
#    wrapup is written into that repo.
# ---------------------------------------------------------------------------
payload="$(cat)"

transcript="$(printf '%s' "$payload" | jq -r '.transcript_path // empty')"
cwd="$(printf '%s' "$payload" | jq -r '.cwd // empty')"
reason="$(printf '%s' "$payload" | jq -r '.reason // empty')"

# ---------------------------------------------------------------------------
# 2. Bail out quietly when there is nothing worth recapping.
#    A cleared session has no meaningful tail, and without a transcript the
#    skill would be guessing.
# ---------------------------------------------------------------------------
[ -n "$transcript" ] || exit 0
[ -f "$transcript" ] || exit 0
[ "$reason" != "clear" ] || exit 0

cd "${cwd:-$PWD}" || exit 0

# Only recap real work. Adjust or delete this guard to taste.
[ -d .git ] || exit 0

# ---------------------------------------------------------------------------
# 3. Start the headless run in the background and exit immediately.
#    SessionEnd hooks are subject to a timeout; blocking here risks a
#    "Hook cancelled" error on every session close.
# ---------------------------------------------------------------------------
(
  WRAPUP_RUNNING=1 \
  claude -p "Use the wrapup skill. The transcript for the session to recap is \
at $transcript — use that file, not the newest one in the project directory." \
    >/dev/null 2>"${TMPDIR:-/tmp}/wrapup-hook.err"
) &

exit 0
