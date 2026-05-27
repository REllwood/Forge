# Forge

**Take a software idea from concept to a verified, documented implementation — in one meticulous, agentic pipeline.**

Forge isn't an app you run. It's a set of instructions your AI coding assistant follows — a complete engineering workflow with the conversational feel of plan mode. It interviews you until there are no grey areas, grounds every assumption in current reality, writes an ultra-granular plan, then builds it autonomously: verifying **every** step, running a security pass, and finishing with a bug-and-logic sweep — documenting the whole thing as it goes.

```
  idea
   │
   ▼
 ① INTERVIEW ──▶ ② RESEARCH ──▶ ③ PLAN ──▶ ④ BUILD ──▶ ⑤ TESTS? ──▶ ⑥ SECURITY ──▶ ⑦ FINAL SWEEP ──▶ done
   SPEC.md       RESEARCH.md     PLAN.md    PROGRESS.md   (opt)        SECURITY.md     REVIEW.md + docs
   (no grey      (ground every   (tiny      (verify EVERY            (OWASP, fix      (bugs, logic,
    areas)        assumption)     steps)     step before moving)      criticals)       run the app)
```

Works with **Claude Code** (full experience), **Codex**, **Cursor**, and any tool that takes a custom command or system prompt.

---

## Contents
- [Why](#why) · [Compatibility](#compatibility) · [Requirements](#requirements) · [Install](#install) · [Usage](#usage) · [How it works](#how-it-works) · [What you get](#what-you-get) · [Customization](#customization) · [FAQ](#faq-and-troubleshooting) · [Layout](#repository-layout) · [Contributing](#contributing) · [License](#license)

## Why

Plan mode is great for thinking; it doesn't build. Heavyweight phased workflows build, but make you drive a dozen commands and carry a lot of scaffolding. Forge is the middle path: **one command**, all the human decisions front-loaded, then autonomous execution that holds itself to a high bar and documents everything.

Its six principles override convenience at every step:

1. **No grey areas** — ambiguity is a bug; resolve it before building.
2. **Ground everything in reality** — verify versions, APIs, and "best practice" against current primary sources, never training memory.
3. **Small steps, deep detail** — many tiny, individually-verifiable steps beat a few big ones.
4. **Verify or it didn't happen** — every build step ends with a concrete check that proves it works.
5. **Document as you go** — the `.forge/` trail is the source of truth and makes a build resumable.
6. **Build to a standard** — sound architecture and accessible, well-designed UI are part of "done," sized to scope.

## Compatibility

Forge is just Markdown instructions, so it runs wherever your assistant can load a skill, command, or system prompt. The *methodology* is identical everywhere; only the *mechanics* differ.

| Tool | Mechanism | Experience |
|------|-----------|------------|
| **Claude Code** | Plugin (skill + 4 subagents) | **Full** — parallel subagents, structured questions, plugin install |
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
git clone https://github.com/rhysellwood/forge.git
cd forge
./install.sh            # auto-detects installed tools
# or target one:  ./install.sh claude | codex | cursor | all
```

### Claude Code

**Option A — plugin (recommended):**
```
/plugin marketplace add rhysellwood/forge
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
{ printf -- '---\nname: forge\ndescription: Idea-to-implementation pipeline — interview, research, plan, verified build, security, final sweep.\n---\n\n'; cat dist/forge.md; } > ~/.codex/skills/forge/SKILL.md
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

**What the first run looks like:** Forge asks you to pick a depth (`quick` / `standard` / `deep`), settles version control, then interviews you — proposing sensible defaults so you can mostly confirm rather than compose. It researches your stack and surfaces anything surprising (a deprecated API, a better library) for your call. It presents a granular plan for approval. After you approve, it builds autonomously — verifying each step, running an optional test suite, a security pass, and a final bug sweep — pausing only when it genuinely needs you.

## How it works

Forge runs seven phases and writes an artifact for each into a `.forge/` folder in your project:

1. **Interview** → settles version control and interviews you across purpose, scope & non-goals, architecture, tech stack, data, integrations, and UI/theme — until there are no grey areas. → `SPEC.md`
2. **Research & grounding** → verifies your stack and APIs against current sources; a hard gate surfaces *material* findings (deprecations, breaking changes, better options) before any planning. → `RESEARCH.md`
3. **Plan** → decomposes the work into many tiny, individually-verifiable steps, each with an explicit verification; you approve it (the one deliberate go/no-go). → `PLAN.md`
4. **Build** → executes the steps in order, **verifying every one** (typecheck/lint/run/functional/regression; browser + accessibility for UI) before moving on; commits per your chosen cadence. → `PROGRESS.md`
5. **Tests** *(optional)* → tests derived from your success criteria and edge cases.
6. **Security pass** → an OWASP-mapped audit; fixes Critical/High. → `SECURITY.md`
7. **Final sweep** → a fresh-context hunt for bugs and logic errors, then runs the app on the golden path and key edge cases, and ships clean docs. → `REVIEW.md`

After plan approval it's **agentic** — it runs straight through, stopping only for genuine ambiguity, a true blocker, a risky/irreversible action, or a material scope change.

## What you get

A documented, resumable trail in `.forge/`:

| File | Contents |
|------|----------|
| `FORGE.md` | Manifest + state (which phase, depth, idea) — the resume anchor |
| `SPEC.md` | Locked decisions from the interview |
| `RESEARCH.md` | Grounded findings, version pins, resolved forks |
| `PLAN.md` | The granular step plan (checkboxes) |
| `PROGRESS.md` | Per-step build log: did / files / verify result / deviations |
| `SECURITY.md` | Severity-classified security findings |
| `REVIEW.md` | Final-sweep bug/logic findings |

Plus, on Claude Code, four read-only subagents do the heavy lifting and return findings: **`forge-researcher`**, **`forge-reviewer`**, **`forge-security-auditor`**, **`forge-verifier`**.

## Customization

- **Depth** — pick `quick` / `standard` / `deep` at the start to scale how thorough each phase is.
- **Standards** — edit [`skills/forge/references/standards.md`](skills/forge/references/standards.md) to encode your own architecture/UI/design bars.
- **Phases** — each phase is a small playbook in [`skills/forge/phases/`](skills/forge/phases); tweak any of them.
- **Optional integrations** — when these skills are installed, Forge prefers them and falls back gracefully: `/verify`, `/run`, `/code-review`, `/security-review`, `engineering:debug`, `engineering:testing-strategy`, and design/architecture skills.

## FAQ and troubleshooting

**Does my code get sent anywhere?** No. Forge is just instructions; it runs entirely through your assistant, using the model and permissions you already have. It ships no telemetry and no dependencies.

**`/forge` isn't found.** Confirm the install path for your tool (above). On Claude Code, a plugin-installed skill may be `/forge:forge`; manual installs are `/forge`. Restart your assistant after installing.

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
  phases/1-7.md        # per-phase playbooks (lazy-loaded)
  references/standards.md  # architecture + UI + design quality bars
agents/
  forge-researcher.md  forge-reviewer.md
  forge-security-auditor.md  forge-verifier.md
dist/
  forge.md             # portable, single-file build for Codex/Cursor/other tools
install.sh             # cross-tool installer
README.md  LICENSE  CHANGELOG.md  CONTRIBUTING.md
```

## Contributing

Issues and PRs welcome — see [CONTRIBUTING.md](CONTRIBUTING.md). The one rule to remember: `skills/forge/` and `dist/forge.md` are two renderings of the same pipeline; keep them in sync.

## Roadmap

Deliberately not in v1 (easy to add): an optional **deploy** phase (Vercel/Netlify/Fly/Docker) and a **CI/CD** workflow + environment bootstrap.

## License

[MIT](LICENSE) © 2026 Rhys Ellwood
