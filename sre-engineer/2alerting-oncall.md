# Phase 2: Alerting & On-Call Readiness

This phase turns observability into something a human can act on at 3am. An alert that isn't actionable is worse than no alert — it trains on-call staff to ignore pages.

## SLO-Tied Alerting

* Alert on burn rate against the error budget (e.g., "will exhaust 28-day budget within 6 hours at current rate"), not on raw thresholds like "CPU > 80%" that may or may not correlate with user impact
* Use multi-window, multi-burn-rate alerting where possible — a short window catches fast burns, a longer window catches slow leaks, both compared against the same budget
* Distinguish page-worthy (wake someone up now) from ticket-worthy (fix during business hours) — not everything that matters is an emergency

## Runbook Requirement

Every page-worthy alert must link to a runbook containing:

* What this alert means in plain language
* Immediate diagnostic steps (dashboards to check, logs to query, common causes ranked by likelihood)
* Mitigation steps (rollback, failover, scale up, feature flag off) — the fastest safe path to reducing user impact, not necessarily the root-cause fix
* Escalation path if the on-call engineer can't resolve it alone

An alert with no runbook is a Gate 2 failure regardless of how well-tuned its threshold is.

## Escalation Policy & Rotation

* Primary and secondary on-call defined, with a clear handoff time
* Escalation timeout defined (e.g., page secondary if primary doesn't acknowledge within 5 minutes)
* Rotation schedule fair and sustainable — check for anyone carrying a disproportionate share
* Escalation beyond on-call (manager, incident commander pool) defined for anything that exceeds the on-call engineer's authority (e.g., customer comms, cross-team coordination)

## Alert Fatigue Review

* Periodically review alert volume per on-call shift — a rising trend is a leading indicator of burnout and missed real incidents
* For each alert that fired: was it actionable? Did the runbook help? If an alert consistently resolves itself or requires no action, downgrade it to a ticket or delete it
* Track false-positive rate per alert; alerts above an agreed threshold get tuned or removed, not tolerated indefinitely

## Communication Channels

* Status page (internal or external) configured and its update process tested
* Incident chat channel/paging tool integration tested with a dry run before relying on it live
* Confirm the paging tool actually reaches the right person — untested paging configuration is a common cause of "nobody got paged" during a real incident

## Deliverables (Exit Criteria for Phase 2)

- [ ] Alerts tied to SLO burn rate, not raw resource thresholds
- [ ] Every page-worthy alert has a linked runbook
- [ ] On-call rotation staffed with escalation policy and secondary coverage
- [ ] Alert fatigue reviewed and non-actionable alerts pruned
- [ ] Paging tool and incident channels configured and dry-run tested
