# Phase ⑥ — Security pass

**Goal:** Find and call out security issues before this is considered done. Produce `SECURITY.md` with
severity-classified findings, and fix the dangerous ones.

**Inputs:** the built code, `.forge/SPEC.md` (data sensitivity, auth, integrations), `.forge/PROGRESS.md`,
`.forge/TESTING.md` (the suite and its one command).

> Be a defensive reviewer here. The job is to find what's wrong, not to reassure. Assume inputs are
> hostile and secrets leak unless proven otherwise. This phase runs the automated adversarial
> **hardening loop** (SKILL.md `<hardening>`) at the chosen hardening level — hunt → fix → re-audit until
> clean — with no user check-ins.

---

## 1. Threat model (lite)

Before hunting, write a short threat model at the top of SECURITY.md: the **assets** worth protecting
(data, secrets, money, availability), every **entry point** (routes, commands, uploads, webhooks,
messages, files read), the **trust boundaries**, and the **roles** with what each may do. The hunt walks
every entry point, and ⑦ Adversarial testing turns this list into executable abuse cases. Keep it to a
screen — it's a map, not a report.

## 2. Adversarial security hunt (round 1 of the loop)

For `standard`/`deep`, run the audit with fresh eyes — prefer the `/security-review` skill if installed,
otherwise spawn the `forge-security-auditor` agent (so the review isn't biased by having just written the
code). For `quick` — or any depth in `economy` mode — a structured, deliberately adversarial inline
self-review against the checklist replaces the spawned auditor (in economy you trade fresh-eyes
separation for tokens, so stay thorough to compensate; never skip the audit). Give the reviewer the
file list (from PROGRESS.md / git diff), the SPEC's data-sensitivity / auth context, and this checklist.

**Checklist — map findings to OWASP Top 10 where applicable:**
- **Secrets:** hardcoded credentials, API keys, tokens in source or logs; secrets committed to git.
- **Injection:** SQL/NoSQL, command, XSS, template, path traversal — anywhere untrusted input reaches a
  sink. Confirm parameterization/escaping/sanitization.
- **AuthN/AuthZ:** missing or broken authentication; missing authorization checks; IDOR; privilege
  escalation; insecure session/token handling.
- **Input validation** at every trust boundary (request bodies, params, file uploads, external API
  responses). Server-side, not just client-side.
- **Sensitive data exposure:** PII in logs/errors/responses; weak crypto; data at rest/in transit.
- **SSRF, insecure deserialization, open redirects.**
- **Dependencies:** run the ecosystem audit (`npm audit`, `pip-audit`, etc.); flag known-vulnerable
  versions.
- **Config & defaults:** debug mode on, permissive CORS, missing security headers, default/weak creds,
  overly broad permissions, no rate limiting on sensitive endpoints.
- **Error handling:** stack traces or internals leaked to users.

## 3. Classify & write SECURITY.md

Classify each finding **Critical / High / Medium / Low / Info** with: what it is, where (file:line),
impact, and a concrete fix. Empty categories are fine — say "none found."

## 4. Remediate — the automated hardening loop

Run the adversarial **hardening loop** (SKILL.md `<hardening>`), automated, until it converges:
- **Fix** Critical/High (plus Medium at `comprehensive`) at the root cause — confirm only for genuinely
  risky/irreversible actions (`<autonomy>`); otherwise just do it. Each fix lands with a **regression
test** — an exploit test that fails before the fix and passes after. Log each fix in PROGRESS.md.
- **Re-audit** the changed code: re-run the OWASP checklist on what you touched plus the relevant
  test/step checks, to confirm the issue is gone and the fix introduced nothing new. Keep it
  diff-scoped — hand the auditor only the files the fixes changed (plus their direct callers), never the
  whole codebase again (SKILL.md `<loop_guards>`).
- **Repeat** the hunt → fix → re-audit cycle until a re-audit finds no new in-scope issues, or the
  level's round cap is hit. Record any still-open items in SECURITY.md (severity + why deferred).

Stay pragmatic: severity-gated, no chasing speculative issues, no looping past convergence. **Don't stop
to ask** — surface anything left in the final summary.

Update FORGE.md (check ⑥, Status → `adversarial`). → Proceed to `phases/7-adversarial.md`.

```markdown
# SECURITY — {title}

## Summary
{posture in 2–3 sentences; counts by severity}

## Threat model
- **Assets:** {what's worth protecting}
- **Entry points:** {routes / commands / uploads / webhooks / files}
- **Trust boundaries & roles:** {who can do what, where untrusted input crosses in}

## Findings
### [Critical|High|Medium|Low|Info] {title}
- **Where:** {file:line}
- **Issue:** {what & why it's exploitable}
- **OWASP:** {category, if applicable}
- **Fix:** {concrete remediation}
- **Regression test:** {file::test name, or why none is possible}
- **Status:** fixed | recommended (deferred) | accepted-risk

## Dependency audit
{tool run + result}
```

**Exit criteria:** SECURITY.md written with its threat model; the hardening loop converged (no new
in-scope findings) or hit its round cap; all Critical/High fixed, re-audited and covered by a regression
test; remaining items recorded with a decision. → `phases/7-adversarial.md`.
