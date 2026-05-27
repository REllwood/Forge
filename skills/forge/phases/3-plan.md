# Phase ③ — Plan

**Goal:** Produce `PLAN.md` — an ultra-granular sequence of tiny, individually-verifiable steps. This is
the contract the build phase executes. Get explicit user approval before building (the plan-mode gate).

**Inputs:** `.forge/SPEC.md`, `.forge/RESEARCH.md`.

> Core principle in play: **Small steps, deep detail.** Prefer many small steps over few big ones. Each
> step should be completable AND verifiable on its own. If a step needs more than one verification or
> touches several unrelated concerns, split it.

---

## 1. Decompose into phases → steps

Group work into ordered **phases** (e.g. Scaffold, Data layer, Core feature A, Core feature B,
Integration, Polish). Within each phase, write **atomic steps**. Order strictly by dependency.

**Front-load a walking skeleton:** the earliest steps should produce a minimal end-to-end thing that
runs (even if it does almost nothing), so every later step builds on something verified-working.

**Architect it early (`references/standards.md`).** Sequence steps so the sound, right-sized structure is
in place before features pile on: scaffold the layers / separation of concerns first, and for a UI set up
design tokens and base components before the screens that use them. Don't defer architecture to "later."

Granularity test for each step: *Can I implement this with a focused change and prove it works with one
concrete check?* If not, split it.

## 2. Write each step with full detail

Every step gets: a Goal, the Files it touches, precise Do-instructions, an explicit **Verify** check
(the exact thing that proves it works — a command to run, output to see, behavior to observe), and
Depends-on. The Verify line is mandatory — it's what the build phase will run.

## 3. Decide tests

Ask the user (`AskUserQuestion`) whether they want automated tests, and if so what kind (unit /
integration / e2e / a mix) and rough coverage expectation. Record the answer. If yes, the **Tests phase
(⑤)** will be appended after the build phase; reflect that in the plan's phase list. Security (⑥) and
Final sweep (⑦) are always included — list them as the closing phases.

## 4. Present for approval — DO NOT build yet

Write `.forge/PLAN.md`, then present a concise outline (phases + step counts + the headline steps) to
the user. Ask via `AskUserQuestion`: **Approve / Revise (tell me what) / Change depth.** Iterate on the
plan until approved. Building before approval violates the pipeline.

**This is the last routine stop.** It's a deliberate go/no-go because building on a wrong plan wastes the
most work. After approval, forge runs **autonomously to done** (build → tests → security → final sweep),
stopping only for a genuine clarity need (see SKILL.md `<autonomy>`). If the user has asked to run fully
unattended, present the plan for visibility and proceed without waiting.

On approval, update FORGE.md: check ③, Status → `build`, refresh Current position. → `phases/4-build.md`.

```markdown
# PLAN — {title}

**Phases:** ① {name} · ② {name} · … · Tests ({yes/no}) · Security · Final sweep
**Verification:** every step self-verified before the next; checkpoints at phase boundaries.

---

## Phase A — {name}
> {one line: what this phase delivers}

### A.1 — {step title}
- **Goal:** {what done looks like}
- **Files:** {paths to create/edit}
- **Do:** {precise, concrete instructions — enough that execution is mechanical}
- **Verify:** {exact check — command + expected result, or behavior to observe}
- **Depends on:** {prior step ids, or —}
- [ ] done

### A.2 — {step title}
- **Goal:** …
- **Files:** …
- **Do:** …
- **Verify:** …
- **Depends on:** A.1
- [ ] done

## Phase B — {name}
…

## Phase T — Tests        ← only if chosen
{step(s) to set up framework, write tests for each success criterion, make green}

## Phase S — Security
{placeholder — executed per phases/6-security.md}

## Phase F — Final sweep
{placeholder — executed per phases/7-final-sweep.md}
```

**Exit criteria:** PLAN.md written with atomic, individually-verifiable steps; tests decision recorded;
user approved; FORGE.md updated. → Proceed to `phases/4-build.md`.
