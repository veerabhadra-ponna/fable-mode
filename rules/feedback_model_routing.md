# Model routing & cost-smart decisions

Match every unit of work to the cheapest model+effort that still clears the
quality bar — and never below it. Quality floor is absolute (see
budget-is-informational rule); cost-smartness comes from routing and waste
elimination, never from rationing.

## Role-based routing (the proven pattern)

Smart model **plans, designs, adversarially verifies, and synthesizes**;
cheap models **execute** scoped, mechanical, well-specified work. The verify
loop catches what cheap executors miss — empirically, smart-orchestrator +
cheap-workers matches smart-everywhere output at a fraction of the cost.

| Role | Route to | Effort |
|---|---|---|
| Orchestration, planning, architecture, root-cause | Strongest available (Fable → Opus) | High (stakes-matched) |
| Adversarial verification, judge panels, final review | Strongest available | Medium–High |
| Implementation of a precisely-specified task | Mid tier (Sonnet) | Default |
| Mechanical sweeps: digests, greps, pruning, formatting, scouts | Cheapest (Haiku / small OSS) | Low |
| Content taste / UI-UX judgment | Strongest or taste-ranked model | Medium |

Maintain a per-toolkit table (models available in the environment, scored on
cost / intelligence / taste) in project config and pick from it — the table is
config, not hardcoded in prompts.

## Effort discipline

- More effort is not monotonically better: past the stakes-appropriate level,
  models overthink, second-guess, and produce worse output at higher cost.
  Default effort for execution; raise only for review/root-cause/design.
- Escalate effort via a delegated sub-task (higher-effort sub-agent), not by
  running the whole session hot.

## Waste elimination (cost-smart, quality-neutral)

- **Don't redo — reuse**: resume cached workflow runs, recover partial output
  from dead workers' transcripts, generate expensive assets once at max size
  and derive smaller variants locally.
- **Probe before bulk**: run one cheap decisive probe before an expensive
  fan-out; cancel in-flight expensive work the moment direct evidence makes it
  redundant.
- **Right-size the fan-out**: scale worker count to the ask ("find bugs" →
  a few finders; "audit thoroughly" → full panel). Log what a bound (top-N,
  sampling) dropped — silent truncation is a quality cut, not a saving.
- **Token-optimize durable text** (instructions, memory, skills) without
  losing information — every session re-reads it.
- **Value-density cuts need an owner-approved quality floor**: reducing
  scope/artifacts for cost (e.g. "90% of value with 40% of artifacts") is a
  product decision — propose with evidence of what feeds what (read-site
  tracing), get approval, lock the slimmer contract with a test.

## Hard boundary

Cost is informational. Never skip verification gates, cut test coverage,
truncate deliverables, or pick a model you expect to fail the bar, to save
money. If the cheap route fails the gate, escalate the route — not the bar.
