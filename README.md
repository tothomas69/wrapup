# wrapup

A Claude Code skill that writes an end-of-session retrospective into the
repository you were working in.

Git keeps the diffs. It does not keep the reasoning behind a decision, the
approach you tried and abandoned, or the thing you meant to do next. Those live
in the conversation and die with it. This writes them down before that happens.

Output is one Markdown file per session in `docs/wrapup/`, under 500 words,
written for a future agent with no context.

## What a wrapup contains

- What the session set out to do, and whether it drifted
- Commits, by hash
- What landed and what is still in flight, by filename
- Problems worked through, including what was rejected and why
- What worked, and the mechanism that made it work
- Transferable lessons, mistakes included, with the cost attached
- Next steps
- The final exchange of the session, quoted verbatim

See `examples/` for a real one.

## Install

Global, so it is available in every repository:

```bash
git clone <your remote> ~/Coding/wrapup
ln -s ~/Coding/wrapup ~/.claude/skills/wrapup
```

Requires `jq` for the hook, and auto-memory enabled in Claude Code — session
start time, duration, and the final exchange all come from the transcripts
under `~/.claude/projects/`.

### Run it by hand

```
/wrapup
```

### Run it at session end

`SessionEnd` fires as the session terminates, when no agent is left to write
anything, so the hook starts a short headless run instead.

```bash
chmod +x ~/Coding/wrapup/hooks/wrapup-on-session-end.sh
```

Then in `~/.claude/settings.json`:

```json
{
  "hooks": {
    "SessionEnd": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/Coding/wrapup/hooks/wrapup-on-session-end.sh",
            "timeout": 10000
          }
        ]
      }
    ]
  }
}
```

The hook exits immediately and leaves the headless run in the background, so
session close is never blocked. It skips sessions ended by `/clear` and
directories that are not git repositories. Errors land in
`$TMPDIR/wrapup-hook.err`.

The hook passes the ending session's transcript path to the skill explicitly.
Without that, the headless run would write its own transcript, find it as the
newest file in the project directory, and recap itself.

Hooks declared in skill frontmatter have reportedly been broken since May 2026,
which is why this lives in `settings.json`.

## Design notes

**Fully automatic.** The skill never asks questions — it reconstructs
everything from the transcript, the working tree, and git state. A hook that
stops to interview you at session teardown is a hook you turn off by Thursday.

**Never invents.** An answer it cannot support from evidence gets dropped, and
inferred reasoning is labelled as inferred. A fabricated recap poisons every
session that trusts it.

**One rule on content:** credentials never get written down. Everything else
goes in as it happened — hostnames, paths, command output, names, the quoted
exchange, the mistakes. A recap that softens what was said is worth less than
no recap.

**No house style.** Language, test runner, lint gates, and CI are read from the
repo or left out, so this behaves the same in any project.

## Layout

```
SKILL.md                            the skill itself
templates/wrapup-template.md        the file shape it fills in
hooks/wrapup-on-session-end.sh      SessionEnd handler
examples/                           a real wrapup
```

## Licence

Personal project. All rights reserved.
