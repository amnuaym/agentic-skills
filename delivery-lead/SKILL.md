---
name: delivery-lead
description: "Guide software delivery through five phases: Discovery, Planning, Development, Deployment, and Hypercare. Use this skill when assessing project readiness, gathering requirements, building product backlogs, reviewing architecture, evaluating test coverage, managing cutover, or auditing DevSecOps and FinOps practices. Ensures gate criteria are met before advancing between phases."
---

# Delivery Lead — Orchestrator

Guide software delivery through five phases: Discovery, Planning, Development, Deployment, and Hypercare. This skill ensures business requirements are captured, non-functional requirements (including cost and compliance) are addressed systematically, and phase transitions happen only when gate criteria are met.

## When to Use

Activate this skill when:

* Starting a new project or major feature that needs requirements gathering
* Building or refining a product backlog with user stories
* Reviewing readiness to move from design to development
* Assessing whether a system is ready for production deployment and business launch
* Conducting post-launch value realization and handover to BAU (Business As Usual)
* Auditing non-functional requirements (security, FinOps, compliance) across the delivery lifecycle

## Phase Model

```text
┌──────────────┐   ┌──────────────┐   ┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│ Phase 0      │──▶│ Phase 1      │──▶│ Phase 2      │──▶│ Phase 3      │──▶│ Phase 4      │
│ DISCOVERY &  │ G │ PLANNING &   │ G │ DEVELOPMENT &│ G │ DEPLOYMENT & │ G │ HYPERCARE &  │
│ REQUIREMENTS │ 0 │ DESIGN       │ 1 │ QUALITY      │ 2 │ OPERATIONS   │ 3 │ VALUE REAL.  │
└──────────────┘   └──────────────┘   └──────────────┘   └──────────────┘   └──────────────┘
```

## Expected Folder Structure

To keep the project organized, always follow this standard folder structure for project files and documents. **All gate criteria deliverables must be saved in their proper folders to pass to the next phase.**

```text
/project-root
  ├── /docs
  │    ├── /discovery      # Phase 0: Requirements, user stories, personas, product backlog
  │    ├── /architecture   # Phase 1: Diagrams, ADRs, API contracts, FinOps budgets
  │    ├── /runbooks       # Phase 3 & 4: Cutover plans, support handovers
  │    └── /reviews        # Phase 4: Post-launch reviews, KPI tracking
  ├── /src                 # Phase 2: Application code
  ├── /tests               # Phase 2: All testing code (unit, integration, E2E)
  ├── /infra               # Phase 2 & 3: Infrastructure code (IaC), CI/CD pipelines
  └── /scripts             # Phase 2: Data migration scripts, database tools
```

## How to Assess Current Phase

1. **Check for business requirements & backlog** — If missing or no user stories in `/docs/discovery` → Phase 0
2. **Check for architecture & migration plans** — If requirements exist but no architecture/cost decisions in `/docs/architecture` → Phase 1
3. **Check for working code & dry-runs** — If architecture exists but coverage/quality/migration-tests have gaps in `/src` and `/tests` → Phase 2
4. **Check for deployment & business readiness** — If code is solid but security/infra/cutover plans are missing in `/docs/runbooks` or `/infra` → Phase 3
5. **Check for post-launch metrics** — If system is live but KPIs aren't measured in `/docs/reviews` or helpdesk hasn't taken over → Phase 4

## Gate Criteria

### Gate 0: Discovery → Planning

All of the following must be satisfied before starting architecture design:

* [ ] Business requirements documented and stakeholder-approved (saved in `/docs/discovery`)
* [ ] User personas defined (saved in `/docs/discovery`)
* [ ] Product backlog exists with prioritized user stories (saved in `/docs/discovery`)
* [ ] Acceptance criteria defined for all Must-Have stories (saved in `/docs/discovery`)
* [ ] MVP scope agreed and documented (saved in `/docs/discovery`)
* [ ] Non-functional requirements captured (performance, security, compliance, scalability) (saved in `/docs/discovery`)
* [ ] Initial compliance triggers identified (e.g., DPIA needed for PII) (saved in `/docs/discovery`)
* [ ] Iteration cadence decided (sprint length, ceremonies)
* [ ] Definition of Done and Definition of Ready agreed by team

### Gate 1: Planning → Development

All of the following must be satisfied before starting development:

* [ ] Bounded contexts and service boundaries documented (saved in `/docs/architecture`)
* [ ] FE-BE-DB layering decided and diagrammed (saved in `/docs/architecture`)
* [ ] API strategy chosen (REST, GraphQL, or hybrid) with contracts defined (saved in `/docs/architecture`)
* [ ] Environment strategy defined (Dev, UAT, Staging, Prod) (saved in `/docs/architecture`)
* [ ] Infrastructure as Code approach selected (tools configured in `/infra`)
* [ ] ADRs (Architecture Decision Records) written for all significant architectural decisions (saved in `/docs/architecture`)
* [ ] **FinOps**: Cloud cost estimates documented and budget approved (saved in `/docs/architecture`)
* [ ] **Data**: Legacy data migration strategy defined, if replacing an old system (saved in `/docs/architecture`)

### Gate 2: Development → Deployment

All of the following must be satisfied before deploying to production environments:

* [ ] Unit test coverage meets threshold (90% overall, 100% domain logic) (code in `/tests`)
* [ ] Integration and E2E tests pass with real dependencies (code in `/tests`)
* [ ] Performance/load test baseline established
* [ ] Documentation is current and cross-references are accurate across `/docs`
* [ ] Database migrations are versioned, idempotent, and rollback-safe (scripts saved in `/scripts`)
* [ ] No critical or high security findings open in the app code (`/src`)
* [ ] **FinOps**: Infrastructure resource tagging applied via IaC (code updated in `/infra`)
* [ ] **Data**: Legacy data migration dry-runs completed in Staging with acceptable error rates (scripts run from `/scripts`)

### Gate 3: Deployment → Hypercare (Go-Live)

All of the following must be satisfied before flipping the switch to live users:

* [ ] OWASP Top 10 audit passed and security headers enforced
* [ ] Secrets rotated and rotation procedure documented
* [ ] CI/CD pipeline complete (Lint → Test → Integration → E2E → Deploy) (pipeline config saved in `/infra`)
* [ ] Production hardening checklist completed
* [ ] **FinOps**: Cloud billing alerts and budget thresholds configured
* [ ] **Compliance**: Formal Legal/InfoSec sign-off secured (e.g., DPIA approved)
* [ ] **Change Mgmt**: End-user training completed and comms sent
* [ ] **Change Mgmt**: Support/Helpdesk Tier 1 & 2 handover complete (runbooks saved in `/docs/runbooks`)
* [ ] **Cutover**: Minute-by-minute Go-Live runbook approved and Go/No-Go secured (saved in `/docs/runbooks`)

### Gate 4: Hypercare → BAU (Business As Usual)

All of the following must be satisfied to close the project:

* [ ] Hypercare period elapsed with stable system performance (no Sev 1/2 incidents)
* [ ] Post-Implementation Review (PIR) completed (saved in `/docs/reviews`)
* [ ] **Value**: Product KPIs measured against Phase 0 baselines (tracked in `/docs/reviews`)
* [ ] Final handover to operations and maintenance teams completed

## Agent Workflow & Rules

As the Delivery Lead AI Agent, follow these rules when managing tasks and files:

1. **Assess the Structure:** When starting, check if the project follows the exact folder structure above. If it does not, politely suggest setting it up to the user.
2. **Place Files Correctly:** Whenever you create or update a document, code, or script, save it in the correct folder based on its phase as strictly defined in the Gate Criteria. Do not create files outside this folder structure.
3. **Enforce Organization:** If you notice files mixed up (for example, the product backlog sitting in the root folder instead of `/docs/discovery`), ask the user if you should help move and organize them.
4. **Phase-Based Navigation:** When verifying if a phase is complete, search ONLY in the specific folder linked to that phase's gate criteria. 

## Phase Details

Each phase has its own detailed guide:

* **Phase 0**: See `discovery.md` — Business requirements, backlog, iteration planning
* **Phase 1**: See `planning.md` — Architecture, API design, messaging, FinOps estimates, Data strategy
* **Phase 2**: See `development.md` — Service components, testing pyramid, migration dry-runs, IaC tagging
* **Phase 3**: See `deployment.md` — DevSecOps, CI/CD, production hardening, cutover, compliance
* **Phase 4**: See `hypercare.md` — Value realization, support transition, post-implementation review
