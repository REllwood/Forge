# Changelog

## 2.0.0 — 2026-10-19

A one-shot pipeline: every question up front, then one autonomous run that builds, tests, attacks and
proves the result.

- **Interview** now works from a question bank (`references/question-bank.md`), writes success criteria as
  testable *Given / When / Then*, confirms a defaults sheet in one go, settles build readiness
  (credentials or mocks, tooling, standing authorisations, test data, CI), and runs a pre-mortem.
- **Run mode** — `review` (approve the plan) or `unattended` (straight through to done).
- **Tests are always on.** The plan maps every success criterion to an acceptance test in a new
  `TESTING.md`; each build step writes its own tests; ⑤ completes a deterministic, one-command suite
  (acceptance, integration, end-to-end golden path, risk-based edge cases) and an optional CI workflow.
- **Security** adds a lightweight threat model, and every fix carries an exploit regression test.
- **New ⑦ Adversarial testing** phase and `forge-adversary` agent: hostile and boundary input, abuse
  cases, property-based fuzzing, failure injection, concurrency, UI abuse, scale smoke and a mutation
  check — every attack kept as a permanent test.
- **Final sweep** (now ⑧) adds a clean-room run from a fresh checkout and an explicit definition of done.

## 1.1.0

- **Loop guards** to stop runaway token use: a step budget per depth, decompose once, a 3-attempt fix
  cap, a no-progress breaker, tiered verification, diff-scoped re-checks, and sparing subagent use.
- Right-sized plan steps with a checkpoint per phase; comprehensive hardening capped at 3 rounds.

## 1.0.0

- Initial release: interview, research, UI design, plan, build, optional tests, security, final sweep.
