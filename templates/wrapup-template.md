<!--
  recap-template.md — fill this in, then delete every comment block.

  Omit any section you cannot fill from evidence. An empty section is noise;
  a missing one is fine. Only TL;DR, Where Things Stand, and Recap are
  mandatory.

  Keep the finished file to roughly one page (~500 words). Recap answers run
  1-3 sentences each — no longer.

  The session marker below is machine-read for idempotency. Leave it in place.
-->
<!-- session-started: YYYY-MM-DDTHH:MM -->

# Session Retrospective: [Brief Title]

**Date**: [date]
**Duration**: [if determinable from timestamps]
**Project**: [working directory or project name]

## TL;DR

[2-3 sentence summary of what was accomplished and the key takeaway]

## What We Set Out To Do

<!-- Same ground as the first Recap question below. Keep one, delete the other. -->

[Brief description of the initial goal/problem. If the goal drifted mid-session,
say so and say when.]

## Commits

<!-- All commits from this session. Hash and message, nothing else.
     If there are none, say so outright — "No commits; work is in flight, see
     below" — so the absence reads as a fact rather than an oversight. -->

- `abc1234` — commit message
- `def5678` — commit message

## Where Things Stand

**Landed:** [what exists now that did not before]

**In flight:** [uncommitted edits, stubs, open branches — name the files, so the
next session knows what it is walking into]

## Recap

<!-- 1-3 sentences per answer. Be specific: cite actual commits and file paths
     rather than gesturing at "the refactor" or "some issues." -->

- **What were we most focused on accomplishing?**
  [The real focus, which is not always the stated goal. Note the drift if there
  was one.]

- **What problems did we work through?**
  [Include what was rejected and why it lost — a decision without its rejected
  alternative is just a fact. Include dead ends: the next session should not
  re-walk proven-empty ground.]

- **What was a win?**
  [What worked, and *why* it worked, so it can be repeated. A mechanism, not a
  compliment.]

- **What's something I learned?**
  [Transferable. General rule first, this session as the evidence. Own the
  mistakes plainly, in the active voice, with the cost attached — the wrong
  assumption, the hour in the wrong file, the fix that got reverted.]

- **What are our next logical steps?**
  [Lead with one concrete first action — a command or a filename, specific
  enough to start without re-reading this file. Anything that should graduate
  out of this recap into CLAUDE.md, a skill, an issue, or the README goes here
  too.]

## Still Unverified

<!-- Optional. Assumptions acted on but never tested. Say what would test them. -->

- [Assumption] — untested. Would be confirmed by: [check or command].

## Last Exchange

<!-- The final user message and the final Claude response from this session,
     pulled from the auto-memory session notes under ~/.claude/projects/.

     Quote both verbatim. The point of this section is that the next session
     can see exactly how the conversation was left, so do not trim, summarise
     or paraphrase. The only exception is a credential — replace that one
     string with [credential omitted] and keep every other word. -->

**You said:**
[final user message]

**I said:**
[final Claude response]
