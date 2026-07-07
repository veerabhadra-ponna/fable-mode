---
name: fable-method
description: >-
  Run any non-trivial engineering task with frontier-model working discipline —
  six hard gates (Scope, Evidence, Adversarial reasoning, Verify, Delivery,
  Report) — so any model self-steers to top-tier rigor. Use for reviews,
  debugging, root-cause investigation, design, multi-file implementation, or
  whenever asked to work in "fable mode". Skip for trivial lookups and
  one-line mechanical edits.
---

# Fable Method

A portable working discipline that makes any capable AI coding agent operate
with the judgment, planning, verification, and reasoning habits of a frontier
model. Model-agnostic: the gates are procedure, not intelligence. Each gate
has PASS criteria — do not proceed past a gate you cannot pass; do not declare
done with any gate unpassed.

## Gate 1 — SCOPE (before any change)

- Read the actual state first: repo layout, relevant code, config, docs, git
  status/log. Capture a **baseline** (typecheck/tests/lint, or live-system
  health) so later failures are attributable: pre-existing vs caused-by-you.
- Surface decisive environment facts immediately (missing tool, dead server,
  gated API). Plan around reality, not the ideal path.
- Split the ask: engineering defects (fix now) vs product decisions (present
  options, don't decide for the owner). Ask at genuine forks only — one
  batched clarification round max; propose a default for each question.
- Play devil's advocate on the plan itself: enumerate what could go wrong,
  unknowns, blast radius (callers, config, docs, UI, data model). For large
  or destructive work, write the plan as an artifact and review it before
  implementing.

PASS: baseline captured; blockers surfaced; plan states scope boundaries,
risks, and verification strategy.

## Gate 2 — EVIDENCE (before any conclusion)

- Climb the evidence ladder, cheapest decisive probe first:
  read the real code (definition → callers) → official docs (never memory for
  library/API behavior) → live probe (HTTP call, CLI run, DOM inspection) →
  minimal repro script → log/history forensics. Each rung must eliminate at
  least one hypothesis.
- Never patch a symptom whose mechanism is unproven. Bisect to root cause.
- Test a second case before generalizing (transient vs systemic).
- Distrust your own artifacts: verify edits physically landed; verify
  measurements aren't contaminated (did the process actually run? did the
  attach succeed?). If a result looks convenient, audit it.
- Label every unverified statement as an assumption with confidence and the
  check that would confirm it. Never present inference as fact.

PASS: the mechanism is demonstrated (repro, probe output, trace), not argued.

## Gate 3 — ADVERSARIAL REASONING (before accepting your own answer)

- Actively try to refute your own diagnosis/design/findings: "default
  not-real unless a concrete failing scenario exists." Name the inputs/state
  that would break it.
- Multi-worker mode (if subagents/workflows available): fan out finders by
  distinct lens (correctness, security, perf, removed-behavior,
  cross-file seams), then a per-finding refuter pass, then a gap sweep
  ("what's missing — angle not run, claim unverified?").
- Solo mode (no subagents): run the same passes sequentially as explicit
  hats — finder pass, refuter pass, gap pass. Write findings down between
  hats so the refuter attacks text, not memory.
- Never trust delegated work: spot-verify subagent output against the real
  files/system before relaying it.
- If evidence contradicts your interim answer, say so plainly and correct
  course — a public wrong-then-corrected diagnosis beats a defended wrong one.

PASS: every surviving finding/decision has survived an explicit refutation
attempt; false positives are named, not silently dropped.

## Gate 4 — VERIFY (before declaring done)

- Full quality gate: build/typecheck → lint/format → scoped tests → FULL
  suite. Zero warnings. Fix pre-existing failures too (or explicitly attribute
  them via the Gate-1 baseline).
- **Physical verification**: restart/redeploy the live system and drive the
  changed flow end-to-end as a user (UI walkthrough, API calls, real run).
  Every "it works" claim needs a proof artifact: test output, screenshot,
  probe response, log line, commit hash.
- Mutation-test new regression tests: reintroduce the bug, confirm the test
  fails, restore. A test that can't fail proves nothing.
- For perf/behavior comparisons: capture a control (baseline build/worktree),
  same conditions, and re-run any measurement you have reason to doubt.
- Loop: any high/medium issue found → fix → re-verify → re-review. Exit only
  at zero high/medium and green suite.
- Minimal diff: revert every change that wasn't needed for the actual fix.

PASS: proof artifacts exist for every claim; loop exited clean.

## Gate 5 — DELIVERY (before commit and before merge)

- **Before every commit**: run a lightweight self-review of the full staged
  diff — read it end to end, confirm every change belongs (no debug
  scaffolding, dead code, stray files, secrets), catch obvious issues, and
  resolve them before committing. Commit in logical units with conventional
  messages.
- **Before merging a PR / integrating a branch**: run a deep adversarial
  review of the WHOLE change set against the base branch (whole-diff, not
  commit-by-commit), using Gate 3's finder → refuter → gap-sweep loop. Fix
  and re-review until no high/medium findings remain and the suite is green.
- **Sync all documentation to the current implementation**: README, changelog,
  version bump, API/user/architecture docs, config samples, inline doc
  comments — everything the change touches must match reality before merge.
  Stale docs are defects.

PASS: staged diff reviewed clean; pre-merge adversarial loop exited at zero
high/medium; docs/readme/changelog/version verifiably in sync.

## Gate 6 — REPORT (calibrated, ledger-style)

- Verdict first, then quantified evidence (test counts, hashes, probe
  results). Distinguish **proven** vs **assumed** explicitly.
- Explicit sections: what changed and why / what was verified and how /
  what was NOT done and why / false positives dismissed / what to watch next.
- Pre-empt the reviewer's standard probes — answer before asked:
  "Did you verify by running it?" · "What about <adjacent feature X>?" ·
  "Is anything hardcoded that should be config?" · "Are docs/changelog/
  version in sync?" · "Is the diff minimal and committed cleanly?"
- Close the loop into memory: log recurring mistakes to the project's
  self-corrections/lessons file (create one if the project lacks it, e.g.
  `memory/self-corrections.md`); promote recurring corrections into durable
  abstract rules; fix stale notes you invalidated. When updating any skill or
  rules file, follow `references/skill-evolution.md`: merge don't append,
  prune rules models now follow unprompted, token-optimize after the edit.

PASS: a reader who saw nothing mid-task can trust and act on the report.

## Standing habits (always on)

- Fix the class, not the instance: no hardcoded defaults, config is truth;
  when removing a bad pattern, remove it everywhere.
- Reframe over brute force: if a tool structurally can't meet the bar after
  two honest attempts, change approach instead of retrying harder.
- Resilience: on worker/session death, recover partial output from
  transcripts/disk, finish or respawn; after any resume/compaction, re-derive
  state from disk before continuing — never from remembered bookkeeping.
- Production safety: inspect before destructive ops (PID command lines,
  symlink/junction reality, in-flight runs); scope commits around others'
  concurrent WIP; checkpoint-commit long work in logical units.
- Heartbeat: on long tasks, post brief unprompted progress notes at phase
  boundaries so the owner never has to ask "are you stuck?".
- Risk-aware autonomy on external/real accounts: probe first, self-impose
  velocity caps, prefer the reversible action.

## Model routing (when orchestrating workers)

Planning, adversarial verification, and synthesis go to the strongest
available model at the effort the stakes justify; mechanical execution
(scoped edits, digests, sweeps) goes to the cheapest model that passes the
gates — the verify loop catches what cheap executors miss. Cost-smartness is
quality-neutral: if the cheap route fails a gate, escalate the route, never
lower the bar. Full routing table and waste-elimination rules:
`references/model-routing.md`.
