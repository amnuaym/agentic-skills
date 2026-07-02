# Phase 2: Automation Planning & Build

This phase decides, deliberately, what gets automated and what stays manual. The goal is not "automate everything" — it's spending automation effort where it pays back the most (fast feedback, frequent regression risk) and leaving genuinely manual/exploratory work to humans.

## Test Pyramid Targets

Set a target proportion for each level, then justify it against the Phase 0 risk register rather than defaulting to a generic ratio (e.g., "70/20/10"):

| Level | Characteristics | Good for |
|---|---|---|
| Unit | Fast (ms), isolated, no I/O | Business logic, edge cases, pure functions — the bulk of coverage |
| Integration | Slower, real DB/API/queue in a container | Contracts between components, data persistence, auth flows |
| E2E | Slowest, full stack, browser/app driver | Critical user journeys only — checkout, login, the paths that make money or block users if broken |

A project with a lot of business-rule complexity should skew heavily toward unit tests. A thin CRUD app with most of its risk in third-party integrations should invest more in integration tests. State the reasoning, not just the ratio.

**Coverage thresholds are a negotiated agreement, not a test-lead decision made in isolation.** A number like "90% unit coverage" only means something if the developers who'll hit that bar and the sponsor who's accepting the resulting risk both agreed to it. Ask the development team what's realistic given the codebase, ask the sponsor/product owner what level of risk they're comfortable accepting, and record the agreed number with who signed off on it — don't pick a round number and present it as settled.

## What to Automate vs. Keep Manual

Go through every test case from Phase 1 and make an explicit call:

* **Automate now**: stable requirements, executed repeatedly (every PR/release), objectively verifiable pass/fail, high risk tier
* **Automate later**: worth automating eventually but not blocking this release (note why — e.g., feature still in flux)
* **Keep manual/exploratory**: visual/UX judgment calls, one-off migration verification, low-frequency low-risk paths, anything requiring human judgment about "does this feel right" (accessibility with a screen reader, real-device quirks, ad-hoc exploratory testing to find what scripted cases miss)

Resist automating a case just because it's easy to automate if it's low risk and rarely re-run — that's automation effort spent for little ongoing return. Conversely, don't leave a high-risk, frequently-run case manual just because writing the automation is annoying.

## Framework & Scaffolding

* **Confirm the actual tech stack before recommending frameworks.** A framework recommendation is only useful if it matches what the team is really running — ask rather than defaulting to a generic guess (e.g., assuming Node/TypeScript when the backend might be Python, Java, or something else entirely). If the stack genuinely isn't known yet, say so explicitly and present the recommendation as conditional on it.
* Pick one framework per level, consistent with what the team already knows unless there's a strong reason to introduce something new
* Scaffold the test project structure in `/tests` (e.g., `/tests/unit`, `/tests/integration`, `/tests/e2e`)
* Wire up test data setup/teardown so tests are independent and repeatable — a suite that only passes in a specific order is a maintenance trap

## CI Integration

Define exactly when each level runs, trading off feedback speed against cost:

* **On every PR/commit**: unit tests, and fast integration tests — must be fast enough that developers don't skip waiting for it
* **On merge to main**: full integration suite
* **Nightly or pre-release**: full E2E suite, performance tests — anything too slow to gate every PR

State what blocks a merge/deploy and what merely reports (e.g., "unit test failure blocks merge; E2E failure blocks release but not merge").

## Flaky Test Policy

Flaky tests erode trust in the whole suite — left unmanaged, teams start ignoring red builds entirely. Define:

* How a test is identified as flaky (e.g., fails intermittently without code changes, N failures in M runs)
* What happens to it: quarantine (skip but track, don't delete), assign an owner, fix-by date
* Who's accountable for keeping the flaky-test list from growing unbounded

## Deliverables (Exit Criteria for Phase 2)

* [ ] Test pyramid targets set and justified against the risk register
* [ ] Every Phase 1 test case has an explicit automate-now/automate-later/manual decision with a reason
* [ ] Automation framework(s) selected and scaffolded in `/tests`
* [ ] CI integration plan defined (what runs when, what blocks what)
* [ ] Flaky-test policy defined
