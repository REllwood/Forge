# Forge — Build standards

The quality bars forge holds every build to. Apply them **proportionally**: match rigor to the project's
scale and the SPEC (a CLI tool ≠ a multi-tenant SaaS). Sound structure is always required; gold-plating
is not. These guide quality, not ceremony — they never override the "don't over-build" guardrail.

When available, lean on the specialists: `engineering:architecture`, `engineering:system-design` for
architecture; `design:design-system`, `design:design-critique`, `design:accessibility-review`,
`anthropic-skills:theme-factory`, and the Shadcn UI tools for UI/design.

---

## Architecture
- **Separation of concerns / layering.** Keep presentation, business/domain logic, and data access in
  distinct modules. UI doesn't embed business rules; data access doesn't leak into views.
- **Clear boundaries & dependency direction.** Dependencies point toward the domain, not outward. No
  circular dependencies. Each module has one reason to change (single responsibility).
- **Program to interfaces at real seams** — where it aids testing or swapability. Not speculative
  abstraction for its own sake.
- **Deliberate state management.** Centralize shared state where it matters; avoid hidden global mutable
  state and prop-drilling sprawl.
- **Config & secrets** come from env/config, never hardcoded; secrets never committed.
- **Error handling at boundaries** (I/O, external APIs, user input). Fail loud internally; degrade
  gracefully at the edges. No silently swallowed errors.
- **Data layer.** Validate at the boundary; use migrations for schema changes; parameterize queries —
  never interpolate untrusted input.
- **Testability.** Keep pure logic separable from I/O; make dependencies injectable.
- **Consistency.** One convention per concern, applied everywhere. In an existing codebase, match its
  patterns rather than introducing parallel ones.
- **Right-sized.** Pick the simplest architecture that satisfies the SPEC's scale and non-goals. Walking
  skeleton first, then grow. No layers/patterns/services the scope doesn't warrant.

## UI — anything with a user interface
- **Accessibility (target WCAG 2.1 AA).** Semantic HTML; full keyboard operability with visible focus
  states; text contrast ≥ 4.5:1; labelled inputs; alt text; ARIA only where native semantics fall short;
  honour `prefers-reduced-motion`.
- **Responsive.** Mobile-first, fluid layouts, sensible breakpoints; nothing that breaks on small screens.
- **Design every state**, not just the happy path: loading (skeletons/spinners), empty, error
  (clear + recoverable), success. Handle async explicitly.
- **Performance.** Lazy-load heavy/below-the-fold assets; avoid layout shift; keep bundles lean.
- **Feedback & affordance.** Every action acknowledges itself; buttons show loading/disabled states;
  destructive actions are confirmed.
- **Forms.** Inline validation, clear errors, correct input types, sensible defaults, logical focus order.

## Design — visual craft
- **Tokens, not magic values.** Define and reuse a scale for color, spacing, typography, radius, shadow.
  (Use `theme-factory` / a design-system approach; with Shadcn, theme via tokens.)
- **Visual hierarchy.** Size, weight, color, and spacing direct the eye to what matters first.
- **Typography.** A small, harmonious set of sizes/weights; comfortable line-height for body; ~45–75
  characters per line; ≤ 2 font families.
- **Spacing & alignment.** Consistent spacing scale; align to a grid; use whitespace deliberately —
  crowding kills clarity.
- **Color.** Restrained palette with an intentional, accessible accent; never encode meaning by color
  alone; consistent semantic colors (success/warning/error).
- **Consistency & restraint.** Reuse components; avoid one-off styles; motion is purposeful and quick
  (~150–250ms), never gratuitous.
- **Polish to the references** the user named in SPEC — aim for a coherent, intentional product, not a
  template dump.

## Platform-specific UI (the design panel adapts to the form factor)
- **Web** — responsive/mobile-first with sane breakpoints; fast first paint, no layout shift;
  SEO-friendly semantics; works for pointer **and** touch; respect browser back/forward.
- **Mobile** — touch targets ≥ 44px; thumb-reachable primary actions; safe areas/notches; platform
  conventions (iOS HIG / Material); gestures + native navigation; offline / poor-network states.
- **Desktop** — keyboard shortcuts, comfortable density, multi-pane layouts, menus, window states.
- **Game / HUD** — diegetic vs. overlay UI; controller + KB/M input; readability over flourish; a strict
  performance budget; satisfying feedback ("juice") that never obscures play.
- **TUI / CLI** — terminal constraints, color-safe palettes, keyboard-only flows, graceful narrow widths.

## UI Acceptance Checklist — the definition of "done" for any UI
A UI is not finished until it **passes every item**. The designer designs to this list, the panel signs
off against it (②.5), and the build + final sweep **verify it and loop-fix until it passes** (anything
still open after the cap is recorded as a known limitation). **Check, don't assume.**

- [ ] **Modern** — current visual language matching the SPEC references; cohesive design-token system
      (color/type/spacing/radius/shadow/motion) applied consistently; not dated or templated.
- [ ] **Responsive** — verified at real breakpoints — mobile ~375px, tablet ~768px, desktop ~1280px+:
      no overflow, clipping, or broken/overlapping layout; mobile-first; works for touch **and** pointer.
- [ ] **Accessible (WCAG 2.1 AA)** — semantic HTML; full keyboard operability with visible focus; contrast
      ≥ 4.5:1 (≥ 3:1 large text/UI); labelled inputs; alt text; ARIA only where needed; honors
      `prefers-reduced-motion`.
- [ ] **All states** — every view has loading, empty, error, and success states; async handled visibly.
- [ ] **Feedback & affordance** — every action acknowledges itself; loading/disabled states; destructive
      actions confirmed; forms have inline validation, clear errors, correct input types.
- [ ] **Performance** — no layout shift; heavy/below-fold assets lazy-loaded; lean bundle; fast first paint.
- [ ] **Polish** — clear visual hierarchy; consistent spacing/alignment to a grid; restrained palette +
      intentional accent; ≤ 2 font families, comfortable measure; purposeful motion (~150–250ms); coherent
      iconography; no misalignment / inconsistent radii / magic values.
- [ ] **Platform-fit** — meets the platform-specific bars above (web / mobile / desktop / game / TUI).

---

## How the phases use this file
- **Interview** — ask informed UI/design/architecture questions; propose good, accessible defaults.
- **UI Design (②.5, if UI)** — the design panel (`forge-ui-designer` + `forge-frontend-engineer` +
  `forge-ui-artist`) proposes the best modern UI *within* the user's scope, captured in `UI-DESIGN.md`.
- **Plan** — sequence steps to establish the architecture early (scaffold layers; set up design tokens
  and base components before features).
- **Build** — implement to these bars; each UI step gets a quick render check, and completed screens are
  checked against the UI Acceptance Checklist (responsive + accessibility included) at phase checkpoints.
- **Final sweep** — review the result against this file: architecture soundness plus a design + a11y pass.
