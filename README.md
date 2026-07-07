# fable-mode

Portable working discipline extracted from real Claude Fable 5 sessions, so
**any AI coding agent** (Claude Opus/Sonnet/Haiku, Codex, Gemini, OSS models)
self-steers with Fable-grade rigor and orchestration — without the Fable model.

## Why

Fable 5's edge on real work was mostly **procedure, not raw intelligence**:
evidence ladders, adversarial self-review, disjoint-scope fan-out, physical
verification gates, honest ledger reporting. Procedure is portable. This repo
captures it from ~75 real sessions across 6 projects (evidence:
[docs/fable-behavior-study.md](docs/fable-behavior-study.md)).

## Contents

| Path | What |
|---|---|
| [skills/fable-method/SKILL.md](skills/fable-method/SKILL.md) | The skill: 5 hard gates (Scope → Evidence → Adversarial → Verify → Report) + standing habits. Works multi-agent or solo (sequential-hats fallback). |
| [rules/feedback_model_routing.md](rules/feedback_model_routing.md) | Model routing + cost-smart decisions: smart model plans/verifies, cheap models execute; waste elimination without quality cuts. |
| [rules/feedback_self_steering.md](rules/feedback_self_steering.md) | The owner's 5 recurring interventions converted to standing self-checks. |
| [docs/fable-behavior-study.md](docs/fable-behavior-study.md) | Transcript study: the 7 invariants, steering pattern, known weak spots. |
| [SETUP.md](SETUP.md) | Wiring per provider (Claude Code, Codex, Gemini, others). |

## Install (Claude Code)

Copy or link `skills/fable-method/` into `~/.claude/skills/` (global) or
`<repo>/.claude/skills/` (per project). The skill auto-triggers on non-trivial
tasks; invoke explicitly with `/fable-method`.

The two `rules/*.md` files are shared-memory factory rules: copy into the
factory (`ai-context/memory/shared/`) and add `@imports` in `_global.md` so
every provider loads them.

## Principles

- Gates are hard: don't pass a gate you can't prove; don't declare done with a
  gate unpassed.
- Cost-smart, never quality-cut: route work to the cheapest model+effort that
  clears the bar; if the cheap route fails the gate, escalate the route, not
  lower the bar.
- Degrades gracefully: no subagent support → run finder/refuter/gap passes
  sequentially as explicit hats.
