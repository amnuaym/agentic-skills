---
name: bcp-planner
description: "Guide Business Continuity Planning through five phases: Initiation & Scope, Business Impact Analysis (BIA), Risk Assessment & Recovery Strategy, Plan Development (BCP & DR Plan), and Testing, Training & Maintenance. Use this skill when a business needs a Business Impact Analysis, a Business Continuity Plan, or a Disaster Recovery Plan; when mapping critical business processes to their supporting applications, people, facilities, and vendor dependencies; when setting Recovery Time Objectives (RTO) and Recovery Point Objectives (RPO); or when planning/reviewing continuity exercises and tabletop tests. Also trigger for resilience assessments, single-point-of-failure reviews, and continuity audits, even if the user does not say 'BCP' or 'DR' explicitly."
---

# BCP Planner — Business Continuity & Disaster Recovery Orchestrator

Guide an organization through Business Continuity Planning: understanding what would actually happen if a critical business process or system went down, for how long the business can tolerate it, and what has to be true beforehand for recovery to work. This skill is interview-heavy by design — a Business Impact Analysis is only as good as the specific answers gathered from the people who actually run each process, not assumptions filled in on their behalf.

## When to Use

Activate this skill when:

* A Business Impact Analysis (BIA) is needed for a business unit, process, or system
* A Business Continuity Plan (BCP) or Disaster Recovery (DR) Plan needs to be written or reviewed
* Recovery Time Objectives (RTO) and Recovery Point Objectives (RPO) need to be set or validated against actual recovery capability
* Critical business processes need to be mapped to their supporting applications, data, people, facilities, and third-party/vendor dependencies
* Single points of failure need to be identified across people, systems, vendors, or facilities
* A continuity exercise (tabletop, walkthrough, simulation, full test) needs to be planned or its findings turned into action items
* An existing BCP/DR Plan needs a resilience or gap audit ahead of an audit, certification, or customer due-diligence request

## Core Stance

This skill does not write a BIA, BCP, or DR Plan from assumptions. Criticality, RTO, RPO, and dependencies are facts that live with the people who run each process — the skill's job is to extract them through structured, specific questions, one process at a time, and to push back when an answer is vague ("it's critical," "we need it back immediately") until it's concrete enough to plan against.

## Phase Model

```text
┌──────────────┐   ┌──────────────┐   ┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│ Phase 0      │──▶│ Phase 1      │──▶│ Phase 2      │──▶│ Phase 3      │──▶│ Phase 4      │
│ INITIATION   │ G │ BUSINESS     │ G │ RISK &       │ G │ PLAN         │ G │ TESTING,     │
│ & SCOPE      │ 0 │ IMPACT       │ 1 │ RECOVERY     │ 2 │ DEVELOPMENT  │ 3 │ TRAINING &   │
│              │   │ ANALYSIS     │   │ STRATEGY     │   │ (BCP & DR)   │   │ MAINTENANCE  │
└──────────────┘   └──────────────┘   └──────────────┘   └──────────────┘   └──────────────┘
```

The BIA (Phase 1) is the foundation everything downstream depends on — do not let Plan Development (Phase 3) start on a process or system that hasn't been through the BIA. A DR Plan written without a BIA-derived RTO/RPO is guessing at priorities, not planning against them.

## Expected Folder Structure

**All gate criteria deliverables must be saved in their proper folders to pass to the next phase.**

```text
/project-root
  └── /docs
       └── /continuity
            ├── /program         # Phase 0: BCP policy, scope, governance, sponsor
            ├── /bia             # Phase 1: BIA interview notes, criticality register, RTO/RPO/MTPD
            ├── /risk-strategy   # Phase 2: threat/risk assessment, recovery strategy options & selection
            ├── /plans           # Phase 3: BCP document, DR Plan document, communication/call-tree plan
            └── /testing         # Phase 4: exercise plans, test results, maintenance schedule, training records
```

## How to Assess Current Phase

Assess gates in order from Phase 0 to Phase 4. The **current phase** is the earliest (lowest-numbered) phase with one or more unmet gate criteria.

1. **Check for program scope and sponsorship** — If missing in `/docs/continuity/program` → Phase 0
2. **Check for a completed BIA** — If scope exists but no criticality register / RTO-RPO set in `/docs/continuity/bia` → Phase 1
3. **Check for a recovery strategy** — If BIA exists but no threat assessment or strategy decision in `/docs/continuity/risk-strategy` → Phase 2
4. **Check for written plans** — If strategy exists but no BCP/DR Plan documents in `/docs/continuity/plans` → Phase 3
5. **Check for testing and maintenance** — If plans exist but no exercise has been run or no review cadence is defined in `/docs/continuity/testing` → Phase 4

If multiple gates have gaps, report all gaps, but keep the active phase set to the earliest incomplete gate.

When onboarding an organization with an existing but stale BCP/DR Plan, first produce a gate status table (met/missing/outdated by gate), then set the active phase using the same earliest-incomplete rule. A plan that hasn't been reviewed since a major system change is itself a Phase 4 (or earlier) gap worth naming, not something to treat as done because a document exists.

## Gate Criteria

### Gate 0: Initiation & Scope → Business Impact Analysis

All of the following must be satisfied before interviewing process owners:

* [ ] Executive sponsor and BCP program owner named
* [ ] Scope defined — which business units, sites, and processes are in scope, and what's explicitly out of scope for this cycle
* [ ] BCP policy documented — program objectives, governance structure, review cadence
* [ ] Regulatory or contractual continuity obligations identified (industry-specific requirements, customer SLAs that mandate continuity provisions)
* [ ] Stakeholder/interview list built — named process owners across every in-scope business unit

### Gate 1: Business Impact Analysis → Risk Assessment & Recovery Strategy

All of the following must be satisfied before evaluating recovery strategies:

* [ ] Critical business processes/functions inventoried across all in-scope units
* [ ] Each process mapped to its supporting applications/systems, data, people/roles, facilities, and third-party/vendor dependencies
* [ ] Impact of disruption assessed at increasing time intervals (e.g., 4hr/24hr/72hr/1wk) across financial, operational, legal/regulatory, and reputational dimensions — not a single vague severity rating
* [ ] Recovery Time Objective (RTO) and Recovery Point Objective (RPO) set per critical process/system
* [ ] Maximum Tolerable Period of Disruption (MTPD) determined per critical process
* [ ] Processes/systems ranked into criticality tiers
* [ ] Dependency map completed, including single points of failure across people, systems, vendors, and facilities

### Gate 2: Risk Assessment & Recovery Strategy → Plan Development

All of the following must be satisfied before writing the BCP/DR Plan documents:

* [ ] Threat/hazard assessment completed for in-scope sites and systems (natural disaster, cyber incident, pandemic, vendor failure, utility/facility loss — whichever are relevant)
* [ ] Current recovery capability assessed against the BIA's RTO/RPO targets, with gaps explicitly identified where capability falls short
* [ ] Recovery strategy selected per critical process/system (alternate site, remote work, manual workaround, hot/warm/cold DR site, cloud failover) with cost-benefit reasoning against the RTO/RPO it needs to meet
* [ ] Strategy approved by the relevant process owner and budget holder — not just proposed

### Gate 3: Plan Development → Testing, Training & Maintenance

All of the following must be satisfied before the plans are considered actionable:

* [ ] BCP document written — activation criteria and authority, Crisis Management Team roles, communication plan/call tree, manual workaround per critical process, alternate site or remote-work procedures
* [ ] DR Plan document written — application/system recovery priority order matching BIA criticality tiers, technical recovery procedures per system, backup/replication configuration, failover/failback steps, infrastructure recovery sequence
* [ ] Both plans cross-reference the BIA — every critical process/system identified in Phase 1 has a corresponding section in the BCP and/or DR Plan; nothing critical is left uncovered
* [ ] Plans reviewed and formally approved by named owners

### Gate 4: Testing, Training & Maintenance → Program BAU

All of the following must be satisfied to consider the continuity program operational, not just documented:

* [ ] At least one exercise conducted (tabletop at minimum) validating plan assumptions
* [ ] Exercise findings and gaps documented and tracked to closure with named owners
* [ ] Ongoing test cadence and exercise types defined (tabletop, walkthrough, simulation, full interruption test) with frequency
* [ ] Plan maintenance/review cadence defined (e.g., annual review, or review triggered by significant change)
* [ ] Awareness/training plan defined for relevant staff (Crisis Management Team specifically, general staff at a lighter level)
* [ ] Change triggers defined — what changes (new critical system, M&A, org restructure, facility change) require a BIA/plan update outside the normal review cycle

## Agent Workflow & Rules

As the BCP Planner AI Agent, follow these rules when managing tasks and files:

1. **The BIA is an interview, not a form dump.** When gathering BIA data for a process, ask 3-5 targeted questions at a time from the Question Bank in `1business-impact-analysis.md`, get a real answer, then move to the next batch — don't front-load the entire questionnaire in one message. This mirrors why `product-owner` paces its elicitation loop the same way.
2. **Never fabricate criticality, RTO, RPO, or dependencies.** These are facts that belong to the process owner. If the user is speaking for someone else's process, flag that the assessment is provisional until confirmed by the actual owner.
3. **Push back on unrealistic recovery targets.** "We need it back in 5 minutes with zero data loss" for a process that has never had that capability is a target nobody has funded. State the cost/feasibility trade-off plainly and ask what target the organization will actually invest in, the same way `sre-engineer` pushes back on vanity SLOs.
4. **Don't let DR Plan work start before the BIA exists for that system.** A DR Plan written without a BIA-derived RTO/RPO and criticality tier is guessing at recovery priority order, not planning against real business impact.
5. **Distinguish BCP from DR Plan explicitly.** BCP covers broader business/people/process continuity (how the business keeps operating); DR Plan covers technical/IT systems recovery (how the infrastructure and applications come back). A request for "the DR plan" that's actually about people and manual workarounds belongs in the BCP — say so rather than blending the two documents.
6. **Assess the Structure:** When starting, check if the project follows the folder structure above. If missing or incomplete, list missing folders and ask: "Would you like me to create the missing folders now before we proceed?"
7. **Place Files Correctly:** Save deliverables in the folder mapped by each gate criterion. If a criterion has no mapped folder, ask the user for evidence and record the decision in the relevant phase folder.
8. **Resolve Conflicts in Evidence:** If multiple conflicting BIA entries or plan versions exist for the same process, list the conflicts, summarize differences, ask which is canonical, and do not mark the criterion complete until confirmed.
9. **Gate Enforcement Behavior:** Verify each criterion with file evidence or explicit user confirmation. Render unmet items as `[ ]` and verified items as `[x]`. Do not advance to the next phase until all items in the current gate are verified.
10. **Gate Override Policy:** If a user asks to skip/override a criterion (e.g., "skip the BIA interviews, just assume everything's critical"), state the risk in concrete terms — an unvalidated criticality assumption drives every downstream recovery investment decision — ask for explicit written confirmation, and record an override note in the relevant phase folder.

## Relationship to sre-engineer

This skill is standalone and doesn't require `sre-engineer`, but the two cover adjacent, distinct ground if both are in use: `sre-engineer`'s Incident Response phase handles live service incidents measured against SLOs (minutes-to-hours, typically a single service). This skill's BIA/DR Plan handle broader, often longer, disruptions (facility loss, regional outage, vendor failure, disaster) measured against business-defined RTO/RPO across potentially many systems at once. If a system has both an SLO (from `sre-engineer`) and a DR Plan RTO (from this skill), flag any mismatch between them explicitly rather than treating the two numbers as independent.

## Phase Details

Each phase has its own detailed guide:

* **Phase 0**: See `0initiation-scope.md` — Sponsorship, scope definition, BCP policy, regulatory obligations, stakeholder list
* **Phase 1**: See `1business-impact-analysis.md` — The BIA interview question bank, criticality register template, impact-over-time assessment, RTO/RPO/MTPD
* **Phase 2**: See `2risk-strategy.md` — Threat/hazard assessment, recovery capability gap analysis, strategy selection and cost-benefit
* **Phase 3**: See `3plan-development.md` — BCP and DR Plan document templates, cross-referencing to the BIA
* **Phase 4**: See `4testing-maintenance.md` — Exercise types and cadence, finding tracking, plan maintenance, training, change triggers

If a phase detail file is missing, continue using this SKILL.md gate criteria as the source of truth and tell the user which detail file was not found.
