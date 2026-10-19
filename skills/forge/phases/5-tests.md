# Phase ⑤ — Test suite

**Always runs.** Forge's definition of done is executable (SKILL.md `<definition_of_done>`): this phase
turns the tests written during the build into a complete, trustworthy suite.

**Goal:** A deterministic suite, run by one command, that proves every SPEC success criterion, covers the
real integration seams and the golden path end to end, and guards the risky logic. Record it in
`.forge/TESTING.md`.

**Inputs:** `.forge/SPEC.md` (success criteria AC-n, edge-case policy, testing & CI decisions),
`.forge/TESTING.md` (the test plan), `.forge/PROGRESS.md` (what was built, deviations),
`.forge/RESEARCH.md` (gotchas, test tooling).

> Most tests should already exist — the build wrote them step by step. This phase fills the gaps, adds
> the layers a step-by-step build misses, and makes the suite trustworthy. Size it to the SPEC
> (`<loop_guards>`): thorough where the risk is real, not coverage for its own sake.

---

## Steps

> If the `engineering:testing-strategy` skill is installed, consult it to shape coverage and test types.

1. **Audit what exists.** Map the current tests against the acceptance matrix in TESTING.md and list the
   gaps. Don't rewrite tests that already do their job.
2. **Fill the layers** (scaled to the form factor):
   - **Acceptance** — at least one automated test per success criterion, named after it (e.g.
     `AC-3: rejects a duplicate email`), asserting the observable behaviour the SPEC promises through the
     public interface (HTTP, CLI, UI, public API) — not internals.
   - **Integration** — each real seam: the database (a real local, containerised or in-memory instance),
     file I/O, the HTTP layer, and external services through the mock, fake or sandbox chosen in the
     SPEC's build readiness.
   - **End-to-end golden path** — the main user journey through the real running app: browser
     automation (e.g. Playwright) for web UIs, real HTTP calls for APIs, the built binary for CLIs.
   - **Unit + edge cases where the risk is real** — parsing, validation, money/time maths,
     auth/permissions, state transitions, research gotchas, anything the build flagged. Assert the
     SPEC's *agreed* edge-case behaviour, not a guess.
   - Don't chase a coverage percentage, and don't write two tests that assert the same behaviour.
3. **Make it trustworthy:**
   - **One command** runs everything (`npm test`, `make test`, `pytest`, …).
   - **Deterministic** — no real network, no unseeded randomness or wall-clock dependence, isolated test
     data, no order dependence. Run the full suite **twice**; any test whose result differs is flaky —
     fix it now.
   - **Fast enough to run often** — keep the slow end-to-end tests few and focused.
   - **Coverage as a map, not a target** — if the stack has a coverage tool, run it once and look for
     uncovered *risky* code. Add tests there; ignore the rest.
4. **Write and run** in batches (one feature area at a time, run together). If a test reveals a real bug,
   fix the code and log it in PROGRESS.md. Fix the test only if it asserts something the SPEC doesn't
   require — never delete, skip, or loosen an assertion just to get green. Each failure gets the
   **3-attempt cap** (SKILL.md `<loop_guards>`). Once the gaps are closed and the suite is green, stop.
5. **CI (if chosen in the SPEC):** add a workflow (e.g. `.github/workflows/ci.yml`) that installs, then
   runs lint, typecheck and the full suite on every push and pull request, pinned to the runtime
   versions from RESEARCH. The final sweep confirms it runs green.
6. **Record** in TESTING.md: the acceptance matrix (every criterion → test → passing), layers and tools,
   the one command, CI, and the two-run result.

Update FORGE.md (check ⑤). → Proceed to `phases/6-security.md`.

**Exit criteria:** every success criterion has a passing acceptance test (or a recorded reason it's
verified by observation instead, e.g. a purely visual judgement); integration tests and an end-to-end
golden path in place; the full suite green twice in a row via one command; CI added if chosen;
TESTING.md updated.
