# Phase ① — Interview

**Goal:** Leave this phase with zero grey areas. Produce `SPEC.md` — locked decisions precise enough
that research, planning and the whole autonomous build can proceed without re-asking the user.

> Every mid-run stop is a question this phase should have asked. Ask it now — or settle it with a
> recommended default the user confirms — so the rest of the pipeline can run in one shot.

**Inputs:** the user's idea (from `$ARGUMENTS` or the routing prompt), any existing code in the repo.

---

## 1. Set depth

If depth isn't already chosen, ask with `AskUserQuestion`: **quick / standard / deep** (see
`<depth_levels>` in SKILL.md). Record it in FORGE.md.

**Also pick economy** (see `<token_economy>` in SKILL.md): in the same `AskUserQuestion` batch, offer
**balanced / economy** — default balanced; recommend economy when the user wants to minimize token/cost
spend. Record it in FORGE.md too. (Economy changes *how* the pipeline spends tokens, never *what* it
does — every phase, the research gate, per-step verification, the test suite, security, adversarial
testing, and the final sweep still run.)

**Hardening level** (see `<hardening>` in SKILL.md) — the intensity of the automated adversarial
find→fix→re-check loop in ⑥/⑦/⑧ — **defaults from depth** (quick→basic, standard→standard,
deep→comprehensive), so you don't need to ask. Honor an explicit request to raise it (e.g. "harden
comprehensively" / "really hunt for bugs"). Record it in FORGE.md.

**Tests are always on** — there's no "tests yes/no" question. The layers follow the form factor (§5).

Scale the number and follow-up depth of the
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
  - **CI** — add a workflow that runs lint, typecheck and the full test suite on every push and PR
    (recommended).
- **Check prerequisites:** run `gh auth status` and `git --version`. If `gh` is missing or
  unauthenticated, say so and fall back to git-only (or pause only if they specifically need GitHub now).

Record the decision under "Version control" in SPEC. The actual `git init` / `gh repo create` happens at
the **start of the Build phase** (so history begins with real scaffold); `.forge/` is git-ignored by
default — offer to track it if they'd rather version the planning trail.

## 3. Interview — eliminate grey areas

Ask **adaptive** questions, mostly via `AskUserQuestion` with curated, recommended-first options.
Batch related questions (up to four per call).

Work from **`references/question-bank.md`**: the universal list, the section for this form factor, and
the grey-area hotspots. It's your checklist, not a script — infer what you can, put a recommended default
on the defaults sheet (§4) for the small things, and ask the user only what genuinely needs them. Follow up on any vague answer. **Offer concrete recommendations** rather than
open-ended "what do you want?" — especially for tech and UI, where the user often wants you to propose.

Stay agentic even here: **decide anything you can sensibly default or infer, and ask only what genuinely
needs the user.** This is intake — the designated place to gather clarity — not an interrogation. The
chosen depth controls how far to probe; it does not license asking what you could reasonably decide.

Cover these dimensions (scaled by depth; skip any that are truly N/A, e.g. UI for a CLI library):

1. **Problem & users** — What does it do? Who is it for? What does success look like? Write each
   success criterion as *Given / When / Then* — each becomes an automated acceptance test. If you can't
   picture the test, it isn't a criterion yet; keep asking.
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
   These answers are the **anchor for the UI Design pass (②.5)** — a design panel builds the best modern UI
   *within* them, so gather references and preferences well here.
9. **Constraints** — Performance/scale targets, deadlines, budget, hosting/deploy target, offline,
   compliance/privacy (PII, auth requirements).
10. **Known risks & unknowns** — Anything the user already worries about or is unsure how to do.
11. **Behaviour rules & edge-case policy** — validation, limits, error behaviour, duplicates, deleting
    things with dependents, concurrent edits, empty states, time zones, precision, who sees what. Don't
    ask these one by one — they go on the defaults sheet.

## 4. Defaults sheet — settle the small things in one go

Gather every decision you'd otherwise make silently — the hotspot defaults from the question bank,
inferred choices, conventions — into one concise list, each with your recommended default. Show it once
(`AskUserQuestion`: **Accept all** / **Change some — tell me which**). Accepted defaults go into SPEC
under *Decisions made on your behalf*. This turns dozens of would-be mid-build guesses into a single
confirmation.

## 5. Build readiness — so the run never stops for you

Settle everything the autonomous run will need (question bank → *Build readiness*):
- **External services** — for each: real credentials now (the user puts values in `.env`; you'll write
  `.env.example`), a sandbox/test key, or a mock/fake behind a clear seam. Decide now, record in SPEC.
- **Tooling preflight** — run the version checks for what the stack needs (runtime, package manager,
  database/containers, a browser driver for UI tests). Missing? Install it now with an OK, or pick an
  alternative now — not mid-build.
- **Standing authorisations** for routine build actions: installing dependencies, creating and migrating
  local dev databases, running local servers, commits and pushes on the agreed cadence. Deploys,
  production data, paid services and destructive git operations still always ask.
- **Test data** — sample inputs, seed data, example files, edge-case fixtures.
- **Testing & CI** — unit + integration always; end-to-end for UIs (browser automation), APIs (real
  HTTP) and CLIs (the built binary); property-based tests wherever there's parsing or calculation logic.
  Ask only about preferences (a specific framework) and confirm CI.

## 6. Maintain a Grey-Area Ledger

As you go, track every unresolved ambiguity. **Do not exit this phase while the ledger has unresolved
items.** Each item must end as either:
- **Resolved** — the user made a decision, or
- **Deferred (assumption)** — explicitly recorded in SPEC's Assumptions section with the assumption
  you'll proceed on, so it's visible and can be revisited.

For `deep`, keep probing with follow-ups until you genuinely cannot find another meaningful ambiguity.

**Pre-mortem before you close.** Walk the build in your head: for each in-scope feature, trace the golden
path and its main failure path end to end, and note every decision you'd have to guess. Each guess is a
ledger item — resolve it or record it. Then ask yourself: *if this shipped and the user was disappointed,
what's the most likely reason?* If the answer is a decision nobody made, make it now.

## 7. Write SPEC.md and confirm

Fill the template below into `.forge/SPEC.md`. Then show the user a concise summary and confirm it
matches their intent. In the same `AskUserQuestion` batch, ask the **run mode** (SKILL.md `<autonomy>`):
*Review the plan first* (recommended) · *Unattended — build straight through to done*. Record it in
FORGE.md. Update FORGE.md: check ① in the ledger, set Status → `research`, update Current position.

```markdown
# SPEC — {title}

## Problem & users
{what it does, who it's for}

## Success criteria
{each becomes an automated acceptance test and a final-sweep check}
- [ ] AC-1 — Given {context}, when {action}, then {observable result}

## In scope (v1)
- {feature}

## Behaviour rules & edge-case policy
- {rule — e.g. "a duplicate email is rejected with a field error; nothing is created"}

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

## Testing & CI
- Layers: {unit · integration · e2e ({tool}) · property-based ({where})}
- CI: {yes — workflow on push + PR | no}

## Build readiness
- External services: {service → real credentials in .env | sandbox key | mock/fake}
- Tooling verified: {runtime x.y, package manager, database, browser driver…}
- Standing authorisations: {dependencies, local DB + migrations, local servers, commits/pushes}
- Test data: {fixtures, seed data, sample files}

## Decisions made on your behalf
- {each default accepted on the defaults sheet}

## Assumptions (deferred grey areas)
- {assumption we're proceeding on, and what would change if it's wrong}

## Open risks to investigate in research
- {thing to verify}
```

**Exit criteria:** SPEC.md written; every success criterion testable (Given/When/Then); defaults sheet
confirmed; build readiness settled (credentials or mocks, tooling, authorisations, test data); pre-mortem
done and the grey-area ledger empty (resolved or recorded as assumptions); user confirmed; run mode and
FORGE.md updated. → Proceed to `phases/2-research.md`.
