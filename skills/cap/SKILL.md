---
name: cap
description: Commit all current changes and push. Invoke when the human says "cap" or "commit and push".
---

Run the full commit + push sequence per the system prompt's git protocol:

1. Parallel inspect — `git status`, `git diff` (staged + unstaged), `git log` (for commit-message style).
2. Stage relevant files by name (never `git add -A`). Skip anything that looks like secrets (`.env`, credentials, tokens) and flag them to the human.
3. Write a concise message (1–2 sentences, *why* over *what*, matching repo style). Use a HEREDOC and the `Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>` trailer.
4. `git push`. If the branch has no upstream, set it with `-u origin <branch>`.
5. Report the commit hash and push result.

Never skip hooks (`--no-verify`). If a pre-commit hook fails, fix the underlying issue and create a **new** commit — do not `--amend`.

If there are no changes, report and exit — no empty commits.
