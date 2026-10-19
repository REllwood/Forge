# Phase ⑧ — Final sweep

**Goal:** The last, meticulous check for bugs and logical errors — the kind that pass typechecks and
slip past per-step verification. Run the whole thing, ship clean documentation, prove it works from a
clean checkout, confirm the **definition of done** (SKILL.md `<definition_of_done>`), and deliver the
final summary.

**Inputs:** everything — the full codebase, `.forge/SPEC.md`, `PLAN.md`, `PROGRESS.md`, `TESTING.md`,
`SECURITY.md`.

> This is the safety net. Assume there's at least one bug you haven't found yet, and go looking for it.
> This phase runs the automated adversarial **hardening loop** (SKILL.md `<hardening>`) at the chosen
> level — hunt → fix → re-review until clean — with no user check-ins.

---

## 1. Adversarial bug & logic hunt (round 1 of the loop; delegate)

Hunt for correctness problems with fresh eyes — prefer the `/code-review` skill if installed, otherwise
spawn the `forge-reviewer` agent (not the context that wrote the code). In `economy` mode, do this hunt
inline (skip the spawn) but stay adversarial — the sweep still happens. Hand it the file list and
`SPEC.md`. These are the hardening **lenses** — one reviewer covers all of them in a single pass per
round, scaled by level (SKILL.md `<hardening>`):
- **Logical errors:** wrong conditions, inverted booleans, off-by-one, incorrect operator/precedence,
  wrong default, mishandled units/timezones, incorrect state transitions.
- **Edge cases:** null/undefined/empty, zero/negative, very large input, concurrent access/races,
  partial failures, retries/timeouts, pagination boundaries.
- **Error handling at boundaries:** unhandled promise rejections, swallowed errors, missing try/catch on
  I/O, resource leaks (unclosed handles/connections), unbounded growth.
- **SPEC-vs-implementation mismatches:** is every success criterion actually met? any in-scope feature
  missing or behaving differently than specced?
- **Loose ends:** leftover TODOs, stubs, dead/duplicate code, commented-out blocks, debug logging, hard-
  coded values that should be config.
- **Consistency:** error/response shapes, naming, patterns across the codebase.

## 2. Run it for real

Prefer the `/verify` · `/run` skills if installed, or the `forge-verifier` agent, to drive this:
- Run the full **test suite** with its one command — all green, and green again on a second run (no
  flakes).
- **Run the app** and exercise the **golden path** end-to-end, plus the key edge cases, against the SPEC
  success criteria. For UI, drive it in a browser (or delegate to a subagent with browser tools) and
  confirm real behavior — don't infer from code.
- **For UI:** verify the built UI against the **UI Acceptance Checklist** (`references/standards.md`) and
  the agreed `.forge/UI-DESIGN.md`, applying the `forge-ui-artist` (visual craft) and
  `forge-frontend-engineer` (implementation) lenses. **Actually test it** — resize the browser to mobile
  (~375px) / tablet (~768px) / desktop (~1280px+) and exercise every state (loading/empty/error/success);
  check keyboard nav, visible focus, and contrast. Each failed checklist item is an in-scope hardening
  finding — **fix → re-check only the failed items until the UI passes** (or the round cap, then record
  as a known limitation).
  Use `design:design-critique` / `design:accessibility-review` if available.
- Re-run typecheck/lint clean.

## 3. Triage & remediate — the automated hardening loop

Write `.forge/REVIEW.md` (template below) with severity-classified findings, then run the **hardening
loop** (SKILL.md `<hardening>`), automated, until it converges:
- **Fix** Critical/High (plus Medium at `comprehensive`) at the root cause, each with a regression test
  that fails before the fix and passes after; log each in PROGRESS.md.
- **Re-review + re-run** — re-hunt only the changed code (plus its direct callers) against the lenses
  in §1 and re-run the affected tests + golden-path checks to confirm the finding is resolved and nothing
  new broke.
- **Repeat** the hunt → fix → re-review cycle until a re-review yields no new in-scope findings, or the
  level's round cap is hit, then close with one full test + golden-path run. Record anything still open
  as a known limitation in REVIEW.md.

Stay pragmatic — severity-gated, no speculative issues, no looping past convergence; **don't stop to ask**.

## 4. Ship documentation

Generate or refresh the polished, user-facing docs (distinct from the `.forge/` process trail):
- A clear **README** (what it is, setup, run, usage, config/env, the commands that matter).
- Brief **architecture notes** if the system is non-trivial (components + data flow, derived from SPEC).
- Update inline docs only where the "why" is non-obvious — don't over-comment.
Default location: repo root `README.md` + `docs/` for architecture (follow the repo's existing layout if
it has one).

## 5. Clean-room run & definition of done

**Commit first.** If version control is in use, commit the completed state (code, tests, docs) now — the
clean-room run clones that commit, so it must include everything from §1–§4.

**Clean-room run** — prove it works beyond your own environment, and that the README is right. Clone the
repo (or, without git, copy the tree minus ignored and build files) into a fresh temporary directory and
follow the README's setup steps **literally**, using nothing from your environment beyond its documented
prerequisites: install, add config from `.env.example`, run the full suite, start the app, and walk the
golden path. Every step that fails, or that you had to know without the README telling you, is a finding —
usually a missing dependency, an undocumented env var, or a README gap. Fix it and re-run only the failed
steps. Hand this to the `forge-verifier` agent in `balanced`.

**CI** — if a workflow was added and pushes are authorised, commit any clean-room fixes, push, and
confirm the CI run on that final commit goes green (e.g. `gh run watch`). If you can't read CI status from
here, say so rather than assuming it passed.

**Definition of done** — walk SKILL.md `<definition_of_done>` item by item and record the result in
REVIEW.md. Anything not met is fixed now (within `<loop_guards>`) or listed as a known limitation with
its reason — never silently dropped.

## 6. Final summary & close out

If version control / GitHub was set up, make sure the **final commit** holds everything (including any
fixes from §5) and push it per the authorized cadence. Then mark FORGE.md Status → `done`, check ⑧.
Present the user a concise wrap-up:
- **What was built** (against the original idea), and **how to run it** (the commands that matter).
- **How it was verified** — test counts by layer, acceptance criteria covered, adversarial attacks run
  and what broke, security findings fixed, clean-room result, CI (point to the artifacts).
- **Definition of done** — each item met, or the limitation and why.
- **Known limitations / deferred items** (assumptions, Medium/Low findings left, non-goals).
- **Suggested next steps.**

```markdown
# REVIEW — {title}  (final sweep)

## Verdict
{is it correct and complete against SPEC? 2–3 sentences}

## Ran
- Tests: {n passing by layer; second run identical?}
- App / golden path: {what was exercised → outcome}
- Edge cases checked: {list → outcome}
- Clean-room run: {steps followed → outcome; README fixes made}
- CI: {green | not set up | couldn't check}

## Findings
### [Critical|High|Medium|Low] {title}
- **Where:** {file:line}
- **Problem:** {bug / logic error / mismatch}
- **Fix:** {what was done, or recommendation}
- **Regression test:** {file::test name}
- **Status:** fixed | deferred (known limitation)

## SPEC success criteria
- [x] {criterion} — verified by {test/observation}
- [ ] {criterion} — NOT met: {why} {only if something is genuinely incomplete}

## Definition of done
- [x] {each <definition_of_done> item} — {evidence}
```

**Exit criteria:** REVIEW.md written; the hardening loop converged (no new in-scope findings) or hit its
round cap; the suite passes twice and the golden path works; the clean-room run succeeds; every SPEC
success criterion confirmed met by a passing test (or explicitly flagged); Critical/High fixed with
regression tests; docs shipped; the definition of done recorded; FORGE.md → done; final summary
delivered.
