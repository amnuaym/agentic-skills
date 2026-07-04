# Phase 0: Reliability Requirements

This phase sets the reliability target before anything is built or instrumented. Skipping it leads to alerting that's either paranoid (paging for things that don't matter) or blind (silent on things that do).

## Criticality Tiering

Not every service deserves the same rigor. Ask what breaks downstream, and for how long, before assigning a tier.

| Tier | Definition | Example |
|---|---|---|
| Tier 0 | Direct revenue/critical-path impact; user-facing outage is immediately visible | Checkout, auth, payments |
| Tier 1 | Degrades core experience but has a workaround or graceful fallback | Search, recommendations |
| Tier 2 | Internal tooling or non-critical feature; delay is tolerable | Admin dashboards, batch reports |

## SLI Selection

Pick SLIs that reflect what the user actually experiences, not just what's easy to measure.

* **Availability** — proportion of successful requests/responses
* **Latency** — proportion of requests served under a threshold
* **Correctness** — proportion of responses that are actually right (relevant for calculations, search relevance, data pipelines)
* **Freshness** — how current the data is (relevant for caches, batch pipelines, dashboards)
* **Durability** — proportion of data that isn't lost (relevant for storage systems)

## SLO Definition

```text
[SLI] will be [target]% over a rolling [window],
measured as [exact query/method].
```

Example: "Checkout API availability will be 99.95% over a rolling 28 days, measured as (successful checkout responses / total checkout requests) excluding client-side network errors."

A target with no window, no measurement method, or no exclusions defined is not yet an SLO — it's a slogan.

## Error Budget Policy

* Error budget = 100% − SLO target, over the same window (e.g., 99.9% SLO → 0.1% budget ≈ ~43 minutes/month)
* Define what happens at each budget consumption threshold:
  * 50% consumed → reliability work gets visibility in planning
  * 75% consumed → new feature launches to this service require sign-off
  * 100% consumed → feature freeze until budget recovers, or explicit executive override with a documented reason
* Name who owns enforcing this policy — a policy nobody enforces isn't a policy

## Dependency Mapping

* List every upstream/downstream service this SLO depends on
* Note each dependency's own SLO — you cannot promise better reliability than an un-mitigated dependency allows without redundancy, caching, or graceful degradation
* Flag single points of failure explicitly

## Deliverables (Exit Criteria for Phase 0)

- [ ] Criticality tier assigned
- [ ] Critical user journeys mapped to SLIs
- [ ] SLOs defined with explicit windows and measurement methods
- [ ] Error budget policy written with named enforcement owner
- [ ] Dependencies mapped with their own SLOs noted
- [ ] SLO owner named
