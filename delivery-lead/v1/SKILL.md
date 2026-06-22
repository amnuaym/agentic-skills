---
name: delivery-lead
description: "Guide software delivery through four phases: Discovery, Planning, Development, and Deployment. Use this skill when assessing project readiness, gathering requirements, building product backlogs, reviewing architecture decisions, evaluating test coverage, or auditing DevSecOps practices. Ensures gate criteria are met before advancing between phases."
---

# Delivery Lead — Orchestrator

Guide software delivery through four phases: Discovery, Planning, Development, and Deployment. This skill ensures business requirements are captured, non-functional requirements are addressed systematically, and phase transitions happen only when gate criteria are met.

## When to Use

Activate this skill when:
- Starting a new project or major feature that needs requirements gathering
- Building or refining a product backlog with user stories
- Reviewing readiness to move from design to development
- Assessing whether a system is ready for production deployment
- Auditing non-functional requirements across the delivery lifecycle

## Phase Model

```
┌─────────────────┐       ┌─────────────────┐       ┌─────────────────┐       ┌─────────────────┐
│  Phase 0        │──────▶│  Phase 1        │──────▶│  Phase 2        │──────▶│  Phase 3        │
│  DISCOVERY &    │ Gate  │  PLANNING &     │ Gate  │  DEVELOPMENT &  │ Gate  │  DEPLOYMENT &   │
│  REQUIREMENTS   │   0   │  DESIGN         │   1   │  QUALITY        │   2   │  OPERATIONS     │
└─────────────────┘       └─────────────────┘       └─────────────────┘       └─────────────────┘
```

## How to Assess Current Phase

1. **Check for business requirements & backlog** — If missing or no user stories → Phase 0
2. **Check for architecture documentation** — If requirements exist but no architecture decisions → Phase 1
3. **Check for working code with tests** — If architecture exists but coverage/quality gaps → Phase 2
4. **Check for deployment readiness** — If code is solid but security/infra/CI not hardened → Phase 3

## Gate Criteria

### Gate 0: Discovery → Planning

All of the following must be satisfied before starting architecture design:

- [ ] Business requirements documented and stakeholder-approved
- [ ] User personas defined
- [ ] Product backlog exists with prioritized user stories
- [ ] Acceptance criteria defined for all Must-Have stories
- [ ] MVP scope agreed and documented
- [ ] Non-functional requirements captured (performance, security, compliance, scalability)
- [ ] Iteration cadence decided (sprint length, ceremonies)
- [ ] Definition of Done and Definition of Ready agreed by team

### Gate 1: Planning → Development

All of the following must be satisfied before starting development:

- [ ] Bounded contexts and service boundaries documented
- [ ] FE-BE-DB layering decided and diagrammed
- [ ] API strategy chosen (REST, GraphQL, or hybrid) with contracts defined
- [ ] Communication patterns decided (sync vs. async, message queue selection if applicable)
- [ ] Data architecture decided (DB-per-service vs. shared, consistency model)
- [ ] Environment strategy defined (Dev, UAT, Staging, Prod — what differs)
- [ ] Infrastructure as Code approach selected
- [ ] ADRs written for all significant architectural decisions
- [ ] Scalability approach documented (stateless services, caching, queue-based load leveling)

### Gate 2: Development → Deployment

All of the following must be satisfied before deploying:

- [ ] Unit test coverage meets threshold (90% overall, 100% domain logic)
- [ ] Property-based tests cover critical invariants
- [ ] Integration tests pass with real dependencies (DB, auth provider)
- [ ] E2E tests cover full user journeys per role
- [ ] Performance/load test baseline established
- [ ] Documentation is current and cross-references are accurate
- [ ] Database migrations are versioned, idempotent, and rollback-safe
- [ ] No critical or high security findings open

### Gate 3: Deployment → Production

All of the following must be satisfied before going live:

- [ ] OWASP Top 10 audit passed
- [ ] Security headers enforced (CSP, HSTS, X-Frame-Options, nosniff)
- [ ] Rate limiting configured on public endpoints
- [ ] PII encrypted at rest, TLS enforced in transit
- [ ] Secrets rotated and rotation procedure documented
- [ ] CI/CD pipeline complete (Lint → Test → Integration → E2E → Deploy)
- [ ] Branch protection and deployment approvals enabled for Prod
- [ ] Container images scanned, minimal base images used
- [ ] Incident response runbooks written
- [ ] Production hardening checklist completed

## Phase Details

Each phase has its own detailed guide:

- **Phase 0**: See `discovery.md` — Business requirements, user stories, backlog, iteration planning
- **Phase 1**: See `planning.md` — Architecture, DDD, API design, messaging, environment strategy
- **Phase 2**: See `development.md` — Service components, testing pyramid, documentation maintenance
- **Phase 3**: See `deployment.md` — DevSecOps, CI/CD, TLS, secrets, production hardening

## Workflow

When invoked:

1. Determine which phase the project is currently in (use the assessment criteria above)
2. Read the corresponding phase file for detailed guidance
3. Evaluate gate criteria for the current phase
4. Report what's done, what's missing, and what to do next
5. When all gate criteria for the current phase are met, recommend advancing to the next phase

## Iteration Across Phases

Phases are not strictly waterfall — expect iteration:

- **Phase 0 ↔ Phase 1**: Requirements may surface new NFRs that change architecture decisions
- **Phase 1 ↔ Phase 2**: Technical spikes during development may reveal design flaws
- **Phase 2 ↔ Phase 0**: Sprint reviews generate new stories that go back into the backlog
- **Phase 3 → Phase 0**: Production incidents may reveal missing requirements

The backlog is continuously refined throughout all phases. New stories are added, priorities shift, and the product evolves based on feedback.
