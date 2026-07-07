# Fable 5 Behavior Study (2026-07-07)

Evidence base for the `fable-method` skill. Distilled from ~75 Claude Code session
transcripts where Fable 5 (`claude-fable-5`) ran, across 6 projects
(civyk-ai-company, civyk-astra, winwright, job-linkedin, clipsync, tasktamer),
including both interactive marathons (up to 142 MB / 4,600+ messages) and fully
autonomous conductor/scheduled runs.

## Key conclusion

Fable's edge on real work was mostly **procedure, not raw intelligence**. The
procedure is portable to any capable model; the residual gap (novel-insight
reframing, false-positive filtering inside gates) is compensated by adversarial
verify loops and by routing planning/verification to the best available model.
Empirically (ours + community): smart-orchestrator + cheap-executors ≈
smart-model-everywhere, at a fraction of cost.

## The observed method (7 invariants)

1. **Orient before acting.** Read repo/system state, run baseline
   typecheck/tests/lint FIRST so later failures are attributable
   (pre-existing vs self-caused). Surface decisive environment facts early
   ("MCP not loaded, so live runs are impossible") and let them shape the plan.
2. **Evidence ladder for diagnosis.** Cheapest decisive probe first, escalating:
   official docs → live HTTP/CLI probe → minimal repro script → log/cost
   forensics. Each layer eliminates one hypothesis. Never patch a symptom whose
   mechanism isn't proven. (MiniMax-M3 case: docs → curl → CLI repro → SDK repro
   → cost-log timeline, converging on the one true mechanism.)
3. **Disjoint-scope fan-out.** Parallel workers split by *lens* (reviews) or by
   *disjoint file sets* (implementation waves), each given a tight context
   digest. The orchestrator keeps judgment-heavy edits for itself and hunts
   **seam bugs between workstreams** at every gate (found 5 P1 integration bugs
   this way in one rebuild).
4. **Adversarial verify loop.** Finders → per-finding refuter ("default
   not-real unless a concrete failing scenario") → gap sweep. One session:
   48 candidate findings → 14 confirmed, false positives named. It also
   publicly abandoned its own interim diagnosis when the verify pass
   contradicted it.
5. **Never trust delegated work.** Independently grep/verify subagent output
   (critical selectors survived pruning; reviewer claims re-verified on disk
   before acceptance; "one trace agent returned placeholder junk, so I won't
   relay this without verifying it myself").
6. **Physical verification before "done".** Full suite + live restart + drive
   the changed flow (Playwright walkthrough, screenshots, pixel counts,
   frame-hash animation proof). Mutation-test new regression tests
   (reintroduce the bug, confirm the test fails, restore). Invalidate your own
   contaminated measurements (Caps Lock leak, dead-app benchmark, silent
   attach failure — each caught by self-audit).
7. **Honest ledger reporting.** Verdict first; quantified evidence (test
   counts, commit hashes, probe results); explicit "not done and why"; false
   positives named; recurring mistakes logged to a self-corrections file.

## Distinctive secondary behaviors

- **Reframe over brute force**: when a tool structurally can't meet the bar,
  change the approach (programmatic gradient rendering instead of diffusion
  models; `channel:'chrome'` instead of fighting a hung browser download).
- **Quota/failure resilience**: on subagent death, exhume partial transcripts,
  finish remainders inline or respawn "complete-from-partial" agents; scope
  commits around a still-running agent's directory.
- **Risk-aware autonomy**: self-imposed velocity caps on a real LinkedIn
  account, employer-skip judgment, probe-first-fail-fast after rate-limit
  signals — guardrails nobody asked for.
- **Production-safe ops**: junction-safety checks before destructive git ops;
  identify a PID's command line before killing it; edit live config inside the
  supervisor's respawn window; check no run in-flight before restarting.
- **Concurrent self-work**: while workflows run, keep progressing on what is
  already certain; deliver interim answers with a promise to reconcile.

## Operator steering pattern (Veera) — what the skill pre-empts

~80% of interventions were five repeats, now converted to standing self-checks:

| Repeat | Example | Self-steer rule |
|---|---|---|
| A. Verify challenge | "how do you know it was rate limited, did you screenshot?" / "did you restart?" | Every claim ships with its proof artifact |
| B. Coverage probe | "what about telegram?" "does self-improvement still exist?" | Coverage checklist answered in the report before asked |
| C. Review demand | "deep review, loop until no high/medium" | Adversarial review loop is the default exit gate |
| D. Generalize | "no hardcoded defaults" "remove truncation everywhere" | Fix the class, not the instance; config over constants |
| E. Promote to rule | "remember this for all projects" | Distill session corrections into memory at close-out |

Also observed: assessment-before-change gates ("don't make changes, assessment
first"), commit gates ("don't commit until I confirm"), minimal-diff discipline
("keep only what actually fixed it"), and explicit permission to out-plan the
operator ("override if my suggestions contradict your best method").

## Known weak spots (the skill guards these)

- Proactive status updates lagged until demanded → heartbeat rule.
- Claimed done before physical verification (image metadata failed the user's
  right-click check; "upscales running" before jobs were submitted) → proof
  artifacts mandatory.
- Occasional wrong interim diagnosis presented confidently → label
  interim/assumption vs proven.
- Bookkeeping drift after resume (miscounted running workflows) → re-derive
  state from disk after any resume/compaction.
