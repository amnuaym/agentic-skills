# Phase 0: Discovery & Requirements

This phase captures what needs to be built before deciding how to build it. No architecture decisions, no code — just understanding the problem space and building a prioritized backlog.

## Business Requirements Gathering

### Stakeholder Identification

- Who are the stakeholders? (Business owner, end users, operations, compliance, security, finance)
- Who has decision authority? (Product owner, sponsor)
- Who provides domain expertise? (Subject matter experts)
- Schedule discovery sessions with each stakeholder group

### Problem Statement

- What problem are we solving? (Not "what system are we building" — the actual business problem)
- Who experiences this problem? (User personas)
- What's the current workaround? (Manual process, legacy system, spreadsheets)
- **Legacy Context**: If replacing an existing system, where does the old data live? Will it need to be migrated?
- What does success look like? (Measurable outcomes, KPIs, not just features)

### Requirements Elicitation

- **Interviews**: 1-on-1 with stakeholders, open-ended questions
- **Workshops**: Group sessions to align on priorities and resolve conflicts
- **Observation**: Watch users perform current workflows (if replacing an existing system)
- **Document analysis**: Review existing specs, regulations, contracts, SLAs

### Non-Functional Requirements Capture

Capture these early — they drive architecture decisions in Phase 1:

| Category | Questions to Ask |
|---|---|
| Performance | Expected concurrent users? Acceptable response time? Peak load? |
| Scalability | Growth projections? Seasonal spikes? |
| Availability | Required uptime (99.9%? 99.99%)? Maintenance windows acceptable? |
| Security | Compliance requirements (GDPR, PCI-DSS, SOX)? Data classification? |
| **Privacy** | Are we capturing Personally Identifiable Information (PII)? Do we need a Data Privacy Impact Assessment (DPIA)? |
| Data | Retention requirements? Backup/recovery targets (RPO/RTO)? |
| Integration | External systems to connect? APIs to consume or expose? |

## Product Backlog Creation

### User Story Format

```text
As a [role/persona],
I want [capability/action],
So that [business value/benefit].
```

### Acceptance Criteria

Each story must have acceptance criteria written as:

```text
Given [precondition/context],
When [action/trigger],
Then [expected outcome].
```

## Backlog Prioritization (MoSCoW & RICE)

- **Must have**: System doesn't work without it (MVP)
- **Should have**: Important but not critical for launch
- **Could have**: Nice to have, include if time allows
- **Won't have (this time)**: Explicitly out of scope for this release

### MVP Definition

- List all Must-Have stories — this is your MVP
- Validate: Can a user complete the core workflow end-to-end with just these stories?

## Iteration Planning & Definitions

### Definition of Done (DoD)

A story is "done" when ALL of the following are true:
- Code written, peer-reviewed, and tested (Unit/Integration)
- Acceptance criteria verified (manually or via E2E test)
- Documentation updated
- Deployed to Dev environment and smoke-tested

### Definition of Ready (DoR)

A story is "ready" for development when:
- User story clearly written with Acceptance Criteria
- Dependencies identified and resolved
- Estimated by the team and fits within one sprint

## Deliverables (Exit Criteria for Phase 0)
- [ ] Business requirements documented and stakeholder-approved
- [ ] User personas defined
- [ ] Product backlog created with prioritized user stories
- [ ] Acceptance criteria defined for all Must-Have stories
- [ ] MVP scope agreed and documented
- [ ] Non-functional requirements captured (including PII/Privacy triggers)
- [ ] First sprint backlog ready
