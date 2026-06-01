# Forge — Engineering flow (the staffed build)

How the build phase runs like a real engineering org: a staff engineer **implements** each feature,
then independent reviewers **try to break it**, and nothing integrates until they all sign off. This
file is the single source of truth for the roster, the adversarial review contract, the verdict format,
and the consensus protocol. `phases/5-build.md` orchestrates it; the `forge-*` agents implement it.

> Core principle in play: **Adversarial consensus.** No feature ships on one set of eyes. Reviewers who
> actively tried to break it — for bugs, for security, and (UI) for design + accessibility — must fail
> to, and sign off. An objection sends it back with feedback, not forward; uncertainty defaults to "send
> it back," never "ship it."

---

## The roster

The **orchestrator is the engineering manager.** It owns every `.forge/` artifact, slices the work, runs
the panel, compiles feedback, adjudicates ties, enforces max-rounds, and commits. It stays a **thin
manager** — it delegates all heavy reading and writing to fresh-context subagents and holds only state
(FORGE.md, the slice manifest, compact verdicts), so a 30–50-slice build never exhausts its context.

| Role | Agent | Writes | Does |
|------|-------|--------|------|
| Staff software engineer | `forge-implementer` | source + tests | Implements a slice + its tests; self-verifies every step before returning. Persistent across feedback rounds. |
| Staff frontend engineer | `forge-frontend-engineer` | source + tests | Implements UI to `DESIGN.md` + accessibility/standards; verifies in a browser. |
| Lead product designer | `forge-designer` | `DESIGN.md` | Produces the design direction (UI slices); also the panel's design + a11y reviewer (read-only mode). |
| Staff engineer (review) | `forge-reviewer` | nothing | Adversarial correctness/integration/standards/architecture review against the whole tree. |
| Staff security engineer | `forge-security-auditor` | nothing | Adversarial OWASP review of the changeset + blast radius. |
| QA / SDET | `forge-verifier` | tests only | Runs it for real + authors independent break-it tests; refutation mode. |

Only **one implementer writes at a time** (slices are sequential), so there are no write conflicts and no
git worktrees are needed. Reviewers are strictly read-only on source; the verifier may add **tests only**.

---

## The adversarial review contract (always on, every depth)

Every panel member is told to **falsify the slice, not bless it.** This is the guarantee against bugs,
sloppy work, and UI defects on a one-shot run.

- **Break-it, don't bless-it.** Start from "this is flawed — prove where." Evidence is `file:line` + why
  it fails, not vague "consider refactoring."
- **Independent adversarial tests.** The implementer's own tests are presumed too kind to their own code.
  `forge-verifier` independently authors and runs **negative / boundary / hostile-input tests designed to
  force a failure** — malformed input, empty/zero/huge, error paths, concurrency/races, retries/timeouts,
  abuse — on top of the full regression suite. A real failure is a `CHANGES_REQUESTED`.
- **Survive refutation, don't just collect approvals.** For **high-risk slices and at `deep` depth**, an
  `APPROVE` is itself challenged: a second independent reviewer is spawned to *refute* it (prompted to
  overturn the sign-off; default to "refuted" when uncertain). The slice passes only if refutation fails
  — **majority-survives** for the riskiest slices.
- **Skeptical prior.** Uncertainty resolves to *send it back*. A tie or an unresolved doubt is a
  `CHANGES_REQUESTED`, never a pass.
- **Adversarial UI.** Design/a11y review actively tries to break the interface: every state
  (loading / empty / error / success), tiny + huge viewports, keyboard-only navigation, visible focus,
  contrast, reduced-motion, and screen-reader semantics.

---

## Verdict format (every panel member returns exactly this)

```
VERDICT: APPROVE | CHANGES_REQUESTED
SUMMARY: <one or two sentences>
FINDINGS:
- [Critical|High|Medium|Low] <file:line> — <what's wrong & why it fails> → <required change>
SIGN-OFF SCOPE: <what this reviewer did and did NOT check>
```

`APPROVE` is only valid with an **empty** Critical/High list. The orchestrator treats the structured
findings as the actionable feedback that goes back to the implementer — this is what makes the loop
mechanical rather than a conversation.

---

## Consensus protocol (run by the orchestrator, per slice)

1. **Implement** → spawn the implementer with a self-contained prompt (see `phases/5-build.md`).
2. **Panel** → spawn the risk-appropriate reviewers **in parallel**, each reviewing the slice **against
   the entire current codebase** (not just the diff — integration and regressions live there).
3. **Decide:**
   - **All `APPROVE`** → slice passes. Record the panel outcome in `PROGRESS.md`, check the slice's boxes
     in `PLAN.md`, commit per cadence, move to the next slice.
   - **Any `CHANGES_REQUESTED`** → consolidate + prioritise the findings, send them **back to the same
     implementer** (continue it — it keeps its context), then re-run **only the members that objected**
     plus `forge-verifier` (to confirm the fix introduced no regression). Increment the round counter.
4. **Stuck consensus** → if the slice still hasn't reached unanimous sign-off at the **max round** for the
   depth, **escalate to the user** with the specific disagreement and each reviewer's position. This is
   the *only* routine stop inside the build (a genuine clarity need per SKILL.md `<autonomy>`).
5. **Conflicting feedback** → the manager adjudicates using SPEC + `ARCHITECTURE.md` + `standards.md` as
   the tie-breaker and records the call. If it's a genuine product trade-off, escalate instead of guessing.

**Review against all current code.** Because every panel reads the whole tree and `forge-verifier`
re-runs the **full regression suite** each round, slice N cannot silently break slice 1. This is the
property that makes a long, many-slice build trustworthy.

---

## Slice risk classification (sets panel intensity)

The orchestrator tags each slice in the manifest when planning. **Depth sets the floor; risk sets the
ceiling.**

| Risk | Examples | Panel |
|------|----------|-------|
| **High** | auth/session, data persistence & migrations, money/payments, external/untrusted input, anything on a public surface, crypto, file/network I/O | **Full panel + security emphasis + survive-refutation**, regardless of depth. |
| **Medium** | core business logic, shared modules, internal APIs, state management | Full panel (reviewer + security + verifier). |
| **Low** | config, copy/README, pure-presentational tweaks, isolated helpers with tests | Light — usually just `forge-verifier`; reviewer if it touches shared code. |

When a build bounds coverage this way, **say so** — note in `PROGRESS.md` which slices got the light path,
so "reviewed" never overstates what happened.

---

## Depth scaling

| Depth | Implement | Panel | Max redo rounds |
|-------|-----------|-------|-----------------|
| **quick** | one implementer (orchestrator may do tiny slices inline) | one combined reviewer (correctness + security) + verifier | 1 |
| **standard** | implementer | full parallel trio: reviewer + security + verifier (+ designer for UI) | 2–3 |
| **deep** | implementer | ≥2 independent reviewers + security + verifier + designer; **survive-refutation** on every slice; thinner slices | 3+ |

Higher depth never skips the panel — it adds independent eyes and tighter consensus.

---

## How this file is used
- **`phases/5-build.md`** — the orchestrator runs the consensus protocol above for every slice.
- **`phases/4-plan.md`** — assigns each slice a risk class (drives panel intensity).
- **The `forge-*` agents** — share the adversarial contract and the verdict format defined here.
- **Degraded tools (no subagents):** play every role inline, in sequence (implement → review as the
  reviewer → review as security → break-it as QA → reconcile → loop), keeping the same adversarial
  standard. You lose the fresh context, not the rigor.
