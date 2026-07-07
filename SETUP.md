# Setup per tool

The install scripts (`install.sh` / `install.ps1`) handle the common cases.
This page covers what they do and how to wire other tools manually.

## Claude Code

`./install.sh` (or `.\install.ps1`) copies the skill to
`~/.claude/skills/fable-method` (global) or, with `--project <path>` /
`-Project <path>`, to `<path>/.claude/skills/fable-method`. The rules are
bundled alongside as `references/*.md`, so the skill's internal pointers
always resolve.

- Auto-triggers on non-trivial tasks via the skill description.
- Explicit invocation: `/fable-method`.
- Optional: copy `rules/*.md` content into your `~/.claude/CLAUDE.md` (or a
  project `CLAUDE.md`) so routing and self-steering apply even when the skill
  isn't triggered.

## Codex / Gemini CLI / Cursor / other AGENTS.md-aware tools

`./install.sh --agents` (or `.\install.ps1 -Agents`) appends the skill body
(frontmatter stripped) to `AGENTS.md` between idempotent markers — re-running
updates the block in place. Use `--project <path>` to target a repo's
`AGENTS.md` instead of `~/AGENTS.md`.

Tools with a different mechanism: paste `skills/fable-method/SKILL.md` (minus
the frontmatter) into the tool's custom-instructions / system-prompt /
rules file, or reference it as a mode ("work per fable-method").

## Multi-agent orchestrators

If your environment can spawn sub-agents or workflows, Gate 3 runs as a real
fan-out (finder lenses → per-finding refuter → gap sweep) and the model-routing
rule decides which model runs each stage. Without sub-agents, the skill's solo
mode runs the same passes sequentially — no configuration needed.

## Keeping in sync

This repo is the source of truth. After pulling updates, re-run the install
script — both the skill copy and the AGENTS.md block are overwritten/updated
idempotently.
