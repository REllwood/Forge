# Forge

**Take a software idea from concept to a verified, tested, documented implementation — in one shot.**

Forge isn't an app you run. It's a set of instructions your AI coding assistant follows: a complete engineering workflow with the conversational feel of plan mode. It interviews you until there are no grey areas — including everything the build will need, so it never has to stop and ask — grounds every assumption in current reality, and writes a detailed, right-sized plan. Then it builds autonomously: writing tests as it goes and verifying **every** step, completing a full automated test suite, running a security pass, **attacking its own work** with adversarial tests, and finishing with a bug sweep and a clean-room run from a fresh checkout — documenting the whole thing as it goes.

```
  idea
   │
   ▼
 ① INTERVIEW ──▶ ② RESEARCH ────▶ ③ PLAN ──▶ ④ BUILD ──────────┐
   SPEC.md         RESEARCH.md      PLAN.md    PROGRESS.md     │
   (no grey        (ground every    (lean      (verify every   │
    areas)          assumption)      steps)     step + tests)  │
   ┌───────────────────────────────────────────────────────────┘
   ▼
 ⑤ TEST SUITE ──▶ ⑥ SECURITY ──────▶ ⑦ ADVERSARIAL ──▶ ⑧ FINAL SWEEP ────▶ done
   TESTING.md       SECURITY.md        TESTING.md        REVIEW.md + docs
   (every           (threat model,     (break it         (clean-room
    criterion)       fix criticals)     for real)         done-check)
```

Works with **Claude Code** (full experience), **Codex**, **Cursor**, and any tool that takes a custom command or system prompt.

---

## Contents
- [Why](#why) · [Compatibility](#compatibility) · [Requirements](#requirements) · [Install](#install) · [Usage](#usage) · [How it works](#how-it-works) · [What you get](#what-you-get) · [Customization](#customization) · [FAQ](#faq-and-troubleshooting) · [Layout](#repository-layout) · [Contributing](#contributing) · [License](#license)

## Why

Plan mode is great for thinking; it doesn't build. Heavyweight phased workflows build, but make you drive a dozen commands and carry a lot of scaffolding. Forge is the middle path: **one command**, all the human decisions front-loaded, then autonomous execution that holds itself to a high bar, proves its work with tests, and documents everything.

Its seven principles override convenience at every step:

1. **No grey areas** — ambiguity is a bug; resolve it before building. Ask everything up front.
2. **Ground everything in reality** — verify versions, APIs, and "best practice" against current primary sources, never training memory.
3. **Right-sized steps, deep detail** — coherent, individually-verifiable steps (about one commit each), with the depth in each step's instructions rather than in ever-smaller steps.
4. **Verify or it didn't happen** — every build step ends with a targeted check that proves it works, and every plan phase ends with a full checkpoint.
5. **Document as you go** — the `.forge/` trail is the source of truth and makes a build resumable.
6. **Build to a standard** — sound architecture and accessible, well-designed UI are part of "done," sized to scope.
7. **Done is executable** — every success criterion becomes an automated test, every bug becomes a regression test, and "done" means the full suite passes from a clean checkout.

## Compatibility

Forge is just Markdown instructions, so it runs wherever your assistant can load a skill, command, or system prompt. The *methodology* is identical everywhere; only the *mechanics* differ.

| Tool | Mechanism | Experience |
|------|-----------|------------|
| **Claude Code** | Plugin (skill + 8 subagents) | **Full** — parallel subagents, structured questions, plugin install |
| **Codex CLI** | [Agent Skill](https://developers.openai.com/codex/skills) (`~/.codex/skills/forge/`) | Core pipeline; subagents → inline, questions → plain text |
| **Cursor** | [Command](https://cursor.com/docs) (`~/.cursor/commands/forge.md`) | Core pipeline; inline review, plain-text questions |
| **Gemini CLI, Aider, Windsurf, Zed, …** | `dist/forge.md` as a command / system prompt, or via [`AGENTS.md`](https://agents.md) | Core pipeline; varies by tool |

On tools without subagents or a choice UI, Forge degrades gracefully — it does the research/review/verification inline and asks questions in plain text, keeping the same rigor.

## Requirements

- **An AI coding assistant** — [Claude Code](https://docs.claude.com/en/docs/claude-code), [Codex](https://developers.openai.com/codex), [Cursor](https://cursor.com), or any tool that accepts a custom command/system prompt.
- **git** — only if you want Forge's version-control features. The [GitHub CLI (`gh`)](https://cli.github.com) is optional, used for automatic repo creation; without it Forge falls back to local git or skips VCS.
- **Nothing else.** Forge ships no code and no dependencies — it uses whatever model and permissions your tool already has, entirely on your machine.

## Install

### Quickest — clone and run the installer

```bash
git clone https://github.com/REllwood/Forge.git
cd forge
./install.sh            # auto-detects installed tools
# or target one:  ./install.sh claude | codex | cursor | all
```

### Claude Code

**Option A — plugin (recommended):**
```
/plugin marketplace add REllwood/Forge
/plugin install forge@forge-marketplace
```

**Option B — manual copy:**
```bash
cp -R skills/forge ~/.claude/skills/forge
cp agents/forge-*.md ~/.claude/agents/
```

Then invoke it:
```
/forge build a CLI that turns Markdown notes into a searchable static site
```
> Depending on your Claude Code version a plugin-installed skill may appear as `/forge:forge`; both refer to the same skill.

### Codex CLI

Forge installs as a self-contained [Agent Skill](https://developers.openai.com/codex/skills) (one file, no
subagents needed). Easiest:
```bash
./install.sh codex
```

<details><summary>Manual (no script)</summary>

```bash
mkdir -p ~/.codex/skills/forge
{ printf -- '---\nname: forge\ndescription: Idea-to-implementation pipeline — interview, research, plan, verified build, test suite, security, adversarial testing, final sweep.\n---\n\n'; cat dist/forge.md; } > ~/.codex/skills/forge/SKILL.md
```
</details>

Codex discovers skills by their `description`. Start a build by asking Codex to *"forge \<your idea\>"*, or trigger it explicitly with `$forge`; run `/skills` in a session to see it listed. Subagents and choice-menus degrade to inline work and plain-text questions (see [Compatibility](#compatibility)).

<details><summary>Legacy: single-file Codex prompt (deprecated)</summary>

Codex's older custom-prompts feature (superseded by skills) also works:
```bash
mkdir -p ~/.codex/prompts && cp dist/forge.md ~/.codex/prompts/forge.md
```
Invoke with `/prompts:forge <idea>`.
</details>

### Cursor

Cursor [Commands](https://cursor.com/docs) are single Markdown files:
```bash
mkdir -p ~/.cursor/commands && cp dist/forge.md ~/.cursor/commands/forge.md
```
Invoke `/forge` in Cursor's Agent. (For a project-only command, copy it into `.cursor/commands/` in the repo instead.)

### Any other tool

Use [`dist/forge.md`](dist/forge.md) as a custom command or system prompt, or fold it into your project's [`AGENTS.md`](https://agents.md). It's the entire pipeline in one self-contained file.

## Usage

```
/forge <what you want to build>     # start a new build
/forge resume                       # continue an in-progress build
/forge status                       # show where a build is
/forge restart                      # archive the current build and start over
/forge abandon                      # archive the current build and stop
```

**What a run looks like:** a short interview (mostly confirming recommended answers), an optional plan approval, then Forge builds, tests, attacks and documents the program on its own. [How it works](#how-it-works) walks through every step.

## How it works

You type one command. Forge interviews you, then builds, tests, attacks and documents the program on its own. Here's every step: what you do, what Forge does, and what it leaves behind in the `.forge/` folder.

### At a glance

| # | Step | What happens | What you do | Writes |
|---|------|--------------|-------------|--------|
| 1 | **Interview** | Settles every decision up front | Answer questions — most come with a recommended answer | `SPEC.md` |
| 2 | **Research** | Checks your stack against current, real-world sources | Decide only if something important turns up | `RESEARCH.md` |
| 2b | **UI design** | A design panel agrees the look *(UI projects only)* | Review it alongside the plan | `UI-DESIGN.md` |
| 3 | **Plan** | Breaks the work into steps and plans the tests | Approve it (skipped in unattended mode) | `PLAN.md`, `TESTING.md` |
| 4 | **Build** | Builds step by step, writing tests as it goes | Nothing | `PROGRESS.md` |
| 5 | **Test suite** | Completes the automated tests | Nothing | `TESTING.md` |
| 6 | **Security** | Threat model and security audit; fixes the serious issues | Nothing | `SECURITY.md` |
| 7 | **Adversarial testing** | Tries to break it with real attacks; fixes what breaks | Nothing | `TESTING.md` |
| 8 | **Final sweep** | Bug hunt, docs, clean-room run, definition-of-done check | Read the summary | `REVIEW.md` + docs |

### Step by step

#### 1. Interview — no grey areas

**You:** answer a few rounds of questions. Most come with a recommended answer, so you can mostly confirm rather than write from scratch.

**Forge:**
1. Asks you to pick a **depth** (`quick` / `standard` / `deep`) and **economy** (`balanced` / `economy`).
2. Settles **version control** — Git + GitHub, git only, none, or an existing repo — plus repo visibility, how often to push, and whether to add a **CI** workflow.
3. Interviews you from a **question bank** for your kind of project (web app, API, CLI, library, mobile, data pipeline, game, AI feature): purpose, users, scope and non-goals, architecture, tech stack, data, integrations, UI and theme, and constraints. Every **success criterion** is written as *Given / When / Then* so it can become a test.
4. Shows a **defaults sheet** — the small decisions it would otherwise guess (duplicate entries, deleting linked records, time zones, rounding, limits, error messages, who sees what), each with a recommended answer. Accept them all, or change the ones you care about.
5. Runs a **build-readiness check** so it never has to stop mid-build: credentials for each external service (or a sandbox key or mock instead), the tools your stack needs, test data, and permission for routine actions such as installing packages, setting up a local database and pushing commits.
6. Runs a **pre-mortem** — walks each feature from start to finish looking for anything it would still have to guess — and asks about whatever it finds.
7. Shows you a summary of the spec to confirm, and asks for the **run mode**: *review* (approve the plan before building) or *unattended* (go straight through to done).

**You get:** `SPEC.md` — every decision, locked in.

#### 2. Research — grounded in reality

**Forge:** checks every library, API and assumption in the spec — including the test tools it'll use — against current official docs, changelogs and security advisories, not its training memory. It settles small findings itself. If something important turns up — a deprecated API, a breaking change, a clearly better option, a licensing or security problem — it stops and asks you before planning.

**You get:** `RESEARCH.md` — verified versions, gotchas, and any decisions you made.

#### 2b. UI design *(only if there's a user interface)*

**Forge:** a design panel — a UI specialist, a senior frontend developer and a UI artist — agrees on a modern, accessible design within the style you asked for. Visual-heavy apps get throwaway HTML mockups. You see it alongside the plan; there's no separate stop.

**You get:** `UI-DESIGN.md`, plus mockups in `.forge/ui-mockups/` where useful.

#### 3. Plan — including the test plan

**Forge:** breaks the work into right-sized steps (about one commit each, within a step budget set by depth), grouped into phases that each end in a full checkpoint. The first steps produce a minimal working version with the test setup already in place. It maps every success criterion to the test that will prove it, and drafts the list of attacks for step 7.

**You:** approve or adjust the plan. This is the last routine stop — in *unattended* mode, Forge shows you the plan and keeps going.

**You get:** `PLAN.md` and `TESTING.md`.

#### 4. Build — verified step by step

**Forge:** for every step, writes the code **and its tests**, runs a targeted check, and actually exercises what it built before moving on. At the end of each phase it runs a full checkpoint: typecheck, lint, the whole test suite, a check that nothing earlier broke and, for screens, a responsive and accessibility check in a browser. If something fails, it gets three attempts, each testing a different idea, then stops and tells you rather than looping. Commits and pushes happen on the schedule you chose.

**You get:** working code, and `PROGRESS.md` — a log of every step and how it was verified.

#### 5. Test suite — complete and trustworthy

**Forge:** fills in the gaps — an acceptance test for every success criterion, integration tests for the real connections (database, files, external APIs), an end-to-end test of the main user journey, and edge-case tests wherever the logic is risky. Everything runs from one command, and it runs twice to catch flaky tests. If you chose CI, it adds the workflow.

**You get:** a full automated test suite, recorded in `TESTING.md`.

#### 6. Security pass

**Forge:** maps what's worth protecting and every way in, then audits the code against the OWASP Top 10, hunts for leaked secrets, and runs a dependency audit. Critical and high-severity issues are fixed, each with a test proving the exploit no longer works.

**You get:** `SECURITY.md`.

#### 7. Adversarial testing — try to break it

**Forge:** attacks its own work with real, runnable tests — hostile and boundary inputs, attempts to reach other users' data, property-based fuzzing, simulated outages and slow services, simultaneous requests, UI abuse, and a **mutation check** that plants small bugs to prove the tests actually catch them. Every attack is kept as a permanent test, and anything that breaks is fixed. How far it goes depends on the hardening level.

**You get:** a stronger test suite, with the attack results in `TESTING.md`.

#### 8. Final sweep — prove it's done

**Forge:** a fresh-eyes hunt for bugs and logic errors, then runs the app for real. It writes the README and architecture notes, commits, then does a **clean-room run**: a fresh copy of the project, set up using only the README, must install, pass the tests and run. Finally it checks the definition of done (below) and wraps up.

**You get:** `REVIEW.md`, polished docs, and a summary — what was built, how to run it, how it was tested, and any known limitations.

### When Forge stops to ask you

After the interview, Forge runs on its own. It only stops for:
- a decision with real trade-offs that the spec doesn't settle;
- something only you can provide, such as a credential or access;
- anything risky or irreversible — deploying, deleting, spending money, force-pushing;
- a discovery that materially changes what's being built or what it'll cost.

Everything else it decides, records in `.forge/`, and keeps going.

### What "done" means

A build is only finished when:
- every success criterion has a passing automated test;
- the full suite passes from one command, twice in a row;
- typecheck, lint and the dependency audit are clean;
- every critical and high-severity finding is fixed and has a test;
- a fresh copy, set up from the README alone, installs, passes and runs;
- the docs are written and CI (if you chose it) is green.

Anything that can't meet that bar is listed as a known limitation, with the reason.

### Stopping and resuming

Everything Forge knows lives in `.forge/`, so a build survives a closed session or a full context reset. Run `/forge status` to see where it's up to, and `/forge resume` to carry on from exactly that point.

## What you get

A documented, resumable trail in `.forge/`:

| File | Contents |
|------|----------|
| `FORGE.md` | Manifest + state (which phase, depth, idea) — the resume anchor |
| `SPEC.md` | Locked decisions from the interview |
| `RESEARCH.md` | Grounded findings, version pins, resolved forks |
| `PLAN.md` | The step plan (checkboxes + a checkpoint per phase) |
| `PROGRESS.md` | Per-step build log: did / files / verify result / deviations |
| `TESTING.md` | Test strategy, the acceptance matrix (criterion → test), adversarial charter + results, mutation check |
| `SECURITY.md` | Threat model + severity-classified security findings |
| `REVIEW.md` | Final-sweep findings, clean-room result, definition-of-done check |

Plus, on Claude Code, eight read-only subagents do the heavy lifting and return findings: **`forge-researcher`**, **`forge-reviewer`**, **`forge-security-auditor`**, **`forge-adversary`**, **`forge-verifier`**, and the UI design team **`forge-ui-designer`**, **`forge-frontend-engineer`**, **`forge-ui-artist`**.

## Customization

- **Run mode** — `review` (default) stops once so you can approve the plan; `unattended` is the true one-shot — answer the interview, walk away, come back to a finished, tested build. Material research findings still come back to you either way.
- **Depth** — pick `quick` / `standard` / `deep` at the start to scale how thorough each phase is. Every depth runs the full test suite and adversarial testing.
- **Economy** — pick `balanced` (default) or `economy`. Economy minimizes total token/cost spend — inline work instead of fresh-context subagents, one combined research pass, terser artifacts — *without* skipping any phase, the research gate, per-step verification, the test suite, security, adversarial testing, or the final sweep. `quick` + `economy` is the leanest run; pick `balanced` for security-sensitive builds so the audit keeps independent context.
- **Hardening** — how hard the security pass, adversarial testing and final sweep hunt for problems. An **automated adversarial find → fix → re-check loop** that runs with no check-ins until the code stops yielding material issues (or a round cap is hit). Level is `basic` / `standard` / `comprehensive` — defaults from depth, and you can raise it explicitly ("harden comprehensively" / "really hunt for bugs"). It's deliberately adversarial but pragmatic: severity-gated, no chasing phantom issues.
- **UI design team** — for builds with a UI, a platform-aware design panel (UI specialist + staff frontend developer + UI artist) proposes the best modern UI within your stated scope, with throwaway mockups for visual-heavy apps; you sign off at the plan gate. It's then verified against an explicit **UI Acceptance Checklist** — modern, responsive (tested at real breakpoints), accessible (WCAG AA), all states, performant, polished — and fixed until it passes, in both the build and the final sweep. Tune it via the three `agents/forge-ui-*.md` or the UI bars in `standards.md`.
- **Loop guards** — built-in budgets that keep runs thorough without spiralling: a step budget per depth, decompose-once (no recursive re-planning mid-build), a 3-attempt cap on any one fix, a no-progress breaker on every loop, tiered verification (targeted per step, full suite at phase checkpoints), and diff-scoped re-reviews. Tune them in the `<loop_guards>` section of [`SKILL.md`](skills/forge/SKILL.md) (and its mirror in `dist/forge.md`).
- **Question bank** — edit [`skills/forge/references/question-bank.md`](skills/forge/references/question-bank.md) to add the questions and defaults that matter in your domain.
- **Standards** — edit [`skills/forge/references/standards.md`](skills/forge/references/standards.md) to encode your own architecture/UI/design bars.
- **Phases** — each phase is a small playbook in [`skills/forge/phases/`](skills/forge/phases); tweak any of them.
- **Optional integrations** — when these skills are installed, Forge prefers them and falls back gracefully: `/verify`, `/run`, `/code-review`, `/security-review`, `engineering:debug`, `engineering:testing-strategy`, and design/architecture skills.

## FAQ and troubleshooting

**Does my code get sent anywhere?** No. Forge is just instructions; it runs entirely through your assistant, using the model and permissions you already have. It ships no telemetry and no dependencies.

**`/forge` isn't found.** Confirm the install path for your tool (above). On Claude Code, a plugin-installed skill may be `/forge:forge`; manual installs are `/forge`. Restart your assistant after installing.

**It's burning through tokens or seems stuck in a loop.** The loop guards (see [Customization](#customization)) should end any loop and surface the issue rather than let it spin — if one doesn't, that's a bug worth an issue. To make a run leaner still, pick `economy` (inline work instead of subagents) and/or `quick` depth, or ask for `basic` hardening.

**Do I need the GitHub CLI?** Only for automatic repo creation. Without `gh`, choose git-only or skip version control — Forge asks at the start.

**It behaves differently in Codex/Cursor.** Expected — see [Compatibility](#compatibility). The pipeline is the same; subagents and choice-menus degrade to inline work and plain-text questions.

**How do I update?** `git pull` then re-run `./install.sh` (or `/plugin` update on Claude Code).

**How do I uninstall?** Remove the files you copied (`~/.claude/skills/forge` + `~/.claude/agents/forge-*.md`, or `~/.codex/skills/forge`, or `~/.cursor/commands/forge.md`), or `/plugin uninstall forge` on Claude Code.

## Repository layout

```
.claude-plugin/
  plugin.json          # Claude Code plugin manifest
  marketplace.json     # lets the repo be added as a plugin marketplace
skills/forge/
  SKILL.md             # orchestrator: principles, autonomy, flow, routing, portability
  phases/*.md          # per-phase playbooks, incl. conditional ui-design.md (lazy-loaded)
  references/standards.md      # architecture + UI + design quality bars (+ platform-specific)
  references/question-bank.md  # what the interview must settle, by form factor
agents/
  forge-researcher.md  forge-reviewer.md  forge-security-auditor.md  forge-adversary.md  forge-verifier.md
  forge-ui-designer.md  forge-frontend-engineer.md  forge-ui-artist.md   # UI design team
dist/
  forge.md             # portable, single-file build for Codex/Cursor/other tools
install.sh             # cross-tool installer
README.md  LICENSE  CHANGELOG.md
```

## Contributing

Issues and PRs welcome. The one rule to remember: `skills/forge/` and `dist/forge.md` are two renderings of the same pipeline; keep them in sync.

## Roadmap

Deliberately not included yet (easy to add): an optional **deploy** phase (Vercel/Netlify/Fly/Docker) with continuous delivery, and environment bootstrap. (A CI workflow that runs lint, typecheck and the full suite is already offered at intake.)

## License

[MIT](LICENSE) © 2026 Rhys Ellwood
