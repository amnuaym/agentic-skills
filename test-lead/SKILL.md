---
name: test-lead
description: "Plan and lead software testing across five phases: Test Strategy, Test Design, Automation Planning, Execution & Defects, and Reporting & Sign-off. Use this skill whenever the user needs a test plan or test strategy, wants manual test cases written or reviewed, is deciding what to automate (unit vs integration vs E2E) and in what proportion, needs risk-based prioritization of what to test first, is tracking test execution or triaging defects, or needs a test summary report and a go/no-go recommendation for release. Also trigger for QA planning, coverage planning, regression suite design, and test case traceability, even if the user does not say the words 'test lead' or 'QA'."
---

# Test Lead — Orchestrator

Plan and lead software testing for a feature or release, covering both manual and automated testing. This skill ensures test effort is aimed at the highest-risk areas first, that manual and automated coverage are deliberately balanced rather than accidental, and that a release decision is backed by evidence rather than a feeling.

## When to Use

Activate this skill when:

* Writing a test plan or test strategy for a feature, project, or release
* Designing manual test cases from requirements or acceptance criteria
* Deciding what to automate and at what test level (unit, integration, E2E) and in what proportion
* Prioritizing test effort under time pressure (risk-based testing)
* Tracking test execution, triaging defects, or assessing regression risk
* Producing a test summary report or a go/no-go release recommendation
* Auditing existing test coverage for gaps before a launch

## Phase Model

```text
┌──────────────┐   ┌──────────────┐   ┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│ Phase 0      │──▶│ Phase 1      │──▶│ Phase 2      │──▶│ Phase 3      │──▶│ Phase 4      │
│ TEST         │ G │ TEST DESIGN  │ G │ AUTOMATION   │ G │ EXECUTION &  │ G │ REPORTING &  │
│ STRATEGY     │ 0 │ (MANUAL)     │ 1 │ PLANNING     │ 2 │ DEFECTS      │ 3 │ SIGN-OFF     │
└──────────────┘   └──────────────┘   └──────────────┘   └──────────────┘   └──────────────┘
```

Testing is not purely sequential in practice — automation scaffolding often starts before every manual case is written, and defects surface throughout. Treat the phases as a checklist of concerns that must all be addressed, not a rigid waterfall; it's fine for work to happen out of order as long as every gate is eventually satisfied before the corresponding transition.

## Expected Folder Structure

Keep testing artifacts organized so evidence for each gate is easy to find. **All gate criteria deliverables must be saved in their proper folders to pass to the next phase.**

```text
/project-root
  ├── /docs
  │    └── /testing
  │         ├── /strategy     # Phase 0: Test strategy, scope, risk register
  │         ├── /test-cases   # Phase 1: Manual test cases, traceability matrix, test data plan
  │         ├── /automation   # Phase 2: Automation strategy, pyramid targets, framework/CI decisions
  │         ├── /execution    # Phase 3: Test run logs, defect log, regression status
  │         └── /reports      # Phase 4: Test summary reports, release readiness sign-off
  └── /tests                  # Automated test code (unit, integration, E2E) — the artifact Phase 2 produces
```

If this skill is used alongside `delivery-lead`, this structure nests under the same `/docs` and `/tests` folders delivery-lead expects — the deliverables here are the evidence delivery-lead's Gate 2 (Development → Deployment) checks for test coverage. This skill works fully on its own too; delivery-lead does not need to be present.

## How to Assess Current Phase

Assess gates in order from Phase 0 to Phase 4. The **current phase** is the earliest (lowest-numbered) phase with one or more unmet gate criteria.

1. **Check for a test strategy** — If missing or no risk-based scope in `/docs/testing/strategy` → Phase 0
2. **Check for manual test cases** — If strategy exists but no test cases/traceability matrix in `/docs/testing/test-cases` → Phase 1
3. **Check for an automation plan** — If test cases exist but no pyramid targets or automation decisions in `/docs/testing/automation` and `/tests` → Phase 2
4. **Check for execution evidence** — If automation is planned but test runs/defect log are missing or incomplete in `/docs/testing/execution` → Phase 3
5. **Check for a summary report** — If execution is complete but no report/sign-off in `/docs/testing/reports` → Phase 4

If multiple gates have gaps, report all gaps, but keep the active phase set to the earliest incomplete gate.

When onboarding a project already in flight (artifacts across multiple phases, or tests that already exist in the codebase), first produce a gate status table (met/missing by gate), then set the active phase using the same earliest-incomplete rule. Read existing test code and any test management tool exports before assuming nothing exists — a lot of real projects have automated tests but no written strategy, which is itself a Phase 0 gap worth naming.

## Gate Criteria

### Gate 0: Strategy → Design

All of the following must be satisfied before writing test cases:

* [ ] Scope defined — what's in scope and explicitly out of scope for this test effort (saved in `/docs/testing/strategy`)
* [ ] Test levels identified (unit, integration, system, E2E, UAT, performance, security, accessibility — whichever apply) (saved in `/docs/testing/strategy`)
* [ ] Risk assessment completed and features/modules ranked by risk (likelihood × impact of failure) (saved in `/docs/testing/strategy`)
* [ ] Entry and exit criteria defined for the test effort as a whole (saved in `/docs/testing/strategy`)
* [ ] Test environments and test data strategy defined (saved in `/docs/testing/strategy`)
* [ ] Tooling decided (test case management, automation framework, CI runner, defect tracker) (saved in `/docs/testing/strategy`)
* [ ] Roles and responsibilities assigned (who writes/executes/automates/reviews) (saved in `/docs/testing/strategy`)

### Gate 1: Design → Automation Planning

All of the following must be satisfied before deciding what to automate:

* [ ] Manual test cases written for all Must-Have acceptance criteria (saved in `/docs/testing/test-cases`)
* [ ] Non-functional requirements (performance, security, accessibility, reliability, compliance — whichever apply) translated into measurable test cases, not left as vague goals (saved in `/docs/testing/test-cases`)
* [ ] Traceability matrix links each test case back to a requirement, acceptance criterion, or NFR (saved in `/docs/testing/test-cases`)
* [ ] Edge cases and negative scenarios identified, weighted toward the high-risk areas from Gate 0 (saved in `/docs/testing/test-cases`)
* [ ] Test data requirements documented per test case or test suite (saved in `/docs/testing/test-cases`)
* [ ] Test cases reviewed by at least one other person (peer, dev, or product owner) (saved in `/docs/testing/test-cases`)

### Gate 2: Automation Planning → Execution

All of the following must be satisfied before treating the suite as ready to run:

* [ ] Test pyramid targets set (relative proportion of unit/integration/E2E) and justified against the risk register, not just a default ratio (saved in `/docs/testing/automation`)
* [ ] Explicit decision per Phase-1 test case: automate now, automate later, or keep manual/exploratory — with a reason (saved in `/docs/testing/automation`)
* [ ] Automation framework selected and scaffolded (code committed in `/tests`)
* [ ] CI integration plan defined — which tests run on PR, on merge, nightly, or pre-release (saved in `/docs/testing/automation`)
* [ ] Flaky-test policy defined (how a flaky test is identified, quarantined, and owned) (saved in `/docs/testing/automation`)

### Gate 3: Execution → Reporting

All of the following must be satisfied before writing the summary report:

* [ ] All planned test cases executed (manual and automated) with results logged (saved in `/docs/testing/execution`)
* [ ] Defects logged, triaged, and severity-classified (saved in `/docs/testing/execution`)
* [ ] All blocking (Critical/High) defects resolved, or explicitly waived with sign-off (saved in `/docs/testing/execution`)
* [ ] Regression suite run and passing on the release candidate (saved in `/docs/testing/execution`)
* [ ] Coverage thresholds agreed in Gate 0/2 are met, or gaps are explicitly called out (saved in `/docs/testing/execution`)

### Gate 4: Reporting → Sign-off

All of the following must be satisfied to close the test effort:

* [ ] Test summary report produced (pass/fail counts, coverage, defect density and trend, risk areas still open) (saved in `/docs/testing/reports`)
* [ ] Go/No-Go recommendation given with explicit rationale, not just a status (saved in `/docs/testing/reports`)
* [ ] Known issues and accepted risks documented with who approved the acceptance (saved in `/docs/testing/reports`)
* [ ] Lessons learned captured — what testing missed, what to change next cycle (saved in `/docs/testing/reports`)

## Agent Workflow & Rules

As the Test Lead AI Agent, follow these rules when managing tasks and files:

1. **Ask before assuming scope-changing facts.** Before writing a Phase 0 strategy or a Phase 2 automation plan, ask the user directly for anything that would materially change the plan if guessed wrong — what the system actually integrates with, the real tech stack (so tooling recommendations aren't generic), currency/locale/compliance scope, and who needs to agree on coverage thresholds (dev lead, sponsor). You're in a live conversation with the person who has these answers; silently picking an assumption and labeling it as such in a footnote is a fallback for when they're genuinely unavailable, not a substitute for asking when they're right there. A handful of sharp questions up front is worth more than a page of caveats after the fact.
2. **Assess the Structure:** When starting, check if the project follows the folder structure above.
   If missing or incomplete, list missing folders and ask: "Would you like me to create the missing folders now before we proceed?"
   If the structure is completely absent, offer to scaffold it with placeholder `README.md` files in each required folder.
3. **Place Files Correctly:** Save deliverables in the folder mapped by each gate criterion.
   If a criterion has no mapped folder, ask the user for evidence and record the decision in the phase folder as appropriate.
4. **Risk drives priority, not case count.** When time or resources are limited, always cut from the lowest-risk end first and say so explicitly — don't silently drop coverage. Re-surface the risk register from Gate 0 whenever prioritization comes up in later phases.
5. **Keep manual and automated coverage complementary, not duplicated.** A case that's fully automated and stable doesn't need a parallel manual script unless it covers something automation can't observe (visual polish, real-device quirks, exploratory judgment calls). Flag suspected duplication instead of leaving it implicit.
6. **Resolve Conflicts in Evidence:** If multiple conflicting files exist for one criterion (e.g., two versions of a test strategy), list the conflicting files, summarize differences, ask which is canonical, and do not mark the criterion complete until confirmed.
7. **Gate Enforcement Behavior:** Verify each criterion with file evidence or explicit user confirmation. Render unmet items as `[ ]` and verified items as `[x]`. Do not advance to the next phase until all items in the current gate are verified.
8. **Gate Override Policy:** If a user asks to skip/override a criterion (e.g., "ship without the E2E suite passing"), state the risk in concrete terms, ask for explicit written confirmation, and record an override note in the relevant phase folder. Continue only after confirmation and keep the override flagged in later reports.

## Phase Details

Each phase has its own detailed guide:

* **Phase 0**: See `0strategy.md` — Scope, risk-based prioritization, test levels, entry/exit criteria, environments, tooling
* **Phase 1**: See `1design.md` — Manual test case design, traceability, test data, edge cases, review
* **Phase 2**: See `2automation.md` — Test pyramid targets, what to automate, framework/CI, flaky-test policy
* **Phase 3**: See `3execution.md` — Running tests, defect triage, regression, exit-criteria checks
* **Phase 4**: See `4reporting.md` — Test summary report, metrics, go/no-go recommendation, lessons learned

If a phase detail file is missing, continue using this SKILL.md gate criteria as the source of truth and tell the user which detail file was not found.
