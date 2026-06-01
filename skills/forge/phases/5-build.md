# Phase ⑤ — Build

**Goal:** Implement the plan **slice by slice**, like a staffed engineering team: a staff engineer builds
each slice (self-verifying every step), then an adversarial review panel **tries to break it**, and the
slice integrates only when they all sign off. Keep momentum; keep the trail current. This phase is where
forge's meticulousness about bugs is enforced.

**Inputs:** `.forge/PLAN.md` (the slice manifest + steps), `SPEC.md`, `RESEARCH.md`, `ARCHITECTURE.md`,
`DESIGN.md` (UI). The roster, verdict format, consensus protocol, risk classes, and depth scaling are
defined once in **`references/engineering-flow.md`** — follow it.

**Your role: engineering manager.** You own the `.forge/` trail, run the panel, compile feedback,
adjudicate ties, enforce max-rounds, and commit. Stay a **thin manager**: delegate all heavy reading and
writing to subagents and hold only state (FORGE.md, the slice manifest, compact verdicts), so even a
many-slice build never exhausts your context.

**Execution mode: autonomous.** Once the plan is approved, work straight through to the end of the
pipeline. Post a brief note at each slice/phase boundary **without waiting for a reply**, and stop only for
a genuine clarity need or stuck consensus (SKILL.md `<autonomy>`). Mirror the slice manifest into your
in-session todo tool for visibility; `PROGRESS.md` is the durable record.

> Core principles in play: **Verify or it didn't happen** (no slice integrates unverified) and
> **Adversarial consensus** (no slice ships until reviewers who tried to break it couldn't).

---

## Before the first slice — version control

Honour the VCS decision recorded in SPEC:
- If Git/GitHub was chosen and no repo exists yet: `git init`, add a stack-appropriate `.gitignore`
  (ignore `.forge/` unless the user opted to track it, plus secrets and build artifacts), and make an
  initial scaffold commit. If GitHub was chosen, create the remote:
  `gh repo create <name> --private|--public --source=. --remote=origin --push` (visibility from SPEC).
- If `gh` is unavailable/unauthenticated, fall back to local commits and tell the user how to add the
  remote later.

## The per-slice loop (repeat for every slice in the manifest, in dependency order)

Size the panel to each slice's **risk class × depth** (`references/engineering-flow.md`).

**0. (UI slices) Design.** Spawn `forge-designer` (design mode) to refine `DESIGN.md` for this slice
against the global direction set in phase ③. Skip for non-UI slices.

**1. Implement.** Spawn the staff engineer — `forge-implementer` (or `forge-frontend-engineer` for UI) —
with a **self-contained prompt**: the slice's steps + Verify checks, the relevant SPEC/ARCHITECTURE/DESIGN
excerpts, `references/standards.md`, the file list, and the instruction to *follow existing conventions,
write the code **and** its tests, and self-verify every step (typecheck/lint/run/functional/no-regression)
before returning.* **The per-step verify loop lives here, inside the staff engineer** — it isn't skipped,
it's delegated. The engineer returns a changeset report.

**2. Adversarial panel (parallel, against the whole current tree).** Spawn the risk-appropriate reviewers
concurrently — each told to **try to break the slice, not bless it**, reviewing it in the context of the
entire codebase (integration + regressions):
- `forge-reviewer` — correctness, logic, edge cases, integration, regressions, ARCHITECTURE conformance,
  standards, spec-match.
- `forge-security-auditor` — the changeset + blast radius (always for high-risk slices).
- `forge-verifier` — run it for real: full regression suite + golden path + **independent break-it
  tests**; UI in a browser.
- `forge-designer` (review mode) — design + a11y conformance, for UI slices.

Each returns the shared **verdict** (`APPROVE` / `CHANGES_REQUESTED` + findings). Uncertainty →
`CHANGES_REQUESTED`. For high-risk slices / `deep`, add a **refutation** pass before accepting an APPROVE
(`references/engineering-flow.md`).

**3. Consensus gate.**
- **All APPROVE** → the slice is done.
- **Any CHANGES_REQUESTED** → consolidate + prioritise the findings and send them **back to the same
  implementer** (continue it — it keeps its context) to fix at root cause; then re-run **only the objecting
  members** + `forge-verifier` (regression check). Increment the round counter.
- **Max rounds** (quick 1 / standard 2–3 / deep 3+) without consensus → **escalate to the user** with the
  specific disagreement and each reviewer's position. This is the only routine stop in the build.
- **Conflicting feedback** → adjudicate using SPEC + ARCHITECTURE + standards as the tie-breaker and record
  the call; escalate a genuine product trade-off rather than guessing.

**4. Integrate.** On unanimous sign-off: check the slice's step boxes in `PLAN.md`, append the slice's
record to `PROGRESS.md` (below), and **commit** per the chosen cadence (atomic; never commit secrets —
check staged files; push per the standing authorization; never force-push without an explicit OK). Update
FORGE.md's Current position (current slice + status) so a reset can resume. → next slice, now reviewed
against this larger codebase.

## Keep moving — stop only for clarity

Drive through the slices on your own. At each slice/phase boundary post a short, **non-blocking** note
(slice done, panel result, what's next) and continue. Stop and ask only for the genuine clarity needs in
SKILL.md `<autonomy>`: real ambiguity SPEC/ARCHITECTURE don't settle, a true blocker, a risky/irreversible
action, a material scope/cost change, or **stuck consensus** after max rounds. For everything else —
equivalent implementation choices, small fixes, feedback rounds — decide, act, and log it. Keep FORGE.md's
Current position current so a context reset can resume mid-slice.

## Degraded tools (no subagents)

If you can't spawn the `forge-*` agents (Codex / Cursor / etc.), **play every role inline, in sequence**,
for each slice: implement → review as the reviewer → audit as security → break-it as QA → reconcile →
loop. You lose the fresh context, not the adversarial standard.

```markdown
# PROGRESS — {title}

## S1 — {slice name}   ({YYYY-MM-DD} · risk {low/med/high} · rounds {n})
- **Implemented by:** forge-implementer | forge-frontend-engineer
- **Did:** {what changed}   **Files:** {paths}   **Tests:** {added}
- **Panel:** reviewer ✓ · security ✓ · verifier ✓ {· designer ✓}  (or: round 1 changes → {summary} → round 2 ✓)
- **Verify:** {suite result; golden path; key edge cases → outcomes}
- **Deviation:** {none | what differed from plan/architecture and why}

## S2 — …
```

**Exit criteria:** every slice in the manifest signed off by its panel and integrated; PLAN.md boxes
checked; PROGRESS.md records each slice's panel outcome; codebase in a working state with the full suite
green. Update FORGE.md (check ⑤). → If tests were chosen, `phases/6-tests.md`; otherwise
`phases/7-security.md`.
