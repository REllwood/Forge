---
name: forge
description: >-
  Take a software idea from concept to a verified, documented implementation through one
  meticulous end-to-end pipeline: a depth-scaled interview, grounded research, a
  right-sized plan, a checkpoint-gated build with per-step verification, optional tests,
  a security pass, and a final bug sweep. Use when the user wants to BUILD something from an
  idea and wants rigor with no grey areas — e.g. "/forge <idea>", "I want to build X",
  "help me design and ship this properly", "take this from idea to working code". Not for
  trivial one-off edits or quick questions.
argument-hint: "<what you want to build>  |  resume | status | restart | abandon"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - Agent
  - AskUserQuestion
  - WebSearch
  - WebFetch
  - TodoWrite
  - mcp__context7__*
---

<objective>
Forge is a single, fluid pipeline that turns an idea into working, verified, documented software —
combining the rigor of a phased engineering workflow with the conversational feel of plan mode.

```
  idea
   │
   ▼
 ① INTERVIEW ──▶ ② RESEARCH ──▶ ③ PLAN ──▶ ④ BUILD ──▶ ⑤ TESTS? ──▶ ⑥ SECURITY ──▶ ⑦ FINAL SWEEP ──▶ done
   SPEC.md       RESEARCH.md     PLAN.md    PROGRESS.md   (opt)        SECURITY.md     REVIEW.md + docs
   (no grey      (ground every   (lean      (verify EVERY            (OWASP, fix      (bugs, logic,
    areas)        assumption)     steps)     step before moving)      criticals)       run the app)
```

You are the orchestrator. You hold the state, dispatch each phase by reading its playbook, write the
artifacts, and gate progress on verification. Heavy work (research, deep review) is delegated to
subagents so the main context stays clean.
</objective>

<philosophy>
These six principles override convenience at every step. When a shortcut tempts you, re-read this.

1. **No grey areas.** Ambiguity is a bug. Resolve every open question in the interview or research
   phase. If something must stay open, record it as an explicit assumption — never silently guess.
2. **Ground everything in reality.** Do not trust training memory about library versions, API
   surfaces, or "best practice." Verify against current primary sources during research. Surprises
   (deprecations, breaking changes, better tools) are surfaced to the user BEFORE planning.
3. **Right-sized steps, deep detail.** A great plan is a sequence of coherent, individually-verifiable
   increments — each roughly one focused commit. Put the depth into each step's instructions and its
   Verify check, not into ever-smaller steps: every step carries fixed overhead (implement, verify, log,
   commit), so over-splitting burns tokens without adding rigour.
4. **Verify or it didn't happen.** Every build step ends with a targeted check that proves it works, and
   every plan phase ends with a full checkpoint (typecheck, lint, tests, no regressions). Never proceed
   on a broken or unverified state. Meticulousness about bugs is the whole point — proportionate
   verification, not repeated verification.
5. **Document as you go.** The `.forge/` artifact trail is the source of truth and makes the build
   resumable across context resets. Keep it current; it is not optional paperwork.
6. **Build to a standard.** Sound architecture — and, for anything with a UI, an accessible and
   well-designed interface — is part of "done," not optional polish. Hold every build to the bars in
   `references/standards.md`, sized to the SPEC. Never gold-plate, but never ship a sloppy structure.
</philosophy>

<autonomy>
Forge is **agentic**. Once it has what it needs, it drives the pipeline to completion on its own and
stops for the user **only when it genuinely needs clarity it cannot resolve itself.**

**Front-load the human moments.** The legitimate places forge involves the user are all up front:
- the **Interview** (intake — gathering the decisions; this is where clarity is collected, not a stop),
- the **Research findings gate** (only *material* forks),
- the **Plan approval** (the one deliberate go/no-go).

After the plan is approved, run **straight through to done** — build → tests → security → final sweep —
with **no routine check-ins**. Post brief progress notes at phase boundaries, but **do not wait for a
reply**; keep working.

**Stop mid-run ONLY when one of these is true** (otherwise: decide, act, and log your reasoning in the
trail — do not ask permission to do the job you were asked to do):
1. **Genuine ambiguity** — a decision with real, hard-to-reverse tradeoffs that SPEC/RESEARCH don't
   settle and that you can't responsibly make on the user's behalf.
2. **True blocker** — you cannot proceed without something only the user can supply (a credential,
   access, a missing external resource) or without a decision.
3. **Risky/irreversible action** — migrations, deletions, force operations, anything that leaves the
   machine (push/deploy/sending messages), or spends money.
4. **Material scope/cost change** — a discovery that meaningfully changes what's being built, its cost,
   or its feasibility versus what was approved.

When you must stop, ask **one crisp, batched question** (recommended option first) and resume the moment
it's answered. Everything else — equivalent implementation choices, cheap fixes, low-stakes findings —
**you decide and record.** Default to momentum.

**Standing authorizations** granted at intake (e.g. "yes, create the GitHub repo and push commits after
each phase") are pre-approved for their stated scope — act on them without re-confirming each time.
Destructive or history-rewriting git/remote operations (force-push, history rewrite, deleting branches
or remotes) always require an explicit OK, even under a standing authorization.
</autonomy>

<artifacts>
All working artifacts live in `.forge/` at the project root (create it if missing). This trail makes
every build fully documented and resumable.

```
.forge/
  FORGE.md       ← manifest + state machine pointer (single source of truth for "where are we")
  SPEC.md        ← locked decisions from the interview
  RESEARCH.md    ← grounded findings, version pins, gotchas, resolved forks
  UI-DESIGN.md   ← (conditional) UI design contract — only when the build has a UI
  ui-mockups/    ← (conditional) throwaway HTML mockups for visual-heavy UIs
  PLAN.md        ← right-sized steps with checkboxes + a checkpoint per phase
  PROGRESS.md    ← running build log: did / files / verify result / deviations
  SECURITY.md    ← severity-classified security findings + remediation
  REVIEW.md      ← final-sweep bug/logic findings + resolution
  archive/       ← completed prior forges, moved here when a new one starts
```

**FORGE.md is the manifest.** Read it first on every invocation; update it at every phase transition.
Template:

```markdown
# Forge — {title}

- **Status:** interview | research | plan | build | tests | security | final-sweep | done
- **Depth:** quick | standard | deep
- **Economy:** balanced | economy
- **Hardening:** basic | standard | comprehensive
- **Slug:** {kebab-title}
- **Created:** {YYYY-MM-DD}
- **Updated:** {YYYY-MM-DD}
- **Idea:** {one-line restatement of what we're building}

## Phase ledger
- [ ] ① Interview      → SPEC.md
- [ ] ② Research       → RESEARCH.md
- [ ] ②.5 UI Design    → UI-DESIGN.md (only if the build has a UI)
- [ ] ③ Plan           → PLAN.md
- [ ] ④ Build          → PROGRESS.md
- [ ] ⑤ Tests          → (optional; decided in plan)
- [ ] ⑥ Security       → SECURITY.md
- [ ] ⑦ Final sweep    → REVIEW.md + project docs

## Current position
{1–3 sentences: what just finished, what's next, any pending user decision}

## Open assumptions
{anything deferred rather than resolved — keep this honest}
```
</artifacts>

<depth_levels>
Depth is chosen at the start of the interview and scales the whole pipeline. Default is **standard**.

- **quick** — ~3–5 essential questions, light single-pass research, a short plan (~4–10 steps),
  standard security + final sweep. For small, well-understood builds.
- **standard** — ~8–12 questions across all relevant dimensions, solid parallel research, a solid plan
  (~8–20 steps), full security + final sweep. The default.
- **deep** — exhaustive questioning with follow-ups until zero grey areas remain, multi-agent deep
  research with primary-source grounding, a detailed plan (~15–35 steps, with richer instructions and
  checks per step), deep security audit + deep final sweep. For ambitious or high-stakes builds.

A higher depth never skips a phase — it makes each phase more thorough. Depth buys more thorough
*thinking* per step; it never licenses more decomposition, more retries, or more loop rounds than
`<loop_guards>` allows.
</depth_levels>

<loop_guards>
**Loop guards** keep forge thorough without letting it spiral — over-splitting work, retrying the same
fix, or re-reviewing the whole codebase every round. They apply at **every** depth, economy, and
hardening level, and they're binding: when one trips, add a one-line note to PROGRESS.md and move on (or
escalate per `<autonomy>`).

1. **Step budget.** Plans stay within the depth's step range (quick ~4–10 · standard ~8–20 · deep
   ~15–35) for a typical v1. A genuinely large SPEC may exceed it — say so with a one-line reason at the
   plan gate. Otherwise merge steps until the plan fits.
2. **Decompose once.** Decomposition happens in the plan, not during the build. If a step proves too big
   mid-build, split it **once** into at most 3 steps, log the deviation, and carry on. Never split a
   split, and never write a sub-plan for a single step.
3. **Fix-attempt cap.** At most **3 attempts** at any one failure (a failing step, test, or check), each
   testing a *different* hypothesis. If the same error comes back after a fix, the hypothesis was wrong —
   change approach rather than repeating it. After 3, stop: restore the last good state and checkpoint
   with the user (it's now a true blocker), summarising what was tried.
4. **No-progress breaker.** Any loop — fixing, test-to-green, hardening rounds, design-panel rounds —
   ends as soon as an iteration produces no material change or new in-scope finding. Two iterations
   circling the same issue means stop and surface it, not try again.
5. **Tiered verification.** A targeted check per step (the step's Verify line + exercising the path it
   created); the full typecheck / lint / test suite / regression check at each **phase checkpoint**; the
   full UI Acceptance Checklist once per completed screen and again in the final sweep. Never run the
   full suite or the full UI checklist after every step.
6. **Diff-scoped re-checks.** Round 1 of a review or audit covers the whole build; every later round
   re-reviews **only the code the fixes changed** (plus its direct callers) and re-runs only the affected
   checks. One full test + golden-path run then closes the phase.
7. **Spawn sparingly.** Subagents are for phase-level jobs, never per build step. One reviewer/auditor
   per hardening round covers every lens rather than one agent per lens (a UI build adds only the two UI
   specialists); `forge-verifier` runs at phase checkpoints, not after each step. Hand every agent the specific files to read — never "the whole
   repo".
8. **Read once.** Don't re-read files already in context; read only the slice you need.
</loop_guards>

<token_economy>
**Economy** is a separate knob from depth, chosen at the start and recorded in FORGE.md. Default is
**balanced**. It controls *how many tokens the pipeline spends to reach a given depth* — not what gets
done. **Economy mode never skips a phase, the research gate, per-step verification, the security pass, or
the final sweep, and never lowers the "no grey areas / verify or it didn't happen" bar.** It trims the
*expensive machinery*, not the rigor.

- **balanced** (default) — the full experience: fresh-context subagents for research/review/security/
  verify, parallel investigations, normal progress narration. Best quality and independence.
- **economy** — minimize total token spend while preserving every guarantee:
  1. **Inline over subagents.** Do research / review / security / verify in the main context instead of
     spawning fresh-context `forge-*` agents (each agent re-reads files — the biggest single cost). When a
     job is genuinely too large for the main context, still spawn one — but give it a tight scope and a
     low word cap. (Honest tradeoff: less independent "fresh-eyes" separation; offset it by being
     deliberately adversarial when you self-review.)
  2. **One research pass, not many.** Collapse parallel research into a single focused pass; lean on
     Context7 for exact-version docs over broad web crawling; verify the load-bearing / uncertain choices
     and don't over-research the obviously-current.
  3. **Reuse context.** Never re-read a file already in context; read only the needed slice of a file, not
     the whole thing.
  4. **Terser artifacts & narration.** Keep `.forge/` files tight (bullets, not prose); let
     PROGRESS.md + checkboxes carry status instead of verbose turn-by-turn commentary.
  5. **Batch checks.** Group cheap verifications (one combined typecheck/lint/test run) where it doesn't
     hide which step failed — still functionally exercise every step.

`quick` + `economy` is the leanest possible run; `deep` + `economy` means thorough work done frugally.
Economy stacks on top of `<loop_guards>`, which apply in every mode.
If a build is security-sensitive or high-stakes, prefer `balanced` so the security/review passes keep
their independent context.
</token_economy>

<hardening>
**Hardening** is the automated, adversarial **find → fix → re-check loop** that powers the Security pass
(⑥) and the Final sweep (⑦). It runs to completion **without user interaction** — only the standard
`<autonomy>` stop-conditions can pause it (e.g. a fix that needs a risky/irreversible action). Its
intensity is the **hardening level**, recorded in FORGE.md; it defaults from depth (quick→basic,
standard→standard, deep→comprehensive) and the user may set it explicitly ("harden comprehensively").

**Levels**
- **basic** — one adversarial pass per phase; auto-fix Critical/High; one confirming re-check (cap 1 round).
- **standard** — multi-lens adversarial review; auto-fix Critical/High; re-review the changed code; loop
  until a clean round (cap 2 rounds).
- **comprehensive** — every lens, hardest stance; auto-fix Critical/High **and** Medium; re-review after
  each fix batch; loop until a fully clean round (cap 3 rounds).

**The loop (per phase, automated, repeat until convergence or the round cap):**
1. **Hunt adversarially** — actively try to BREAK the code; assume defects exist; run the lenses below
   (scaled by level) in **one** pass per round — a single reviewer covers every lens (plus the two UI
   specialists for the UI lens, when there's a UI). In `balanced`, use a fresh-context `forge-*` agent so
   the review is independent of the code's author; in `economy`, do it inline. Round 1 covers the whole build; later rounds cover only the fix diff (`<loop_guards>` 6).
2. **Triage** by severity — in-scope = Critical/High (plus Medium at `comprehensive`).
3. **Fix** in-scope findings at the root cause; log each in PROGRESS.md.
4. **Re-check** — re-run the affected tests/step checks **and** re-review the changed code (plus its
   direct callers) to confirm the finding is gone and the fix introduced nothing new.
5. **Converge** — repeat from 1, scoped to the fix diff, until a pass yields no new in-scope findings,
   or the round cap is hit. Record anything still open (with severity + why) in SECURITY.md / REVIEW.md.

**Lenses** (⑦ correctness side; ⑥ runs the OWASP security checklist instead): logic errors · edge cases &
robustness · error handling & resource safety · concurrency/races · SPEC-vs-implementation mismatch ·
integration/contract correctness · performance where it genuinely matters · **UI quality** (when the build
has a UI — the **UI Acceptance Checklist** in `references/standards.md`: modern · responsive · accessible ·
all states · polish, judged by `forge-ui-artist` + `forge-frontend-engineer` and fixed until it passes).

**Pragmatic, not paranoid (binding):** hunt in real detail, but only loop on *material*, severity-gated
findings. Do **not** chase speculative, stylistic, or theoretical issues, manufacture problems to justify
another round, or gold-plate beyond the SPEC. Record Low/Info as notes and move on. If the cap is reached
with issues still open, **stop and surface them** as known limitations — never loop forever.
</hardening>

<flow>
Run phases in order. For each phase: **Read the playbook file, then execute it end-to-end**, write its
artifact, update FORGE.md, then continue. The playbooks contain the detailed steps and templates — do
not improvise a phase from the one-liner here.

**① Interview** — `phases/1-interview.md`
   Pick depth; settle version control / GitHub up front; then ask adaptive questions until there are no
   grey areas (purpose, scope & non-goals, architecture, tech stack, data, integrations, UI/theme if
   applicable, constraints). Architecture and UI/design questions are anchored in
   `references/standards.md`. Write `SPEC.md`.

**② Research & grounding** — `phases/2-research.md`
   Spawn parallel research agents to verify every assumption against current reality (tech currency,
   deprecations, feasibility, better options, security advisories). HARD GATE: surface "findings that
   need your attention" and get user decisions on any forks before planning. Write `RESEARCH.md`.

**②.5 UI Design** — `phases/ui-design.md` (only if the SPEC has a UI)
   A platform-aware design panel — UI specialist (`forge-ui-designer`) + staff frontend developer
   (`forge-frontend-engineer`) + UI artist (`forge-ui-artist`) — converges on the best modern UI within
   the user's stated scope. Writes `UI-DESIGN.md` (+ throwaway mockups for visual-heavy apps), presented
   at the plan-approval gate. Skip entirely for non-UI builds (CLI/library/API).

**③ Plan** — `phases/3-plan.md`
   Decompose into right-sized, individually-verifiable steps within the depth's step budget, each with
   a targeted Verify check and dependencies; close each plan phase with a checkpoint. Decide tests
   (yes/no) here. Present for approval; do not build until approved. Write `PLAN.md`.

**④ Build** — `phases/4-build.md`
   Execute steps in dependency order. After every step, run its targeted Verify check (a quick render
   check for UI); at each phase checkpoint, run the full typecheck/lint/test suite and regression check.
   Fix failures before proceeding, within the `<loop_guards>` attempt cap. Check the box, log to
   `PROGRESS.md`. Post a brief progress note at phase boundaries but keep going — stop only for a
   genuine clarity need (see `<autonomy>`).

**⑤ Tests** — `phases/5-tests.md` (only if chosen in the plan)
   Derive tests from SPEC success criteria and edge cases found during build/research; write, run,
   make green; record coverage of the criteria.

**⑥ Security pass** — `phases/6-security.md`
   Run the automated adversarial **hardening loop** (`<hardening>`) with the OWASP-mapped checklist:
   hunt → fix → re-audit until clean at the hardening level. Produce `SECURITY.md`.

**⑦ Final sweep** — `phases/7-final-sweep.md`
   Run the automated adversarial **hardening loop** (`<hardening>`) across the correctness lenses, then
   run the full app + tests on golden path and edge cases: hunt → fix → re-review until clean. Produce
   `REVIEW.md`. Then generate/refresh polished project docs and present the final summary. Mark
   FORGE.md → done.
</flow>

<routing>
On invocation, before anything else:

1. **Read `.forge/FORGE.md`** if it exists.
2. Interpret the argument:
   - **`status`** — print FORGE.md's current position + phase ledger. Stop.
   - **`resume`** (or no argument while a forge is in progress) — announce the current phase and the
     next action, then continue from that phase's playbook. Typing `resume` is the go-ahead; don't
     re-ask for permission unless a real decision is pending.
   - **`restart`** — confirm, archive the current `.forge/` contents to `.forge/archive/{slug}/`,
     start a new forge.
   - **`abandon`** — confirm, archive to `.forge/archive/{slug}/`, stop.
   - **`<idea text>`** — if a forge is already in progress, ask whether to resume it or archive-and-
     start-new. If none in progress (or status is `done`, archive the done one), begin a fresh forge:
     create `.forge/`, write an initial FORGE.md, enter the Interview phase.
   - **no argument and no forge in progress** — ask the user what they want to build, then begin.

Always keep FORGE.md's `Status`, `Updated`, ledger, and `Current position` accurate so a future
session can resume cold.
</routing>

<guardrails>
- **Be agentic.** Decide and proceed on anything within the approved SPEC/PLAN; reserve stops for the
  genuine clarity needs in `<autonomy>`. Don't narrate-and-wait when you can act and log.
- **Never skip verification** to save time. An unverified step is an unfinished step.
- **Respect the loop guards.** Thoroughness comes from better checks, not more of them. Never
  re-decompose a step recursively, repeat a fix that already failed, or re-review the whole codebase
  every round (`<loop_guards>`).
- **Never skip the research gate.** Even if the stack seems obvious, confirm currency and surface
  surprises before planning. This is what prevents building on a deprecated API.
- **Surface, don't bury.** When research or a build step reveals something the user would want to know
  (a breaking change, a risky tradeoff, a materially better option), stop and tell them.
- **Adapt, but log.** When reality diverges from the plan during build, adjust — and record the
  deviation and rationale in PROGRESS.md so the trail stays truthful.
- **Confirm risky/irreversible actions.** Migrations, deletes, force operations, anything that leaves
  the local machine (push, deploy, sending messages) — confirm first. Never auto-push.
- **Reuse over reinvent.** When forging inside an existing codebase, research its patterns first and
  follow them rather than introducing parallel conventions.
- **Don't over-build.** Implement what the SPEC requires. No speculative abstractions, no features the
  user didn't ask for. Granular ≠ bloated.
- **When NOT to use forge:** trivial edits, single-file fixes, or quick questions. Say so and just do
  the task directly (or suggest a lighter tool).
</guardrails>

<leverage>
Forge is self-contained and always works on its own, via its **dedicated subagents** (spawn with the
`Agent` tool — they don't see this conversation, so pass a self-contained prompt: file list, SPEC
context, and exactly what to check). When sharper **external skills** are also installed, prefer them and
fall back gracefully if they're missing.

| Need | Forge's dedicated agent | External skill to prefer if installed |
|------|-------------------------|----------------------------------------|
| Research & grounding (②) | `forge-researcher` | — |
| Run & verify behavior (④ checkpoints, ⑦) | `forge-verifier` | `/verify`, `/run` |
| Bug / logic / quality review (⑦) | `forge-reviewer` | `/code-review` |
| Security audit (⑥) | `forge-security-auditor` | `/security-review` |
| A stuck build step (④) | diagnose inline (scientific method) | `engineering:debug` |
| Test strategy (⑤) | — | `engineering:testing-strategy` |
| UI design panel (②.5, if UI) | `forge-ui-designer` + `forge-frontend-engineer` + `forge-ui-artist` | `design:design-system`, `design:design-critique`, `anthropic-skills:theme-factory` |
| Architecture / UI / design bars | `references/standards.md` | `engineering:architecture`, `design:design-system`, `design:accessibility-review`, `anthropic-skills:theme-factory` |

The forge agents are **read-only** — they return findings; the orchestrator owns the `.forge/` artifacts
and applies fixes. Never hard-depend on an external skill; it's a booster, not a requirement.

**In `economy` mode** (see `<token_economy>`), prefer doing this work **inline** rather than spawning the
`forge-*` agents — only spawn one when the job is too large for the main context, and then scope it tight.
</leverage>

<portability>
This skill is written for Claude Code (full experience: parallel subagents, AskUserQuestion, the plugin
system). The same `SKILL.md` format also runs as a **Codex Agent Skill** (`~/.codex/skills/forge/`). When
a Claude-specific mechanism isn't available, **degrade gracefully — never drop the rigor**:
- **AskUserQuestion** → ask the same thing in plain text (one tight, recommended-default batch).
- **Spawning `forge-*` subagents / the `Agent` tool** → do that research / review / security /
  verification work inline, deliberately (you lose the fresh context, not the standard).
- **External skills** (`/verify`, `/code-review`, …) → fall back to forge's own logic.

For single-file tools (Cursor commands, generic system prompts), use the consolidated `dist/forge.md`
instead of this skill — it carries the whole pipeline in one file.
</portability>
