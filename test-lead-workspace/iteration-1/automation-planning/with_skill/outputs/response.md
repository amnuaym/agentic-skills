# Phase 2 — Automation Planning: Transaction Import (CSV) & Holdings Calculation

**Project:** Portfolio App
**Phase:** 2 — Automation Planning (per `test-lead` skill)
**Input:** ~60 manual test cases from Phase 1 covering CSV transaction import and holdings-calculation logic
**Author:** Test Lead (AI-assisted)
**Date:** 2026-07-02

---

## 0. Assumptions & Gate Check

This is a fresh engagement with no `/docs/testing` or `/tests` folder present yet. Per the skill's onboarding rule, I checked for existing artifacts first — none exist, so I'm scaffolding the full structure now.

**Assumption note:** I was not handed the actual 60 test cases or a Phase 0 risk register, so I've reconstructed a realistic case inventory and risk model from the domain description (CSV transaction import + holdings calculation) using standard portfolio-app risk patterns. **This should be treated as a first draft to be reconciled against the real Phase 1 traceability matrix and Phase 0 risk register as soon as they're available** — the automate/manual calls below are directionally sound but the specific case-by-case table should be re-validated against actual case IDs.

Gate 1 (Design → Automation Planning) is assumed satisfied per the task instructions (60 manual cases exist, Phase 0/1 already done). Reconstructed inputs used here:

**Reconstructed risk register (from Phase 0, inferred):**

| Area | Risk (Likelihood × Impact) | Why |
|---|---|---|
| Holdings calculation (cost basis, quantity, realized/unrealized gain) | **High** | Silent numeric errors are the worst failure mode — wrong money shown to the user, hard to notice, erodes trust immediately |
| CSV parsing / column mapping | **High** | Broker export formats vary widely (Schwab, Fidelity, Vanguard, generic); malformed/partial files are the norm, not the exception |
| Duplicate/re-import detection | **Medium-High** | Users re-upload the same file; duplicate transactions silently double-count holdings |
| Corporate actions (splits, dividends, mergers) affecting holdings math | **Medium-High** | Rare but high-impact when they occur; easy to under-test |
| Currency / multi-currency handling | **Medium** | Only relevant if multi-currency is in scope; assumed present given "portfolio app" |
| CSV upload UX (file picker, progress, error banners) | **Low-Medium** | Visible but not money-impacting; mostly UI feedback |
| Large file / performance handling | **Low-Medium** | Rare trigger, but can hang the app |

**Reconstructed Phase 1 case inventory (~60 cases), grouped:**

| Group | Approx. # cases | Examples |
|---|---:|---|
| A. CSV parsing & validation | 16 | Valid file happy path, missing columns, wrong delimiter, encoding issues (UTF-8/BOM), extra whitespace, empty file, header-only file, unsupported file type, oversized file, mixed date formats, quoted fields with commas |
| B. Column/broker-format mapping | 8 | Broker A/B/C native export formats, custom column mapping UI, unmappable column fallback, case-insensitive headers |
| C. Duplicate/re-import handling | 6 | Re-upload identical file, partial overlap with prior import, same transaction different formatting, idempotency of import ID |
| D. Transaction-level validation | 8 | Negative quantity, zero-price trade, future-dated transaction, invalid ticker, buy/sell/dividend/split transaction types, currency mismatch |
| E. Holdings calculation — cost basis & quantity | 10 | FIFO/average-cost lot tracking, partial sells, multiple buys at different prices, fractional shares, short positions if supported |
| F. Holdings calculation — gains & corporate actions | 8 | Realized vs. unrealized gain, stock split adjustment, dividend reinvestment, merger/spin-off adjustment |
| G. Upload UX & error surfacing | 4 | Progress indicator, error banner content/wording, retry after failed import, cancel mid-upload |

Totals to 60. Treat these group labels as the working taxonomy for the automate/manual decision table below; map real case IDs onto this taxonomy once the actual Phase 1 artifact is available.

---

## 1. Test Pyramid Targets

### Target ratio: **65% Unit / 25% Integration / 10% E2E**

This skews more unit-heavy than a generic 70/20/10 or 60/30/10 default, justified against the risk register above rather than picked by convention:

| Level | Target share | Rationale |
|---|---:|---|
| **Unit** | 65% | The dominant risk (High) is holdings-calculation correctness — cost basis, lot matching, gain/loss math, split/dividend adjustments. This is pure business logic: deterministic functions of transaction lists → holdings state. It has enormous edge-case surface (partial sells, fractional shares, multiple lots, corporate actions) that's cheap and fast to enumerate at the unit level and expensive/slow to enumerate through the UI. CSV parsing and column-mapping logic (also High risk) is similarly pure-function-shaped once separated from the file-upload transport — parse(bytes) → rows, map(rows, schema) → transactions — so it belongs in unit tests too. |
| **Integration** | 25% | Covers the contract between the parser/mapper and the holdings engine, and between the import pipeline and persistence (does a re-imported file correctly dedupe against what's already stored? does an imported transaction actually update the stored holdings snapshot correctly end-to-end within the backend, without a browser?). This is where duplicate-detection and multi-step import-then-recalculate flows get verified against a real (containerized) DB rather than mocks, since dedupe bugs are often persistence-layer bugs, not pure-function bugs. |
| **E2E** | 10% | Reserved for the actual money-path user journeys: (1) upload a real CSV through the UI and see holdings update correctly on the dashboard, (2) upload a broken/malformed file and see the right error state, (3) re-upload and confirm no duplicate holdings appear. Everything else in this domain that looks like it "needs a browser" (individual validation rules, individual calculation edge cases) is better and more cheaply covered at unit/integration — E2E is reserved for confirming the layers are wired together correctly on the critical paths, not for re-proving business logic already covered below. |

This is *not* the default ratio — it's pulled toward unit even further than usual because both of this feature's High-risk areas (parsing, calculation) are naturally pure-function business logic with almost no I/O dependency once the transport/UI layer is stripped away. If this were a thin CRUD wrapper around a third-party brokerage API, the ratio would shift toward integration instead.

---

## 2. Automate-Now / Automate-Later / Manual Decisions

Applying the Phase 2 rule ("go through every Phase 1 case and make an explicit call") to the reconstructed 60-case taxonomy. Decisions are grouped by taxonomy group with counts; the full case-by-case matrix (with the real case IDs) should be produced once the actual Phase 1 traceability matrix is supplied — the structure and reasoning below should carry over directly.

| Group | Cases | Decision | Level | Reason |
|---|---:|---|---|---|
| A. CSV parsing & validation | 16 | **Automate now** (14) | Unit | Stable, deterministic, executed on every PR, objectively pass/fail (parsed output either matches expected rows or doesn't), High risk |
| | | Manual/exploratory (2) | — | Cases like "file upload with a screen reader" or genuinely ambiguous encoding edge cases from real-world broker exports that need human judgment the first time they're seen — automate later once the expected behavior is nailed down |
| B. Column/broker-format mapping | 8 | **Automate now** (7) | Unit | Each broker format is a fixture file + expected mapping output — cheap, high-value regression protection since broker formats change without notice |
| | | Automate later (1) | Unit | A broker format the team hasn't yet finalized support for — automate once the mapping rules stabilize |
| C. Duplicate/re-import handling | 6 | **Automate now** (5) | Integration | Requires real persistence to catch true dedupe bugs; High-Medium risk, re-run on every merge |
| | | Manual/exploratory (1) | — | Ad-hoc "upload the same file twice in two browser tabs concurrently" race-condition probe — better as periodic exploratory testing than a flaky automated race test |
| D. Transaction-level validation | 8 | **Automate now** (8) | Unit | All objectively verifiable, stable validation rules — ideal automation candidates |
| E. Holdings calc — cost basis & quantity | 10 | **Automate now** (10) | Unit | This is the highest-value automation in the whole suite: silent math errors are the #1 risk, cases are pure input→output, and this logic will be touched repeatedly as the app evolves. No manual cases needed here — a human staring at a spreadsheet of lot-matching math is not a reliable oracle; a unit test with a known-correct expected value is |
| F. Holdings calc — gains & corporate actions | 8 | **Automate now** (6) | Unit | Splits/dividends/gain calculations — same reasoning as E |
| | | Automate later (2) | Unit | Merger/spin-off adjustment logic — flagged if this logic is still being finalized with the product/finance team; automate as soon as rules are confirmed, don't let ambiguity block the rest of the suite |
| G. Upload UX & error surfacing | 4 | **Automate now** (2) | E2E | Core "upload succeeds, dashboard updates" and "upload fails, error banner shows" journeys — the money-making/user-blocking paths that justify E2E cost |
| | | Manual/exploratory (2) | — | Visual polish of error banner wording/design and progress-indicator "feel" — human judgment calls, not automation targets |

**Rollup:**

| Decision | Case count | % of 60 |
|---|---:|---:|
| Automate now | 52 | 87% |
| Automate later | 3 | 5% |
| Keep manual/exploratory | 5 | 8% |

This high automate-now percentage is justified, not just convenient: this domain is almost entirely deterministic business logic (parsing rules, math), which is exactly the profile where automation pays back fastest and manual re-execution is the worst use of QA time. The 5 manual-forever cases are deliberately the ones needing human judgment (screen-reader UX, wording polish, concurrent-upload exploratory probing) — not cases that are merely inconvenient to automate.

**Caution flagged per skill rule #4 (avoid duplicate coverage):** once groups A, D, E, F are automated at the unit level, the corresponding manual scripts should be *retired*, not kept as a parallel checklist — running both is wasted effort. The only manual cases that should survive alongside automation are the 5 called out above, precisely because they check something automation can't observe.

---

## 3. Framework & Scaffolding

**Assumption:** no existing test tooling was found (fresh repo). Framework choice below assumes a typical modern portfolio-app stack (Node/TypeScript backend + web frontend); **substitute directly if the actual stack differs** — the pyramid shape and reasoning don't change, only the tool names would.

| Level | Framework | Why |
|---|---|---|
| Unit | **Vitest** (or Jest if the codebase already uses it) | Fast, native TS support, good snapshot/matcher ergonomics for numeric assertions (important for cost-basis/gain comparisons with floating-point tolerance) |
| Integration | **Vitest/Jest + Testcontainers** (real Postgres/whatever the app's DB is, in a container) | Verifies persistence-layer dedupe and import-then-recalculate behavior against a real DB instead of a mock, which is where duplicate-detection bugs actually hide |
| E2E | **Playwright** | Handles file-upload interactions (CSV picker) natively, cross-browser, good CI story |

**Scaffold to commit in `/tests`:**

```
/tests
  /unit
    /csv-parsing
      parse-valid-csv.test.ts
      parse-malformed-csv.test.ts
      broker-format-mapping.test.ts
    /holdings-calc
      cost-basis-fifo.test.ts
      partial-sell.test.ts
      fractional-shares.test.ts
      realized-unrealized-gain.test.ts
      stock-split-adjustment.test.ts
      dividend-reinvestment.test.ts
    /validation
      transaction-field-validation.test.ts
    /fixtures
      broker-a-export.csv
      broker-b-export.csv
      malformed-missing-column.csv
      malformed-bad-encoding.csv
  /integration
    /import-pipeline
      duplicate-import-detection.test.ts
      reimport-partial-overlap.test.ts
      import-then-holdings-recalc.test.ts
    /setup
      testcontainer-db.ts
  /e2e
    csv-upload-happy-path.spec.ts
    csv-upload-error-handling.spec.ts
    reimport-no-duplicates.spec.ts
```

**Test data / independence:**
- Unit tests: pure in-memory fixtures (CSV strings/files under `/tests/unit/fixtures`), no shared mutable state, safe to run in any order or in parallel.
- Integration tests: each test spins up (or truncates/reseeds) its own Testcontainers DB schema in `beforeEach`/`afterEach` — no test should depend on data left behind by another. This directly avoids the "only passes in a specific order" trap called out in the skill.
- E2E tests: seed a dedicated test portfolio account per run (or reset via API before each spec) so upload journeys don't collide across parallel CI workers.

---

## 4. CI Integration Plan

| Trigger | What runs | Blocks |
|---|---|---|
| **Every PR / commit** | Full unit suite (parsing, mapping, validation, holdings-calc — ~39 automated cases) | **Blocks merge.** Must stay fast (target: under 2 minutes) so devs don't skip waiting for it. This is the majority of coverage, so keeping it fast is the top CI priority. |
| **Merge to main** | Full integration suite (dedupe, import-then-recalc — ~13 cases), plus unit suite again | **Blocks deploy to staging**, does not re-block the PR that already merged. Uses containerized DB, so it's slower (~5–8 min) — acceptable at merge cadence, not at every keystroke. |
| **Nightly** | Full E2E suite (upload happy path, error handling, reimport) + full regression re-run of everything above | **Reports only** (does not block anything by itself) — surfaces environment/flakiness drift overnight. |
| **Pre-release** | Full E2E suite + full integration suite, gate check against Phase 0 exit criteria | **Blocks release** if any E2E or integration test in this domain fails — these are the money-path journeys, a failure here means real users see wrong holdings or a broken upload. |

Explicit statement per skill guidance: **unit test failure blocks merge; integration failure blocks deploy to staging; E2E failure blocks release but not the originating merge** (since E2E only runs nightly/pre-release, not per-PR, to keep PR feedback fast).

---

## 5. Flaky-Test Policy

- **Identification:** a test is marked flaky if it fails intermittently with no corresponding code change — operationalized as **2 failures within any rolling 10 CI runs** without a diff touching the code path under test. Nightly E2E and integration runs are the primary place this will surface, since unit tests (no I/O) should essentially never be flaky by construction — a "flaky" unit test is usually a signal of a real bug (e.g., relying on floating-point equality instead of a tolerance comparison in a gain-calculation test) rather than true flakiness, and should be fixed, not quarantined.
- **Quarantine process:** flaky test is tagged `@quarantined`, excluded from the blocking run, but still executed nightly and tracked — not deleted, not silently skipped forever.
- **Ownership:** the engineer who last modified the code path the test covers is assigned as owner at quarantine time; if unclear, the import-pipeline or holdings-calc tech lead (whoever owns that module) is default owner.
- **Fix-by date:** 2 weeks from quarantine. If unresolved, escalated in the weekly test-health review; a quarantined test open >30 days requires an explicit keep-or-delete decision rather than sitting indefinitely.
- **Accountability for list growth:** the Test Lead reviews the quarantine list weekly as part of Phase 3 execution tracking and reports quarantine-list size/age as a metric in the eventual Phase 4 summary report — an ever-growing quarantine list is itself a red flag to surface, not hide.

---

## 6. Phase 2 Exit Criteria — Status

| Criterion | Status |
|---|---|
| Test pyramid targets set and justified against the risk register | [x] Done — 65/25/10, justified above against reconstructed risk register (Section 1) |
| Every Phase 1 test case has an explicit automate-now/automate-later/manual decision with a reason | [x] Done for the reconstructed 60-case taxonomy (Section 2) — **needs reconciliation against the real Phase 1 case IDs once available; treat as draft until then** |
| Automation framework(s) selected and scaffolded in `/tests` | [~] Framework selected and folder scaffold specified (Section 3); **no actual code/files committed yet** since no existing repo/stack was available to inspect — this is a plan, not yet executed scaffolding |
| CI integration plan defined (what runs when, what blocks what) | [x] Done (Section 4) |
| Flaky-test policy defined | [x] Done (Section 5) |

**Overall Gate 2 status: not yet fully closed.** Two items need follow-up before this gate can be marked fully met:

1. The automate/manual decision table (Section 2) is built from a *reconstructed* case inventory, not the actual 60 written cases — it must be reconciled against the real Phase 1 traceability matrix before being treated as final.
2. The `/tests` scaffold in Section 3 is a proposed structure, not yet committed code — actual scaffolding (empty test files wired to a working CI job) still needs to happen in the real repository before Gate 2 can be marked complete per the skill's requirement that framework selection be "scaffolded in `/tests`" with code committed.

**Recommended next step:** provide the actual 60 Phase 1 case titles/IDs (or the traceability matrix file) so the decision table in Section 2 can be finalized 1:1 against real case IDs, and confirm the actual tech stack so Section 3's framework choices can be locked in and scaffolded for real.
