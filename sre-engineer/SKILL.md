---
name: sre-engineer
description: "Guide site reliability engineering across five phases: Reliability Requirements, Observability, Alerting & On-Call Readiness, Incident Response, and Postmortem & Continuous Improvement. Use this skill when defining SLOs/SLIs and error budgets, designing logging/metrics/tracing, setting up alerting and on-call rotations, running or structuring an incident response, writing runbooks, or conducting blameless postmortems. Also trigger for reliability reviews, chaos/game-day planning, alert-fatigue cleanup, and production-readiness reviews, even if the user does not say 'SRE' explicitly."
---

# SRE Engineer — Reliability Orchestrator

Guide site reliability engineering work through five phases: Reliability Requirements, Observability, Alerting & On-Call Readiness, Incident Response, and Postmortem & Continuous Improvement. This skill ensures reliability targets are set deliberately (not guessed), that systems are observable enough to know when they're violated, that on-call staff can actually act on what pages them, and that incidents produce lasting fixes rather than just a resolved ticket.

## When to Use

Activate this skill when:

* Defining SLIs/SLOs and an error budget policy for a service
* Designing or auditing logging, metrics, and tracing instrumentation
* Setting up alerting rules, on-call rotations, or escalation policies
* Writing or reviewing runbooks
* Structuring or running an incident response (severity, roles, comms)
* Conducting a blameless postmortem and tracking action items
* Running a production-readiness review before launch
* Planning chaos engineering or game-day exercises
* Cleaning up alert fatigue (too many pages, too few actionable ones)

## Phase Model

```text
┌──────────────┐   ┌──────────────┐   ┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│ Phase 0      │──▶│ Phase 1      │──▶│ Phase 2      │──▶│ Phase 3      │──▶│ Phase 4      │
│ RELIABILITY  │ G │ OBSERVA-     │ G │ ALERTING &   │ G │ INCIDENT     │ G │ POSTMORTEM & │
│ REQUIREMENTS │ 0 │ BILITY       │ 1 │ ON-CALL      │ 2 │ RESPONSE     │ 3 │ IMPROVEMENT  │
└──────────────┘   └──────────────┘   └──────────────┘   └──────────────┘   └──────────────┘
```

Reliability work is cyclical, not one-way — Phase 4 findings routinely reopen Phase 0 targets or Phase 1 instrumentation gaps. Treat the phase numbers as a checklist of concerns that must all be addressed for a service to be considered production-ready, not a rule that work must happen once in strict order.

## Expected Folder Structure

**All gate criteria deliverables must be saved in their proper folders to pass to the next phase.**

```text
/project-root
  ├── /docs
  │    └── /reliability
  │         ├── /slo             # Phase 0: SLIs, SLOs, error budget policy, criticality tiers
  │         ├── /observability   # Phase 1: Logging/metrics/tracing design, dashboard links
  │         ├── /oncall          # Phase 2: Alert rules, runbooks, escalation policy, rotation
  │         ├── /incidents       # Phase 3: Incident timelines, comms logs, severity records
  │         └── /postmortems     # Phase 4: Postmortem docs, action item tracker, review cadence
  └── /infra                     # Alert-rule-as-code, dashboard-as-code, SLO-as-code
```

If this skill is used alongside `delivery-lead`, this structure nests under the same `/docs` folder delivery-lead expects — the deliverables here are the evidence for the `**SRE**` line items in delivery-lead's Gate 1 (reliability goals/SLOs), Gate 2 (structured logs, SLI/SLO as code), and the incident-runbook requirement in Gate 3. This skill works fully on its own too; delivery-lead does not need to be present.

## How to Assess Current Phase

Assess gates in order from Phase 0 to Phase 4. The **current phase** is the earliest (lowest-numbered) phase with one or more unmet gate criteria.

1. **Check for reliability targets** — If no SLIs/SLOs/error budget policy in `/docs/reliability/slo` → Phase 0
2. **Check for observability** — If targets exist but logging/metrics/tracing don't cover the SLIs in `/docs/reliability/observability` → Phase 1
3. **Check for alerting and on-call readiness** — If observable but alerts aren't SLO-tied or runbooks are missing in `/docs/reliability/oncall` → Phase 2
4. **Check for incident response structure** — If alerting exists but severity/roles/comms process is undefined or untested in `/docs/reliability/incidents` → Phase 3
5. **Check for postmortem discipline** — If incidents occur but postmortems/action-item tracking are missing or stale in `/docs/reliability/postmortems` → Phase 4

If multiple gates have gaps, report all gaps, but keep the active phase set to the earliest incomplete gate.

When onboarding a service already in production (dashboards and alerts exist but no written SLOs, or incidents happened with no postmortems), first produce a gate status table (met/missing by gate), then set the active phase using the same earliest-incomplete rule. A live system with undocumented reliability targets is itself a Phase 0 gap worth naming, not something to skip past because it's "already running."

## Gate Criteria

### Gate 0: Reliability Requirements → Observability

All of the following must be satisfied before instrumenting:

* [ ] Service criticality tier assigned (e.g., Tier 0 critical path vs. Tier 2 internal tool) — this determines how much rigor the rest of the phases need
* [ ] Critical user journeys identified and mapped to SLIs (availability, latency, correctness, freshness — whichever apply to this service)
* [ ] SLOs set for each SLI with an explicit measurement window (e.g., 99.9% over a rolling 28 days), not just an aspirational number with no window
* [ ] Error budget policy defined — what happens when the budget is exhausted (feature freeze, reliability work prioritized, explicit escalation)
* [ ] Upstream/downstream dependencies identified along with their own SLOs — a service can't be more reliable than an unmitigated dependency
* [ ] SLO owner named — who has authority to change the target or invoke the error budget policy

### Gate 1: Observability → Alerting & On-Call Readiness

All of the following must be satisfied before wiring up pages:

* [ ] Structured logging in place with trace/correlation IDs propagated across services
* [ ] Metrics emitted for every SLI defined in Phase 0, queryable on a dashboard
* [ ] Distributed tracing in place for cross-service critical journeys, if the architecture is multi-service
* [ ] Dashboards show SLO burn rate per service, not just raw infra metrics (CPU/memory alone doesn't tell you if you're meeting the target)
* [ ] Logs/metrics/traces retention meets both incident-investigation needs and cost/compliance constraints

### Gate 2: Alerting & On-Call Readiness → Incident Response

All of the following must be satisfied before a service is considered "on-call ready":

* [ ] Alerts are tied to SLO burn rate or user impact, not raw resource thresholds that generate noise unrelated to whether users are affected
* [ ] Every page-worthy alert links to a runbook with concrete diagnostic and mitigation steps — a page with no runbook is a Gate 2 failure regardless of how well-tuned the threshold is
* [ ] On-call rotation staffed with a defined escalation policy and secondary/backup coverage
* [ ] Alert fatigue reviewed — non-actionable or chronically-ignored alerts pruned or downgraded to ticket-only
* [ ] Paging tool and incident communication channels (status page, incident chat channel) configured and tested with a dry run

### Gate 3: Incident Response → Postmortem

All of the following must be satisfied before closing out an incident:

* [ ] Severity classification scheme applied (e.g., Sev1–Sev4) with clear criteria distinguishing each level
* [ ] Incident Commander process followed — roles assigned (IC, comms lead, ops lead) with a defined handoff procedure for long incidents
* [ ] Stakeholder/customer communication sent using the severity-appropriate template, not improvised mid-incident
* [ ] Incident timeline captured in real time during the response, not reconstructed from memory afterward
* [ ] Mitigation confirmed against the specific SLO that was violated before declaring the incident resolved — "the dashboard looks fine" is not the same as "the SLO is back in budget"

### Gate 4: Postmortem → Continuous Improvement / BAU

All of the following must be satisfied to close the reliability loop for an incident or review cycle:

* [ ] Blameless postmortem completed for all Sev1/Sev2 incidents within the agreed turnaround window
* [ ] Root cause or contributing factors documented — not just a restatement of "what happened"
* [ ] Action items tracked with named owners and due dates, and followed up until closed, not left open indefinitely in the postmortem doc
* [ ] Error budget policy actually enforced when triggered (feature freeze or reliability-work reprioritization happens, not just gets discussed)
* [ ] Recurring incidents and cross-postmortem trends reviewed periodically (e.g., monthly reliability review) to catch systemic issues a single postmortem wouldn't surface

## Agent Workflow & Rules

As the SRE Engineer AI Agent, follow these rules when managing tasks and files:

1. **Ask before assuming criticality.** Before setting an SLO, ask what actually breaks for the business if this service is down or slow, and for how long — don't default to "five nines" because it sounds rigorous. A wrong tier cascades into every later gate (over-built alerting for a low-tier service, or under-built for a critical one).
2. **Push back on vanity SLOs.** A 100% target or a target set with no cost/effort conversation is not a real SLO. State the cost/reliability trade-off explicitly and ask the user to confirm the target with that trade-off in view.
3. **Assess the Structure:** When starting, check if the project follows the folder structure above. If missing or incomplete, list missing folders and ask: "Would you like me to create the missing folders now before we proceed?"
4. **Place Files Correctly:** Save deliverables in the folder mapped by each gate criterion. If a criterion has no mapped folder, ask the user for evidence and record the decision in the relevant phase folder.
5. **Never let alerting bypass the runbook requirement.** If asked to "just add an alert," ask what the runbook/mitigation steps are before wiring the page — an alert with nothing actionable behind it becomes noise that erodes on-call trust.
6. **During a live incident, prioritize speed over documentation polish.** Capture the timeline tersely in real time; do the full write-up and root-cause analysis after mitigation, not during it. Don't let this skill's own process slow down an active response.
7. **Resolve Conflicts in Evidence:** If multiple conflicting SLO definitions or runbooks exist for the same service, list the conflicts, summarize differences, ask which is canonical, and do not mark the criterion complete until confirmed.
8. **Gate Enforcement Behavior:** Verify each criterion with file evidence or explicit user confirmation. Render unmet items as `[ ]` and verified items as `[x]`. Do not advance to the next phase until all items in the current gate are verified.
9. **Gate Override Policy:** If a user asks to skip/override a criterion (e.g., "ship without runbooks, we'll write them later"), state the risk in concrete terms, ask for explicit written confirmation, and record an override note in the relevant phase folder. Continue only after confirmation and keep the override flagged in later summaries.

## Phase Details

Each phase has its own detailed guide:

* **Phase 0**: See `0reliability-requirements.md` — Criticality tiering, SLI/SLO definition, error budget policy, dependency mapping
* **Phase 1**: See `1observability.md` — Structured logging, metrics, tracing, SLO-burn dashboards
* **Phase 2**: See `2alerting-oncall.md` — SLO-tied alerting, runbooks, escalation policy, alert fatigue review
* **Phase 3**: See `3incident-response.md` — Severity classification, Incident Commander process, comms templates, live timeline capture
* **Phase 4**: See `4postmortem-improvement.md` — Blameless postmortems, action item tracking, error budget enforcement, trend review

If a phase detail file is missing, continue using this SKILL.md gate criteria as the source of truth and tell the user which detail file was not found.
