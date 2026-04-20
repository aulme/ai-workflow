#!/usr/bin/env bash
# Install ai-workflow skills into ~/.claude/skills/ (or $CLAUDE_SKILLS_DIR).
# Picks up both top-level skills (skills/<name>/) and workflow-scoped skills
# (<workflow>/skills/<name>/). Each skill folder is symlinked as-is.
# Idempotent: re-running only adds new skills and verifies existing links.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

mkdir -p "$SKILLS_DST"

shopt -s nullglob
linked=0
ok=0
skipped=0

for src in "$SCRIPT_DIR"/skills/*/ "$SCRIPT_DIR"/*/skills/*/; do
    src="${src%/}"
    name="$(basename "$src")"
    dst="$SKILLS_DST/$name"

    if [[ -L "$dst" ]]; then
        current="$(readlink "$dst")"
        if [[ "$current" == "$src" ]]; then
            echo "ok:    $name"
            ok=$((ok + 1))
            continue
        fi
        echo "skip:  $name (symlink points elsewhere: $current)"
        skipped=$((skipped + 1))
        continue
    fi

    if [[ -e "$dst" ]]; then
        echo "skip:  $name (exists, not a symlink)"
        skipped=$((skipped + 1))
        continue
    fi

    ln -s "$src" "$dst"
    echo "link:  $name"
    linked=$((linked + 1))
done

echo
echo "installed $linked, already present $ok, skipped $skipped"
echo "target: $SKILLS_DST"
