# Phase ⑥ — Security pass

**Goal:** Find and call out security issues before this is considered done. Produce `SECURITY.md` with
severity-classified findings, and fix the dangerous ones.

**Inputs:** the built code, `.forge/SPEC.md` (data sensitivity, auth, integrations), `.forge/PROGRESS.md`.

> Be a defensive reviewer here. The job is to find what's wrong, not to reassure. Assume inputs are
> hostile and secrets leak unless proven otherwise.

---

## 1. Review (delegate for thoroughness)

For `standard`/`deep`, run the audit with fresh eyes — prefer the `/security-review` skill if installed,
otherwise spawn the `forge-security-auditor` agent (so the review isn't biased by having just written the
code). For `quick`, a structured self-review against the checklist is acceptable. Give the reviewer the
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

## 2. Classify & write SECURITY.md

Classify each finding **Critical / High / Medium / Low / Info** with: what it is, where (file:line),
impact, and a concrete fix. Empty categories are fine — say "none found."

## 3. Fix the dangerous ones

Fix **Critical and High** now (confirm before anything risky/irreversible). Re-verify the fix didn't
break behavior (re-run the relevant step/test checks). Fix cheap, low-risk Medium/Low inline too;
record the rest in SECURITY.md as recommendations — **don't stop to ask**, surface them in the final
summary. Log fixes in PROGRESS.md.

Update FORGE.md (check ⑥). → Proceed to `phases/7-final-sweep.md`.

```markdown
# SECURITY — {title}

## Summary
{posture in 2–3 sentences; counts by severity}

## Findings
### [Critical|High|Medium|Low|Info] {title}
- **Where:** {file:line}
- **Issue:** {what & why it's exploitable}
- **OWASP:** {category, if applicable}
- **Fix:** {concrete remediation}
- **Status:** fixed | recommended (deferred) | accepted-risk

## Dependency audit
{tool run + result}
```

**Exit criteria:** SECURITY.md written; all Critical/High fixed and re-verified; remaining items recorded
with a decision. → `phases/7-final-sweep.md`.
