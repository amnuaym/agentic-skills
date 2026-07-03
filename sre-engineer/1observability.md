# Phase 1: Observability

This phase makes the SLOs from Phase 0 measurable. If you can't query whether an SLO was met last week, it isn't really an SLO yet — it's a hope.

## Structured Logging

* Emit logs as structured data (JSON or equivalent key-value format), not free-text strings that require regex to parse later
* Propagate a trace/correlation ID through every service a request touches, generated at the edge and passed through headers/context
* Log at a level that supports incident investigation without being so verbose that signal drowns in noise — log business-meaningful events and errors, not every function entry/exit

## Metrics

* Emit a metric for every SLI defined in Phase 0 — if an SLI has no corresponding metric, it can't be measured
* Use the right metric type: counters for rates (requests, errors), histograms/summaries for latency distributions (avoid averages alone — they hide tail latency)
* Tag metrics with dimensions useful for slicing during an incident (region, version, customer tier) without creating unbounded cardinality

## Distributed Tracing

* Required for any critical journey that spans more than one service
* Traces should let you answer "which hop in the chain added the latency/error" without guessing
* Sample intelligently — 100% sampling is rarely necessary outside of low-traffic critical paths; ensure error traces are always captured even under sampling

## Dashboards

* Every service needs a dashboard showing SLO burn rate (how fast the error budget is being consumed), not just raw CPU/memory/request-count panels
* Burn-rate visualization should make it obvious at a glance whether the current trajectory will exhaust the budget before the window resets
* Link dashboards from the SLO doc in `/docs/reliability/slo` so the target and the live measurement live one click apart

## Retention

* Balance incident-investigation needs (how far back do you need to look during an investigation) against cost and compliance constraints (e.g., data minimization requirements)
* Document the retention period per log/metric/trace type — a default retention nobody chose deliberately is a Gate 1 gap

## Deliverables (Exit Criteria for Phase 1)

- [ ] Structured logging with trace IDs across all services in the critical journey
- [ ] Metrics cover every SLI from Phase 0
- [ ] Distributed tracing in place for multi-service critical journeys
- [ ] Dashboard shows SLO burn rate per service
- [ ] Retention period documented per log/metric/trace type
