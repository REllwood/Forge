# Phase ④ — Build

**Goal:** Implement the plan with momentum and **verify every single step before moving on**. Keep the
trail current. This phase is where forge's meticulousness about bugs is enforced.

**Inputs:** `.forge/PLAN.md` (the steps), `.forge/SPEC.md`, `.forge/RESEARCH.md`.

**Execution mode:** autonomous. Once the plan is approved, work straight through to the end of the
pipeline. Post brief progress notes at phase boundaries **without waiting for a reply**, and stop only
for a genuine clarity need (SKILL.md `<autonomy>`). Mirror the plan's steps into your in-session todo
tool so progress is visible, but `PROGRESS.md` is the durable record. **In `economy` mode** (SKILL.md
`<token_economy>`): keep narration minimal, do verification inline, batch cheap checks, and keep
PROGRESS.md terse — without ever skipping a step's verification.

> Core principle in play: **Verify or it didn't happen.** Never advance past a step whose verification
> hasn't passed. Never leave the codebase in a broken state between steps.

---

## The per-step loop (repeat for every step, in order)

1. **Announce** the step in one line: id, goal, and its Verify check (so intent is explicit).
2. **Implement** precisely — the smallest change that satisfies the step's Do-instructions. Follow the
   codebase's existing conventions (from RESEARCH), the bars in `references/standards.md`, and — for UI
   work — the agreed `.forge/UI-DESIGN.md` (sound architecture; accessible, well-designed UI), sized to
   the SPEC. No speculative extras, no stubs left behind, no half-finished work. **Write the step's tests
   as part of the step** — unit tests for the logic it adds, and the acceptance test if it completes a
   success criterion (per TESTING.md's matrix). Keep them focused; ⑤ fills in the remaining layers.
3. **Verify (mandatory, targeted).** Run the step's Verify check (ideally the tests it just added) and
   **functionally exercise the path this step created** — actually run it and observe the expected
   behaviour, don't just assume. Add a compile/typecheck of the touched code when it's cheap
   (incremental build, single-file check). The full suite and regression check wait for the phase
   checkpoint (below).
   - **UI steps:** load it in the browser and confirm the new piece renders and works. The full UI
     Acceptance Checklist waits for the checkpoint, not every step. If you genuinely cannot drive a
     browser, say so explicitly rather than claiming the UI works.
   - Verify steps **inline** — don't spawn an agent for a single step.
4. **On failure:** fix it now. Diagnose root cause; don't paper over it. Take at most **3 attempts**,
   each testing a *different* hypothesis (a scientific-method pass, or the `engineering:debug` skill if
   installed). If the same error returns after a fix, the hypothesis was wrong — change approach, don't
   repeat it. After 3 attempts, restore the last good state and **checkpoint with the user** with what
   you tried (don't proceed on a broken state, and don't keep looping). Never delete, skip or loosen a
   test to get green.
5. **Record:** check the step's box in `PLAN.md` and append a short entry to `.forge/PROGRESS.md`
   (template below) — what you did, files touched, the verify result, and any deviation. When a step's
   acceptance test passes, mark that criterion's row in TESTING.md. The PLAN.md
   checkboxes are the mid-phase resume pointer; FORGE.md only needs updating at checkpoints.
6. **Deviation handling:** if reality differs from the plan (a step is wrong, missing, or a better path
   appears), adapt — and **log the deviation and rationale** in PROGRESS.md. If scope shifts materially,
   update PLAN.md and flag it at the next checkpoint. **Don't re-plan mid-build:** if a step turns out
   too big, split it **once** into at most 3 steps, log it, and carry on — never split a split or write a
   sub-plan for one step.

## Phase checkpoints — the heavy verification lives here

When the last step of a plan phase is done, run its **Checkpoint** before starting the next phase:
- Full compile / typecheck, lint / format, and the test suite (if any) — all clean.
- **No regressions** — re-exercise what earlier phases delivered (the golden path so far).
- **UI screens this phase completed:** verify them against the **UI Acceptance Checklist** in
  `references/standards.md` — actually resize to mobile (~375px) / tablet (~768px) / desktop
  (~1280px+), exercise each state (loading/empty/error/success), and check keyboard nav, visible focus,
  and contrast. Use available preview/browser tools, or delegate the visual check to a subagent that has
  them.
- **Delegation:** for substantial phases or UI, hand the checkpoint to the `forge-verifier` agent (or
  the `/verify` · `/run` skills if installed) with the specific files and criteria to check.

Fix a checkpoint failure like any other (same attempt cap), then re-run **only the checks that failed**
plus anything the fix touched. Update FORGE.md's Current position, then post the phase-boundary note.

## Keep moving — stop only for clarity

Forge is agentic: drive through the steps and phases on your own. At each **phase** boundary, post a
short, **non-blocking** note (what's done, verified state, what's next) and continue — do not wait for
permission to proceed. Stop and ask only when you hit one of the genuine clarity needs in SKILL.md
`<autonomy>`: real ambiguity SPEC/RESEARCH don't settle, a true blocker, a risky/irreversible action, or
a material scope/cost change. For everything else — equivalent implementation choices, small fixes, a
failed verify you can diagnose — **decide, act, and log it.** Fix a failed step yourself, within
the attempt cap, before escalating. PLAN.md checkboxes plus FORGE.md's Current position (refreshed at
each checkpoint) let a context reset resume mid-phase.

## Version control & GitHub

Honor the VCS decision recorded in SPEC:
- **First build step:** if Git/GitHub was chosen and no repo exists yet — `git init`, add a stack-
  appropriate `.gitignore` (ignore `.forge/` unless the user opted to track it, plus secrets and build
  artifacts), and make an initial scaffold commit. If GitHub was chosen, create the remote:
  `gh repo create <name> --private|--public --source=. --remote=origin --push` (visibility from SPEC).
- **Commits:** atomic — one per step (or per phase, per the chosen cadence), with clear messages.
  **Never commit secrets** (`.env`, keys, tokens) — check staged files before every commit.
- **Push:** on the cadence authorized at intake — that standing authorization means you push **without
  re-asking** (SKILL.md `<autonomy>`). Never **force-push** or rewrite history without an explicit OK.
- If `gh` is unavailable or unauthenticated, fall back to local commits and tell the user how to add the
  remote later.

```markdown
# PROGRESS — {title}

## Phase A — {name}
### ✅ A.1 — {step title}   ({YYYY-MM-DD})
- **Did:** {what changed}
- **Files:** {paths}
- **Verify:** {check run → result, e.g. "ran `npm start`, GET /health → 200 ✓"}
- **Deviation:** {omit if none | what differed from plan and why}

### ✅ A.2 — {step title}   ({YYYY-MM-DD})
- …

### ✓ Checkpoint A   ({YYYY-MM-DD})
- **Ran:** {typecheck / lint / tests / golden path so far / UI checklist} → {result}
```

**Exit criteria:** every build step checked off in PLAN.md and logged in PROGRESS.md with a passing
verify and its tests; every phase checkpoint passed; codebase in a working state. Update FORGE.md
(check ④). → `phases/5-tests.md`.
