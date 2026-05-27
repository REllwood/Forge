# Phase ② — Research & grounding

**Goal:** Ground every assumption in SPEC against current reality before a single line is planned.
Catch deprecations, breaking changes, feasibility problems, and better options now — not mid-build.
Produce `RESEARCH.md` and a user-facing **"Findings that need your attention"** gate.

**Inputs:** `.forge/SPEC.md` (especially Tech stack, Integrations, and "Open risks to investigate").

> Core principle in play: **Ground everything in reality.** Do not rely on training memory for version
> numbers, API shapes, or "current best practice." Verify against primary sources dated recently.

---

## 1. Build the research question list

From SPEC, enumerate what must be verified. Typically:
- For each **library/framework**: current stable version, release date, any deprecations or breaking
  changes affecting our use, known bugs/gotchas, maintenance health, license.
- For each **external API/service**: current endpoints/methods we'll use, auth model, rate limits,
  pricing tier limits, recent deprecations, whether the specific methods in our design still exist.
- **Feasibility** of the overall approach and any novel/uncertain part.
- **Better alternatives** to any choice that looks risky, unmaintained, or ill-fitting.
- For **existing codebases**: reusable patterns, conventions, and assets we must align with.

## 2. Spawn research in parallel (scale by depth)

Delegate to subagents so the main context stays clean. Launch independent investigations
**concurrently** (one message, multiple `Agent` calls):

- **Existing-codebase research** → `Explore` agent: "find how X is done here, conventions, reusable
  modules, where new code should live." (Skip if greenfield.)
- **External/tech research** → `forge-researcher` agent(s), one per cluster of related questions (falls
  back to `general-purpose` if unavailable). Each verifies versions/deprecations/feasibility against
  **primary sources** (official docs, changelogs, release notes, GitHub issues, advisories) and returns
  current facts, version pins, gotchas, and recommended adjustments with dated source URLs. Pass it the
  SPEC items and the questions to check.
- **Authoritative library docs** → use `mcp__context7__*` (resolve-library-id, then query) for precise,
  version-correct API documentation where available.

Depth scaling: `quick` = one combined pass; `standard` = a few parallel agents; `deep` = thorough
multi-agent investigation with cross-checking of conflicting sources.

Instruct every research agent to **report under a word cap** with structured findings + sources, and to
flag explicitly anything that contradicts SPEC's assumptions.

## 3. Synthesize into RESEARCH.md

Write `.forge/RESEARCH.md` (template below). Pin concrete versions. Convert findings into either
confirmations of SPEC or proposed adjustments.

## 4. HARD GATE — surface findings that need a decision

This is the "come back to the user" requirement — applied agentically. **Resolve trivial findings
yourself** (an obvious best option, low stakes) and just note them in RESEARCH.md. **Stop and present
before planning only for *material* forks** — real tradeoffs, cost/feasibility/security implications, or
a contradiction of a decision the user owns. Examples that trigger the gate:
- A method/endpoint/library in SPEC is **deprecated or removed**.
- A **breaking change** between the version they expect and current.
- A **materially better** library/approach exists.
- A choice has a **licensing, cost, security, or feasibility** problem.
- Research **contradicts** a SPEC assumption.

Present these via `AskUserQuestion` (recommended option first, with the rationale). Apply their decisions
back into `SPEC.md` (amend the locked choices) and note them in RESEARCH.md. If research surfaced
nothing notable, say so in one line and proceed — but never skip the check.

Update FORGE.md: check ②, Status → `plan`, refresh Current position.

```markdown
# RESEARCH — {title}

## Summary
{2–4 sentences: is the approach sound as specced? what changed?}

## ⚠ Findings that need your attention
{the gate items — what, why it matters, recommendation. Empty? say "none — assumptions held."}

## Verified tech & versions
| Thing | Verified version / status | Notes | Source (dated) |
|-------|---------------------------|-------|----------------|

## Gotchas & pitfalls
- {thing to watch for during build}

## External APIs
- {service}: methods we'll use, auth, limits, anything deprecated

## Existing-codebase findings    ← omit if greenfield
- Conventions to follow:
- Reusable assets:
- Where new code goes:

## Decisions applied to SPEC
- {what the user decided at the gate, and the SPEC edit made}

## Sources
- {url — what it confirmed — date checked}
```

**Exit criteria:** RESEARCH.md written, every SPEC assumption either confirmed or revised, findings gate
presented and resolved, FORGE.md updated. → Proceed to `phases/3-plan.md`.
