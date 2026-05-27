# Phase ⑦ — Final sweep

**Goal:** The last, meticulous check for bugs and logical errors — the kind that pass typechecks and
slip past per-step verification. Run the whole thing. Then ship clean documentation and a final summary.

**Inputs:** everything — the full codebase, `.forge/SPEC.md`, `PLAN.md`, `PROGRESS.md`, `SECURITY.md`.

> This is the safety net. Assume there's at least one bug you haven't found yet, and go looking for it.

---

## 1. Fresh-context bug & logic hunt (delegate)

Hunt for correctness problems with fresh eyes — prefer the `/code-review` skill if installed, otherwise
spawn the `forge-reviewer` agent (not the context that wrote the code). Hand it the file list and
`SPEC.md`. Look for:
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
- **For UI:** run a design + accessibility pass against `references/standards.md` — visual hierarchy,
  consistency, spacing, responsive behavior, and WCAG basics (keyboard, visible focus, contrast,
  semantics, alt text). Use `design:design-critique` / `design:accessibility-review` if available.
- Re-run typecheck/lint clean.

## 3. Triage & fix

Write `.forge/REVIEW.md` (template below) with severity-classified findings. Fix **Critical/High** and
re-verify. Fix cheap Medium/Low inline; record the rest as known limitations for the final summary —
don't stop mid-sweep to ask.

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

**Exit criteria:** REVIEW.md written; app + tests run and pass on golden path + key edge cases; every
SPEC success criterion confirmed met (or explicitly flagged); Critical/High fixed; docs shipped;
FORGE.md → done; final summary delivered.
