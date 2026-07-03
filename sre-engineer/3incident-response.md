# Phase 3: Incident Response

This phase is about what happens when the alerting from Phase 2 actually fires. During a live incident, prioritize speed of mitigation over documentation polish — capture the timeline tersely in real time and do the full write-up after, in Phase 4.

## Severity Classification

| Severity | Definition | Example |
|---|---|---|
| Sev1 | Critical-path outage or major data risk, all hands | Checkout down, data loss in progress |
| Sev2 | Significant degradation, subset of users affected | Elevated error rate on one region |
| Sev3 | Minor degradation, workaround exists | Non-critical feature slow |
| Sev4 | No user impact, internal-only issue | Dashboard lag with no downstream effect |

Classify by user impact, not by how technically interesting or effortful the underlying bug is.

## Incident Commander Process

* **Incident Commander (IC)**: owns the response, makes the call on mitigation vs. further diagnosis, is not necessarily the person fixing the bug
* **Ops/Investigator**: does the technical digging and applies the fix
* **Comms lead**: owns stakeholder/customer updates so the IC and ops aren't context-switching to write status updates mid-investigation
* For long incidents, define a handoff procedure (shift change) so the IC role doesn't silently drop when someone logs off

## Communication Templates

Prepare templates per severity so nothing is improvised mid-incident:

```text
[Sev1/2] Investigating: We're aware of [symptom] affecting [scope]. Investigating now. Next update in [X] minutes.
[Sev1/2] Update: [what's known], [what's being tried]. Next update in [X] minutes.
[Sev1/2] Resolved: [symptom] is resolved as of [time]. Root cause: [brief]. Full postmortem to follow.
```

Match cadence and audience (internal-only vs. external status page) to the severity level.

## Real-Time Timeline Capture

* Log timestamped entries as the incident unfolds: when detected, when acknowledged, actions taken, observations, mitigation applied
* Capture this in the incident channel or a shared doc as it happens — reconstructing a timeline from memory after the fact loses detail and introduces bias
* This timeline becomes the primary input to the Phase 4 postmortem

## Confirming Resolution

* An incident is resolved when the violated SLO is back within budget, confirmed against the dashboard from Phase 1 — not when "things look fine" subjectively
* Watch for a false "all clear" — some mitigations (cache warm-up, rolling restarts) take time to fully propagate; confirm sustained recovery, not a momentary dip in error rate

## Deliverables (Exit Criteria for Phase 3)

- [ ] Severity assigned using the defined classification scheme
- [ ] IC/ops/comms roles assigned (for Sev1/Sev2)
- [ ] Stakeholder communication sent using the appropriate template
- [ ] Real-time timeline captured during the incident
- [ ] Resolution confirmed against the specific SLO, not just general system health
