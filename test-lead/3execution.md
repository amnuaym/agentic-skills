# Phase 3: Execution & Defect Management

This phase is where planning meets reality: tests actually run, defects get found, and the team has to decide which ones block release.

## Running Tests

* Execute automated suites per the CI plan from Phase 2; execute manual cases per the priority order from the risk register (High-risk cases first, so blocking issues surface early rather than on the last day)
* Log results per test case: pass, fail, blocked (couldn't run due to an environment/dependency issue), or skipped (with a reason)
* Re-run failed automated tests once to rule out infrastructure flakiness before logging a defect — but don't let this become an excuse to wave away genuine failures

## Defect Logging & Triage

For each failure, log a defect with:

```text
ID: DEF-<number>
Title: <short description>
Severity: Critical / High / Medium / Low   (impact if unresolved)
Priority: <urgency to fix, may differ from severity>
Linked Test Case: TC-<id>
Steps to Reproduce:
Expected vs. Actual:
Environment:
```

**Severity** is about impact (data loss, security hole, core flow broken vs. a cosmetic misalignment). **Priority** is about urgency (a Low-severity bug blocking a demo tomorrow might get high priority). Keep the two separate — conflating them leads to trivial bugs jumping the queue just because someone is annoyed by them.

Triage regularly (daily during active execution) with whoever has authority to prioritize — don't let the defect list become a backlog nobody looks at until reporting day.

## Resolving or Waiving Blockers

* Critical/High defects on High-risk areas should generally block the exit criteria from Gate 3 until fixed
* If the team wants to ship anyway, that's the Gate Override Policy from SKILL.md: state the risk plainly, get explicit sign-off, record it — don't quietly reclassify a defect's severity downward to make the numbers look better

## Regression

* Re-run the regression suite (typically the automated suite plus any manual smoke cases) against the release candidate after defect fixes land
* A fix that isn't regression-tested is a fix nobody has verified didn't break something else

## Tracking Toward Exit Criteria

Keep a running view against the Gate 3 checklist so there are no surprises at reporting time:

| Metric | Target (from Phase 0) | Current |
|---|---|---|
| High-risk cases passed | 100% | ... |
| Open Critical/High defects | 0 | ... |
| Regression suite status | Passing | ... |
| Coverage threshold | ... | ... |

## Deliverables (Exit Criteria for Phase 3)

* [ ] All planned test cases executed with results logged
* [ ] Defects logged, triaged, and severity/priority assigned
* [ ] All blocking (Critical/High) defects resolved or explicitly waived with sign-off
* [ ] Regression suite passing on the release candidate
* [ ] Coverage thresholds met, or gaps explicitly documented
