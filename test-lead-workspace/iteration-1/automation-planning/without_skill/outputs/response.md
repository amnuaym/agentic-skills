# Test Automation Plan: Transaction Import (CSV) & Holdings Calculation

## Context & Assumptions

Since I don't have access to your actual 60 manual test cases, codebase, or tech stack, I'm making the following reasonable assumptions. Adjust the plan once you map it against your real test case inventory:

- **System under test**: a portfolio app that (1) imports transactions via CSV upload, and (2) computes holdings (positions, cost basis, quantities, possibly P&L/market value) from those transactions.
- **Architecture**: a typical web app with a backend API/service layer that does parsing + calculation, and a frontend that handles the upload UI and displays results. Could be a monolith or separate services — the pyramid below works either way.
- **Manual tests likely split roughly**: ~35-40 on CSV import (parsing, validation, error handling, format variants) and ~20-25 on holdings calculation (math correctness, corporate actions, edge cases).
- **No test automation exists yet** — so we're also choosing frameworks/tooling conventions, not just categorizing tests.
- **Goal**: convert manual regression burden into a fast, reliable automated suite using a classic test pyramid (unit-heavy, thin E2E layer).

If any of these assumptions are wrong (e.g., you're on mobile, or holdings calc is a separate microservice), the categorization logic still applies — just remap the layers to your actual components.

---

## Step 1: Triage Your 60 Manual Tests Into Categories

Before building the pyramid, sort the existing 60 cases into four buckets. This determines *where* each test belongs, not just *whether* to automate it.

| Bucket | Description | Typical % of 60 |
|---|---|---|
| **A. Pure logic / calculation** | No I/O, no UI — given inputs, assert an output. E.g., "average cost basis after partial sell," "FIFO vs. average cost lot matching." | ~30-35% |
| **B. Parsing / validation logic** | CSV row → internal data structure, including malformed input handling. E.g., "missing column header," "date format DD/MM vs MM/DD," "negative quantity for a sell." | ~30-35% |
| **C. Integration / workflow** | Multiple components together: file upload → parser → persistence → recalculation trigger. E.g., "importing a CSV updates the holdings table and dashboard total." | ~20-25% |
| **D. UI / user-journey** | Requires a browser, involves clicking, seeing error toasts, downloading a report. E.g., "user sees inline error banner when uploading a .xlsx file by mistake." | ~10-15% |

**Action**: literally go through your 60 test cases and tag each with A/B/C/D. This single exercise usually reveals that 60-70% of your "manual test cases" are actually just poorly-disguised unit tests — which is great news, because those are the cheapest and fastest to automate.

---

## Step 2: The Test Pyramid

```
                    ▲
                   / \
                  / E2E \          5-8 tests   (~5%)
                 /-------\
                /         \
               / Integration\      15-20 tests (~20-25%)
              /-------------\
             /               \
            /   Unit Tests    \    100-150+ tests (~70-75%)
           /___________________\
```

### Layer 1 — Unit Tests (the base, ~70-75% of effort)

**What goes here**: Buckets A and B above — anything you can test as a pure function with in-memory inputs and no external dependencies (no DB, no HTTP, no filesystem beyond an in-memory string/buffer).

**CSV import unit tests**:
- Row-level parsing: correct column mapping, type coercion (string → decimal, string → date)
- Date format handling (ISO, US, EU, ambiguous formats), locale/number formats (1,000.00 vs 1.000,00)
- Missing/extra columns, reordered columns, extra whitespace, BOM/encoding issues (UTF-8 vs UTF-8-BOM vs Latin-1)
- Malformed rows: empty lines, trailing commas, quoted fields containing commas, embedded newlines
- Validation rules: negative price, zero quantity, unknown ticker/symbol format, duplicate transaction IDs, future-dated transactions
- Transaction type handling: buy, sell, dividend, split, transfer-in/out, fee-only rows
- Error message correctness and error-row collection (does it fail the whole file or report per-row errors?)
- Large-file boundary behavior (row count limits, if any — but true performance testing belongs in a separate perf suite, not this pyramid)

**Holdings calculation unit tests**:
- Cost basis methods: FIFO, LIFO, average cost — pick whichever your app supports and test each explicitly
- Partial sells (lot matching correctness)
- Stock splits / reverse splits adjusting historical cost basis and quantity
- Dividends (cash vs. reinvested — DRIP changes both cash and quantity)
- Short positions, if supported
- Currency conversion, if multi-currency
- Zero/negative resulting positions (fully sold out, oversold detection)
- Rounding and precision (this is where financial bugs hide — test with fractional shares, penny rounding, and assert exact decimal values, not floats)
- Empty portfolio, single transaction, and "very long history" (hundreds of transactions for one symbol) as boundary cases

**Tooling**: whatever your language's standard unit framework is (Jest/Vitest for JS/TS, pytest for Python, JUnit for Java, xUnit for .NET). Use **table-driven / parameterized tests** here — this is the single highest-leverage technique for converting your 60 manual cases, since many of them are the same assertion shape with different inputs (e.g., "date format X → parses to Y" repeated for 10 formats becomes one parameterized test with 10 rows).

**Target**: sub-second total run time for the whole unit layer. If parsing or calculation touches a database "just to look up a symbol," fake/stub that dependency — don't let it creep into this layer.

---

### Layer 2 — Integration Tests (middle, ~20-25% of effort)

**What goes here**: Bucket C — tests that need two or more real components wired together, typically CSV file → API endpoint → database → recomputed holdings, verified via API/DB assertions (no browser).

Examples:
- POST a real CSV file to the import endpoint; assert the transactions table and holdings table are correctly populated
- Re-importing the same file is idempotent (no duplicate transactions) or correctly rejected as a duplicate
- Importing a CSV with 3 valid rows and 2 invalid rows results in partial success with the right error report, and holdings reflect only the valid rows
- Import triggers a holdings recalculation that's consistent with existing holdings (not just the new transactions in isolation)
- Concurrent imports for the same account don't corrupt state (race condition check — worth 1-2 tests here, not more)
- CSV import from each broker/institution format you support, if you support multiple source formats (this is often a bigger deal than people expect — different brokers export wildly different CSVs)

**Tooling**: spin up a real (or containerized/in-memory) database and hit the actual API layer — e.g., Testcontainers, an in-memory SQLite/Postgres instance, or your framework's integration test harness (Django TestCase, Spring Boot @SpringBootTest, supertest against a real Express app, etc.).

**Target**: seconds per test, low-single-digit minutes for the whole layer. Should run on every PR, not just nightly.

---

### Layer 3 — End-to-End / UI Tests (top, ~5% of effort, small and deliberate)

**What goes here**: Bucket D — only the handful of journeys that must be verified through the actual UI because the risk lives in the UI itself (rendering, browser file-upload mechanics, user-visible error states).

Keep this to 5-8 tests, e.g.:
1. Happy path: user uploads a valid CSV, sees a success confirmation, and the holdings dashboard updates
2. User uploads a non-CSV file (e.g., .xlsx or .pdf) and sees a clear inline error, no crash
3. User uploads a CSV with some invalid rows and sees a partial-success summary with row-level errors
4. User uploads a very large CSV and sees a progress indicator / doesn't freeze the UI
5. User re-uploads a previously-imported file and sees the duplicate-handling UX (whatever that is — block, merge, warn)
6. User navigates to holdings view after import and the totals match what a human would hand-calculate for a small fixture file

**Tooling**: Playwright or Cypress. Run these against a real browser, ideally headless in CI, with a small seeded test account per run so tests are independent and repeatable.

**Target**: minutes, not seconds, per test — that's expected and fine at this layer. Because there are only a handful, total suite time stays manageable (aim for under ~10 minutes total).

---

## Step 3: Prioritization — What to Automate First

Don't try to convert all 60 at once. Sequence by **risk × frequency of regression**:

1. **Week 1 — Holdings calculation math (unit layer)**: this is the highest-risk area (silent financial miscalculation is worse than a crash) and the cheapest to automate since it's pure functions. Also gives you a regression safety net immediately for any refactor.
2. **Week 2 — CSV parsing/validation (unit layer)**: second highest value; malformed-input bugs are common and easy to parameterize into fast tests.
3. **Week 3 — Integration layer**: import-to-holdings pipeline tests, once the unit layer proves the components work individually.
4. **Week 4 — E2E layer**: last, and smallest, once you're confident the lower layers catch most regressions — E2E should only be catching UI-specific issues at this point.

This order also naturally front-loads the fastest, cheapest, most stable tests, which builds team confidence in the suite early rather than starting with flaky E2E tests that erode trust in automation.

---

## Step 4: Guardrails to Avoid Common Pitfalls

- **Golden/fixture files**: build a small library of representative CSV fixtures (valid-simple, valid-complex-multi-symbol, malformed-various, broker-format-A, broker-format-B, edge-case-fractional-shares) and reuse them across unit, integration, and E2E layers instead of inlining CSV strings everywhere. Keeps tests readable and consistent.
- **Decimal precision**: use a fixed-point/decimal type in both the app and the test assertions — never compare floats directly for money math. This is the #1 source of flaky "off by 0.00000001" failures in financial test suites.
- **Determinism**: freeze/mock "current date" wherever holdings calculations depend on today's date (e.g., market value as of now) so tests aren't time-dependent.
- **One assertion concept per test**: resist the urge to make one giant "import this file and check 40 things" test — split into focused tests so a failure tells you exactly what broke.
- **CI wiring**: run unit + integration on every push/PR (should complete in well under 5 minutes combined); run E2E on every PR too if feasible, otherwise at minimum pre-merge to main and nightly.
- **Track coverage against your original 60**: keep a simple spreadsheet mapping each of the 60 manual case IDs to the automated test(s) that now cover it (or "intentionally not automated — reason"). This closes the loop and shows stakeholders real progress instead of just "we wrote some tests."

---

## Suggested Target End-State

| Layer | Test count (approx.) | Run time | Runs on |
|---|---|---|---|
| Unit | 100-150+ | < 10 sec | every save / every commit |
| Integration | 15-20 | 1-3 min | every PR |
| E2E | 5-8 | 5-10 min | every PR (or pre-merge minimum) |

This gets you from 60 manual, human-executed cases to a suite that runs in well under 15 minutes total, catches regressions automatically, and actually gets *more* thorough over time (unit tests are cheap enough that new edge cases get added as you find bugs, rather than being a 61st manual case nobody has time to re-run).
