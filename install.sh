#!/usr/bin/env sh
# fable-mode installer (macOS / Linux / Git Bash / WSL)
# Installs the fable-method skill (+ bundled rules) for Claude Code.
#
#   ./install.sh                 # global:  ~/.claude/skills/fable-method
#   ./install.sh --project .     # project: <path>/.claude/skills/fable-method
#   ./install.sh --agents        # also write the method into AGENTS.md (for
#                                # Codex, Gemini CLI, Cursor, and other
#                                # AGENTS.md-aware tools)
#
# Works from a checkout OR standalone (no clone):
#   curl -fsSL https://raw.githubusercontent.com/veerabhadra-ponna/fable-mode/master/install.sh | sh
set -e
RAW_BASE="https://raw.githubusercontent.com/veerabhadra-ponna/fable-mode/master"
RULES="model-routing.md self-steering.md skill-evolution.md"
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" 2>/dev/null && pwd || true)

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
mkdir -p "$DEST/references"

if [ -f "$SCRIPT_DIR/skills/fable-method/SKILL.md" ]; then
  cp "$SCRIPT_DIR/skills/fable-method/SKILL.md" "$DEST/SKILL.md"
  for r in $RULES; do cp "$SCRIPT_DIR/rules/$r" "$DEST/references/$r"; done
else
  echo "No local checkout - downloading from $RAW_BASE ..."
  curl -fsSL "$RAW_BASE/skills/fable-method/SKILL.md" -o "$DEST/SKILL.md" \
    || { echo "Download failed - check network or install from a git clone." >&2; exit 1; }
  for r in $RULES; do curl -fsSL "$RAW_BASE/rules/$r" -o "$DEST/references/$r"; done
fi
echo "Installed skill -> $DEST"

if [ "$AGENTS" = 1 ]; then
  AGENTS_FILE="$ROOT/AGENTS.md"
  MARKER_START="<!-- fable-method:start -->"
  MARKER_END="<!-- fable-method:end -->"
  # strip CR (CRLF checkouts) and YAML frontmatter
  BODY=$(tr -d '\r' < "$DEST/SKILL.md" | awk 'BEGIN{fm=0;done=0} /^---$/{if(!done){fm++; if(fm==2)done=1; next}} done||fm==0{print}')
  if [ -f "$AGENTS_FILE" ]; then
    # drop any previous block; $(...) also trims trailing blank lines
    KEPT=$(tr -d '\r' < "$AGENTS_FILE" | awk -v s="$MARKER_START" -v e="$MARKER_END" '$0==s{skip=1} !skip{print} $0==e{skip=0}')
  else
    KEPT=""
  fi
  { [ -n "$KEPT" ] && printf '%s\n\n' "$KEPT"; printf '%s\n%s\n%s\n' "$MARKER_START" "$BODY" "$MARKER_END"; } > "$AGENTS_FILE"
  echo "Wrote fable-method block to $AGENTS_FILE"
fi
echo "Done. In Claude Code, the skill auto-triggers on non-trivial tasks; invoke explicitly with /fable-method."
