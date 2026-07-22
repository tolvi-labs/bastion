#!/usr/bin/env bash
# install.sh — install the Bastion Claude Code skill.
#
# Default: symlink skills/bastion → ~/.claude/skills/bastion so that `git pull`
# on the tolvi-labs/bastion repo updates the skill automatically. Use --copy for
# a frozen snapshot isolated from repo updates.
#
# Flags:
#   --copy         Deep-copy the skill instead of symlinking
#   --uninstall    Remove the installed skill
#   --path <dir>   Override install base (default: ~/.claude/skills)
#   --force        Overwrite an existing install (refuses by default)
#   -h, --help     Print usage

set -euo pipefail

# Resolve the directory this script lives in, so the source is found regardless
# of where the user invoked it from.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_SKILL="$SCRIPT_DIR/skills/bastion"

DEST_BASE="${HOME}/.claude/skills"
MODE="symlink"
ACTION="install"
FORCE="false"

usage() {
  cat <<EOF
Usage: bash install.sh [--copy] [--uninstall] [--path <dir>] [--force]

Default: symlink skills/bastion into \$HOME/.claude/skills/bastion so that
         'git pull' on the tolvi-labs/bastion repo updates the skill automatically.

Flags:
  --copy         Deep-copy the skill instead of symlinking.
  --uninstall    Remove the installed bastion/ skill.
  --path <dir>   Install destination base (default: \$HOME/.claude/skills).
  --force        Overwrite an existing install. Refuses by default.
  -h, --help     Show this help.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --copy)      MODE="copy";        shift ;;
    --uninstall) ACTION="uninstall"; shift ;;
    --path)      DEST_BASE="$2";     shift 2 ;;
    --force)     FORCE="true";       shift ;;
    -h|--help)   usage; exit 0 ;;
    *) echo "install.sh: unknown flag: $1" >&2; usage; exit 1 ;;
  esac
done

DEST_DIR="$DEST_BASE/bastion"

if [[ "$ACTION" == "uninstall" ]]; then
  if [[ -L "$DEST_DIR" ]]; then
    echo "✓ Removing $DEST_DIR (was symlink → $(readlink "$DEST_DIR"))"
    rm "$DEST_DIR"
  elif [[ -d "$DEST_DIR" ]]; then
    echo "✓ Removing $DEST_DIR (was copy)"
    rm -rf "$DEST_DIR"
  else
    echo "install.sh: nothing installed at $DEST_DIR"
  fi
  exit 0
fi

if [[ ! -d "$SOURCE_SKILL" ]]; then
  echo "install.sh: cannot find skill source at $SOURCE_SKILL" >&2
  exit 1
fi

if [[ -e "$DEST_DIR" || -L "$DEST_DIR" ]]; then
  if [[ "$FORCE" != "true" ]]; then
    echo "install.sh: $DEST_DIR already exists. Re-run with --force to overwrite." >&2
    exit 1
  fi
  rm -rf "$DEST_DIR"
fi

mkdir -p "$DEST_BASE"
if [[ "$MODE" == "symlink" ]]; then
  ln -s "$SOURCE_SKILL" "$DEST_DIR"
  echo "✓ Symlinked $DEST_DIR → $SOURCE_SKILL"
else
  cp -R "$SOURCE_SKILL" "$DEST_DIR"
  echo "✓ Copied skill to $DEST_DIR"
fi

if [[ ! -r "$DEST_DIR/SKILL.md" ]]; then
  echo "install.sh: $DEST_DIR/SKILL.md is not readable after install" >&2
  exit 1
fi
echo "✓ Verifying: $DEST_DIR/SKILL.md is readable ✓"

cat <<EOF

✓ Bastion installed.
Next steps:
  - In any Claude Code session, invoke /bastion <plan | ticket | description> to run the crucible.
  - Bastion reads your repo's vault/ (run 'tolvi init' if you don't have one yet).
  - Optional: set ANTHROPIC_API_KEY to enable ranked vault retrieval via 'tolvi ask'.
EOF
