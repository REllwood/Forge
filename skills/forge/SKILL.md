---
name: forge
description: >-
  Take a software idea from concept to a verified, documented implementation through one
  meticulous end-to-end pipeline: a depth-scaled interview, grounded research, an
  ultra-granular plan, a checkpoint-gated build with per-step verification, optional tests,
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
   (no grey      (ground every   (tiny      (verify EVERY            (OWASP, fix      (bugs, logic,
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
3. **Small steps, deep detail.** A great plan is many tiny, individually-verifiable steps — not few
   big ones. The more granular the step and the more precise its instructions, the better.
4. **Verify or it didn't happen.** Every build step ends with a concrete check that proves it works.
   Never proceed on a broken or unverified state. Meticulousness about bugs is the whole point.
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
  PLAN.md        ← ultra-granular steps with checkboxes
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
- **Slug:** {kebab-title}
- **Created:** {YYYY-MM-DD}
- **Updated:** {YYYY-MM-DD}
- **Idea:** {one-line restatement of what we're building}

## Phase ledger
- [ ] ① Interview      → SPEC.md
- [ ] ② Research       → RESEARCH.md
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

- **quick** — ~3–5 essential questions, light single-pass research, plan with reasonable granularity,
  standard security + final sweep. For small, well-understood builds.
- **standard** — ~8–12 questions across all relevant dimensions, solid parallel research, granular
  plan, full security + final sweep. The default.
- **deep** — exhaustive questioning with follow-ups until zero grey areas remain, multi-agent deep
  research with primary-source grounding, ultra-granular plan, deep security audit + deep final
  sweep. For ambitious or high-stakes builds.

A higher depth never skips a phase — it makes each phase more thorough.
</depth_levels>

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

**③ Plan** — `phases/3-plan.md`
   Decompose into many tiny, individually-verifiable steps, each with a Verify check and dependencies.
   Decide tests (yes/no) here. Present for approval; do not build until approved. Write `PLAN.md`.

**④ Build** — `phases/4-build.md`
   Execute steps in dependency order. After EVERY step, run its verification (typecheck/lint/run/
   functional check; browser for UI). Fix failures before proceeding. Check the box, log to
   `PROGRESS.md`. Post a brief progress note at phase boundaries but keep going — stop only for a
   genuine clarity need (see `<autonomy>`).

**⑤ Tests** — `phases/5-tests.md` (only if chosen in the plan)
   Derive tests from SPEC success criteria and edge cases found during build/research; write, run,
   make green; record coverage of the criteria.

**⑥ Security pass** — `phases/6-security.md`
   Delegate a thorough security review (OWASP-mapped). Produce `SECURITY.md` with severity-classified
   findings; fix Critical/High (confirm anything risky) and re-verify.

**⑦ Final sweep** — `phases/7-final-sweep.md`
   Fresh-context hunt for bugs and logical errors; run the full app + tests on golden path and edge
   cases. Produce `REVIEW.md`; fix Critical/High. Then generate/refresh polished project docs and
   present the final summary. Mark FORGE.md → done.
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
| Run & verify behavior (④, ⑦) | `forge-verifier` | `/verify`, `/run` |
| Bug / logic / quality review (⑦) | `forge-reviewer` | `/code-review` |
| Security audit (⑥) | `forge-security-auditor` | `/security-review` |
| A stuck build step (④) | diagnose inline (scientific method) | `engineering:debug` |
| Test strategy (⑤) | — | `engineering:testing-strategy` |
| Architecture / UI / design | `references/standards.md` | `engineering:architecture`, `design:design-system`, `design:accessibility-review`, `anthropic-skills:theme-factory` |

The forge agents are **read-only** — they return findings; the orchestrator owns the `.forge/` artifacts
and applies fixes. Never hard-depend on an external skill; it's a booster, not a requirement.
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
