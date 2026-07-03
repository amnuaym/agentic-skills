# Test Strategy & Manual Test Cases — Portfolio Management Web App (v1.0 Release)

## Document Assumptions

Since this is a first release, I'm making the following assumptions to scope the strategy concretely. Adjust if any don't match reality:

1. **Core features in scope**: (a) brokerage account linking (likely via an aggregator like Plaid), (b) holdings view, (c) transaction history, (d) performance/returns tracking (e.g., time-weighted or money-weighted return, gain/loss).
2. Account linking uses a third-party aggregator (OAuth-style flow) rather than users manually entering brokerage credentials directly into our app.
3. Data is refreshed periodically (scheduled sync) and/or on-demand ("refresh" action), not necessarily real-time streaming.
4. The app displays real financial data — even "view only" — so correctness and data integrity are release blockers, not cosmetic bugs.
5. Multi-currency, tax-lot accounting, and multi-user/shared portfolios may or may not be in v1 — flagged as open questions where relevant.
6. Supported platforms: responsive web app, modern evergreen browsers (Chrome, Safari, Edge, Firefox), desktop + mobile web.
7. There is no in-app trading/order execution in v1 (view/track only) — if this assumption is wrong, a whole additional risk category (trade execution) needs its own strategy.

---

## 1. Test Strategy

### 1.1 Objective

Ensure the app presents **accurate, trustworthy financial data** and a **secure, reliable account-linking experience** before first release. For a finance product, correctness and trust are the product — a single wrong balance or duplicated transaction can destroy user confidence permanently, even if the UI is polished.

### 1.2 Guiding Principle: Risk-Based Prioritization

Testing effort is allocated by **(likelihood of failure) × (impact of failure)**, not by feature size. Impact is weighted heavily toward:
- **Financial data correctness** (wrong numbers are worse than missing features)
- **Security/privacy of financial credentials and account data**
- **Data integrity across sync/refresh cycles** (duplication, loss, staleness)

A bug that shows a wrong account balance is P0 even if it's visually tiny. A bug that misaligns a button is P3 even if it's visually obvious.

### 1.3 Risk Assessment by Core Area

| # | Area | Key Risks | Risk Level |
|---|------|-----------|------------|
| 1 | Account Linking | Credential/token leakage, failed/partial links leaving orphaned state, wrong account linked, MFA flow breaking, re-auth after token expiry | **Critical** |
| 2 | Holdings View | Wrong quantities/prices/valuations, stale data shown as current, missing asset classes, cost-basis errors | **Critical** |
| 3 | Transaction History | Missing, duplicated, or miscategorized transactions; incorrect sign (buy vs. sell); pagination dropping rows; date/timezone errors | **High** |
| 4 | Performance/Returns | Incorrect return calculation methodology, mixing time-weighted/money-weighted incorrectly, benchmark comparison errors, misleading charts | **High** |
| 5 | Multi-Account Aggregation | Double-counting holdings across linked accounts, currency mismatches, incorrect net worth roll-up | **High** |
| 6 | Data Sync/Refresh | Sync failures silently shown as success, race conditions on concurrent refresh, unbounded retry storms hitting broker rate limits | **Medium-High** |
| 7 | Security & Privacy | Session hijacking, data exposure to wrong user (multi-tenant leakage), insufficient logout/token revocation, PII in logs | **Critical** |
| 8 | Authentication & Authorization | Login bypass, weak password/session policy, unauthorized access to another user's portfolio via IDOR | **Critical** |
| 9 | Performance/Scalability | Slow load with large portfolios (1000+ transactions), timeouts on holdings refresh | Medium |
| 10 | Cross-Browser/Responsive UI | Broken layouts hiding critical numbers, chart rendering failures | Medium |
| 11 | Error Handling & Empty States | Confusing errors during broker outages, no guidance when zero accounts linked | Medium |
| 12 | Notifications/Alerts (if in scope) | Missed or false alerts on large balance changes | Low-Medium |

### 1.4 Test Levels & Types

| Level/Type | Focus | Primarily Owned By |
|---|---|---|
| Unit tests | Return/gain-loss calculation formulas, cost-basis logic, currency conversion | Engineering |
| Integration tests | Aggregator API contract, sync job idempotency, DB transaction integrity | Engineering + QA |
| API/contract tests | Endpoints for holdings, transactions, performance — schema, auth, error codes | QA |
| **Manual functional testing** (this document) | End-to-end user flows, edge cases, exploratory | QA |
| Security testing | AuthN/AuthZ, IDOR, token storage, transport security, dependency scan | QA + Security review (recommend external pen test before GA) |
| Data accuracy/reconciliation testing | Compare app numbers against source brokerage statements (golden datasets) | QA (critical, finance-specific) |
| Performance/load testing | Large portfolios, concurrent sync jobs | Engineering + QA |
| Cross-browser/responsive testing | Chrome, Safari, Firefox, Edge; mobile web breakpoints | QA |
| Accessibility testing | Screen reader on holdings/transaction tables, color contrast (esp. red/green gain-loss) | QA |
| Regression testing | Full P0/P1 suite before every release; automate over time | QA |
| UAT / Beta | Internal dogfooding with real (or realistic sandbox) linked accounts before public launch | Product + QA |

### 1.5 Test Environment Strategy

- **Sandbox/test brokerage accounts**: Use aggregator's sandbox mode (e.g., Plaid Sandbox) with deterministic test institutions covering success, MFA-required, invalid-credential, and error scenarios.
- **Seeded reference datasets**: Maintain a "golden" test account with known holdings/transactions/expected returns to validate calculations against a hand-computed answer key — re-run this every release as a smoke test.
- **Broker outage simulation**: Mock aggregator responses for timeouts, 5xx errors, partial data, rate-limiting to test resilience without waiting for a real outage.
- **Multi-user test accounts**: At least 2 separate user accounts to test data isolation (critical for security risk category).
- **Data refresh timing control**: Ability to trigger/mock sync jobs on demand rather than waiting for real schedules.

### 1.6 Entry / Exit Criteria

**Entry criteria for test cycle:**
- Feature-complete build deployed to staging
- Aggregator sandbox integration functional
- Test data/accounts provisioned

**Exit criteria for release:**
- 100% of Critical (P0) test cases pass
- ≥95% of High (P1) test cases pass; no open P0/P1 defects
- No known data-correctness defects of any severity affecting balances, returns, or transaction amounts
- Security test cases (auth, data isolation, token handling) fully pass
- Sign-off from Product + Eng on any deferred P2/P3 issues

### 1.7 Defect Severity Definitions (finance-specific)

| Severity | Definition | Example |
|---|---|---|
| S1 – Blocker | Wrong money numbers shown, security/data leak, cannot link any account | Balance off by $X, User A sees User B's portfolio |
| S2 – Critical | Major flow broken but no wrong numbers shown | Refresh button fails silently, transaction list fails to paginate |
| S3 – Major | Degraded but workable | Slow load, minor calculation edge case (e.g., dividends not included in return %) |
| S4 – Minor | Cosmetic/UX | Misaligned column, non-blocking console warning |

---

## 2. Manual Test Cases (Prioritized by Risk)

Priority key: **P0 = Critical/blocker**, **P1 = High**, **P2 = Medium**, **P3 = Low**

### 2.1 Account Linking (P0 area)

| ID | Title | Priority | Preconditions | Steps | Expected Result |
|---|---|---|---|---|---|
| AL-01 | Successfully link a valid brokerage account | P0 | User logged in, no accounts linked | 1. Go to "Link Account" 2. Select supported broker 3. Enter valid sandbox credentials 4. Complete MFA if prompted 5. Confirm | Account appears in dashboard within expected sync time; status shows "Connected"; holdings begin populating |
| AL-02 | Reject invalid credentials gracefully | P0 | User logged in | 1. Start link flow 2. Enter invalid credentials | Clear error message shown; no partial/orphaned account record created; user can retry |
| AL-03 | Handle MFA-required broker flow | P0 | Broker sandbox configured for MFA | 1. Start link flow 2. Enter valid creds 3. Complete MFA challenge (SMS/OTP simulated) | Link completes successfully after MFA; no credential/OTP values logged or cached beyond session |
| AL-04 | Cancel mid-link flow leaves no orphaned state | P1 | — | 1. Start link flow 2. Abandon at MFA step (close tab / click cancel) | No partial account, no duplicate entry on retry; user can restart cleanly |
| AL-05 | Link second account from different institution | P1 | One account already linked | 1. Add second account from different broker | Both accounts listed independently; holdings/net worth aggregate correctly across both |
| AL-06 | Prevent duplicate linking of same account | P1 | Account A already linked | 1. Attempt to link same account again | System detects duplicate and either blocks or merges gracefully; no doubled holdings/transactions |
| AL-07 | Unlink/remove a linked account | P1 | Account linked | 1. Go to account settings 2. Remove/unlink account | Account and its data removed or archived per spec; access token revoked with aggregator (verify via API log, not just UI) |
| AL-08 | Broker outage during initial link | P1 | Mock aggregator 5xx/timeout | 1. Attempt link while broker sandbox returns error | User sees actionable error ("try again later"), not a raw stack trace or infinite spinner |
| AL-09 | Re-authentication after token expiry | P0 | Simulate expired access token for linked account | 1. Force token expiry 2. Trigger refresh/view holdings | App detects expired auth, prompts user to re-link/re-auth; does not show stale data silently as current |
| AL-10 | Credentials are never stored/visible in our app | P0 | — | 1. Complete link flow 2. Inspect network requests, DB (if accessible), local storage, logs | Brokerage username/password never transmitted to or stored by our backend (only aggregator token); confirm via network trace |
| AL-11 | Link flow works across supported browsers | P2 | — | Repeat AL-01 on Chrome, Safari, Firefox, Edge, mobile Safari/Chrome | Consistent success on all supported browsers |
| AL-12 | Unsupported/unlisted institution search | P3 | — | 1. Search for a broker not in supported list | Clear "not supported" messaging, no crash |

### 2.2 Security & Data Isolation (P0 area)

| ID | Title | Priority | Preconditions | Steps | Expected Result |
|---|---|---|---|---|---|
| SEC-01 | User A cannot view User B's portfolio via URL manipulation | P0 | Two separate test users, each with linked accounts | 1. Log in as User A 2. Note account/holding ID from URL or API call 3. Log in as User B 4. Attempt to access User A's ID directly (URL edit or API call) | Access denied (403/404); no data leakage |
| SEC-02 | Session expires and protects data after logout | P0 | Logged-in session | 1. Log out 2. Use browser back button 3. Attempt to replay old API requests/tokens | No portfolio data accessible after logout; session/token invalidated server-side |
| SEC-03 | Sensitive data not exposed in browser storage/logs | P0 | Linked account with data loaded | Inspect localStorage, sessionStorage, cookies, console logs, network payloads | No plaintext credentials, no unnecessary PII/account numbers exposed client-side beyond what's needed to render |
| SEC-04 | Transport security enforced | P0 | — | Inspect all network calls | All traffic over HTTPS/TLS; no mixed content; API enforces auth headers |
| SEC-05 | Account numbers masked appropriately in UI | P1 | Linked account | View account details | Full account number not displayed (e.g., shows last 4 digits only), consistent with industry norms |
| SEC-06 | Password/auth brute-force protection | P1 | — | Attempt repeated failed logins | Rate limiting/lockout triggers after threshold; no user enumeration via error messages |
| SEC-07 | Revoking account access via aggregator also revokes in-app | P1 | Linked account | 1. Revoke access from broker's side (simulated) 2. Refresh in app | App detects revocation, shows reconnect prompt, does not display last-known data as if current without indication |

### 2.3 Holdings View (P0 area)

| ID | Title | Priority | Preconditions | Steps | Expected Result |
|---|---|---|---|---|---|
| HV-01 | Holdings match source brokerage exactly (golden dataset) | P0 | Golden test account with known holdings | 1. View holdings page | Quantities, current prices, market values, and total match hand-computed expected values exactly |
| HV-02 | Holdings reflect real-time or clearly-timestamped prices | P0 | — | 1. View holdings 2. Note "as of" timestamp | Timestamp/staleness indicator shown; values not presented as live if they aren't |
| HV-03 | Holdings aggregate correctly across multiple linked accounts | P1 | 2+ accounts holding same ticker | 1. View aggregated/net-worth holdings view | Quantities and values sum correctly without double-counting or omission |
| HV-04 | Cost basis and unrealized gain/loss calculated correctly | P0 | Golden dataset with known cost basis | 1. View holding detail | Gain/loss $ and % match expected calculation (verify FIFO/avg-cost method matches documented methodology) |
| HV-05 | Zero-holdings / empty portfolio state | P2 | New account, no holdings yet or fully liquidated | 1. View holdings | Friendly empty state, not a broken table or error |
| HV-06 | Holdings view handles delisted/unsupported security gracefully | P2 | Account holding an obscure/delisted symbol | 1. View holdings | Shows symbol with "price unavailable" rather than $0 or crash (a $0 value could be misread as real data loss) |
| HV-07 | Multi-currency holdings displayed/converted correctly (if in scope) | P1 | Account with non-USD holdings | 1. View holdings | Correct currency symbol and conversion rate/timestamp shown; totals converted consistently |
| HV-08 | Sorting/filtering holdings table | P3 | Multiple holdings | 1. Sort by value, name, gain/loss 2. Filter by account/asset class | Sort and filter operate correctly without altering underlying values |
| HV-09 | Large portfolio (500+ positions) loads within acceptable time | P2 | Seeded large dataset | 1. Load holdings page | Loads within defined SLA (e.g., <3s), pagination/virtualization works, no truncated data |

### 2.4 Transaction History (P1 area)

| ID | Title | Priority | Preconditions | Steps | Expected Result |
|---|---|---|---|---|---|
| TX-01 | All transactions from source match exactly (golden dataset) | P0 | Golden account with known transaction list | 1. View transaction history | Every buy/sell/dividend/fee transaction present, correct date, amount, sign (debit/credit), and type |
| TX-02 | No duplicate transactions after repeated sync/refresh | P0 | Linked account | 1. Trigger manual refresh multiple times in succession | Transaction count remains stable; no duplicates created |
| TX-03 | New transactions appear after sync without gaps | P1 | Account with new activity since last sync | 1. Simulate new transaction at broker 2. Trigger sync | New transaction appears; no gap or missing entries around the sync boundary |
| TX-04 | Transaction dates respect correct timezone | P1 | Transaction near midnight boundary | 1. Inspect transaction dated near UTC/local boundary | Date shown matches brokerage statement date, not shifted by timezone conversion bug |
| TX-05 | Pagination does not drop or duplicate rows | P1 | Account with 100+ transactions | 1. Page through transaction history fully 2. Count total | Total matches expected count; no row appears on two pages or is skipped |
| TX-06 | Transaction categorization (buy/sell/dividend/fee/transfer) correct | P1 | Golden dataset with varied transaction types | 1. View each transaction type | Category/label matches actual transaction type from broker |
| TX-07 | Filtering by date range/account/type | P2 | Multiple transactions | 1. Apply date range filter 2. Apply account filter | Correct subset returned; totals recalculate correctly if summary shown |
| TX-08 | Export transaction history (if supported) | P2 | — | 1. Export to CSV/PDF | Exported data matches on-screen data exactly |
| TX-09 | Corrected/amended transactions from broker reflected correctly | P2 | Broker issues a correction (simulated) | 1. Sync after broker-side correction | App reflects corrected amount, not both old and new as separate entries |
| TX-10 | Empty transaction history state | P3 | New account, no activity | 1. View transaction history | Friendly empty state message |

### 2.5 Performance / Returns Tracking (P1 area)

| ID | Title | Priority | Preconditions | Steps | Expected Result |
|---|---|---|---|---|---|
| PF-01 | Overall portfolio return % matches golden dataset expected value | P0 | Golden dataset with hand-calculated expected return | 1. View performance/returns summary | Calculated return matches expected value within acceptable rounding tolerance; methodology (TWR vs MWR) documented and consistent |
| PF-02 | Return calculation correctly accounts for deposits/withdrawals | P0 | Account with a mid-period cash deposit | 1. View return over period spanning the deposit | Return % is not artificially inflated/deflated by the cash flow (this is the single most common finance-app bug) |
| PF-03 | Return calculation includes dividends/income, not just price change | P1 | Holding with dividend payout in period | 1. View return including dividend period | Total return includes dividend income, or clearly labels "price return" vs "total return" if only price is shown |
| PF-04 | Performance chart renders correct trend matching underlying data | P1 | Golden dataset | 1. View performance chart over 1M/3M/1Y/YTD/All | Chart shape/endpoints match expected values at each data point; no gaps or flat-lining due to missing data treated as $0 |
| PF-05 | Time period selector recalculates correctly | P1 | — | 1. Toggle between 1D/1W/1M/YTD/1Y/All | Values and chart update correctly for each period, no stale data left from previous selection |
| PF-06 | Multi-account aggregate performance is weighted correctly | P1 | 2+ accounts of different sizes | 1. View combined performance | Aggregate return is value-weighted correctly, not a simple average of each account's % |
| PF-07 | Negative returns/losses displayed clearly and correctly | P0 | Account with unrealized loss | 1. View performance for losing position | Negative sign/red color/parentheses shown correctly; not accidentally shown as positive |
| PF-08 | Benchmark comparison accuracy (if in scope, e.g., vs S&P 500) | P2 | — | 1. View benchmark overlay | Benchmark data and calculation period align with portfolio period exactly |
| PF-09 | Performance updates after new account linked mid-period | P2 | — | 1. Link new account 2. View performance | Historical performance correctly reflects only the period the account contributes to, not retroactively misattributed |
| PF-10 | Rounding/display consistency across app | P3 | — | 1. Compare same figure (e.g., total return) shown on dashboard vs detail page | Numbers match exactly between screens; no inconsistent rounding causing apparent discrepancy |

### 2.6 Data Sync / Refresh Reliability (P1-P2 area)

| ID | Title | Priority | Preconditions | Steps | Expected Result |
|---|---|---|---|---|---|
| SY-01 | Manual refresh reflects updated data | P1 | Linked account | 1. Change data at broker (sandbox) 2. Trigger manual refresh in app | UI updates to new values; loading state shown during refresh |
| SY-02 | Sync failure is surfaced to user, not silently swallowed | P0 | Mock sync failure | 1. Trigger refresh with mocked broker error | User sees "sync failed, showing data as of [time]" rather than blank or misleadingly fresh-looking data |
| SY-03 | Concurrent refresh requests don't cause race conditions/duplicates | P1 | — | 1. Trigger refresh rapidly multiple times (double-click, multi-tab) | No duplicate transactions/holdings created; requests deduplicated or queued |
| SY-04 | Scheduled background sync runs and updates data without user action | P2 | — | 1. Wait for scheduled sync window (or trigger via test hook) | Data updates automatically per documented schedule |
| SY-05 | Rate-limit/backoff handling with aggregator | P2 | Mock 429 response from aggregator | 1. Trigger multiple refreshes to exceed rate limit | App backs off gracefully, informs user, does not retry-storm the aggregator |

### 2.7 Error Handling & Edge/Empty States (P2 area)

| ID | Title | Priority | Preconditions | Steps | Expected Result |
|---|---|---|---|---|---|
| ER-01 | No linked accounts — first-time user state | P1 | Brand-new user | 1. Log in for first time | Clear onboarding CTA to link first account; no broken empty tables |
| ER-02 | Network loss mid-session | P2 | — | 1. Disable network while app loaded 2. Attempt an action | Graceful error/offline messaging, no data corruption on reconnect |
| ER-03 | Partial data load (some accounts sync, one fails) | P1 | 2 accounts, mock one failing | 1. Trigger refresh | Successful accounts show updated data; failed account clearly flagged, not blocking the rest of the UI |
| ER-04 | Session timeout during active use | P2 | — | 1. Leave session idle past timeout 2. Attempt an action | Redirected to re-login; no silent failure or data shown to unauthenticated state |

### 2.8 Cross-Browser / Responsive / Accessibility (P2-P3 area)

| ID | Title | Priority | Preconditions | Steps | Expected Result |
|---|---|---|---|---|---|
| UI-01 | Core flows work on Chrome, Safari, Firefox, Edge (desktop) | P2 | — | Repeat account link, holdings view, transaction view, performance view on each | Consistent, correct rendering and functionality |
| UI-02 | Mobile web responsive layout doesn't clip financial figures | P2 | — | 1. View on mobile viewport (375px width) | All numbers fully visible/readable, no horizontal scroll cutting off values, tables adapt (e.g., card view) |
| UI-03 | Gain/loss color coding meets accessibility contrast; not color-only signal | P2 | — | 1. Inspect red/green indicators with contrast checker 2. Check for +/- text or icon alongside color | Sufficient contrast ratio; a colorblind user can distinguish gain vs. loss via text/icon, not color alone |
| UI-04 | Screen reader can navigate holdings/transaction tables | P3 | — | 1. Use screen reader (NVDA/VoiceOver) on tables | Table headers, row data announced correctly and in logical order |

---

## 3. Recommended Execution Plan

1. **Phase 1 (before any other testing)**: Build and validate the golden reference dataset(s) with hand-calculated expected values for holdings, transactions, and returns. This underpins HV-01, TX-01, PF-01 and is the single highest-leverage test asset for a finance app.
2. **Phase 2**: Execute all P0 test cases (account linking core paths, security/data isolation, holdings/transaction/return accuracy against golden data). Zero tolerance for failures here.
3. **Phase 3**: Execute P1 cases (edge cases in linking, multi-account aggregation, sync reliability, transaction/performance edge cases).
4. **Phase 4**: P2/P3 (cross-browser, responsive, accessibility, minor UX states) — can run in parallel with Phase 2-3 by a second tester.
5. **Phase 5**: Regression pass on all P0/P1 after fixes; sign-off against exit criteria in section 1.6.
6. **Ongoing**: Automate the golden-dataset reconciliation checks (HV-01, TX-01, PF-01, PF-02) first — these are exactly the kind of high-value, stable, high-risk checks worth converting to automated regression tests immediately after v1 ships, since every future release risks silently breaking financial calculations.

## 4. Open Questions to Confirm With Product/Eng

- Exact aggregator/provider being used (Plaid, Yodlee, MX, direct broker APIs) — affects sandbox test setup.
- Return methodology: time-weighted vs. money-weighted vs. simple — must be confirmed to write precise expected values in PF-01/PF-02.
- Is trading/order execution in scope for v1? (Not covered above — would require its own critical-risk test category if so.)
- Multi-currency support in v1?
- Data retention/deletion policy on unlink (GDPR/CCPA implications) — affects AL-07 expected behavior.
