# Phase ⑦ — Adversarial testing

**Always runs.** Reviews read code; this phase **runs attacks**. The goal is to break the build with
executable tests before a user does — then fix what broke, and keep every attack as a permanent test.

**Inputs:** `.forge/SPEC.md` (success criteria, edge-case policy), `.forge/TESTING.md` (the suite, the
one command, the draft charter), `.forge/SECURITY.md` (threat model, findings), `.forge/RESEARCH.md`
(gotchas, test tooling), `.forge/PROGRESS.md` (what was tricky or deviated).

> Assume it breaks — then prove where, with a red test. An attack that holds becomes a regression test;
> an attack that breaks becomes a fix plus a regression test. This phase runs the automated **hardening
> loop** (SKILL.md `<hardening>`) with no user check-ins, bounded by `<loop_guards>`.

---

## 1. Write the charter

Finalise the draft charter in TESTING.md: pick the **categories** that apply to this build and, for each,
the concrete **targets** (entry points, modules, flows). Scale by hardening level:

| Category | What to attack | basic | standard | comprehensive |
|----------|----------------|:-----:|:--------:|:-------------:|
| **Hostile & boundary input** | every entry point: empty, huge, wrong type, malformed (JSON/CSV/dates), unicode/emoji/RTL, null bytes, negative/zero/max numbers, injection payloads (SQL, XSS, path traversal, command) | ✓ | ✓ | ✓ |
| **Abuse cases** | from the threat model: missing/expired/forged auth, another user's resource (IDOR), privilege escalation, mass assignment, replay, rate limits | ✓ | ✓ | ✓ |
| **Property-based fuzzing** | parsers, validators, serialisers, calculations — invariants such as round-trips, idempotence, never crashes, output within bounds | — | ✓ | ✓ |
| **Failure injection** | external API down / slow / erroring (via its mock), DB unavailable, disk or permission errors, a crash mid-operation — graceful handling, no corruption, bounded retries | — | ✓ | ✓ |
| **Concurrency & state** | parallel writes to one resource, double submit, out-of-order events, restart mid-flow — consistent state afterwards | — | ✓ | ✓ |
| **UI abuse** (if UI) | rapid repeat clicks, back/forward/refresh mid-flow, slow network, very long strings, keyboard-only, 200% zoom | — | ✓ | ✓ |
| **Scale smoke** | ~10× the SPEC's expected input or data volume — no blow-ups, no unbounded growth | — | — | ✓ |
| **Mutation check** | the suite itself: small deliberate bugs in critical logic — does a test catch each one? | 3 mutants | 5 mutants | 10, or a mutation tool on critical modules |

Skip categories that genuinely don't apply (no concurrency in a single-user CLI, no UI in an API) and say
so in the charter. Keep each category to a handful of focused attacks on the riskiest targets — this is
a targeted assault, not an exhaustive one.

## 2. Attack (round 1)

In `balanced`, spawn **one** `forge-adversary` agent with the charter, the target files, the run command,
the SPEC criteria + edge-case policy, and the threat model. In `economy`, do it inline — work in a
scratch copy of the repo (`git worktree add`, or a plain copy without git) so mutants never touch the
real tree.

Each attack is written as a test in the project's framework and run. Outcomes:
- **Held** — the build rejected or handled it as the SPEC says. Commit the test; it's now a regression
  guard.
- **Broke** — a crash, wrong result, data loss, leak, bypass, hang, or unbounded resource use. Commit the
  test (red) and triage it.
- **Mutant survived** — a test gap. Add the test that catches it.

## 3. Fix — the automated hardening loop

- **Triage** breaks by severity; in scope = Critical/High (plus Medium at `comprehensive`).
- **Fix** each in-scope break at the root cause until its attack test passes. **Never weaken the attack
  test** to get green — if the test misreads the SPEC, correct it to the SPEC's edge-case policy and
  note why.
- **Re-check** — re-run the attack tests for what changed, plus the affected suite; later rounds attack
  only the fix diff (`<loop_guards>` 6).
- **Repeat** until a round produces no new in-scope break, or the level's round cap is hit. Then run the
  full suite once (twice, if anything was flaky) to close the phase.
- Out-of-scope breaks (Medium/Low) are recorded, not chased.

## 4. Record in TESTING.md

Fill the **Adversarial charter** table (category · targets · attacks · result), the **Mutation check**
(mutant → caught by / survived → test added), and add a **Runs** line. Log fixes in PROGRESS.md.

Update FORGE.md (check ⑦). → Proceed to `phases/8-final-sweep.md`.

**Exit criteria:** charter written for the hardening level; every attack committed as a permanent test;
all in-scope breaks fixed with their attack tests green; surviving mutants closed with new tests; full
suite green; TESTING.md updated; anything still open recorded with severity and reason.
