# Forge — Interview question bank

What the interview must settle so the build can run start to finish without guessing. It's a checklist
for **you**, not a script for the user: most items are settled by inference or by a recommended default
on the defaults sheet. Ask the user only what genuinely needs them. Skip anything that doesn't apply.

---

## Universal — every build

- **Users & roles** — who uses it; distinct roles and what each may do.
- **Success criteria** — each one testable as *Given / When / Then*. If you can't picture the test, it
  isn't a criterion yet.
- **Scope & non-goals** — the v1 must-haves, and what is explicitly out.
- **Data lifecycle** — what's created, edited and deleted; retention; export/import; what happens to
  dependent records when a parent is deleted.
- **Validation rules** — required fields, formats, lengths, ranges, uniqueness.
- **Limits** — max sizes, counts, rates, file types; what happens at the limit.
- **Error behaviour** — what the user sees, what's logged, what's retried, what's fatal.
- **Persistence & state** — where it lives; what must survive a restart.
- **Auth** — none, local accounts, OAuth/SSO, API keys; sessions and expiry.
- **Configuration & secrets** — what's configurable; what comes from env.
- **Time, money, locale** — time zones, date formats, currency and precision, languages.
- **Observability** — logging level and format; what counts as an audit event.
- **Environment & deploy target** — where it runs; what it's built and tested on.

## By form factor

- **Web app** — pages/routes and navigation; sign-up, login, reset and session flows; roles and
  permissions per page; empty/loading/error states; responsive targets; browser support; real-time
  updates?; file uploads; emails and notifications; SEO?
- **API / service** — resources and endpoints; request/response shapes; auth scheme; error format and
  status codes; pagination; filtering and sorting; idempotency; rate limits; versioning; webhooks;
  OpenAPI docs.
- **CLI** — commands, flags and defaults; input (args, stdin, files); output (human and/or JSON);
  exit codes; config file and precedence; interactive vs scriptable; supported OSes and install method.
- **Library / SDK** — the public API surface; error types; supported runtimes; semver policy; packaging
  and publishing; docs and examples.
- **Mobile** — platforms; offline and sync; push notifications; device permissions; store constraints.
- **Desktop** — platforms; install and auto-update; file associations; menus and shortcuts.
- **Data pipeline / script** — sources and sinks; schedule or trigger; volumes; re-runs and
  idempotency; partial-failure handling; data-quality checks; outputs and formats.
- **Game** — platform and input; core rules and win/lose conditions; save/load; assets; performance
  budget.
- **AI / LLM feature** — provider and model; what the model decides vs what code decides; cost and
  latency limits; how quality is judged (evals); fallbacks when the model fails.

## Grey-area hotspots — what agents guess when nobody asked

Put sensible defaults for these on the **defaults sheet** so the user can accept or amend them in one go:

- Duplicate submissions or entries — reject, merge, or allow?
- Deleting something other records depend on — block, cascade, or soft-delete?
- Concurrent edits to the same record — last write wins, or conflict detection?
- Sort orders and default filters for every list.
- Default values for every optional field.
- Empty states — what a first-time user sees.
- Exact rounding and precision for money and measurements.
- Which time zone timestamps are stored and shown in.
- What "invalid input" returns, and in what shape.
- What happens when an external dependency is down or slow.
- Maximum sizes, and the message shown when one is exceeded.
- Who can see what — every list and every detail view, per role.

## Build readiness — so the run never stops for you

- **Every external service** — real credentials now (values in `.env`, never committed; you add
  `.env.example`), a sandbox/test key, or a mock/fake behind a clear seam.
- **Tooling** — runtimes, package manager, database/containers, and a browser driver for UI tests;
  confirm they're installed (or how to install them) before the build.
- **Standing authorisations** — installing dependencies, creating and migrating local dev databases,
  running local servers, commits and pushes on the agreed cadence.
- **Test data** — sample inputs, seed data, example files and edge-case fixtures.
- **Testing & CI** — test layers (decided by form factor; ask only about preferences) and whether to add
  a CI workflow.
