#!/usr/bin/env bash
set -euo pipefail

# Fogo Dev Skill installer for Claude Code
# Usage:
#   ./install.sh              # Install to ~/.claude/skills/fogo-dev (personal)
#   ./install.sh --project    # Install to .claude/skills/fogo-dev (project-scoped)
#   ./install.sh --path DIR   # Install to custom directory

SKILL_NAME="fogo-dev"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_SRC="$SCRIPT_DIR/plugins/fogo-dev-skill/skills/fogo-dev"

# Verify source exists
if [ ! -f "$SKILL_SRC/SKILL.md" ]; then
  echo "Error: SKILL.md not found in $SKILL_SRC"
  echo "Make sure you're running this from the fogo-dev-skill repository root."
  exit 1
fi

# Parse arguments
INSTALL_DIR="$HOME/.claude/skills/$SKILL_NAME"
MODE="personal"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      INSTALL_DIR=".claude/skills/$SKILL_NAME"
      MODE="project"
      shift
      ;;
    --path)
      INSTALL_DIR="$2"
      MODE="custom"
      shift 2
      ;;
    -h|--help)
      echo "Usage: ./install.sh [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --project     Install to .claude/skills/$SKILL_NAME (project-scoped)"
      echo "  --path DIR    Install to custom directory"
      echo "  -h, --help    Show this help"
      echo ""
      echo "Default: Install to ~/.claude/skills/$SKILL_NAME (personal)"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Check for existing installation
if [ -d "$INSTALL_DIR" ]; then
  echo "Existing installation found at: $INSTALL_DIR"
  read -rp "Overwrite? [y/N] " confirm
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
  fi
  rm -rf "$INSTALL_DIR"
fi

# Install
mkdir -p "$INSTALL_DIR"
cp "$SKILL_SRC"/*.md "$INSTALL_DIR/"

# Count files
FILE_COUNT=$(ls -1 "$INSTALL_DIR"/*.md 2>/dev/null | wc -l)

echo ""
echo "Installed $SKILL_NAME skill ($FILE_COUNT files) to:"
echo "  $INSTALL_DIR"
echo ""
echo "Mode: $MODE"
echo ""
echo "Tip: For best results, also install the companion solana-dev-skill:"
echo "  npx skills add https://github.com/solana-foundation/solana-dev-skill"
