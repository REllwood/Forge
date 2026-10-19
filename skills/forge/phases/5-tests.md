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
2. **Derive the test list — coverage that maps to intent, not vanity coverage.** Size it to the SPEC:
   - At least one test for **each SPEC success criterion** (these are the acceptance tests).
   - A happy-path test for each feature **not already covered** by an acceptance test.
   - **Edge cases where the risk is real**: boundaries, empty/missing input, and error paths in logic
     that can genuinely break (parsing, money/time maths, auth, state transitions), the gotchas flagged
     in research, and anything the build phase logged as tricky or deviated on. Not every function needs
     its own edge-case suite.
   - For the kind(s) of tests the user asked for (unit / integration / e2e).
   - Don't chase a coverage percentage, and don't write two tests that assert the same behaviour.
3. **Write and run** in batches (one feature area at a time, run together) rather than one test per
   cycle. If a test reveals a real bug, fix the code (not the test) and log it in PROGRESS.md; if the
   test itself is wrong (it asserts something the SPEC doesn't require), fix the test. Each failure gets
   the same **3-attempt cap** as a build step (SKILL.md `<loop_guards>`). Once the list is green, stop —
   don't keep adding tests beyond it.
4. **Record coverage of criteria** — note which SPEC success criteria are now covered by which tests in
   PROGRESS.md, so the final sweep can confirm nothing is unverified.

Update FORGE.md (check ⑤). → Proceed to `phases/6-security.md`.

**Exit criteria:** test framework in place; tests for every success criterion + key edge cases written
and passing; criterion→test mapping recorded.
