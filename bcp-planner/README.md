# BCP Planner

Guides Business Continuity Planning through five gated phases — Initiation & Scope, Business Impact Analysis, Risk Assessment & Recovery Strategy, Plan Development, and Testing/Training/Maintenance — producing a Business Impact Analysis (BIA), a Business Continuity Plan (BCP), and a Disaster Recovery (DR) Plan. Interview-heavy by design: criticality, RTO, and RPO come from the people who actually run each process, not from assumption.

## When to use

* A Business Impact Analysis is needed for a business unit, process, or system
* A Business Continuity Plan or Disaster Recovery Plan needs to be written or reviewed
* RTOs/RPOs need to be set or validated against real recovery capability
* Critical processes need to be mapped to their supporting systems, people, facilities, and vendor dependencies
* Single points of failure need to be identified
* A continuity exercise (tabletop, walkthrough, simulation, full test) needs to be planned

## Structure

A 5-phase gate model (Phase 0 → Phase 4). Phase 1 (the BIA) carries a structured interview question bank worked in small batches per process — see `SKILL.md` for the full model and gate criteria.

## Files

| File | Contents |
|---|---|
| `SKILL.md` | Phase model, folder structure, gate criteria, agent workflow rules |
| `0initiation-scope.md` | Phase 0 detail — sponsorship, scope, BCP policy, regulatory obligations, stakeholder list |
| `1business-impact-analysis.md` | Phase 1 detail — the BIA interview question bank, criticality tiering, RTO/RPO/MTPD, dependency mapping |
| `2risk-strategy.md` | Phase 2 detail — threat/hazard assessment, recovery capability gap analysis, strategy selection |
| `3plan-development.md` | Phase 3 detail — BCP and DR Plan document templates, cross-referencing to the BIA |
| `4testing-maintenance.md` | Phase 4 detail — exercise types and cadence, finding tracking, maintenance, training |
| `evals/evals.json` | Behavioral test prompts/assertions for this skill |

## Works well with

Standalone by design — a distinct domain from the other skills here. `sre-engineer`'s Incident Response phase handles live, SLO-scale service incidents; this skill's DR Plan/RTO handle broader, often longer disruptions (facility loss, regional outage, vendor failure) — flag any RTO/SLO mismatch if both are in use.
