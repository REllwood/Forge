# Phase ⑤ — Tests (optional)

**Run only if the user chose tests in the plan.** Otherwise skip straight to `phases/6-security.md`.

**Goal:** Lock in correctness with automated tests derived from what we promised (SPEC success criteria)
and what we learned could break (edge cases from research and build).

**Inputs:** `.forge/SPEC.md` (success criteria), `.forge/PROGRESS.md` (what was built, deviations),
`.forge/RESEARCH.md` (gotchas), the tests decision recorded in the plan.

---

## Steps

> If the `engineering:testing-strategy` skill is installed, consult it to shape coverage and test types.

1. **Set up the framework** matching the stack (the one identified in research; follow repo conventions
   if tests already exist). Add the test script/runner and any CI-friendly config.
2. **Derive the test list — coverage that maps to intent, not vanity coverage:**
   - One or more tests for **each SPEC success criterion** (these are the acceptance tests).
   - Tests for each feature's core behavior (happy path).
   - **Edge cases**: boundaries, empty/missing input, error paths, the gotchas flagged in research, and
     anything the build phase logged as tricky or deviated on.
   - For the kind(s) of tests the user asked for (unit / integration / e2e).
3. **Write and run.** Make them pass. If a test reveals a real bug, fix the code (not the test) and log
   it in PROGRESS.md. Iterate until green.
4. **Record coverage of criteria** — note which SPEC success criteria are now covered by which tests in
   PROGRESS.md, so the final sweep can confirm nothing is unverified.

Update FORGE.md (check ⑤). → Proceed to `phases/6-security.md`.

**Exit criteria:** test framework in place; tests for every success criterion + key edge cases written
and passing; criterion→test mapping recorded.
