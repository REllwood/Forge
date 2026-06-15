# Phase ⑦ — Final sweep

**Goal:** The last, meticulous check for bugs and logical errors — the kind that pass typechecks and
slip past per-step verification. Run the whole thing. Then ship clean documentation and a final summary.

**Inputs:** everything — the full codebase, `.forge/SPEC.md`, `PLAN.md`, `PROGRESS.md`, `SECURITY.md`.

> This is the safety net. Assume there's at least one bug you haven't found yet, and go looking for it.
> This phase runs the automated adversarial **hardening loop** (SKILL.md `<hardening>`) at the chosen
> level — hunt → fix → re-review until clean — with no user check-ins.

---

## 1. Adversarial bug & logic hunt (round 1 of the loop; delegate)

Hunt for correctness problems with fresh eyes — prefer the `/code-review` skill if installed, otherwise
spawn the `forge-reviewer` agent (not the context that wrote the code). In `economy` mode, do this hunt
inline (skip the spawn) but stay adversarial — the sweep still happens. Hand it the file list and
`SPEC.md`. These are the hardening **lenses** (run them scaled by level — see SKILL.md `<hardening>`):
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
- Run the full **test suite** (if tests exist) — all green.
- **Run the app** and exercise the **golden path** end-to-end, plus the key edge cases, against the SPEC
  success criteria. For UI, drive it in a browser (or delegate to a subagent with browser tools) and
  confirm real behavior — don't infer from code.
- **For UI:** verify the built UI against the **UI Acceptance Checklist** (`references/standards.md`) and
  the agreed `.forge/UI-DESIGN.md`, applying the `forge-ui-artist` (visual craft) and
  `forge-frontend-engineer` (implementation) lenses. **Actually test it** — resize the browser to mobile
  (~375px) / tablet (~768px) / desktop (~1280px+) and exercise every state (loading/empty/error/success);
  check keyboard nav, visible focus, and contrast. Each failed checklist item is an in-scope hardening
  finding — **fix → re-check until the UI passes** (or the round cap, then record as a known limitation).
  Use `design:design-critique` / `design:accessibility-review` if available.
- Re-run typecheck/lint clean.

## 3. Triage & remediate — the automated hardening loop

Write `.forge/REVIEW.md` (template below) with severity-classified findings, then run the **hardening
loop** (SKILL.md `<hardening>`), automated, until it converges:
- **Fix** Critical/High (plus Medium at `comprehensive`) at the root cause; log each in PROGRESS.md.
- **Re-review + re-run** — re-hunt the changed code (the lenses in §1) and re-run the tests + golden-path
  checks to confirm the finding is resolved and nothing new broke.
- **Repeat** the hunt → fix → re-review cycle until a full pass yields no new in-scope findings, or the
  level's round cap is hit. Record anything still open as a known limitation in REVIEW.md.

Stay pragmatic — severity-gated, no speculative issues, no looping past convergence; **don't stop to ask**.

## 4. Ship documentation

Generate or refresh the polished, user-facing docs (distinct from the `.forge/` process trail):
- A clear **README** (what it is, setup, run, usage, config/env, the commands that matter).
- Brief **architecture notes** if the system is non-trivial (components + data flow, derived from SPEC).
- Update inline docs only where the "why" is non-obvious — don't over-comment.
Confirm location with the user if unsure (default: repo root `README.md` + `docs/` for architecture).

## 5. Final summary & close out

If version control / GitHub was set up, make the **final commit and push** of the completed state (code +
docs) per the authorized cadence. Then mark FORGE.md Status → `done`, check ⑦. Present the user a concise
wrap-up:
- **What was built** (against the original idea).
- **How it was verified** (per-step, tests, security, final sweep — point to the artifacts).
- **Known limitations / deferred items** (assumptions, Medium/Low findings left, non-goals).
- **Suggested next steps.**

```markdown
# REVIEW — {title}  (final sweep)

## Verdict
{is it correct and complete against SPEC? 2–3 sentences}

## Ran
- Tests: {result}
- App / golden path: {what was exercised → outcome}
- Edge cases checked: {list → outcome}

## Findings
### [Critical|High|Medium|Low] {title}
- **Where:** {file:line}
- **Problem:** {bug / logic error / mismatch}
- **Fix:** {what was done, or recommendation}
- **Status:** fixed | deferred (known limitation)

## SPEC success criteria
- [x] {criterion} — verified by {test/observation}
- [ ] {criterion} — NOT met: {why} {only if something is genuinely incomplete}
```

**Exit criteria:** REVIEW.md written; the hardening loop converged (no new in-scope findings) or hit its
round cap; app + tests pass on golden path + key edge cases; every SPEC success criterion confirmed met
(or explicitly flagged); Critical/High fixed; docs shipped; FORGE.md → done; final summary delivered.
