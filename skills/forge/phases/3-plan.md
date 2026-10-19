# Phase ③ — Plan

**Goal:** Produce `PLAN.md` — a sequence of right-sized, individually-verifiable steps, grouped into
phases that each end in a checkpoint. This is the contract the build phase executes. Get explicit user
approval before building (the plan-mode gate).

**Inputs:** `.forge/SPEC.md`, `.forge/RESEARCH.md`.

> Core principle in play: **Right-sized steps, deep detail.** Each step is a coherent increment —
> roughly one focused commit — completable AND verifiable on its own. Split a step only when it mixes
> unrelated concerns; merge steps that are too small to be worth their own verify/log/commit cycle. Stay
> within the depth's step budget (SKILL.md `<loop_guards>`).

---

## 1. Decompose into phases → steps

Group work into ordered **phases** (e.g. Scaffold, Data layer, Core feature A, Core feature B,
Integration, Polish). Within each phase, write **atomic steps**. Order strictly by dependency.

**Front-load a walking skeleton:** the earliest steps should produce a minimal end-to-end thing that
runs (even if it does almost nothing), so every later step builds on something verified-working. Put the
**test harness** in it — the runner configured and one passing end-to-end smoke test — so every later
step can add its tests from the start.

**Architect it early (`references/standards.md`).** Sequence steps so the sound, right-sized structure is
in place before features pile on: scaffold the layers / separation of concerns first, and for a UI set up
design tokens and base components before the screens that use them. Don't defer architecture to "later."
**When `.forge/UI-DESIGN.md` exists** (the build has a UI), sequence the UI steps from it — design tokens +
base components first, then each screen with its states — implementing the panel's agreed design, not an
ad-hoc look.

Granularity test for each step: *Would a competent engineer make this as one focused commit and prove it
works with one meaningful check?* If it mixes unrelated concerns, split it. If it's trivial on its own,
merge it:
- **Fold setup into the step that needs it** — adding a dependency, an import, a config value, a type,
  a constant, or a file rename is never a step by itself.
- **One behaviour, one step** — a step that needs a couple of assertions about the *same* behaviour is
  fine; don't split it just to get one check per step.
- **Don't plan the obvious** — no steps for "create the folder", "add the file", or "re-run the build".

**Fit the step budget.** Count the steps against the depth's range — quick ~4–10 · standard ~8–20 ·
deep ~15–35 (SKILL.md `<loop_guards>`). Over budget? Merge adjacent steps that touch the same module or
feature until it fits. If the SPEC genuinely needs more, keep them but give a one-line reason at the
approval gate. More depth means richer instructions and checks per step, not more steps.

## 2. Write each step with full detail

Every step gets: a Goal, the Files it touches, precise Do-instructions, an explicit **Verify** check
(the exact thing that proves it works — a command to run, output to see, behavior to observe), and
Depends-on. The Verify line is mandatory — it's what the build phase will run.

Keep each Verify **targeted and fast** — the one command, request, or observation that proves *this*
step works — not "run everything". Each plan phase then ends with a **Checkpoint**: the full typecheck /
lint / test suite, a regression check of what already worked, and (for UI) the UI Acceptance Checklist
for any screen the phase completed. That's where the heavy verification lives.

Prefer a Verify that *is* an automated test the step adds — it then guards against regressions at every
checkpoint for free. The step whose work completes a success criterion also writes that criterion's
acceptance test.

## 3. Write the test plan → TESTING.md

Tests are always on; the layers were settled in SPEC's *Testing & CI*. Create `.forge/TESTING.md`
(template below):
- **Acceptance matrix** — every success criterion (AC-n) → the acceptance test that will prove it → the
  step that writes it. A criterion with no planned test is a gap in the plan; fix it now.
- **Strategy** — the layers and tools (from RESEARCH) and the one command that will run everything.
- **Draft adversarial charter** — which attack categories apply to this build (hostile & boundary input,
  abuse cases, property-based fuzzing, failure injection, concurrency & state, UI abuse, scale smoke,
  mutation check) and their likely targets, so ⑦ starts with a target list.

The closing phases are always the same — list them in the plan: Test suite (⑤), Security (⑥),
Adversarial testing (⑦), Final sweep (⑧).

## 4. Present for approval — DO NOT build yet

Write `.forge/PLAN.md`, then present a concise outline to the user (phases, step count against the
depth's budget, the headline steps, and the acceptance matrix in brief) — **and, if `.forge/UI-DESIGN.md`
exists, the UI direction with it**: the design summary, any `.forge/ui-mockups/`, and any flagged
departures from the user's stated preference, for sign-off here.
Ask via `AskUserQuestion`: **Approve / Revise (tell me what) / Change depth.** Iterate on the plan (and
the UI direction) until approved. Building before approval violates the pipeline.

**This is the last routine stop.** It's a deliberate go/no-go because building on a wrong plan wastes the
most work. After approval, forge runs **autonomously to done** (build → test suite → security →
adversarial testing → final sweep), stopping only for a genuine clarity need (see SKILL.md `<autonomy>`).
If the run mode in FORGE.md is **unattended**, present the plan for visibility and proceed without
waiting — the user already chose a one-shot run. Build the user's stated UI preference, not any flagged
departure (those wait for the final summary).

On approval, update FORGE.md: check ③, Status → `build`, refresh Current position. → `phases/4-build.md`.

```markdown
# PLAN — {title}

**Phases:** ① {name} · ② {name} · … · Test suite · Security · Adversarial testing · Final sweep
**Steps:** {n} (budget for {depth}: {range})
**Verification:** targeted check per step; full suite + regression check at each phase checkpoint.

---

## Phase A — {name}
> {one line: what this phase delivers}

### A.1 — {step title}
- **Goal:** {what done looks like}
- **Files:** {paths to create/edit}
- **Do:** {precise, concrete instructions — enough that execution is mechanical}
- **Verify:** {exact check — ideally the automated test this step adds; command + expected result}
- **Depends on:** {prior step ids, or —}
- [ ] done

### A.2 — {step title}
- **Goal:** …
- **Files:** …
- **Do:** …
- **Verify:** …
- **Depends on:** A.1
- [ ] done

### A.✓ — Checkpoint
- **Verify:** {full typecheck / lint / tests + regression check of earlier phases; UI checklist for screens this phase completed}
- [ ] passed

## Phase B — {name}
…

## Phase T — Test suite
{placeholder — executed per phases/5-tests.md; acceptance matrix in TESTING.md}

## Phase S — Security
{placeholder — executed per phases/6-security.md}

## Phase X — Adversarial testing
{placeholder — executed per phases/7-adversarial.md; draft charter in TESTING.md}

## Phase F — Final sweep
{placeholder — executed per phases/8-final-sweep.md}
```

```markdown
# TESTING — {title}

## Strategy
- Layers: {unit · integration · e2e ({tool}) · property-based ({library})}
- Run everything: `{one command}`
- CI: {workflow path | none}

## Acceptance matrix
| Criterion | Test | Written in step | Status |
|-----------|------|-----------------|--------|
| AC-1 {short} | {file::test name} | {A.3} | planned / passing |

## Adversarial charter        ← drafted here, finalised and run in ⑦
| Category | Targets | Attacks | Result |
|----------|---------|---------|--------|

## Mutation check             ← filled in at ⑦
- {file:line — the change} → caught by {test} | survived → {test added}

## Runs
- {YYYY-MM-DD}: {n} tests · {pass/fail} · second run identical {yes/no}
```

**Exit criteria:** PLAN.md written with right-sized, individually-verifiable steps within the step
budget and a checkpoint per phase; TESTING.md written (acceptance matrix covering every criterion,
strategy, draft charter); user approved (or the plan presented, in unattended mode); FORGE.md updated. →
Proceed to `phases/4-build.md`.
