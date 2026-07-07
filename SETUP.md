# Wiring per provider

The rules are provider-agnostic; only the loading mechanism differs.

## Claude Code

1. Skill: link/copy `skills/fable-method` → `%USERPROFILE%\.claude\skills\fable-method`
   (auto-triggers via its description; explicit via `/fable-method`).
2. Rules: copy `rules/*.md` → factory `ai-context/memory/shared/`, then add to
   `_global.md` imports:
   ```
   @feedback_model_routing.md
   @feedback_self_steering.md
   ```
   (`_global.md` is imported by `~/.claude/CLAUDE.md`, so all projects load them.)

## Codex / Gemini / others

The factory `_global.md` is already included via each tool's native config
include (see factory SETUP.md). Adding the two rule imports there covers every
provider. For the skill: paste `skills/fable-method/SKILL.md` (minus
frontmatter) into the tool's custom-instructions / AGENTS.md mechanism, or
reference it as a mode prompt ("work per fable-method").

## Conductor / scheduled agents (civyk-ai-company)

Agent instructions reference the skill gates; routing tiers live in
`company.yaml` `agents` block (config is routing truth — never hardcode).

## Keeping in sync

This repo is the source of truth for the skill + rules. After editing here,
re-copy to `~/.claude/skills/` and the factory, same change set.
