# Phase 4: Postmortem & Continuous Improvement

This phase turns an incident into a lasting fix rather than a resolved ticket. A postmortem that doesn't change anything is just an autopsy.

## Blameless Postmortem

* Focus on systems and processes, not individual blame — "why did the system allow this mistake to cause an outage" rather than "who made the mistake"
* Required for all Sev1/Sev2 incidents within the agreed turnaround window (commonly 3–5 business days while details are fresh)
* Sev3/Sev4 can use a lighter-weight template, but recurring Sev3/Sev4 incidents in the same area should trigger a full postmortem

## Postmortem Structure

```text
## Summary
One paragraph: what happened, user impact, duration.

## Timeline
Pulled from the Phase 3 real-time log — detection, acknowledgment, key actions, mitigation, resolution.

## Root Cause / Contributing Factors
Not just "what happened" — why the system allowed it, including process and design factors, not only the proximate technical bug.

## Impact
Quantified: SLO/error-budget consumed, users affected, duration, any downstream effects.

## What Went Well
Genuinely note what worked (detection speed, runbook accuracy) — this reinforces effective practices, not just failures.

## Action Items
| Item | Owner | Due date | Status |
```

## Action Item Tracking

* Every action item needs a named owner and a due date — an item with neither is a wish, not a commitment
* Track to closure; a postmortem doc with open action items six months later is a signal the process isn't working, not just an oversight to note
* Prioritize action items that reduce recurrence probability or detection/mitigation time over items that only make the postmortem feel thorough

## Error Budget Policy Enforcement

* If this incident pushed the error budget past a defined threshold (from Phase 0), the policy from that threshold must actually trigger — feature freeze, reprioritization, or executive override with a documented reason
* Track whether the policy is being enforced in practice or quietly ignored; an unenforced error budget policy erodes trust in the whole SLO framework

## Trend Review

* Periodically (e.g., monthly) review postmortems as a set, not just individually — look for repeat root causes, repeat services, or repeat action items that never landed
* Systemic issues (e.g., "every incident this quarter involved the same deploy pipeline gap") are easy to miss one postmortem at a time and are exactly what this review is for

## Deliverables (Exit Criteria for Phase 4)

- [ ] Postmortem completed for all Sev1/Sev2 incidents within the turnaround window
- [ ] Root cause/contributing factors documented, not just a restatement of events
- [ ] Action items have owners, due dates, and are tracked to closure
- [ ] Error budget policy enforcement confirmed if a threshold was crossed
- [ ] Trend review conducted across postmortems on a recurring cadence
