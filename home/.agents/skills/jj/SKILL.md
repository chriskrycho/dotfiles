---
name: jj
description: |
    Jujutsu (jj) VCS guidance for this project. Use whenever performing any version control operations: committing, viewing history, working with bookmarks, pushing/fetching, or any time a git command would otherwise be used.
allowed-tools: Bash(jj *)
---

This project uses [Jujutsu (`jj`)](https://jj-vcs.github.io/jj/latest/) in a colocated git repo (`.jj/` and `.git/` both exist). Use `jj` for all version control operations. Do **not** use `git` commands directly.

## Key concepts

| Concept | jj | git equivalent |
|---|---|---|
| Current state | `@` (working copy commit) | working tree + index |
| Staging | None — all tracked changes are part of `@` automatically | `git add` |
| Named refs | Bookmarks | Branches |
| Stable ID | Change ID (survives rewrites) | — |
| Content ID | Commit ID (changes on rewrite) | Commit SHA |
| Main ref | `canon` bookmark | `main`/`master` branch |

## Common commands

```bash
# Inspect
jj status                          # changes in the working copy
jj log                             # compact history
jj log -r 'all()'                  # full graph
jj diff                            # diff of working copy
jj diff -r <change>                # diff of a specific change

# Describe / "commit"
jj describe -m "message"           # set description on @ (the working copy change)
jj new                             # start a new empty change on top of @
jj new -m "message"                # new change with description
jj new <rev>                       # new change on top of a specific revision

# Amend / edit history
jj squash                          # fold @ into its parent
jj squash -m "message"             # fold @ into parent with new description
jj split                           # split @ interactively into two changes
jj rebase -d <destination>         # rebase @ onto a different parent

# Bookmarks (≈ branches)
jj bookmark list                   # list all bookmarks
jj bookmark set <name>             # move bookmark to @
jj bookmark create <name>          # create bookmark at @
jj bookmark move <name> --to <rev> # move bookmark to a specific revision

# Remote sync
jj git fetch                       # fetch from remote
jj git push                        # push tracked bookmarks to remote
jj git push -b <name>              # push a specific bookmark
```

## Workflow notes

- There is no staging area. Every tracked file change is part of the current working copy commit (`@`) automatically.
- Prefer change IDs (short alphabetic strings like `v`, `qk`, `xnm`) over commit IDs when specifying revisions in commands.
- `jj describe` is how you "write a commit message" — the change already exists; you are just naming it.
- `jj new` followed by `jj squash` is the `jj` equivalent of amending an earlier commit.
- The `canon` bookmark tracks the main branch. Do not move it manually.