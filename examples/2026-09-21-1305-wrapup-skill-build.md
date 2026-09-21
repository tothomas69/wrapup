<!-- session-started: 2026-09-21T13:05 -->

# Session Retrospective: Splitting wrapup out of the hive bundle

**Date**: 2026-09-21
**Duration**: ~2h 15m
**Project**: /Users/tothomas/Coding/wrapup

## TL;DR

Built a standalone end-of-session retrospective skill, split out of the hive
bundle so it carries none of the hive's vocabulary and can travel to work
repos on its own. `SKILL.md` and the template are complete; nothing is
committed and the hook isn't wired yet. The skill was nearly shipped with an
`allowed-tools` list that would have prevented it from writing its own output.

## Commits

No commits. The repo hasn't been initialised — `git init` and the Gitea remote
are still outstanding. Everything below is in the working tree only.

## Where Things Stand

**Landed:** `SKILL.md` (frontmatter, operating mode, output location,
idempotency, ten look-for prompts, session-notes resolution, writing rules,
secrets rule) and `templates/wrapup-template.md`.

**In flight:** README not started. `.gitignore` not written. One `TODO` left
in the Voice section of `SKILL.md` — the personal writing skill's name is still
unknown. The `SessionEnd` hook JSON hasn't been drafted.

## Recap

- **What were we most focused on accomplishing?**
  A general retrospective skill with no inherited framing. The renaming to
  `wrapup` came late and rippled through the repo directory, the frontmatter
  `name`, the output path, and the template filename.

- **What problems did we work through?**
  The trigger was specified as a Stop hook. Claude Code fires `Stop` once per
  turn, not once per session, so that would have written a wrapup after every
  response — switched to `SessionEnd`. Idempotency originally keyed off YAML
  front matter that the template didn't have; rejected in favour of an HTML
  comment marker on line 2, which stays invisible in Gitea's preview. A full
  redaction section was also rejected: filtering hostnames and quoted messages
  defeats the Last Exchange section, whose entire purpose is showing how the
  conversation was actually left. Only credentials stay out.

- **What was a win?**
  Deciding the skill drafts everything from the transcript and never prompts.
  That's what makes a `SessionEnd` hook viable — a hook that stops to ask
  questions at session teardown is a hook nobody keeps enabled.

- **What's something I learned?**
  **Check a hook event's cadence before designing around it.** "Fires when the
  agent stops" reads like session end and isn't. **A skill's `allowed-tools`
  must cover whatever it writes with** — the list was scoped to Read plus git,
  which is defensible until you notice the skill's only job is writing a file.
  Both caught on review, no rework beyond the edits. One `edit_file` call was
  also malformed and forced a full rewrite of `SKILL.md`; cost about ten
  minutes.

## Still Unverified

- `Write` creating missing parent directories — untested. Confirmed by a first
  run in a repo with no `docs/wrapup/`.
- Hooks declared in skill frontmatter are reportedly broken since May 2026.
  Single source, unconfirmed — hence putting the hook in `settings.json`.
- The `~/.claude/projects/<slug>/<uuid>.jsonl` parsing has never been run.

## Last Exchange

**You said:**
2

**I said:**
Redaction is gone, replaced by a **Secrets** section with one rule —
credentials become `[credential omitted]`, everything else goes in as it
happened. [...] Want the README next, or the hook JSON first so you can test a
real run?
