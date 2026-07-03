# Portfolio Management Web App — Test Strategy & Manual Test Cases (First Release)

**Prepared by:** Test Lead (AI-assisted)
**Date:** 2026-07-02
**Status:** Draft for review — Phase 0 (Test Strategy) and Phase 1 (Test Design)

> **Assumptions made (no clarifying questions asked, per instructions):**
> - This is a web app (desktop browser primary, responsive is a nice-to-have, not gating this release).
> - Brokerage linking is via a third-party aggregator (e.g., Plaid-style OAuth/credential-based linking), not a direct broker API integration built in-house.
> - Holdings, transaction history, and performance/returns are read-only views for this release — no trading, no money movement, no order placement in-app.
> - The app handles real financial account data, so it is treated as a **high-sensitivity financial application** even though it doesn't move money.
> - Single currency (USD) and single-user accounts (no multi-user/household sharing) for v1.
> - A staging environment with sandbox/test brokerage credentials is assumed available (standard for aggregators like Plaid, Yodlee, MX, Finicity).
> - Team is small: one test lead/QA doing manual design, developers assist with review and unit/integration tests.
>
> Where an assumption materially changes scope, it's called out inline so it can be corrected before execution.

---

## Phase 0 — Test Strategy

### 1. Scope

**In scope for this release's test effort:**
- Account linking: connecting a brokerage account via the aggregator flow (OAuth/credential handoff), link status, re-authentication when a link expires.
- Holdings view: positions, quantities, current value, cost basis (if shown), asset allocation.
- Transaction history: buys/sells/dividends/transfers pulled from linked accounts, filtering/sorting, pagination.
- Performance & returns: time-weighted or simple return calculations, gain/loss, performance over time ranges (e.g., 1M/YTD/1Y/All).
- Account management: unlinking/removing a brokerage account, viewing multiple linked accounts, refreshing data.
- Cross-cutting: authentication/session security, data sync/refresh behavior, error handling when the aggregator or broker is unavailable.

**Explicitly out of scope for this test effort:**
- **Trading/order execution** — not in this release; no test coverage needed since the feature doesn't exist.
- **Internals of the brokerage/aggregator's own systems** — we test our integration against the aggregator's sandbox/API contract, not the aggregator's correctness or the broker's back-end accuracy.
- **Tax lot accounting / tax document generation** — not in this release unless confirmed otherwise.
- **Mobile native apps** — this release is web-only; responsive browser behavior is smoke-tested only, not a full parallel matrix.
- **Localization/multi-currency** — USD/single-locale assumed for v1.
- **Load/scale testing at production-scale user volume** — basic performance sanity only (see Test Levels); full load testing deferred to a dedicated performance testing pass before broader marketing/launch scale-up.

**Environments in scope for sign-off:** Staging (with sandbox brokerage credentials from the aggregator) is the primary sign-off environment. A production smoke test (read-only checks: login, view a real linked account, view holdings) is required post-deploy before the release is considered fully closed.

### 2. Test Levels

| Level | Applies? | Answers | Owner |
|---|---|---|---|
| Unit | Yes | Do return/gain-loss calculations, aggregation logic, and data transformers produce correct results in isolation? | Developers |
| Integration | Yes | Does our backend correctly call the aggregator API, persist linked-account data, and reconcile sync responses? | Developers / QA |
| System / E2E | Yes | Does the full journey — link account → view holdings → view transactions → view performance — work end to end? | QA |
| UAT | Yes (lightweight) | Does a real user (internal beta or product owner acting as proxy) find the numbers trustworthy and the flows intuitive? | Product / beta users |
| Performance | Yes (scoped) | Does the app stay responsive with realistic data volumes (large transaction histories, multiple linked accounts) and during aggregator sync delays? | QA / SRE |
| Security | Yes (elevated priority) | Can account credentials, linked-account tokens, or financial data be exposed, intercepted, or accessed by the wrong user? | Security / QA |
| Accessibility | Yes (baseline) | Can key flows (link account, view holdings/returns) be completed via keyboard and screen reader, and do numeric displays meet contrast/labeling basics? | QA |

Security and correctness of financial calculations are elevated above typical web-app defaults because this is money-adjacent data — even without trade execution, a wrong balance or a leaked credential is a trust-ending bug for this product category.

### 3. Risk-Based Prioritization

Features/journeys scored on **Likelihood × Impact**. This release is new (everything is "new code" from a likelihood standpoint), so ranking leans on **impact** and on which components are hardest to get right (third-party integration, financial math) to avoid the "everything is High" trap.

| # | Feature / Journey | Likelihood | Impact | Risk Tier | Rationale |
|---|---|---|---|---|---|
| 1 | Account linking (OAuth/credential flow, success + failure paths) | High (new, third-party dependency, many failure modes) | High (broken link = zero value from the app; credential mishandling = severe trust/security issue) | **High** | Gateway to every other feature; highest surface area for third-party failure and security exposure. |
| 2 | Performance & returns calculations | High (custom math, easy to get subtly wrong) | High (wrong numbers directly mislead a user's financial decisions — this is the core value prop) | **High** | Silent calculation errors are the single most damaging bug class for this product; users won't necessarily notice a wrong return % is wrong. |
| 3 | Holdings accuracy (positions, quantities, current value) | Medium-High (depends on correct sync + valuation) | High (wrong holdings = user distrust, potential real-world financial decisions made on bad data) | **High** | Directly visible, directly consequential if wrong. |
| 4 | Transaction history accuracy & completeness | Medium (sync/pagination logic) | High (missing or duplicated transactions undermine trust and can misstate performance) | **High** | Feeds performance calculations — errors here cascade into risk #2. |
| 5 | Session/account security & data isolation (auth, authorization, token storage) | Medium (standard patterns, but consequences severe if wrong) | High (cross-account data leakage or credential exposure is a severe/regulatory-adjacent issue) | **High** | Low likelihood if built on solid frameworks, but impact is severe enough to keep in the top tier. |
| 6 | Account sync/refresh behavior (manual refresh, stale data indicators, background sync) | Medium | Medium | **Medium** | Annoying if wrong (stale data shown as current) but usually visible/correctable, not silently catastrophic. |
| 7 | Unlinking/removing a brokerage account | Low-Medium | Medium (data should be fully removed/disassociated; partial removal is a privacy concern) | **Medium** | Used less frequently, but privacy implications keep it out of Low. |
| 8 | Multi-account aggregation (viewing combined holdings/performance across accounts) | Medium | Medium | **Medium** | Adds complexity on top of already-tested single-account logic; incremental risk. |
| 9 | Filtering/sorting transaction history UI | Low | Low-Medium | **Medium** | Usability issue if broken, not a data-integrity issue. |
| 10 | General navigation, empty states, onboarding copy | Low | Low | **Low** | Cosmetic/UX; failure is annoying, not harmful. |
| 11 | Notification/email on link failure (if present) | Low | Low | **Low** | Nice-to-have; absence doesn't block core value. |

**Distribution check:** 5 of 11 items (~45%) are High. This is above the "roughly a third" guideline, so it's worth stating explicitly why: this app's core value (holdings + performance) *is* financial-data accuracy plus a third-party integration, so the concentration of High-risk items in "does the money math check out" and "is the link secure" reflects the product's actual risk profile, not a failure to discriminate. Items 6–11 are deliberately kept at Medium/Low to preserve a real prioritization signal — if time is cut, cases in items 9–11 are cut first, then item 8, then item 6/7, before any High-risk case is dropped.

### 4. Entry & Exit Criteria

**Entry criteria (testing can begin when):**
- Build deploys cleanly to staging.
- Staging is connected to the aggregator's sandbox environment with at least 2–3 sandbox brokerage institutions available (to cover multi-broker variability).
- Acceptance criteria exist (even in brief form) for account linking, holdings, transactions, and performance views.
- Seeded sandbox test accounts exist with known, predictable holdings/transaction data (see Test Data below).

**Exit criteria (test effort is done when):**
- 100% of High-risk test cases executed with a Pass result (or explicitly waived with sign-off per the skill's override policy).
- No open Critical or High-severity defects; any exceptions have documented, approved waivers.
- Financial calculations (returns, gain/loss, holdings value) independently verified against a hand-calculated or spreadsheet-derived expected value for every seeded test account.
- Account-linking security cases (session isolation, token handling, no cross-account leakage) pass with no exceptions — this category is not eligible for waiver given impact severity.
- Medium-risk cases at least 90% executed and passing; Low-risk cases smoke-tested.
- Production post-deploy smoke test passes (login, view real linked account, view holdings/returns without error).

### 5. Test Environments & Data

- **Environments:**
  - *Local/dev*: unit and integration tests, run by developers, on every commit.
  - *Staging*: full manual E2E test execution, connected to the brokerage aggregator's **sandbox** mode (not live institutions) so tests are deterministic and don't touch real financial accounts.
  - *Production*: smoke test only, post-deploy, using one real (team-owned, consented) linked test account with minimal real holdings.
- **Test data strategy:**
  - Use the aggregator's sandbox test institutions/credentials (most aggregators — Plaid, MX, Finicity, Yodlee — provide these) to simulate: normal accounts, accounts with large transaction histories, accounts with zero holdings, accounts that fail to link, and accounts that require re-authentication (expired credentials).
  - Seed at least one sandbox account with a **known, hand-verifiable** set of transactions and holdings so expected performance/return values can be calculated independently and compared against the app's output.
  - No real user PII or real account credentials are used in staging under any circumstance.
  - Data reset: sandbox accounts should be re-seedable/resettable between test cycles so tests are repeatable; note in each test case if it mutates state (e.g., unlinking) and needs a reset afterward.
- **Environment quirks to account for:** aggregator sandbox sync can be slower/faster than production and may have simulated failure modes (feature-flaggable) — testers should know how to trigger "link failure," "requires re-auth," and "sync delay" scenarios in sandbox specifically.

### 6. Tooling

- **Test case management:** Spreadsheet/markdown-based tracking for this release (team size doesn't justify a dedicated TCM tool yet); this document plus a traceability matrix (below) is the source of truth. Revisit if the team or scope grows.
- **Automation framework:** Not decided in this document — deferred to Phase 2 (Automation Planning) per the skill's phase model. Constraint to note now: whatever E2E framework is chosen must be able to handle the third-party aggregator's OAuth/credential-handoff redirect flow (this rules out some simpler DOM-only tools and favors something with full browser control, e.g., Playwright).
- **Defect tracker:** Assumed to be whatever issue tracker the team already uses (e.g., GitHub Issues, Jira). Severity defined as: **Critical** (data loss, security breach, wrong financial numbers shown, app unusable), **High** (major feature broken, no workaround), **Medium** (feature impaired, workaround exists), **Low** (cosmetic/minor usability).

### 7. Roles & Responsibilities

Small-team assumption — flagged explicitly rather than left implied:

| Role | Responsibility | Assumed Owner |
|---|---|---|
| Test strategy & risk register | This document | Test Lead |
| Manual test case authoring | Phase 1 below | Test Lead |
| Test case review | Reviews test cases for gaps/technical accuracy | 1 Developer + 1 Product Owner (each reviews a pass) |
| Manual test execution | Runs test cases pre-release | Test Lead (+ developers for integration-level checks) |
| Automation build | Deferred to Phase 2 | Developers, with Test Lead defining what/priority |
| Defect triage & severity call | Classifies and prioritizes defects found | Test Lead proposes, Product Owner + Eng Lead confirm Critical/High calls |
| Go/No-Go authority | Final release decision | Product Owner + Eng Lead, informed by Test Lead's report |

### Phase 0 Deliverables Checklist

- [x] Scope (in and out) documented
- [x] Applicable test levels identified
- [x] Risk register produced with features/modules ranked High/Medium/Low
- [x] Entry and exit criteria defined
- [x] Test environment and test data strategy defined
- [x] Tooling decided (test management, automation, defect tracking)
- [x] Roles and responsibilities assigned

---

## Phase 1 — Test Design (Manual Test Cases)

Cases are grouped by feature area and ordered by risk tier within each area (High-risk areas get the deepest edge-case coverage, per the strategy above). IDs use `TC-<module>-<number>`.

### Traceability Matrix

| Requirement / AC ID | Test Case ID(s) | Risk Tier | Status |
|---|---|---|---|
| REQ-LINK-01: User can link a brokerage account | TC-LINK-01, TC-LINK-02, TC-LINK-03 | High | Written |
| REQ-LINK-02: Linking fails gracefully | TC-LINK-04, TC-LINK-05, TC-LINK-06 | High | Written |
| REQ-LINK-03: Expired/revoked link requires re-auth | TC-LINK-07, TC-LINK-08 | High | Written |
| REQ-LINK-04: User can unlink an account | TC-LINK-09, TC-LINK-10 | Medium | Written |
| REQ-SEC-01: Session and data isolation between users | TC-SEC-01, TC-SEC-02, TC-SEC-03 | High | Written |
| REQ-SEC-02: Credentials/tokens not exposed | TC-SEC-04, TC-SEC-05 | High | Written |
| REQ-HOLD-01: Holdings display accurately | TC-HOLD-01, TC-HOLD-02, TC-HOLD-03 | High | Written |
| REQ-HOLD-02: Holdings handle edge quantities/values | TC-HOLD-04, TC-HOLD-05, TC-HOLD-06 | High | Written |
| REQ-HOLD-03: Multi-account holdings aggregation | TC-HOLD-07 | Medium | Written |
| REQ-TXN-01: Transaction history displays accurately | TC-TXN-01, TC-TXN-02, TC-TXN-03 | High | Written |
| REQ-TXN-02: Transaction history handles volume/pagination | TC-TXN-04, TC-TXN-05 | High | Written |
| REQ-TXN-03: Filtering and sorting transactions | TC-TXN-06, TC-TXN-07 | Medium | Written |
| REQ-PERF-01: Returns/performance calculated correctly | TC-PERF-01, TC-PERF-02, TC-PERF-03 | High | Written |
| REQ-PERF-02: Performance across time ranges | TC-PERF-04, TC-PERF-05 | High | Written |
| REQ-PERF-03: Performance edge cases (new account, zero activity) | TC-PERF-06, TC-PERF-07 | High | Written |
| REQ-SYNC-01: Manual refresh / stale data indication | TC-SYNC-01, TC-SYNC-02 | Medium | Written |
| REQ-UX-01: Empty/onboarding states | TC-UX-01 | Low | Written |
| REQ-A11Y-01: Keyboard/screen-reader access to core flows | TC-A11Y-01, TC-A11Y-02 | Medium | Written |

---

### A. Account Linking (High Risk)

```text
ID: TC-LINK-01
Title: Successfully link a brokerage account with valid sandbox credentials
Priority: High
Preconditions: User is logged in; no accounts currently linked; aggregator sandbox available
Steps:
  1. Navigate to "Link Account" / "Add Brokerage Account"
  2. Select a sandbox institution from the list
  3. Enter valid sandbox credentials in the aggregator's connection flow
  4. Complete any MFA/verification step presented by the sandbox flow
  5. Return to the app after the aggregator flow completes
Expected Result: Account appears in the user's linked accounts list with status "Connected"; initial data sync begins or completes; user is returned to a sensible in-app screen (not an error page)
Test Data: Sandbox institution "Test Bank A" with known credentials from aggregator sandbox docs
```

```text
ID: TC-LINK-02
Title: Link a second brokerage account from a different institution
Priority: High
Preconditions: User already has one account linked (from TC-LINK-01)
Steps:
  1. Initiate "Add another account" flow
  2. Select a different sandbox institution
  3. Complete the connection flow
Expected Result: Both accounts appear in the linked accounts list, independently; data from account 1 is unaffected
Test Data: Sandbox institution "Test Bank B"
```

```text
ID: TC-LINK-03
Title: Link flow is abandoned/cancelled by user mid-flow
Priority: High
Preconditions: User is logged in, in the middle of the linking flow at the aggregator's UI
Steps:
  1. Start the link flow
  2. Close/cancel the aggregator popup or navigate back before completing
Expected Result: App returns to a clean state with no partial/broken account entry created; user can retry linking without needing to reload or re-login
Test Data: N/A
```

```text
ID: TC-LINK-04
Title: Linking fails due to invalid credentials
Priority: High
Preconditions: User is logged in, on the link flow
Steps:
  1. Select a sandbox institution
  2. Enter intentionally invalid credentials (per aggregator sandbox's documented failure-simulation values)
Expected Result: Aggregator/app shows a clear, user-understandable error; no broken/half-linked account is created; user can retry
Test Data: Aggregator sandbox's designated "invalid credentials" test values
```

```text
ID: TC-LINK-05
Title: Linking fails due to institution/aggregator outage (simulated)
Priority: High
Preconditions: Aggregator sandbox supports simulating an institution-down response
Steps:
  1. Trigger the simulated outage condition per aggregator sandbox docs
  2. Attempt to link an account against that institution
Expected Result: App shows a clear "service temporarily unavailable, try again later" message; does not show a generic crash/error page; does not silently fail with no feedback
Test Data: Aggregator sandbox outage-simulation institution
```

```text
ID: TC-LINK-06
Title: Linking fails due to network interruption mid-flow
Priority: High
Preconditions: User is mid-linking-flow
Steps:
  1. Start link flow, reach the credential submission step
  2. Simulate network loss (disable network / throttle to offline) before flow completes
  3. Restore network
Expected Result: App detects the failure state and shows an appropriate error/retry option rather than hanging indefinitely; no partial account created
Test Data: N/A (network condition simulated via dev tools/proxy)
```

```text
ID: TC-LINK-07
Title: Previously linked account shows "requires re-authentication" when credentials expire/are revoked
Priority: High
Preconditions: An account is linked; aggregator sandbox supports forcing an "item login required" state
Steps:
  1. Trigger the sandbox's expired/revoked credential state for the linked account
  2. Load the app's dashboard or linked accounts page
Expected Result: Affected account is clearly flagged (e.g., "Reconnect required") rather than silently showing stale data as if current; other linked accounts are unaffected
Test Data: Aggregator sandbox re-auth-required simulation
```

```text
ID: TC-LINK-08
Title: User successfully re-authenticates an expired link
Priority: High
Preconditions: Account is in "requires re-authentication" state (from TC-LINK-07)
Steps:
  1. Click "Reconnect" / "Fix connection" on the flagged account
  2. Complete the aggregator's re-auth flow with valid sandbox credentials
Expected Result: Account status returns to "Connected"; historical data is preserved (not wiped/duplicated); sync resumes
Test Data: Same sandbox institution, valid credentials
```

```text
ID: TC-LINK-09
Title: User unlinks/removes a brokerage account
Priority: Medium
Preconditions: At least one account is linked
Steps:
  1. Navigate to account settings for a linked account
  2. Select "Remove" / "Unlink account"
  3. Confirm the action (assume a confirmation step exists given the destructive nature)
Expected Result: Account is removed from the linked accounts list; associated holdings/transactions no longer appear in aggregate views; underlying access token is revoked with the aggregator (verify via aggregator sandbox dashboard/logs if accessible)
Test Data: A linked sandbox account dedicated to deletion testing (so it doesn't affect other test cases' data)
```

```text
ID: TC-LINK-10
Title: Unlinking one account does not affect other linked accounts' data
Priority: Medium
Preconditions: Two or more accounts linked
Steps:
  1. Unlink one account
  2. View holdings, transactions, and performance for the remaining account(s)
Expected Result: Remaining account's data is complete and unchanged; no orphaned references to the removed account (e.g., in aggregate totals) remain
Test Data: Two sandbox accounts with distinct, known holdings
```

### B. Security & Session Isolation (High Risk)

```text
ID: TC-SEC-01
Title: User A cannot view User B's linked accounts or financial data
Priority: High
Preconditions: Two distinct user accounts (User A, User B) each with their own linked brokerage accounts
Steps:
  1. Log in as User A, note account/holdings identifiers (IDs, URLs) shown
  2. Log out; log in as User B
  3. Attempt to access User A's account/holdings data directly via URL manipulation (e.g., changing an account ID in the URL) if such direct-access URLs exist
Expected Result: User B receives an authorization error (403/404-equivalent) and cannot view any of User A's data under any circumstance
Test Data: Two separate test user accounts, each with a distinct linked sandbox brokerage account
```

```text
ID: TC-SEC-02
Title: Session expires and requires re-login after inactivity/timeout
Priority: High
Preconditions: User logged in; session timeout policy known (assumed to exist; confirm actual timeout value with dev team)
Steps:
  1. Log in, leave session idle past the configured timeout
  2. Attempt to view holdings/transactions
Expected Result: User is prompted to re-authenticate; no financial data is rendered without a valid session
Test Data: N/A
```

```text
ID: TC-SEC-03
Title: Logging out clears session and prevents back-navigation data exposure
Priority: High
Preconditions: User logged in, has viewed holdings/transactions
Steps:
  1. Log out
  2. Use browser back button to attempt to return to a previously viewed holdings/transactions page
Expected Result: App redirects to login / does not display cached financial data; no sensitive data visible without re-authentication
Test Data: N/A
```

```text
ID: TC-SEC-04
Title: Brokerage credentials are never handled or stored by our application directly
Priority: High
Preconditions: Access to network traffic inspection (dev tools) during a link flow
Steps:
  1. Initiate account linking
  2. Inspect network requests during credential entry
Expected Result: Credentials are transmitted directly to the aggregator's domain, not to our application's backend; our backend only ever receives a token/public token, never raw broker credentials
Test Data: N/A (inspection-based test)
```

```text
ID: TC-SEC-05
Title: Access tokens/secrets are not exposed in client-side code, logs, or browser storage in plaintext
Priority: High
Preconditions: Account linked; access to dev tools
Steps:
  1. Inspect browser local storage, session storage, and cookies after linking
  2. Inspect any client-visible network responses for token values
Expected Result: No long-lived aggregator access token or secret is stored in plaintext in client-accessible storage; any token present is appropriately scoped/short-lived or absent from the client entirely
Test Data: N/A (inspection-based test)
```

### C. Holdings View (High Risk)

```text
ID: TC-HOLD-01
Title: Holdings list matches known sandbox account positions
Priority: High
Preconditions: Sandbox account with a known, pre-verified set of positions is linked
Steps:
  1. Navigate to Holdings view
  2. Compare displayed positions (symbol, quantity, current price, market value) against the known sandbox data
Expected Result: All positions match exactly — no missing, extra, or misvalued holdings
Test Data: Seeded sandbox account "known-holdings-01" with documented expected values
```

```text
ID: TC-HOLD-02
Title: Holdings values update after a data refresh/sync
Priority: High
Preconditions: Account linked; sandbox supports simulating a price/quantity change between syncs
Steps:
  1. Note current holdings values
  2. Trigger a change in sandbox data (or wait for scheduled sync if simulation isn't available) and force a refresh in-app
Expected Result: Updated values are reflected accurately; no stale values persist after refresh completes
Test Data: Sandbox account with simulate-able data change
```

```text
ID: TC-HOLD-03
Title: Cost basis and unrealized gain/loss display correctly (if in scope for v1)
Priority: High
Preconditions: Seeded account with known cost basis per position
Steps:
  1. View a position's detail
  2. Compare displayed cost basis and unrealized gain/loss against hand-calculated expected values
Expected Result: Values match expected calculation (market value − cost basis); gain/loss sign (positive/negative) and formatting (color, +/-) are correct
Test Data: Seeded sandbox account with known purchase prices
```

```text
ID: TC-HOLD-04
Title: Holdings view handles an account with zero positions
Priority: High
Preconditions: A linked sandbox account with no current holdings (e.g., fully liquidated)
Steps:
  1. View Holdings for this account
Expected Result: A clear empty state is shown ("No holdings found") rather than a blank screen, error, or loading spinner that never resolves
Test Data: Sandbox account with zero positions
```

```text
ID: TC-HOLD-05
Title: Holdings view handles a very large number of positions
Priority: High
Preconditions: Sandbox account (or simulated data) with a large number of distinct positions (e.g., 100+)
Steps:
  1. View Holdings for this account
Expected Result: All positions load (paginated or scrollable as designed); no truncation, timeout, or performance degradation that blocks usability
Test Data: Sandbox/synthetic account with 100+ positions
```

```text
ID: TC-HOLD-06
Title: Holdings view handles fractional shares and very small/large quantities correctly
Priority: High
Preconditions: Seeded account with a fractional-share position (e.g., 0.0001 shares) and a very large quantity position
Steps:
  1. View Holdings
  2. Check displayed quantity and computed market value for both edge positions
Expected Result: Fractional and large quantities display with correct precision (no silent rounding that changes computed value); market value math remains accurate
Test Data: Seeded position with fractional shares; seeded position with large quantity (e.g., 100,000 shares)
```

```text
ID: TC-HOLD-07
Title: Aggregate holdings view correctly sums positions across multiple linked accounts
Priority: Medium
Preconditions: Two+ accounts linked, each with known holdings, including an overlapping symbol held in both
Steps:
  1. View the combined/aggregate holdings view (if the app offers a cross-account rollup)
Expected Result: Overlapping symbol is correctly summed (or clearly shown per-account, per design); total portfolio value equals the sum of both accounts' verified values
Test Data: Two sandbox accounts, one shared symbol held in both
```

### D. Transaction History (High Risk)

```text
ID: TC-TXN-01
Title: Transaction history matches known sandbox account activity
Priority: High
Preconditions: Seeded sandbox account with a known list of transactions (buys, sells, dividends)
Steps:
  1. Navigate to Transaction History
  2. Compare each transaction (date, type, symbol, quantity, price, amount) against the known expected list
Expected Result: All transactions present, none missing or duplicated, all fields accurate
Test Data: Seeded sandbox account "known-transactions-01"
```

```text
ID: TC-TXN-02
Title: Transaction history includes non-trade activity (dividends, transfers, fees) if in scope
Priority: High
Preconditions: Seeded account with a dividend and/or transfer event
Steps:
  1. View Transaction History
Expected Result: Non-trade activity types display with correct labeling and amounts, distinguishable from buy/sell trades
Test Data: Seeded dividend/transfer event
```

```text
ID: TC-TXN-03
Title: Transaction detail view shows accurate, complete information for a single transaction
Priority: High
Preconditions: A known transaction exists
Steps:
  1. Click into a single transaction's detail view
Expected Result: All fields (date, settlement date if shown, price, quantity, fees, total) match expected values with no truncation or mislabeling
Test Data: Single known transaction record
```

```text
ID: TC-TXN-04
Title: Transaction history handles a large volume of transactions (pagination/infinite scroll)
Priority: High
Preconditions: Seeded/synthetic account with a large transaction count (e.g., 500+)
Steps:
  1. Load Transaction History
  2. Scroll/paginate through the full list
Expected Result: All transactions are reachable, no duplicates or gaps introduced by pagination, performance remains acceptable (no multi-second freezes)
Test Data: Synthetic account with 500+ transactions
```

```text
ID: TC-TXN-05
Title: New transactions appear after a sync following the initial link
Priority: High
Preconditions: Account already linked and synced once
Steps:
  1. Simulate a new transaction occurring in the sandbox account
  2. Trigger a sync/refresh
Expected Result: New transaction appears in history without duplicating previously synced transactions
Test Data: Sandbox account supporting incremental transaction simulation
```

```text
ID: TC-TXN-06
Title: Filtering transaction history by type/date range works correctly
Priority: Medium
Preconditions: Account with a mix of transaction types across multiple dates
Steps:
  1. Apply a filter for a specific transaction type (e.g., "Dividends only")
  2. Apply a date range filter
Expected Result: Only matching transactions display; filters can be combined and cleared without stale results lingering
Test Data: Mixed transaction dataset spanning several months and types
```

```text
ID: TC-TXN-07
Title: Sorting transaction history by date/amount works correctly
Priority: Medium
Preconditions: Account with multiple transactions of varying dates/amounts
Steps:
  1. Sort by date ascending/descending
  2. Sort by amount ascending/descending
Expected Result: Sort order is correct and stable; no transactions dropped when re-sorting
Test Data: Mixed transaction dataset
```

### E. Performance & Returns (High Risk)

```text
ID: TC-PERF-01
Title: Total return percentage matches hand-calculated expected value for a known account
Priority: High
Preconditions: Seeded account with fully known transaction and price history sufficient to hand-calculate expected return
Steps:
  1. Independently calculate expected return (e.g., simple return or time-weighted return, per whatever methodology the app documents) using spreadsheet/manual math
  2. View the app's displayed return for the same account/period
Expected Result: App's displayed value matches the independently calculated value within an agreed rounding tolerance (e.g., 0.01%)
Test Data: Seeded account "known-performance-01" with documented calculation worksheet
```

```text
ID: TC-PERF-02
Title: Gain/loss (dollar amount) matches hand-calculated expected value
Priority: High
Preconditions: Same seeded account as TC-PERF-01
Steps:
  1. Compare app's displayed $ gain/loss against independently calculated expected value
Expected Result: Values match within rounding tolerance; sign (gain vs. loss) is correct
Test Data: Same as TC-PERF-01
```

```text
ID: TC-PERF-03
Title: Performance calculation correctly accounts for deposits/withdrawals (cash flow), not just price movement
Priority: High
Preconditions: Seeded account with a mid-period deposit or withdrawal event
Steps:
  1. Calculate expected return using a method that correctly excludes cash-flow timing distortion (e.g., time-weighted return) if that's the app's documented methodology
  2. Compare against app's displayed return
Expected Result: App's return figure is not distorted by the deposit/withdrawal (i.e., it doesn't misrepresent a cash injection as investment gain, or vice versa)
Test Data: Seeded account with a documented mid-period cash flow event
```

```text
ID: TC-PERF-04
Title: Performance displays correctly across all supported time ranges
Priority: High
Preconditions: Seeded account with sufficient history to cover all offered ranges (e.g., 1M, YTD, 1Y, All)
Steps:
  1. Select each time range option in turn
  2. Verify the return/gain-loss figure updates and matches the expected value for that specific range
Expected Result: Each range shows a distinct, correct value scoped to that period only; switching ranges doesn't leave stale data from a previous selection
Test Data: Seeded account with multi-year history
```

```text
ID: TC-PERF-05
Title: Performance chart (if present) reflects the same data as the numeric summary
Priority: High
Preconditions: Seeded account with known performance history
Steps:
  1. Compare the chart's start/end values and general trend against the numeric performance summary shown alongside it
Expected Result: Chart and numeric summary are consistent with each other (no case where the chart shows a gain but the number shows a loss, or similar contradiction)
Test Data: Same seeded account
```

```text
ID: TC-PERF-06
Title: Performance view handles a brand-new account with no price history yet
Priority: High
Preconditions: Newly linked account, first sync just completed, insufficient history for a return calculation
Steps:
  1. View Performance for this account immediately after linking
Expected Result: App shows an appropriate "not enough data yet" state rather than a misleading 0%, error, or NaN/undefined value
Test Data: Freshly linked sandbox account
```

```text
ID: TC-PERF-07
Title: Performance view handles an account with zero net gain/loss (flat performance)
Priority: High
Preconditions: Seeded account engineered to have exactly flat performance over the test period
Steps:
  1. View Performance for this account
Expected Result: Displays 0.00% / $0.00 correctly formatted, not blank, not an error, correct neutral styling (not colored as a gain or loss)
Test Data: Seeded account with flat performance
```

### F. Sync / Refresh Behavior (Medium Risk)

```text
ID: TC-SYNC-01
Title: Manual refresh updates data and shows a loading/progress indicator
Priority: Medium
Preconditions: Account linked
Steps:
  1. Trigger a manual refresh
Expected Result: A loading indicator is shown during sync; data updates on completion; no duplicate data created by repeated syncs
Test Data: N/A
```

```text
ID: TC-SYNC-02
Title: Stale data is indicated to the user when a sync fails or hasn't run recently
Priority: Medium
Preconditions: Simulate a sync failure or an account that hasn't synced in an extended period
Steps:
  1. View the account/holdings after a failed or overdue sync
Expected Result: A "last updated" timestamp or stale-data indicator is visible so the user isn't misled into thinking the data is current
Test Data: Sandbox account with simulated sync failure
```

### G. Usability / Empty States (Low Risk)

```text
ID: TC-UX-01
Title: New user with no linked accounts sees a clear onboarding/empty state
Priority: Low
Preconditions: Newly registered user, no accounts linked
Steps:
  1. Log in for the first time
  2. View the dashboard/holdings/transactions/performance pages
Expected Result: Each page shows a clear call-to-action to link an account rather than a blank or broken page
Test Data: Fresh test user account
```

### H. Accessibility (Medium Risk, Baseline)

```text
ID: TC-A11Y-01
Title: Core flows (link account, view holdings, view performance) are keyboard-navigable
Priority: Medium
Preconditions: None
Steps:
  1. Using only keyboard (Tab/Shift+Tab/Enter/Space), complete: initiating account link, navigating to Holdings, navigating to Performance
Expected Result: All interactive elements are reachable and operable via keyboard; focus order is logical; focus is visible
Test Data: N/A
```

```text
ID: TC-A11Y-02
Title: Screen reader announces key financial figures meaningfully
Priority: Medium
Preconditions: Screen reader enabled (e.g., NVDA/VoiceOver)
Steps:
  1. Navigate to Holdings and Performance views with a screen reader active
  2. Listen to how values (position values, return %, gain/loss) are announced
Expected Result: Values are announced with sufficient context (e.g., "AAPL, 10 shares, $1,500 market value") rather than bare unlabeled numbers; positive/negative performance isn't conveyed by color alone
Test Data: N/A
```

---

### Test Data Requirements Summary

| Test Data Set | Used By | Description |
|---|---|---|
| `known-holdings-01` | TC-HOLD-01–03, TC-PERF-01–03 | Sandbox account with fully documented positions, cost basis, and transaction history enabling independent hand-calculation of expected values |
| `known-transactions-01` | TC-TXN-01–03 | Sandbox account with a documented, itemized transaction list |
| Zero-position account | TC-HOLD-04, TC-PERF-06 | Sandbox account with no current holdings / freshly linked |
| High-volume account | TC-HOLD-05, TC-TXN-04 | Synthetic account with 100+ positions / 500+ transactions |
| Fractional/large-quantity account | TC-HOLD-06 | Seeded position with fractional and very large share counts |
| Flat-performance account | TC-PERF-07 | Engineered to have exactly 0% return over the test window |
| Multi-account pair (overlapping symbol) | TC-HOLD-07, TC-LINK-02, TC-LINK-10 | Two sandbox accounts, one shared ticker |
| Two distinct user accounts | TC-SEC-01 | For cross-user isolation testing |
| Invalid-credential / outage / re-auth-required sandbox states | TC-LINK-04, 05, 07 | Aggregator sandbox's documented failure-simulation values |

All sandbox data must be resettable between test cycles; test cases that mutate state (TC-LINK-09, TC-LINK-10) should use dedicated accounts not shared with read-only verification cases.

### Phase 1 Deliverables Checklist

- [x] Manual test cases written for all Must-Have acceptance criteria (Account Linking, Holdings, Transactions, Performance, Security)
- [x] Traceability matrix complete (see above) — 18 requirements mapped to 38 test cases
- [x] Edge cases and negative scenarios identified, weighted toward High-risk areas (linking failures, security isolation, calculation edge cases, volume/boundary cases concentrated in Sections A–E)
- [x] Test data requirements documented (see Test Data Requirements Summary)
- [ ] Test cases reviewed by at least one other person — **not yet done; this is a generated first draft.** Recommend a developer pass (for technical accuracy on sync/token handling cases) and a product owner pass (for correctness of expected results on performance/returns cases) before these are marked execution-ready.

---

## Gap Called Out for the Record

Per the skill's gate rules, **Gate 1 (Design → Automation Planning) is not yet fully met** — everything is satisfied except the peer/dev/product review step, which requires a human reviewer and cannot be completed in this non-interactive run. Recommend scheduling that review before moving to Phase 2 (Automation Planning).

## Suggested Next Steps

1. Route this document to one developer and one product owner for the required Phase 1 review.
2. Confirm the assumptions stated at the top (aggregator choice, read-only v1 scope, currency/locale) with the actual product owner — several test cases (e.g., TC-HOLD-03 cost basis) depend on whether those features are actually in v1 scope.
3. Once reviewed, proceed to Phase 2 (Automation Planning) to decide test pyramid targets and which of these 38 manual cases become automated regression coverage versus stay manual/exploratory.
