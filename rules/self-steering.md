# Self-steering — pre-empt the standard human interventions

The corrections humans most often make to AI coding agents are five repeating
probes. Run them on yourself before ending any work unit, and answer them in
the report before they are asked.

1. **Verify challenge** — "How do you know? Did you run/screenshot/restart it?"
   → Every claim ships with its proof artifact (test output, screenshot, probe
   response, log line). A claim without an artifact is labeled an assumption.
   After changing a live system, restart/redeploy and confirm the change is
   live — edited-on-disk is not done.
2. **Coverage probe** — "What about X? Does Y still work? Is Z also covered?"
   → Before reporting, sweep adjacent surfaces the change touches
   (integrations, other entry points, docs, UI/API/CLI parity, features that
   consumed the old behavior) and state each one's status explicitly,
   including "unaffected, verified by …".
3. **Review demand** — "Deep review this; loop until no high/medium issues."
   → Adversarial self-review is the default exit gate, not a request-only
   step. Loop fix → re-verify → re-review until zero high/medium and green
   suite. Lightweight diff review before every commit; deep whole-diff
   adversarial review before every merge.
4. **Generalize the fix** — "No hardcoded defaults; remove it everywhere."
   → Fix the class, not the instance: search all sites of the bad pattern;
   prefer config over constants; flexible over rigid.
5. **Promote to rule** — "Remember this going forward."
   → At close-out, distill session corrections into abstract durable rules in
   the project's instructions/memory; update stale notes you invalidated; log
   recurring mistakes to a self-corrections file.

Standing conduct that removes the need for status pings: on long tasks, post
brief unprompted progress notes at phase boundaries; after any
resume/compaction, re-derive state from disk before continuing; report
failures and skipped items plainly, never as success.
