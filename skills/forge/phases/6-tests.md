# Phase ⑥ — Tests (consolidation)

**Per-feature tests already exist** — the staff engineer wrote them with each slice and the panel's
verifier added adversarial cases. This phase **consolidates**: it fills cross-feature gaps, adds
integration/e2e coverage across the seams, and audits coverage against every SPEC success criterion. (If
the user declined automated tests in the plan, do only the coverage audit, then `phases/7-security.md`.)

**Goal:** Lock in correctness across the whole system — not vanity coverage, but coverage that maps to
intent (SPEC success criteria) and to what could break (edge cases from research, build, and the panels).

**Inputs:** `.forge/SPEC.md` (success criteria), `.forge/PROGRESS.md` (slices, deviations, per-slice
tests), `.forge/RESEARCH.md` (gotchas), `.forge/ARCHITECTURE.md` (the seams worth integration-testing),
the tests decision recorded in the plan.

---

## Steps

> If the `engineering:testing-strategy` skill is installed, consult it to shape coverage and test types.

1. **Confirm the framework & harness** are in place from the build loop (the stack's runner, CI-friendly
   config). Add anything missing.
2. **Audit coverage against intent — find the gaps:**
   - One or more **acceptance tests per SPEC success criterion** — confirm each is covered by *some* test;
     add the missing ones.
   - **Integration / e2e tests across the seams** in `ARCHITECTURE.md` — the interactions between slices
     that per-slice tests don't exercise.
   - **Adversarial / negative coverage** — boundaries, empty/missing input, error paths, the gotchas
     flagged in research, and anything a build panel logged as tricky. Not just the happy path.
3. **Write and run.** Make them pass. If a test reveals a real bug, fix the **code** (not the test) and
   log it in PROGRESS.md. Iterate until green.
4. **Record the criterion → test map** in PROGRESS.md, so the final sweep can confirm nothing is unverified.

Update FORGE.md (check ⑥). → Proceed to `phases/7-security.md`.

**Exit criteria:** framework in place; every success criterion covered by an acceptance test;
integration/e2e + adversarial gaps filled; suite green; criterion→test mapping recorded.
