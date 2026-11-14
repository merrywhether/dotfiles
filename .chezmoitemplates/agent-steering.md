# Global instructions (Risto)

## Lore: read `~/lore/readme.md` first

Risto's private knowledge lives in `~/lore`: one private git repo per scope, plus a routing
file, `~/lore/readme.md`. At the start of work in any repo:

1. Read `~/lore/readme.md`. It lists the lore repos on this machine and where writes go.
2. Read the notes for the code repo you're in. Each lore repo's `readme.md` gives its layout
   (per-repo notes usually sit in `repos/<code-repo>/`).

Durable context, plans and task notes go to lore, not into the checkout, unless Risto says
the content should be checked in and shared. "Update lore" means write there, then commit and
push that lore repo.

- A checkout's `.llms/` folder, where one exists, is a generated copy (it holds a
  `GENERATED.md`). Never edit it: edit the lore file it came from, then run the sync that
  `GENERATED.md` names.
- Lore is private. Never copy its content anywhere public (checked-in files, PRs, issues,
  public repos) unless Risto asks.
