# fable-mode

Make **any AI coding agent** — Claude Opus/Sonnet/Haiku, GPT/Codex, Gemini,
open-source models — work with the discipline of a frontier model: rigorous
scoping, evidence-first reasoning, adversarial self-review, physical
verification, and clean delivery. No frontier model required; the gates are
procedure, not intelligence.

## Quick install

One line, no clone needed.

**macOS / Linux / WSL / Git Bash:**

```sh
curl -fsSL https://raw.githubusercontent.com/veerabhadra-ponna/fable-mode/master/install.sh | sh
```

**Windows (PowerShell):**

```powershell
irm https://raw.githubusercontent.com/veerabhadra-ponna/fable-mode/master/install.ps1 | iex
```

That installs the skill globally for Claude Code. For per-project install or
AGENTS.md wiring (Codex/Gemini/Cursor), clone and pass options:

```sh
git clone https://github.com/veerabhadra-ponna/fable-mode && cd fable-mode

# examples
./install.sh --project ~/code/my-app             # skill for one repo only
./install.sh --agents                            # global + ~/AGENTS.md block
./install.sh --project ~/code/my-app --agents    # repo skill + repo AGENTS.md
```

```powershell
git clone https://github.com/veerabhadra-ponna/fable-mode; cd fable-mode

# examples
.\install.ps1 -Project C:\code\my-app            # skill for one repo only
.\install.ps1 -Agents                            # global + ~\AGENTS.md block
.\install.ps1 -Project C:\code\my-app -Agents    # repo skill + repo AGENTS.md
```

### Then use it

```text
/fable-method                                   # explicit invocation in Claude Code
> review this branch in fable mode              # or just mention fable mode
> use the fable method to root-cause this flaky test
> fable mode: implement dark mode across the app
```

In Claude Code the skill also auto-triggers on non-trivial tasks (reviews,
debugging, multi-file changes) — no invocation needed. Other tools pick it up
from `AGENTS.md` or their custom-instructions mechanism (see
[SETUP.md](SETUP.md)).

## What you get

**The skill — six hard gates** ([skills/fable-method/SKILL.md](skills/fable-method/SKILL.md)).
Each gate has PASS criteria; the agent may not proceed past a gate it can't pass:

1. **Scope** — read real state, capture a baseline, surface blockers, red-team the plan.
2. **Evidence** — cheapest decisive probe first; mechanisms proven, never argued; assumptions labeled.
3. **Adversarial reasoning** — actively try to refute your own findings (multi-agent fan-out, or sequential "hats" solo).
4. **Verify** — full quality gate + drive the changed flow live; every claim ships a proof artifact; mutation-test new tests; loop until zero high/medium.
5. **Delivery** — lightweight diff review before every commit; deep whole-diff adversarial review before every merge; README/changelog/docs/version synced to the implementation.
6. **Report** — verdict first, proven vs assumed, what was NOT done and why.

**Supporting rules** — bundled into the skill as `references/` by the
installer; also usable standalone in any agent's instructions/memory:

| File | What |
|---|---|
| [rules/model-routing.md](rules/model-routing.md) | Smart model plans/verifies, cheapest capable model executes; effort discipline; cost-smart waste elimination that never cuts quality. |
| [rules/self-steering.md](rules/self-steering.md) | The five corrections humans always end up making, converted to standing self-checks so the agent pre-empts them. |
| [rules/skill-evolution.md](rules/skill-evolution.md) | Continuous improvement: extract new steering from daily usage, merge instead of append, prune rules models have outgrown, token-optimize after every edit. |

## Principles

- **Gates are hard.** Don't pass a gate you can't prove; don't declare done
  with a gate unpassed.
- **Cost-smart, never quality-cut.** Route work to the cheapest model+effort
  that clears the bar; if the cheap route fails the gate, escalate the route,
  not lower the bar.
- **Degrades gracefully.** No subagent support → run finder/refuter/gap passes
  sequentially as explicit hats. No live system → the proof artifact is the
  strongest available evidence, labeled as such.

## License

MIT — see [LICENSE](LICENSE).
