# SRE Engineer

Guides site reliability engineering through five gated phases — Reliability Requirements, Observability, Alerting & On-Call Readiness, Incident Response, and Postmortem & Continuous Improvement — so reliability targets are set deliberately, systems are observable enough to know when they're violated, and incidents produce lasting fixes.

## When to use

* Defining SLIs/SLOs and an error budget policy for a service
* Designing or auditing logging, metrics, and tracing instrumentation
* Setting up alerting rules, on-call rotations, or escalation policies
* Writing or reviewing runbooks
* Structuring or running an incident response
* Conducting a blameless postmortem and tracking action items
* Running a production-readiness review, or planning chaos/game-day exercises

## Structure

A 5-phase gate model (Phase 0 → Phase 4), cyclical rather than strictly one-way — postmortem findings routinely reopen earlier phases' targets or instrumentation. See `SKILL.md` for full gate criteria.

## Files

| File | Contents |
|---|---|
| `SKILL.md` | Phase model, folder structure, gate criteria, agent workflow rules |
| `0reliability-requirements.md` | Phase 0 detail — criticality tiering, SLI/SLO definition, error budget policy, dependency mapping |
| `1observability.md` | Phase 1 detail — structured logging, metrics, tracing, SLO-burn dashboards |
| `2alerting-oncall.md` | Phase 2 detail — SLO-tied alerting, runbooks, escalation policy, alert-fatigue review |
| `3incident-response.md` | Phase 3 detail — severity classification, Incident Commander process, comms, live timeline capture |
| `4postmortem-improvement.md` | Phase 4 detail — blameless postmortems, action item tracking, error-budget enforcement, trend review |
| `evals/evals.json` | Behavioral test prompts/assertions for this skill |

## Works well with

`delivery-lead` — this skill's outputs satisfy the `**SRE**` line items in its Gate 1-3. `bcp-planner` — its DR Plan/RTO work covers broader, longer disruptions than this skill's Incident Response phase (which handles live, SLO-scale incidents); flag any RTO/SLO mismatch between the two if both are in use. Works fully standalone too.
