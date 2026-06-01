# Forge — Brownfield mode (changing an existing system)

When forging on a project that already exists, Forge switches to **brownfield mode**: comprehend the
system first, design the change as a delta that fits it, and protect what already works. The greenfield
path is unchanged — this file is the canonical set of adaptations each phase applies when
`Mode: brownfield`.

> Core principle in play: **Safe change over clean slate.** You are a guest in a working system.
> Understand it before you touch it, fit its conventions, pin its behaviour, and never break what you
> weren't asked to change.

---

## Principles
- **Comprehend first.** No design or plan until `MAP.md` exists and you understand the architecture, the
  conventions, the real build/test/run commands, and the fragile areas.
- **Fit, don't fork.** Match the existing architecture and conventions (from `MAP.md`); never introduce a
  parallel pattern, framework, or style alongside the established one.
- **Pin before you change.** Establish a green test **baseline**, and add **characterization tests** that
  capture current behaviour around the code you'll touch, so any regression is caught immediately.
- **Respect contracts.** Don't change public APIs, schemas, or observable behaviour unless that *is* the
  task. Capture "must not change" in SPEC and honour it.
- **Surface, don't scope-creep.** Pre-existing bugs, tech debt, and vulnerabilities you find are recorded
  as findings (SECURITY.md / REVIEW.md / the final summary) — not silently refactored. Fix what's in
  scope; propose the rest.
- **Higher default risk.** Touching existing code has blast radius. Default a slice a notch higher on the
  risk scale (`references/engineering-flow.md`) than the equivalent greenfield slice.

## Per-phase adaptations
- **① Interview** — Detect mode: substantial existing source ⇒ brownfield (confirm with the user). Ask
  what to **add / change / fix**, the **target area**, the **success criteria for the change**, and
  explicitly **what must NOT change** (contracts, behaviour, performance). Record `Mode: brownfield`.
- **② Research** — **Lead with comprehension:** spawn `forge-cartographer` to produce `MAP.md`. Then run
  currency/feasibility research scoped to the existing stack + whatever the change introduces. RESEARCH.md
  references MAP.md rather than duplicating it.
- **③ Architecture** — **Document then delta.** Summarise the *existing* architecture (from MAP.md) in
  `ARCHITECTURE.md`, then design the change as an addition/modification that **fits** it — boundaries
  honoured, no new parallel patterns. ADRs cover only the change's decisions. Threat model = the change +
  its blast radius (plus any pre-existing risk the change newly exposes).
- **④ Plan** — **No walking skeleton** (it already exists). The **foundational slice** instead: confirm
  the green baseline, then write **characterization tests** around the target so regressions are
  detectable. Slices are change-deltas in dependency order; tag each with **blast radius** (what existing
  code/callers it touches) and a risk class (default a notch higher).
- **⑤ Build** — **Regression-first.** Before the first change, run the existing suite and record the
  baseline. The implementer follows MAP.md conventions and makes the smallest change that fits. Every panel
  runs the **full existing suite** (not just new tests), and the reviewer explicitly checks: *did this
  break an existing contract, caller, or behaviour?* A broken baseline is a stop, not a deviation.
- **⑥ Tests** — Use the existing framework/conventions. Add characterization + new-behaviour tests for the
  change; backfill characterization tests for any touched legacy code that lacked them.
- **⑦ Security / ⑧ Final sweep** — Scope the audit/sweep to the change + blast radius. **Record
  pre-existing issues** found along the way as findings (don't fix the whole legacy app); confirm the
  change met its criteria and broke nothing.
- **⑨ Deploy** — Detect and reuse the project's existing deploy path / CI rather than inventing one.

## How this file is used
- `SKILL.md` `<modes>` points here when `Mode: brownfield`.
- Each phase playbook carries a short **Brownfield** note that defers to this file.
- `forge-cartographer` produces the `MAP.md` this mode depends on.
