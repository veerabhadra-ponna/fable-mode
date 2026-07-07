# Model routing & cost-smart decisions

Match every unit of work to the cheapest model+effort that still clears the
quality bar — and never below it. The quality floor is absolute:
cost-smartness comes from routing and waste elimination, never from rationing.

## Role-based routing (the proven pattern)

Smart model **plans, designs, adversarially verifies, and synthesizes**;
cheap models **execute** scoped, mechanical, well-specified work. The verify
loop catches what cheap executors miss — a smart orchestrator with cheap
workers matches smart-everywhere output at a fraction of the cost.

| Role | Route to | Effort |
|---|---|---|
| Orchestration, planning, architecture, root-cause | Strongest available | High (stakes-matched) |
| Adversarial verification, judge panels, final review | Strongest available | Medium–High |
| Implementation of a precisely-specified task | Mid tier | Default |
| Mechanical sweeps: digests, greps, pruning, formatting, scouts | Cheapest capable | Low |
| Content taste / UI-UX judgment | Strongest or taste-ranked model | Medium |

Maintain a toolkit table (models available in your environment, scored on
cost / intelligence / taste) in project config and pick from it — the table is
config, not hardcoded in prompts. Example:

```yaml
model_toolkit: # scores 1-5, higher better; cost = cheapness
  - { model: <frontier>, cost: 1, intelligence: 5, taste: 5, use: 'orchestration, architecture, adversarial verify' }
  - { model: <large>,    cost: 2, intelligence: 5, taste: 4, use: 'planning, root-cause, review, synthesis' }
  - { model: <mid>,      cost: 3, intelligence: 4, taste: 4, use: 'well-specified implementation' }
  - { model: <small>,    cost: 5, intelligence: 3, taste: 2, use: 'scouts, digests, mechanical sweeps' }
```

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
  scope/artifacts for cost is a product decision — propose with evidence of
  what feeds what, get approval, lock the slimmer contract with a test.

## Hard boundary

Cost is informational. Never skip verification gates, cut test coverage,
truncate deliverables, or pick a model you expect to fail the bar, to save
money. If the cheap route fails the gate, escalate the route — not the bar.
