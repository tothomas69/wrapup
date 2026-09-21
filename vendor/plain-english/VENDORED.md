# Vendored: plain-english

`wrapup` uses the Orwell/Gowers plain-English rules to clean the file it
writes. Rather than depend on that skill being installed, a copy lives here.

Upstream: https://github.com/b1rdmania/claude-plain-english-skill
Licence: MIT, (c) 2025-2026 b1rdmania — see `LICENSE` in this directory.

## Files

    PLAIN-ENGLISH.md    upstream skills/plain-english/SKILL.md, renamed
    REFERENCE.md        upstream skills/plain-english/REFERENCE.md, unchanged
    LICENSE             upstream LICENSE, unchanged

## Why SKILL.md is renamed

`wrapup` gets symlinked into `~/.claude/skills/`. A file named `SKILL.md`
sitting anywhere underneath it risks being discovered as a second skill
declaring `name: plain-english`, which collides with the standalone skill if
the user has that installed too. Renaming the file removes the possibility.
`wrapup` reads it by path, so the name does not matter to anything else.

## Updating

    cp ~/path/to/claude-plain-english-skill/skills/plain-english/SKILL.md \
       vendor/plain-english/PLAIN-ENGLISH.md
    cp ~/path/to/claude-plain-english-skill/skills/plain-english/REFERENCE.md \
       vendor/plain-english/REFERENCE.md

Then record the new commit below.

## Vendored from

    1e1501e0e4da21d63b6611e2f258cf28c356a86c
    2026-09-10 23:18:37 +0200
