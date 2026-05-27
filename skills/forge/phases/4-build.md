# Phase ④ — Build

**Goal:** Implement the plan with momentum and **verify every single step before moving on**. Keep the
trail current. This phase is where forge's meticulousness about bugs is enforced.

**Inputs:** `.forge/PLAN.md` (the steps), `.forge/SPEC.md`, `.forge/RESEARCH.md`.

**Execution mode:** autonomous. Once the plan is approved, work straight through to the end of the
pipeline. Post brief progress notes at phase boundaries **without waiting for a reply**, and stop only
for a genuine clarity need (SKILL.md `<autonomy>`). Mirror the plan's steps into your in-session todo
tool so progress is visible, but `PROGRESS.md` is the durable record.

> Core principle in play: **Verify or it didn't happen.** Never advance past a step whose verification
> hasn't passed. Never leave the codebase in a broken state between steps.

---

## The per-step loop (repeat for every step, in order)

1. **Announce** the step: id, goal, and its Verify check (so intent is explicit).
2. **Implement** precisely — the smallest change that satisfies the step's Do-instructions. Follow the
   codebase's existing conventions (from RESEARCH) and the bars in `references/standards.md` (sound
   architecture; accessible, well-designed UI), sized to the SPEC. No speculative extras, no stubs left
   behind, no half-finished work.
3. **Verify (mandatory).** Run the step's Verify check, plus the relevant subset of:
   - Compiles / typechecks.
   - Lints / formats clean.
   - The specific command or test for this step passes.
   - **Functionally exercise the path this step created** — actually run it and observe the expected
     behavior, don't just assume.
   - **No regressions** — the things that worked before still work.
   - **UI steps:** run the dev server and check it in a browser — confirm it renders and behaves, and
     check responsiveness + basic accessibility (keyboard nav, visible focus, contrast) per
     `references/standards.md`. Use available preview/browser tools, or delegate the visual check to a
     subagent that has them. If you genuinely cannot drive a browser, say so explicitly rather than
     claiming the UI works.
   - **Delegation:** for substantial or UI steps, hand the functional check to the `forge-verifier`
     agent (or the `/verify` · `/run` skills if installed); verify small steps inline.
4. **On failure:** fix it now. Diagnose root cause; don't paper over it. For a stubborn failure, apply a
   scientific-method debugging pass (or the `engineering:debug` skill if installed) before giving up. If
   you still can't resolve it after a reasonable effort, **checkpoint with the user** (don't proceed on a
   broken state).
5. **Record:** check the step's box in `PLAN.md` and append an entry to `.forge/PROGRESS.md` (template
   below) — what you did, files touched, the verify result, and any deviation.
6. **Deviation handling:** if reality differs from the plan (a step is wrong, missing, or a better path
   appears), adapt — and **log the deviation and rationale** in PROGRESS.md. If scope shifts materially,
   update PLAN.md and flag it at the next checkpoint.

## Keep moving — stop only for clarity

Forge is agentic: drive through the steps and phases on your own. At each **phase** boundary, post a
short, **non-blocking** note (what's done, verified state, what's next) and continue — do not wait for
permission to proceed. Stop and ask only when you hit one of the genuine clarity needs in SKILL.md
`<autonomy>`: real ambiguity SPEC/RESEARCH don't settle, a true blocker, a risky/irreversible action, or
a material scope/cost change. For everything else — equivalent implementation choices, small fixes, a
failed verify you can diagnose — **decide, act, and log it.** Keep retrying and fixing a failed step
yourself before escalating. Keep FORGE.md's Current position current so a context reset can resume
mid-phase.

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
- **Verify:** {check run → result, e.g. "tsc clean; ran `npm start`, GET /health → 200 ✓"}
- **Deviation:** {none | what differed from plan and why}

### ✅ A.2 — {step title}   ({YYYY-MM-DD})
- …
```

**Exit criteria:** every build step checked off in PLAN.md and logged in PROGRESS.md with a passing
verify; codebase in a working state. Update FORGE.md (check ④). → If tests were chosen,
`phases/5-tests.md`; otherwise `phases/6-security.md`.
