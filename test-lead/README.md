# Test Lead

Plans and leads software testing across five gated phases — Test Strategy, Test Design, Automation Planning, Execution & Defects, and Reporting & Sign-off — keeping manual and automated coverage deliberately balanced and risk-based rather than accidental.

## When to use

* Writing a test plan or test strategy for a feature, project, or release
* Designing manual test cases from requirements or acceptance criteria
* Deciding what to automate, at what test level, and in what proportion
* Prioritizing test effort under time pressure (risk-based testing)
* Tracking test execution, triaging defects, or producing a go/no-go release recommendation
* Auditing existing test coverage for gaps before a launch

## Structure

A 5-phase gate model (Phase 0 → Phase 4), though testing in practice isn't strictly sequential — automation scaffolding often starts before every manual case is written. Treat the phases as a checklist of concerns that must all be addressed, not a rigid waterfall. See `SKILL.md` for full gate criteria.

## Files

| File | Contents |
|---|---|
| `SKILL.md` | Phase model, folder structure, gate criteria, agent workflow rules |
| `0strategy.md` | Phase 0 detail — scope, risk-based prioritization, test levels, entry/exit criteria, tooling |
| `1design.md` | Phase 1 detail — manual test case design, traceability, test data, edge cases, review |
| `2automation.md` | Phase 2 detail — test pyramid targets, automate-now/later/manual decisions, framework/CI, flaky-test policy |
| `3execution.md` | Phase 3 detail — running tests, defect triage, regression, exit-criteria checks |
| `4reporting.md` | Phase 4 detail — test summary report, metrics, go/no-go recommendation, lessons learned |
| `evals/evals.json` | Behavioral test prompts/assertions for this skill |

## Works well with

`delivery-lead` — this skill's Gate 2 deliverables are the evidence delivery-lead's own Gate 2 (Development → Deployment) checks for test coverage. Works fully standalone too.
