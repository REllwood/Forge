# Phase ②.5 — UI Design (conditional)

**Runs only when the SPEC has a UI.** For a CLI / library / API / script with no UI, skip straight to
`phases/3-plan.md`. Goal: a deliberate, modern UI design — the best achievable **within the user's stated
scope** — captured in `.forge/UI-DESIGN.md` (plus throwaway mockups for visual-heavy apps), ready for the
plan to implement and for the user to sign off at the plan-approval gate.

**Inputs:** `.forge/SPEC.md` (UI & design section, references, scope), `.forge/RESEARCH.md`,
`references/standards.md` (the UI + design bars, incl. platform-specific notes).

> The user's interview answers are the **ANCHOR**. The team elevates *within* what they asked for — modern
> look and feel, best-in-class craft — and surfaces any proposed departure for approval at the plan gate.
> It never silently overrides the user's stated direction or gold-plates beyond scope.

---

## The design panel

Detect the **platform(s)** from SPEC's form factor, then run the team (in `balanced`, as the agents below;
in `economy`, do the same roles inline):

1. **Platform UI specialist** — `forge-ui-designer`, adapted to the platform (web · mobile · desktop ·
   game/HUD · TUI). Proposes information architecture, key screens & states, design tokens (color, type,
   spacing, radius, motion), layout, navigation, component choices, and the modern reference direction —
   all honoring SPEC scope and preferences.
2. **Staff frontend developer** — `forge-frontend-engineer`. Reviews the proposal for implementation
   feasibility, modern frontend best practices, component architecture, responsiveness, performance, and
   accessibility-in-practice. Flags what's impractical; proposes concrete, buildable adjustments.
3. **UI artist** — `forge-ui-artist`. Reviews visual craft: hierarchy, color, typography, spacing,
   consistency, polish, modern aesthetic and emotional tone. Flags anything dated/cluttered/off; proposes
   specific refinements.

**Converge:** fold both critiques back into the design and iterate until the panel agrees it's *both
buildable and beautiful* **and the design meets every item of the UI Acceptance Checklist**
(`references/standards.md`) — modern, responsive, accessible, all states, performance, polish,
platform-fit — or the cap is hit (1 round at quick, 2 at standard, 3 at deep). Round 2+ critiques only
what changed since the last round, and the panel stops early once a round raises no material issues
(SKILL.md `<loop_guards>`). Stay anchored to scope; don't gold-plate.

## Fidelity — auto by app type

- **Visual-heavy / UI-centric** (consumer web or mobile app, game UI, marketing site, rich dashboard):
  the designer returns complete self-contained **throwaway HTML** for 1–3 key screens; write them to
  `.forge/ui-mockups/` so the user can see and pick a direction at the plan gate. (Static, illustrative —
  explicitly not the real build.)
- **Simpler UI** (internal tool, small form, admin panel): a precise **written design direction** in
  UI-DESIGN.md — no rendered mockups.
- **`economy` mode:** prefer spec-only unless the app is clearly visual-first.

## Write UI-DESIGN.md

```markdown
# UI-DESIGN — {title}

## Platform & principles
{platform(s); 3–5 design principles guiding the look}

## Design tokens
- Color: {palette + semantic roles; light/dark; all AA-contrast}
- Type: {families ≤2, scale, line-height/measure}
- Spacing / radius / shadow / motion: {scales; motion ~150–250ms}

## Layout & navigation
{structural system; how users move through it; responsive behavior}

## Key screens & states
- {screen} — {loading / empty / error / success}

## Components
{inventory; library (shadcn/Tailwind/MUI…) vs hand-rolled, per SPEC}

## Accessibility commitments
{WCAG 2.1 AA specifics: keyboard, focus, contrast, semantics, reduced-motion}

## Modern reference direction
{what current well-designed products this should feel like, and why}

## Mockups
{paths under .forge/ui-mockups/ , or "spec-only (simpler UI)"}

## Departures from stated preference (if any)
{anything the panel recommends changing from the user's interview answer, + rationale — for the gate}

## Open questions
{anything to confirm at the plan-approval gate}
```

## Hand to the plan & approval gate

UI-DESIGN.md (and any mockups) feed `phases/3-plan.md`: the plan sequences the UI build from it (design
tokens + base components **before** screens). The **UI direction is presented together with the plan at
the approval gate** — the user signs off or tweaks it there; there is **no separate UI stop**. Any
"departures from stated preference" are surfaced explicitly for that sign-off. Update FORGE.md (check
②.5, refresh Current position).

**Exit criteria:** UI-DESIGN.md written (+ mockups in `.forge/ui-mockups/` if visual-heavy); panel
converged on a design that meets the UI Acceptance Checklist; anchored to SPEC scope; departures flagged for the gate. →
`phases/3-plan.md`.
