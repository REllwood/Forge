# Phase ① — Interview

**Goal:** Leave this phase with zero grey areas. Produce `SPEC.md` — locked decisions precise enough
that research and planning can proceed without re-asking the user.

**Inputs:** the user's idea (from `$ARGUMENTS` or the routing prompt), any existing code in the repo.

---

## 1. Set depth

If depth isn't already chosen, ask with `AskUserQuestion`: **quick / standard / deep** (see
`<depth_levels>` in SKILL.md). Record it in FORGE.md. Scale the number and follow-up depth of the
questions below accordingly.

## 2. Orient (silent, ~30s)

Before asking anything, look around so your questions are informed, not generic:
- Is this a fresh project or an existing codebase? `Glob`/`ls` for package manifests, framework config,
  source layout. If existing, you'll follow its conventions — note them.
- Restate the idea in one sentence and infer the obvious (form factor, likely stack) so you can ASK
  about the non-obvious instead of wasting questions.

## Version control & GitHub — settle this first

Before the main interview, ask (via `AskUserQuestion`) how to handle source control:
- **Set up version control?** — *Git + GitHub* (recommended) · *Git only (local)* · *No VCS* · *Use
  existing repo*. Auto-detect first: if a `.git` already exists, default to "use existing" and skip init.
- If **GitHub** is chosen, also capture:
  - **Visibility** — private (recommended) or public.
  - **Push cadence** — after each phase (recommended) · at the end · commits only (user pushes).
  - Confirm this **authorizes forge to create the repo and push on that cadence** without asking again —
    a standing authorization (see SKILL.md `<autonomy>`). Force-push / history rewrites still need an OK.
- **Check prerequisites:** run `gh auth status` and `git --version`. If `gh` is missing or
  unauthenticated, say so and fall back to git-only (or pause only if they specifically need GitHub now).

Record the decision under "Version control" in SPEC. The actual `git init` / `gh repo create` happens at
the **start of the Build phase** (so history begins with real scaffold); `.forge/` is git-ignored by
default — offer to track it if they'd rather version the planning trail.

## 3. Interview — eliminate grey areas

Ask **adaptive** questions, mostly via `AskUserQuestion` with curated, recommended-first options.
Batch related questions. Follow up on any vague answer. **Offer concrete recommendations** rather than
open-ended "what do you want?" — especially for tech and UI, where the user often wants you to propose.

Stay agentic even here: **decide anything you can sensibly default or infer, and ask only what genuinely
needs the user.** This is intake — the designated place to gather clarity — not an interrogation. The
chosen depth controls how far to probe; it does not license asking what you could reasonably decide.

Cover these dimensions (scaled by depth; skip any that are truly N/A, e.g. UI for a CLI library):

1. **Problem & users** — What does it do? Who is it for? What does success look like (concrete,
   testable success criteria)?
2. **Scope & non-goals** — Must-have features for v1. Explicitly capture **non-goals** (what we are
   deliberately NOT building) — this prevents scope creep later.
3. **Form factor & platform** — CLI / web app / API / mobile / desktop / library / script. Target
   environment (browser, Node, OS, cloud).
4. **Architecture shape** — Major components and how data flows between them. Monolith vs. services.
   Sync vs. async. Where state lives. Aim for the sound, right-sized structure in
   `references/standards.md` (separation of concerns, clear boundaries) — propose it; don't make the user
   design it from scratch.
5. **Tech stack** — Language, framework, runtime, database. If the user defers, **propose a specific
   recommended stack with a one-line rationale** and let them confirm or override. (Verify currency in
   research — don't lock versions here.)
6. **Data & persistence** — Key entities/models, storage (DB/files/in-memory), migrations, seed data.
7. **Integrations & external APIs** — Which third-party services/APIs, auth method, rate limits, keys.
8. **UI & design** — *Only if there's a UI.* Reference apps they admire; layout density; **color theme/
   palette** (propose 2–3 concrete, accessible options if they're unsure); typography vibe; component
   library (e.g. shadcn/ui, Tailwind, MUI) or hand-rolled; light/dark; accessibility expectations.
   Anchor questions and defaults in `references/standards.md` (the UI + design bars). The `theme-factory`,
   `design:design-system`, `design:accessibility-review`, and Shadcn UI tools can help here if available.
9. **Constraints** — Performance/scale targets, deadlines, budget, hosting/deploy target, offline,
   compliance/privacy (PII, auth requirements).
10. **Known risks & unknowns** — Anything the user already worries about or is unsure how to do.

## 4. Maintain a Grey-Area Ledger

As you go, track every unresolved ambiguity. **Do not exit this phase while the ledger has unresolved
items.** Each item must end as either:
- **Resolved** — the user made a decision, or
- **Deferred (assumption)** — explicitly recorded in SPEC's Assumptions section with the assumption
  you'll proceed on, so it's visible and can be revisited.

For `deep`, keep probing with follow-ups until you genuinely cannot find another meaningful ambiguity.

## 5. Write SPEC.md and confirm

Fill the template below into `.forge/SPEC.md`. Then show the user a concise summary and confirm it
matches their intent. Update FORGE.md: check ① in the ledger, set Status → `research`, update Current
position.

```markdown
# SPEC — {title}

## Problem & users
{what it does, who it's for}

## Success criteria
{concrete, testable statements — these become test cases and final-sweep checks}
- [ ] {criterion}

## In scope (v1)
- {feature}

## Non-goals
- {explicitly not building}

## Form factor & platform
{CLI / web / API / ... ; target environment}

## Architecture
{components, data flow, state — a short prose description and/or a simple diagram}

## Tech stack
| Layer | Choice | Why |
|-------|--------|-----|
| Language | | |
| Framework | | |
| Storage | | |
| Key libs | | |

## Data model
{entities and relationships}

## Integrations
{external APIs/services, auth, limits}

## UI & design        ← omit if no UI
- Look & references:
- Layout/density:
- Color theme:
- Typography:
- Component approach:
- Light/dark, accessibility:

## Constraints
{perf, scale, deadline, hosting, compliance}

## Version control
{Git+GitHub | git-only | none | existing repo} · visibility {private/public} · push cadence {per-phase/end/manual} · standing push authorization {yes/no}

## Assumptions (deferred grey areas)
- {assumption we're proceeding on, and what would change if it's wrong}

## Open risks to investigate in research
- {thing to verify}
```

**Exit criteria:** SPEC.md written, grey-area ledger empty (resolved or recorded as assumptions), user
confirmed, FORGE.md updated. → Proceed to `phases/2-research.md`.
