#!/usr/bin/env sh
# fable-mode installer (macOS / Linux / Git Bash / WSL)
# Installs the fable-method skill for Claude Code, globally or per-project.
#
#   ./install.sh                 # global:  ~/.claude/skills/fable-method
#   ./install.sh --project .     # project: <path>/.claude/skills/fable-method
#   ./install.sh --agents        # also append the method to AGENTS.md (for
#                                # Codex, Gemini CLI, Cursor, and other
#                                # AGENTS.md-aware tools)
# Works from a checkout OR standalone (curl | sh) — standalone downloads the
# skill from GitHub raw:
#   curl -fsSL https://raw.githubusercontent.com/veerabhadra-ponna/fable-mode/master/install.sh | sh
set -e
RAW_BASE="https://raw.githubusercontent.com/veerabhadra-ponna/fable-mode/master"
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" 2>/dev/null && pwd || true)
SRC="$SCRIPT_DIR/skills/fable-method/SKILL.md"
if [ ! -f "$SRC" ]; then
  SRC=$(mktemp)
  trap 'rm -f "$SRC"' EXIT
  echo "No local checkout - downloading skill from $RAW_BASE ..."
  curl -fsSL "$RAW_BASE/skills/fable-method/SKILL.md" -o "$SRC" \
    || { echo "Download failed - check network or install from a git clone." >&2; exit 1; }
fi

ROOT="$HOME"; AGENTS=0
while [ $# -gt 0 ]; do
  case "$1" in
    --project)
      ROOT=$(CDPATH= cd -- "$2" 2>/dev/null && pwd) || { echo "Project path not found: $2" >&2; exit 1; }
      shift 2 ;;
    --agents)  AGENTS=1; shift ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

DEST="$ROOT/.claude/skills/fable-method"
mkdir -p "$DEST"
cp "$SRC" "$DEST/SKILL.md"
echo "Installed skill -> $DEST/SKILL.md"

if [ "$AGENTS" = 1 ]; then
  AGENTS_FILE="$ROOT/AGENTS.md"
  MARKER_START="<!-- fable-method:start -->"
  MARKER_END="<!-- fable-method:end -->"
  # strip YAML frontmatter (first --- ... --- block)
  BODY=$(awk 'BEGIN{fm=0;done=0} /^---$/{if(!done){fm++; if(fm==2)done=1; next}} done||fm==0{print}' "$SRC")
  if [ -f "$AGENTS_FILE" ] && grep -q "$MARKER_START" "$AGENTS_FILE"; then
    # remove old block, then append fresh
    awk -v s="$MARKER_START" -v e="$MARKER_END" '$0==s{skip=1} !skip{print} $0==e{skip=0}' "$AGENTS_FILE" > "$AGENTS_FILE.tmp"
    mv "$AGENTS_FILE.tmp" "$AGENTS_FILE"
  fi
  { printf '\n%s\n' "$MARKER_START"; printf '%s\n' "$BODY"; printf '%s\n' "$MARKER_END"; } >> "$AGENTS_FILE"
  echo "Wrote fable-method block to $AGENTS_FILE"
fi
echo "Done. In Claude Code, the skill auto-triggers on non-trivial tasks; invoke explicitly with /fable-method."
