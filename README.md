# ai-workflow

Portable Claude Code workflows. Each workflow is a self-contained folder with its rules, procedure files, and Claude Code skills. Install all skills globally with [`install.sh`](./install.sh).

## Install

```sh
./install.sh
```

Symlinks every workflow's skills into `~/.claude/skills/` so they become slash commands in any project. Skills resolve their procedure files via absolute paths into this repo — keep the clone at `~/dev/ai-workflow` (or set `CLAUDE_SKILLS_DIR` to override the skills destination).

Idempotent. Re-run after pulling changes that add new skills.

## Standalone skills

General-purpose slash commands under [`skills/`](./skills/), not tied to a specific workflow:

- **`/cap`** — commit all current changes and push (with the standard git protocol).
- **`/wyt`** — "what do you think?" Advisory opinion on the argument; does not take action.

## Workflows

Self-contained folders with their own rules, procedure files, and workflow-scoped skills:

- **[proposal-based/](./proposal-based/)** — design non-trivial changes in prose before coding. Slash commands: `/draft-proposal`, `/sharpen-proposal`, `/split-proposal`, `/implement-proposal`.

## Adding a skill or workflow

- **Standalone skill:** create `skills/<name>/SKILL.md` with Claude Code skill frontmatter (`name`, `description`, optional `argument-hint`, optional `allowed-tools`).
- **Workflow:** create `<name>/` with a `README.md` (rules), procedure files as needed, and a `skills/` subfolder of `<skill-name>/SKILL.md` files. Keep skill bodies thin — reference procedure files via absolute path (`~/dev/ai-workflow/<workflow>/<file>.md`), don't inline them.

Re-run `./install.sh` on each machine after adding anything.
