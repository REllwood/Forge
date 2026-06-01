# Phase ③ — Architecture & Design

**Goal:** Agree the **system design** before decomposing into a granular plan. Produce `ARCHITECTURE.md`
(and, for UI, kick off `DESIGN.md`) — the contract the plan decomposes into slices and the build panel
reviews every slice against. A staff/principal engineer wouldn't break a large project into 50 steps
before the shape is sound; this phase is where that shape is decided.

**Inputs:** `.forge/SPEC.md`, `.forge/RESEARCH.md`.

> Core principles in play: **Build to a standard** (sound, right-sized architecture per
> `references/standards.md`) and **Ground everything in reality** (design around the versions/APIs
> verified in research, not assumptions).

**Brownfield:** *document then delta* — summarise the existing architecture from `MAP.md`, then design the
change to **fit** it (boundaries honoured, no parallel patterns); keep ADRs and the threat model scoped to
the change + its blast radius. See `references/brownfield.md`.

---

## 1. Design the system

Synthesise SPEC + RESEARCH into a sound, **right-sized** structure (match `references/standards.md`):
- **Components & boundaries** — the major modules, each one's single responsibility, and how data flows
  between them. Separation of concerns (presentation ⊥ domain ⊥ data); dependency direction toward the
  domain; no circular dependencies.
- **Runtime shape** — monolith vs. services, sync vs. async, where state lives, key interfaces/seams.
- **Right-sized** — the simplest architecture that satisfies the SPEC's scale and non-goals. No layers,
  patterns, or services the scope doesn't warrant. Prefer `engineering:architecture` /
  `engineering:system-design` skills if installed.

## 2. Data model & contracts

- **Data model** — entities, relationships, storage (DB/files/in-memory), migration strategy, seed data.
  Validate at boundaries; parameterise queries.
- **Contracts at the seams** — the API/interface contracts new code will honour: endpoints + shapes,
  key function signatures, events/messages. These become the boundaries the build's slices implement to.

## 3. Key decisions as ADRs

For each significant choice (framework, persistence, auth model, a notable trade-off), record a short
**ADR**: *context → decision → consequences*. This is what keeps the build consistent and gives the
review panel a reference for "does this slice honour the decision?"

## 4. Threat model (lightweight — shift-left security)

Sketch the security picture so the per-slice security reviews are sharp from the start: **assets** (what's
worth protecting), **trust boundaries** (where untrusted input enters), **attack surface**, and the
**top risks** with intended mitigations. Scale by depth and data sensitivity — a few lines for a CLI, a
real model for anything handling auth/PII/payments. These risks tag which build slices are **high-risk**.

## 5. UI — kick off the design system  ← only if there's a UI

Spawn `forge-designer` (design mode) to draft the **global** `DESIGN.md`: design tokens (color/spacing/
type/radius), the layout system + breakpoints, a base component inventory, and the standard states
(loading/empty/error/success) — grounded in the SPEC references + Dribbble/Mobbin inspiration and the bars
in `references/standards.md`. Per-slice design refinements happen later in build; this establishes the
direction so the plan can sequence tokens + base components before feature screens. (Inline tools without
subagents: produce `DESIGN.md` yourself to the same standard.)

## 6. (deep) Adversarial design review

For `deep`, before locking, have fresh eyes challenge the design — spawn `forge-reviewer` (or use
`engineering:architecture`) to attack `ARCHITECTURE.md`: single points of failure, boundaries that will
leak, a data model that won't scale to the stated load, a contract that can't evolve. Fold the valid
critiques in.

## 7. Write ARCHITECTURE.md and carry it to the plan gate

Write `.forge/ARCHITECTURE.md` (template below). **Do not present a separate approval stop** — this phase
flows straight into the plan; the plan phase presents `ARCHITECTURE.md` **together with** `PLAN.md` at the
single approval gate. (For `deep`, you may present the architecture for its own sign-off first if the build
is large or high-stakes.) Update FORGE.md: check ③, Status → `plan`, refresh Current position.

```markdown
# ARCHITECTURE — {title}

## Overview
{2–4 sentences: the shape of the system and why it fits the SPEC}

## Components & boundaries
{module → responsibility; a simple diagram or list of data flows}

## Data model
{entities, relationships, storage, migrations}

## Contracts (the seams)
{key endpoints / signatures / events new code implements to}

## Key decisions (ADRs)
### ADR-1: {decision}
- **Context:** … **Decision:** … **Consequences:** …

## Threat model
- **Assets:** … **Trust boundaries:** … **Top risks → mitigations:** …
- High-risk areas (drive build panel intensity): {auth / data / payments / external input / public surface}

## Design system   ← omit if no UI
{pointer to DESIGN.md + the headline direction}

## Open architecture risks
- {anything to watch when planning/building}
```

**Exit criteria:** ARCHITECTURE.md written (and DESIGN.md drafted if there's a UI); key decisions captured
as ADRs; threat model noted with high-risk areas flagged; FORGE.md updated. → Proceed to
`phases/4-plan.md`.
