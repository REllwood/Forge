# Phase ⑨ — Deploy / Release (optional)

**Run only if the user chose Deploy in the plan.** Otherwise the Final sweep (⑧) already closed the build
out.

**Goal:** Ship the verified build to its target, confirm it runs there, and close out.

**Inputs:** the finished, swept codebase, `.forge/SPEC.md` (hosting/target, constraints),
`.forge/ARCHITECTURE.md`, `.forge/PROGRESS.md`.

> Deploy is **risky** — it leaves the machine, needs credentials, and can cost money. Every outward or
> irreversible action here is a **confirm-first** stop (SKILL.md `<autonomy>`), even under a standing push
> authorization.

> **Brownfield:** detect and reuse the project's **existing** deploy path / CI rather than inventing one;
> match its release conventions. See `references/brownfield.md`.

---

## 1. Confirm target & prerequisites
Detect/confirm the target (Vercel / Netlify / Fly / a Docker image / a server / an app store — from SPEC).
Check the CLI/tooling and auth for that target. Identify the required **env vars & secrets** and confirm
with the user how they're supplied — **never commit secrets**; use the platform's secret store.

## 2. Prepare the release
Produce the production build artifact, wire env/secrets, and set up the run target (Dockerfile / platform
config / start command). Add a minimal CI workflow only if the user asked (full CI/CD is roadmap). Keep
config in version control; keep secrets out of it.

## 3. Deploy (confirm first)
**Confirm before the deploy itself.** Run the deploy. Capture the resulting URL / artifact reference.

## 4. Smoke-test the live artifact
Verify it actually works where it now lives — the golden path against the deployed instance (curl/browser),
health checks, and that env/config resolved. A failed smoke test is a blocker: diagnose and fix; don't
leave a broken deploy.

## 5. Write DEPLOY.md & close out
Write `.forge/DEPLOY.md` (template below). Make the final commit + push (per cadence). Mark FORGE.md
Status → `done`, check ⑨. Present the final wrap-up: what was built, how it was verified, **where it's
deployed**, known limitations, suggested next steps.

```markdown
# DEPLOY — {title}
## Target
{platform + why}
## Steps
{what was done to deploy, reproducibly}
## Env & secrets
{required vars; where they live — never the values}
## Result
- Live at: {url / artifact}
- Smoke test: {what was checked → outcome}
## Rollback
{how to roll back}
```

**Exit criteria:** deployed and smoke-tested on the golden path; DEPLOY.md written; secrets kept out of
git; FORGE.md → done; final summary delivered.
