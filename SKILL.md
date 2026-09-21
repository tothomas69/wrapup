---
name: wrapup
description: Writes a durable end-of-session retrospective into the current repository's docs/wrapup/ directory. One short Markdown file per session, written for a future agent with zero context. Invoked explicitly, never chosen by the model.
disable-model-invocation: true
allowed-tools: Read, Glob, Grep, Write, Edit, Bash(git status:*), Bash(git log:*), Bash(git diff:*), Bash(git rev-parse:*), Bash(mkdir:*)
---

# Wrapup

Capture what a session learned before the context window closes on it.

The expensive parts of a working session are not the diffs — those survive in
git. The expensive parts are the reasoning behind a decision, the approach that
was tried and abandoned, and the one thing that should happen next. Those live
only in the conversation and die with it. This skill writes them down.

## Operating mode

**Fully automatic. Do not ask the user questions.**

Reconstruct everything from the session transcript, the working tree, and git
state. When an answer is not recoverable, omit the item — do not invent it, and
do not stop to ask. Where reasoning is inferred rather than stated, label it:

> _Inferred:_ the retry loop was dropped because the client already retries.

An omitted section is honest. A fabricated one poisons every session after it.

## Output location

Write to `docs/wrapup/` inside the repository the session is running in.

- Create the directory if it does not exist.
- Filename: `YYYY-MM-DD-HHMM-<slug>.md` — e.g. `2026-09-21-1440-auth-token-refresh.md`.
- The slug is 2–4 words describing the session's actual subject, kebab-case.
- These files are committed. One narrow content rule applies — see
  **Secrets** below.

If the current directory is not a git repository, write the recap to
`docs/wrapup/` relative to the working directory and note in the file that it
is not under version control.

### Idempotency

The template's second line carries a machine-readable marker:

    <!-- session-started: YYYY-MM-DDTHH:MM -->

Before writing, scan `docs/wrapup/` for a file whose marker matches the current
session's start time. If one exists, **update that file in place**. Never write
a second file for one session. Never rewrite a recap from an earlier session.

The marker is an HTML comment so it stays invisible in rendered Markdown and in
Git forge previews.

## Procedure

1. **Determine the repo root** and whether `docs/wrapup/` exists.
2. **Gather state** — `git status --short`, `git log --oneline` for commits made
   during this session, and the list of files touched.
3. **Re-read the session** for decisions, rejections, surprises, mistakes, and
   unverified assumptions.
4. **Work through "What to look for" below** silently. Drop every item you
   cannot answer from evidence.
5. **Write the file** using `templates/wrapup-template.md`.
6. **Report** one line to the user: the path written and the section count.
   Nothing more — the file is the deliverable.

## What to look for

These are the prompts you run through while reading the session — not headings.
**The output uses only the headings in the template.** Several of these land
under one heading; that is intended.

Ordered by how expensive each answer is to reconstruct later.

1. **What were we trying to do?** The goal as stated at the start, plus whether
   it drifted mid-session.
2. **What landed?** Files, commits, and artifacts that exist now and did not
   before.
3. **What is half-done?** Uncommitted edits, stubs, open branches, a function
   with a `TODO` where the body should be.
4. **What did we decide, and why?** The reasoning, not just the outcome.
5. **What did we rule out, and why?** The highest-value content in the file. It
   is what stops the next session re-walking a dead end.
6. **What went wrong, and what did it cost?** Wrong assumptions, wasted effort,
   reverted work. See **Honesty about mistakes** below.
7. **What is still unverified?** Assumptions acted on but never tested.
8. **What are the next logical steps?** Concrete, with commands or filenames.
   Lead with whatever has to happen first.
9. **What context is not in the repo?** Knowledge a cold reader would need and
   cannot derive from the code.
10. **What should be promoted out of this file?** Into `CLAUDE.md`, a new skill,
    an issue, or the README. Recaps are a staging area, not a permanent home.

A real session surfaces five or six of these. Ten is a ceiling, not a quota.

## Session notes

Auto-memory is a **requirement** of this skill, not an optional input. Session
start time, duration, and the Last Exchange all come from it.

Notes live at:

    ~/.claude/projects/<slug>/<session-uuid>.jsonl

The slug is the absolute working directory with every `/` replaced by `-`,
including the leading one — `/Users/you/Coding/myrepo` becomes
`-Users-you-Coding-myrepo`. Git worktrees get their own slug, so resolve it
from the **actual** cwd rather than the repo root, or the recap will quote the
wrong session.

Steps:

1. **If a transcript path was passed in, use it.** The `SessionEnd` hook
   supplies one. Trust it over anything you find by searching.
2. Only if no path was given: build the slug from the current working
   directory and take the most recently modified `.jsonl` in it.
   **This fallback is unreliable under the hook** — a headless run started by
   `SessionEnd` writes its own `.jsonl`, which will be newer than the session
   you are meant to be recapping.
3. First entry's timestamp is the session start; last entry's is the end.
   Duration is the difference.
4. Take the final user message and the final assistant response for
   **Last Exchange**, labelled **You said:** and **I said:**.

Ignore the transcript's own tail if it belongs to the wrapup run itself — the
last exchange of interest is the last *human* exchange of the working session.

Quote them as they were written. The point of the section is that both sides
can see exactly how the conversation was left — a paraphrase defeats it.

If the notes directory is missing, say so in the recap rather than guessing at
the values. Never reconstruct a quoted exchange from context.

## Writing rules

### Voice

Write in English, in Tom's voice. The rules below are the whole of it — follow
them rather than falling back to generic assistant prose.

Orwell's rules, applied to a recap:

- Never use a long word where a short one will do.
- If it is possible to cut a word out, cut it out.
- Use the active voice, and **name the actor**. "I dropped the retry loop
  because the client already retries" — not "the retry loop was removed."
- Never use a metaphor or figure of speech you are used to seeing in print.
- Break any of these sooner than write something outright barbarous.

### Tone

Write as if explaining the session to another developer over coffee. Direct,
unceremonious, occasionally dry. Contractions are fine. Short sentences beat
balanced ones.

Conversational means plain, not chatty. Every line still has to earn its place
against the length cap.

### Honesty about mistakes

**The most valuable lessons come from what went wrong, so write them down
plainly.** You are explicitly permitted — expected — to record your own errors:
the wrong assumption, the forty minutes spent in the wrong file, the fix that
got reverted.

No passive-voice laundering. "An issue was encountered with the config path" is
worthless. "I assumed the config came from the repo root; it comes from
`$XDG_CONFIG_HOME`, and I lost half an hour to that" is the whole point of the
file.

Record the cost — time lost, work discarded. Cost is what tells the next reader
how hard to avoid that path.

### Transferable lessons

Frame each lesson so it survives outside this repository. State the general rule
first, then this session as the evidence for it:

> **Check where a tool actually reads its config before editing anything.**
> This project's CLI ignores the repo-root file entirely; an hour went into
> edits that were never loaded.

A lesson that only makes sense with this codebase open is a note, not a lesson.
Put it under current state instead.

### Standing rules

- **Write for a cold reader.** A future agent with zero context. No "as we
  discussed," no pronouns without antecedents, no reference to "the earlier
  approach" without naming it.
- **A decision without its rejected alternative is just a fact.** Record what
  lost, and why it lost.
- **Cap the file at roughly one page** (~500 words). If it runs longer than a
  future session will actually read, it is wrong.
- **State over narrative.** No blow-by-blow. Decisions, current state, lessons,
  next action.
- **Mark unverified claims as unverified.** No invented certainty.
- **Make no project assumptions.** Language, test runner, lint gates, and CI get
  detected from the repo or left out. This skill carries no house style of its
  own beyond the voice rules above.

## Secrets

One rule, and it is the only thing this skill will not write down:

**Never copy a credential into a recap.** Tokens, API keys, passwords,
connection strings — even expired ones, even ones the user pasted themselves.
Write `[credential omitted]` in its place and carry on.

That is the whole restriction. Everything else goes in as it happened:
hostnames, paths, command output, ticket references, names, the quoted
exchange, the mistakes. A recap that softens what was said is worth less than
no recap, because the next session trusts it.

If a credential appears inside the **Last Exchange** quote, replace just that
string and keep every other word intact. Do not trim the surrounding message
and do not paraphrase around it.
