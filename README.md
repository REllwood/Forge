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
```

**What the first run looks like:** Forge asks you to pick a depth (`quick` / `standard` / `deep`), settles version control and CI, then interviews you — proposing sensible defaults so you can mostly confirm rather than compose. Small decisions arrive as one **defaults sheet** you can accept in a click. It checks the build has everything it'll need (credentials or mocks, tooling, test data, permissions for routine actions) so it won't have to stop later, then asks whether you want to **review the plan** or run **unattended**. It researches your stack and surfaces anything surprising (a deprecated API, a better library) for your call. Then it plans and builds autonomously — writing tests as it goes, completing the test suite, running a security pass and adversarial testing, and finishing with a final sweep and a clean-room run — pausing only when it genuinely needs you.

## How it works

Forge runs eight phases and writes an artifact for each into a `.forge/` folder in your project:

1. **Interview** → settles version control and CI, then works through a question bank for your kind of project — purpose, testable success criteria, scope & non-goals, architecture, tech stack, data, integrations, UI/theme and edge-case behaviour — plus a defaults sheet, a build-readiness check and a pre-mortem, until there are no grey areas. → `SPEC.md`
2. **Research & grounding** → verifies your stack and APIs against current sources; a hard gate surfaces *material* findings (deprecations, breaking changes, better options) before any planning. → `RESEARCH.md`
   - **2b. UI Design** *(only if there's a UI)* → a platform-aware design team — UI specialist + staff frontend developer + UI artist — converges on the best modern UI **within your scope**; shown for sign-off at the plan gate. → `UI-DESIGN.md`
3. **Plan** → decomposes the work into right-sized, individually-verifiable steps (within a step budget set by depth), each phase closed by a checkpoint, and maps every success criterion to the acceptance test that will prove it; you approve it (the one deliberate go/no-go — skipped if you chose unattended). → `PLAN.md` + `TESTING.md`
4. **Build** → executes the steps in order, writing each step's tests as part of the step and **verifying every one** before moving on, with a full checkpoint (typecheck/lint/tests/regression; browser + accessibility for UI) at each phase boundary; commits per your chosen cadence. → `PROGRESS.md`
5. **Test suite** → completes a full automated suite: an acceptance test for every success criterion, integration tests across the real seams, an end-to-end golden path, and edge cases where the risk is real. One command, no flaky tests, CI if you chose it. → `TESTING.md`
6. **Security pass** → a lightweight threat model and an OWASP-mapped audit; fixes Critical/High, each with an exploit regression test. → `SECURITY.md`
7. **Adversarial testing** → tries to break the build for real with executable attacks: hostile and boundary inputs, abuse cases, property-based fuzzing, failure injection, concurrency, and a mutation check that proves the tests actually catch bugs. Every attack becomes a permanent test; every break gets fixed. → `TESTING.md`
8. **Final sweep** → a fresh-context hunt for bugs and logic errors, runs the app on the golden path and key edge cases, ships clean docs, then does a **clean-room run** from a fresh checkout following only the README, and checks the definition of done. → `REVIEW.md`

After the interview it's **agentic** — it runs straight through, stopping only for genuine ambiguity, a true blocker, a risky/irreversible action, or a material scope change. A build is only **done** when every success criterion has a passing test, the suite passes twice from one command, every Critical/High finding is fixed with a regression test, and the clean-room run works.

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
