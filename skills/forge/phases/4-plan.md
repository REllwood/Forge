# Phase ④ — Plan

**Goal:** Turn `ARCHITECTURE.md` into `PLAN.md` — an ordered set of **feature slices**, each a cluster of
tiny, individually-verifiable steps. This is the contract the build phase executes slice by slice. Present
it **together with `ARCHITECTURE.md`** for one explicit approval before building (the plan-mode gate).

**Inputs:** `.forge/SPEC.md`, `.forge/RESEARCH.md`, `.forge/ARCHITECTURE.md` (and `DESIGN.md` if UI).

> Core principle in play: **Small steps, deep detail.** Prefer many small steps over few big ones. Each
> step is completable AND verifiable on its own. The **slice** is the unit the review panel signs off; the
> **steps** inside it are what the staff engineer self-verifies while building.

---

## 1. Decompose ARCHITECTURE.md into feature slices

A **slice** is a coherent, integration-meaningful unit of work — a vertical feature, or a foundational
layer — the thing the build panel reviews and signs off as a whole. Order slices strictly by dependency.

- **Foundational slice first.** The earliest slice scaffolds the architecture from `ARCHITECTURE.md`
  (layers, boundaries, the data layer) and — for UI — sets up the `DESIGN.md` tokens + base components,
  producing a **walking skeleton** that runs end-to-end (even if it does almost nothing). Every later
  slice then builds on something verified-working.
- **Right-sized slices.** Each slice should be implementable and reviewable on its own. **Depth controls
  thinness:** `quick` = coarser slices; `deep` = thin slices close to per-step (see
  `references/engineering-flow.md`).

## 2. Build the slice manifest

List every slice in a manifest at the top of `PLAN.md` — the backbone that lets a large build run
near-one-shot and resume cold:

| Slice | Summary | UI? | Risk | Depends on |
|-------|---------|-----|------|------------|
| S1 | Scaffold + walking skeleton | — | … | — |
| S2 | … | yes | high | S1 |

- **Risk** (low / medium / high) comes from `ARCHITECTURE.md`'s threat model — it sets the review-panel
  intensity per `references/engineering-flow.md` (high-risk → full panel + security emphasis + refutation;
  low-risk → light panel). Classify honestly; under-classifying ships bugs.
- **UI?** flags slices that need the `forge-designer` design step and `forge-frontend-engineer`.

## 3. Write each slice's steps with full detail

Within each slice, write **atomic steps**. Every step gets: a **Goal**, the **Files** it touches, precise
**Do**-instructions, an explicit **Verify** check (the exact command/output/behaviour that proves it
works), and **Depends-on**. The Verify line is mandatory — the staff engineer runs it while building.
Granularity test: if a step needs more than one verification or touches unrelated concerns, split it.

## 4. Tests & deploy decisions

- **Tests are per-feature by default** — every slice's steps include writing its tests (acceptance for the
  SPEC criteria it covers + edge cases). Confirm the **kinds** wanted (unit / integration / e2e) via
  `AskUserQuestion`; the **Tests phase (⑥)** later consolidates cross-feature/integration/e2e coverage.
- **Deploy** — ask whether to include the optional **Deploy phase (⑨)**, and if so the target.

Security (⑦) and Final sweep (⑧) are always the closing phases — name them in the plan's phase line.

## 5. Present for approval — DO NOT build yet

Write `.forge/PLAN.md`, then present **`ARCHITECTURE.md` + `PLAN.md` together** at one gate: the system-
design headline, the slice manifest, and the closing phases. Ask via `AskUserQuestion`: **Approve / Revise
(tell me what) / Change depth.** Iterate until approved. Building before approval violates the pipeline.

**This is the last routine stop.** After approval, forge runs **autonomously to done** (build → tests →
security → final sweep → deploy), stopping only for a genuine clarity need or stuck consensus (see SKILL.md
`<autonomy>` and `references/engineering-flow.md`). If the user asked to run fully unattended, present for
visibility and proceed.

On approval, update FORGE.md: check ④, Status → `build`, refresh Current position. → `phases/5-build.md`.

```markdown
# PLAN — {title}

**Phases:** Build (slices below) · Tests ({yes/no}) · Security · Final sweep · Deploy ({yes/no})
**Verification:** every step self-verified by the staff engineer; every slice signed off by the review
panel (`references/engineering-flow.md`) before it integrates.

## Slice manifest
| Slice | Summary | UI? | Risk | Depends on |
|-------|---------|-----|------|------------|
| S1 | … | — | … | — |

---

## S1 — {slice name}   ({risk} · {UI? yes/no})
> {one line: what this slice delivers}

### S1.1 — {step title}
- **Goal:** {what done looks like}
- **Files:** {paths}
- **Do:** {precise, mechanical instructions}
- **Verify:** {exact check — command + expected result, or behaviour to observe}
- **Depends on:** {prior step ids, or —}
- [ ] done

### S1.2 — …

## S2 — {slice name}
…
```

**Exit criteria:** PLAN.md written with a slice manifest (risk + UI tagged) and atomic, individually-
verifiable steps per slice; tests/deploy decisions recorded; ARCHITECTURE.md + PLAN.md presented together
and approved; FORGE.md updated. → Proceed to `phases/5-build.md`.
