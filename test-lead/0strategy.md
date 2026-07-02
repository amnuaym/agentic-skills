# Phase 0: Test Strategy & Risk Assessment

This phase decides what "testing this well" even means before a single test case is written. Skipping it produces test suites that are thorough where it's easy to test and thin where it actually matters.

## Scope

* What's being tested: a feature, a release, a whole system regression?
* What's explicitly **out** of scope, and why (e.g., "third-party payment gateway internals are out of scope; we test our integration with it, not its correctness")
* Which environments count as in-scope for sign-off (staging only? production smoke tests too?)

Scope is where guessing costs the most later, because everything downstream (risk tiers, test cases, automation targets) inherits whatever gets assumed here. Before locking in scope, ask the user directly about anything that would change the plan if guessed wrong: which third-party services/integrations are actually involved (and by name — "a brokerage aggregator" and "Plaid specifically" lead to different sandbox setups and different failure modes to test), what's actually in this release versus deferred, and any compliance/locale/currency constraints. If the user isn't available to ask, state assumptions prominently and treat them as open questions to confirm — but asking first is almost always faster than writing a plan around a guess and redoing it.

## Test Levels

Identify which levels apply — not every project needs all of them:

| Level | Answers | Owner (typical) |
|---|---|---|
| Unit | Does this function/class do what it claims, in isolation? | Developers |
| Integration | Do two or more components work together correctly (real DB, real API)? | Developers / QA |
| System / E2E | Does a full user journey work end-to-end? | QA |
| UAT | Does this meet the business's actual need, per the business? | Product / end users |
| Performance | Does it hold up under expected and peak load? | QA / SRE |
| Security | Can it be broken or abused? | Security / QA |
| Accessibility | Can it be used by people relying on assistive tech? | QA |

## Requirements Intake: Functional and Non-Functional

Test cases in Phase 1 are only as good as the requirements they're derived from, and requirements come in two flavors that get gathered differently:

* **Functional requirements** — what the system should *do*, usually already expressed as user stories or acceptance criteria (Given/When/Then). These map fairly directly to test cases.
* **Non-functional requirements (NFRs)** — how well the system should do it: performance (response time, throughput under load), security (authn/authz rules, data protection), accessibility (WCAG conformance level), reliability/availability (uptime, failover behavior), and compliance (data retention, consent). These are frequently missing, vague, or assumed rather than written down — "the app should be fast" is not testable, "95th-percentile page load under 2s at 500 concurrent users" is.

If NFRs weren't handed to you in measurable form, don't silently skip them or invent a plausible-sounding number — ask the user (or whoever owns the requirement) for the actual target, or flag the absence of one as a gap in this strategy rather than a gap that quietly surfaces later as an untested area. A feature can pass every functional test case and still fail the product if it's unusably slow or leaks data — NFRs aren't secondary to functional scope, they need the same explicit treatment.

## Risk-Based Prioritization

Testing time is always finite. Spend it where failure would hurt most, not evenly across everything.

1. **List features/modules/user journeys in scope, and the NFR targets that apply to them** — a risk register that only tracks functional areas will under-invest in things like performance or security that don't show up as a "feature" but can still sink the product.
2. **Score each on two axes:**
   - *Likelihood of defect*: new/complex/recently-changed code scores higher than stable, simple, unchanged code.
   - *Impact if it fails*: revenue-critical, safety-critical, or high-traffic paths score higher than rarely-used admin screens.
3. **Rank into High / Medium / Low.** High-risk items get the deepest manual + automated coverage and the most edge cases. Low-risk items might get a single smoke test.
4. Keep this ranked list — it's the reference point for every prioritization decision in later phases (which manual cases to write first, what to automate first, what to cut if time runs short).

Don't let "everything is high risk" stand — if more than roughly a third of scope ends up High, push back and ask what would actually happen if each item failed. A flat ranking that doesn't discriminate defeats the purpose.

## Entry & Exit Criteria

* **Entry criteria**: What must be true before testing starts? (e.g., "build deploys cleanly to staging," "acceptance criteria exist for all stories in scope")
* **Exit criteria**: What must be true to call the test effort done? (e.g., "100% of High-risk cases pass," "no open Critical/High defects," "coverage threshold met") — these become the checks in Gate 3.

## Test Environments & Data

* Which environments are used for which test levels (unit tests run anywhere; E2E might need a staging environment with realistic data)
* How test data is created, refreshed, and kept free of real user PII
* Any environment-specific quirks that testing needs to account for (feature flags, seeded accounts, mocked third parties)

## Tooling

Decide and document:

* Test case management (spreadsheet is fine for small efforts; a dedicated tool for larger ones)
* Automation framework(s) per level (deferred in detail to Phase 2, but note constraints now — e.g., "must integrate with existing CI")
* Defect tracker and how severity/priority are defined there

## Roles & Responsibilities

Who writes manual cases, who executes them, who builds automation, who triages defects, who has authority to call go/no-go. Small teams may have one person wearing several hats — say so explicitly rather than leaving it implied.

## Deliverables (Exit Criteria for Phase 0)

* [ ] Scope (in and out) documented
* [ ] Applicable test levels identified
* [ ] Risk register produced with features/modules ranked High/Medium/Low
* [ ] Entry and exit criteria defined
* [ ] Test environment and test data strategy defined
* [ ] Tooling decided (test management, automation, defect tracking)
* [ ] Roles and responsibilities assigned
