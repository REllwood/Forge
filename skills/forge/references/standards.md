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

---

## How the phases use this file
- **Interview** — ask informed UI/design/architecture questions; propose good, accessible defaults.
- **Plan** — sequence steps to establish the architecture early (scaffold layers; set up design tokens
  and base components before features).
- **Build** — implement to these bars; UI step verification includes responsive + accessibility checks.
- **Final sweep** — review the result against this file: architecture soundness plus a design + a11y pass.
