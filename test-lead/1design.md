# Phase 1: Test Design (Manual)

This phase turns requirements and the Phase 0 risk register into concrete, executable test cases. Write these before deciding what to automate — you can't sensibly decide what to automate until you know what "everything" actually is.

## Test Case Format

Use a consistent, scannable structure so cases are executable by someone who didn't write them, and so a long list of cases stays skimmable rather than turning into a wall of repeated headers.

For most functional areas, a table is the more scannable default — group a whole area's cases into one table so a reviewer can compare priorities and expected results at a glance instead of scrolling through repeated blocks:

| ID | Title | Priority | Preconditions | Steps | Expected Result |
|---|---|---|---|---|---|
| TC-\<module>-01 | \<short description> | High/Medium/Low | \<state required> | 1. ... 2. ... | \<what should happen> |

Reach for a standalone block instead when a single case has enough steps, preconditions, or test-data detail that squeezing it into a table cell would hurt readability more than the table's compactness helps:

```text
ID: TC-<module>-<number>
Title: <short description of what's being verified>
Priority: High / Medium / Low   (inherited from the Phase 0 risk register)
Preconditions: <state required before the steps below>
Steps:
  1. <action>
  2. <action>
Expected Result: <what should happen>
Test Data: <specific values/accounts/records needed>
```

Either way, avoid prose paragraphs — a tester (human or automated) should be able to follow the steps without interpreting intent. Note test data either in a dedicated column/field per case or in the shared Test Data Planning section below, not left to be inferred from the steps.

## Deriving Cases from Functional Requirements

For every acceptance criterion (typically already in Given/When/Then form from requirements gathering), write at least one test case that verifies it directly. Then add:

* **Boundary cases**: the edges of any range (zero items, one item, the max allowed, one past the max)
* **Negative cases**: invalid input, unauthorized access, missing required fields, network/timeout failures
* **State-based cases**: does behavior differ based on user role, account state, or prior actions?
* **Cross-feature interactions**: does this feature break or get broken by an adjacent one?

Weight the depth of edge-case coverage by the risk tier from Phase 0 — a High-risk checkout flow deserves a dozen boundary/negative cases; a Low-risk settings toggle might only need the happy path and one negative case.

**Keep positive and negative coverage deliberately balanced, not just "some of each."** As a starting heuristic: in High-risk areas, negative/boundary cases should roughly match or outnumber happy-path cases — most of what breaks in production is an edge case, not the main path, so the main path alone tells you the least about whether the feature is actually safe to ship. In Medium-risk areas, aim for a smaller but real set of negative cases per happy-path case. In Low-risk areas, one happy-path case plus a single representative negative case is usually enough. Treat this as a starting ratio to reason from, not a quota to hit mechanically — the real number of ways a feature can be misused or fail should drive the count as much as the ratio does.

## Deriving Cases from Non-Functional Requirements

Functional test cases confirm the system does the right thing; NFR-derived cases confirm it does the right thing *well enough*. Skipping this half of Phase 1 is how a feature ships with perfect functional coverage and then falls over under real load, leaks data, or fails an accessibility audit.

The core move is turning a vague NFR into a measurable pass/fail case, same as functional acceptance criteria:

* **Performance**: turn "should be fast" into a specific case with a load profile and a threshold — e.g. "TC-PERF-NFR-01: 95th-percentile response time stays under 400ms with 500 concurrent users for 10 minutes." The expected result is the number, not a feeling.
* **Security**: turn general security concerns into specific abuse-case tests — authorization bypass attempts (can User A reach User B's data by ID manipulation?), injection attempts on every input, rate-limit/brute-force behavior on auth endpoints, and whatever's called out in the risk register as a High-risk area.
* **Accessibility**: tie cases to a specific standard and level (e.g., WCAG 2.1 AA) rather than "should be accessible" — keyboard-only navigation of critical flows, screen-reader announcement of key content, color-contrast ratios.
* **Reliability/availability**: what should happen when a dependency is slow or down — does the system degrade gracefully or cascade-fail? Does failover actually work, or has it only ever been diagrammed?
* **Compliance**: retention/deletion behavior, consent flows, audit-trail completeness — whatever the applicable regulation actually requires, not a generic checklist.

Not every NFR case is executed by a human clicking through steps — load tests and security scans are usually tool-driven, and that's fine. Phase 1's job is still to define the case and its pass/fail threshold; Phase 2 decides which tool runs it and how often. A performance target with no owner and no tooling plan isn't "deferred to automation," it's dropped — cross-reference it into Phase 2 explicitly rather than letting it fall out of scope silently.

## Traceability Matrix

Maintain a simple mapping so nothing in scope is silently untested and nothing tested is untraceable to a reason. Include NFR-derived cases alongside functional ones — an NFR with no traceability row is exactly as risky as a functional requirement with no test case:

| Requirement / AC ID | Test Case ID(s) | Risk Tier | Status |
|---|---|---|---|
| REQ-101 | TC-checkout-01, TC-checkout-02 | High | Written |
| REQ-102 | TC-settings-05 | Low | Written |
| NFR-PERF-01 (checkout p95 < 400ms @ 500 users) | TC-PERF-NFR-01 | High | Written |

Update this as requirements or test cases change — a stale traceability matrix is worse than none, because it creates false confidence.

## Test Data Planning

For each test case or suite of related cases, specify:

* What records/accounts/states are needed
* Whether data is seeded, generated, or captured from production (sanitized)
* Any data that must be reset between test runs to keep cases independent

## Review

Before a test case is considered done, have at least one other person review it — a developer for technical accuracy, a product owner for business correctness, or a peer tester for gaps. Look specifically for: steps that assume undocumented context, expected results that are vague ("works correctly" is not verifiable), and missing negative/edge cases in High-risk areas.

## Deliverables (Exit Criteria for Phase 1)

* [ ] Manual test cases written for all Must-Have acceptance criteria
* [ ] Non-functional requirements translated into measurable test cases (performance, security, accessibility, reliability, compliance — whichever apply per Phase 0's Test Levels)
* [ ] Traceability matrix complete and up to date, covering both functional and non-functional requirements
* [ ] Edge cases and negative scenarios identified, weighted by risk tier
* [ ] Test data requirements documented
* [ ] Test cases reviewed by at least one other person
