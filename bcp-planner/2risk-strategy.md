# Phase 2: Risk Assessment & Recovery Strategy

This phase turns the BIA's "what matters and how fast it needs to come back" into "what's realistically going to threaten it, and what are we actually going to do about it." Don't let strategy selection happen before the threat picture and capability gap are both understood — a strategy chosen for the wrong threat, or one that ignores an existing capability gap, wastes the investment it costs.

## Threat & Hazard Assessment

For each in-scope site/system, identify plausible threats — don't run the full generic list against everything if it's not relevant to that site/system:

* **Natural** — flood, earthquake, severe weather, wildfire (site-specific; check actual geography, don't assume)
* **Technical** — hardware failure, power/utility outage, network/ISP failure, data corruption
* **Cyber** — ransomware, data breach, DDoS, insider threat
* **Human/Operational** — pandemic/workforce unavailability, key-person loss, human error, labor action
* **Third-party** — critical vendor outage or insolvency, supply chain disruption
* **Facility** — building loss/inaccessibility, fire, prolonged access loss (e.g., civil unrest, lockdown)

Ask which of these are actually plausible for this specific site/system rather than defaulting to the full list — a cloud-hosted SaaS dependency and a single physical warehouse have almost no threat overlap.

## Recovery Capability Gap Analysis

For each Tier 1/2 process or system from the BIA:

* What's the current actual recovery capability — how would it really be restored today, and how long would that really take?
* Compare that honestly against the BIA's RTO/RPO target
* Where current capability doesn't meet the target, that gap is the thing Phase 2 strategy has to close — name it explicitly rather than letting an optimistic assumption stand in for a tested capability

## Recovery Strategy Options

Match the strategy to what's actually driving the risk (a people problem needs a people strategy; a data-center-loss problem needs an infrastructure strategy):

| Dimension | Strategy options |
|---|---|
| People | Cross-training, documented backups per role, remote-work capability, contractor/staffing agreements |
| Process | Manual workaround procedures, temporary reduced-service mode, workload shift to another team/site |
| Technology/Data | Backup and replication strategy, redundancy (active-active vs. active-passive), cloud failover |
| Facilities | Alternate work site, reciprocal agreement with another location, fully remote fallback |
| Third-party | Backup vendor/supplier, contractual SLA with recovery commitments, in-house fallback for a critical vendor function |

### DR Site Tiers (for technology/data strategy specifically)

* **Cold site** — space and power only, equipment/data restored from backup on activation; cheapest, slowest (days)
* **Warm site** — partially configured with some data replication; moderate cost, moderate recovery time (hours)
* **Hot site** — fully mirrored and ready, near-continuous replication; most expensive, fastest (minutes)

Match the tier to the RTO the BIA actually set — a Tier 4 process doesn't need a hot site, and a Tier 1 process with a 1-hour RTO can't be served by a cold site regardless of budget preference.

## Cost-Benefit & Approval

* For each strategy option considered, state its rough cost and the RTO/RPO it can realistically achieve — let the process owner and budget holder see the trade-off explicitly rather than presenting one option as the only path
* A strategy is not "selected" until the process owner and budget holder have actually signed off — a proposed option sitting unconfirmed is not a Gate 2 pass
* If the approved budget can't fund a strategy that meets the BIA's RTO/RPO, surface that conflict explicitly and ask whether the target should be revised or the budget increased — don't silently downgrade the target to fit the budget without flagging it

## Deliverables (Exit Criteria for Phase 2)

- [ ] Threat/hazard assessment completed per in-scope site/system
- [ ] Recovery capability gap identified against BIA RTO/RPO targets
- [ ] Recovery strategy selected per critical process/system with cost-benefit reasoning
- [ ] Strategy approved by process owner and budget holder
