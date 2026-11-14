# Global instructions (Risto)

## Agent bootstrap: check `.llms/readme.md`

At the start of work in any repo, check whether `.llms/readme.md` exists. If it does, read
it first — it's Risto's local-only (git-ignored) orientation/bootstrap doc for AI agents,
and it points to deeper context under `.llms/context/` and active task notes under
`.llms/plans/`. Treat it as the primary entry point for understanding the repo and any
in-progress work. It is intentionally not checked in (the whole `.llms/` dir is git-ignored),
so it won't show up in normal repo docs — look for it explicitly.

If asked to record durable AI context for a repo, prefer adding/updating files under `.llms/`
(keep `.llms/.gitignore` = `*` so it stays local-only) over checked-in docs, unless told the
content should be shared with the team. Conventions within `.llms/`:
- `.llms/readme.md` — top-level orientation / bootstrap entry point.
- `.llms/context/` — durable reference docs about the repo.
- `.llms/plans/` — project docs, task working-notes, plans, and in-progress work to pick
  back up. Put project/task docs here.
