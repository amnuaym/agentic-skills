# Phase 4: Reporting & Sign-off

This phase turns everything logged in Phase 3 into a decision someone can act on. A report that just restates pass/fail counts without a recommendation hasn't done its job.

## Test Summary Report Structure

```text
# Test Summary Report — <feature/release name>
## Scope
What was tested (link back to Phase 0 scope).

## Results Overview
- Total test cases: <n> (Manual: <n>, Automated: <n>)
- Passed / Failed / Blocked / Skipped: <counts and %>
- By risk tier: High <pass rate>, Medium <pass rate>, Low <pass rate>

## Defect Summary
- Total defects found: <n>, by severity
- Open vs. resolved
- Any waived/accepted defects, with who approved

## Coverage
- Automated coverage achieved vs. target (by test level)
- Manual coverage of planned cases

## Risk Areas Still Open
Anything from the Phase 0 risk register that isn't fully covered or has known open issues.

## Recommendation
Go / No-Go / Go-with-conditions, with the reasoning — not just the verdict.

## Lessons Learned
What testing missed or caught late, and what to change next cycle.
```

## Metrics Worth Including

* **Pass rate** by risk tier (a 95% overall pass rate can hide a 60% pass rate on the one High-risk module that matters most — always break it out)
* **Defect density** (defects per feature/module) to spot where quality was weakest
* **Defect trend** over the execution period (climbing near the end is a bad sign; flattening out is a good one)
* **Coverage** — automated coverage percentage, and how many planned manual cases actually ran

Avoid vanity metrics that don't inform the decision (e.g., total number of test cases written says nothing about quality on its own).

## Go/No-Go Recommendation

Base it on the exit criteria from Phase 0 and the actuals from Phase 3, not gut feel:

* **Go**: exit criteria met, no unresolved Critical/High defects on High-risk areas
* **No-Go**: exit criteria unmet in a way that materially risks users or the business
* **Go-with-conditions**: ship with explicitly accepted, documented risk (e.g., "ship without the accessibility audit; scheduled for next sprint, low-traffic feature")

State the recommendation plainly at the top of the report — don't bury it in a wall of metrics the reader has to interpret themselves.

## Known Issues & Accepted Risk

List every defect or gap being shipped with, who accepted the risk, and when it's expected to be addressed (if ever). This is the artifact that protects the team later when "didn't we know about this?" comes up.

## Lessons Learned

Close the loop for next time:

* Which defects should have been caught earlier (wrong test level, missing case, or a genuine blind spot in the risk register)?
* Did any low-risk area turn out to matter more than expected? Feed that back into how risk is scored next time.
* Was automation coverage where it needed to be, or did manual testers end up covering ground that should have been automated?

## Deliverables (Exit Criteria for Phase 4)

* [ ] Test summary report produced and shared with stakeholders
* [ ] Go/No-Go recommendation given with rationale
* [ ] Known issues and accepted risks documented with sign-off
* [ ] Lessons learned captured
