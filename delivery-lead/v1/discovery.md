# Phase 0: Discovery & Requirements

This phase captures what needs to be built before deciding how to build it. No architecture decisions, no code — just understanding the problem space and building a prioritized backlog.

## Business Requirements Gathering

### Stakeholder Identification

- Who are the stakeholders? (Business owner, end users, operations, compliance, security)
- Who has decision authority? (Product owner, sponsor)
- Who provides domain expertise? (Subject matter experts)
- Schedule discovery sessions with each stakeholder group

### Problem Statement

- What problem are we solving? (Not "what system are we building" — the actual business problem)
- Who experiences this problem? (User personas)
- What's the current workaround? (Manual process, legacy system, spreadsheets)
- What does success look like? (Measurable outcomes, not features)

### Requirements Elicitation

- **Interviews**: 1-on-1 with stakeholders, open-ended questions
- **Workshops**: Group sessions to align on priorities and resolve conflicts
- **Observation**: Watch users perform current workflows (if replacing an existing system)
- **Document analysis**: Review existing specs, regulations, contracts, SLAs

### Requirements Documentation

Structure each business requirement as:

```
Requirement ID: BR-001
Title: [Short descriptive title]
Description: [What the system must do]
Rationale: [Why this is needed — business justification]
Source: [Who requested it]
Priority: [Must/Should/Could/Won't]
Acceptance Criteria: [How we know it's done]
Constraints: [Regulatory, technical, timeline]
```

### Non-Functional Requirements Capture

Capture these early — they drive architecture decisions in Phase 1:

| Category | Questions to Ask |
|---|---|
| Performance | Expected concurrent users? Acceptable response time? Peak load? |
| Scalability | Growth projections? Seasonal spikes? |
| Availability | Required uptime (99.9%? 99.99%)? Maintenance windows acceptable? |
| Security | Compliance requirements (GDPR, PCI-DSS, SOX)? Data classification? |
| Data | Retention requirements? Backup/recovery targets (RPO/RTO)? |
| Integration | External systems to connect? APIs to consume or expose? |
| Localization | Multi-language? Multi-timezone? Multi-currency? |

## Product Backlog Creation

### From Requirements to Epics

- Group related requirements into epics (large bodies of work)
- Each epic represents a capability or workflow (e.g., "Policy Lifecycle", "Claims Processing")
- Epics are too large to implement in one iteration — they break down into stories

### User Story Format

```
As a [role/persona],
I want [capability/action],
So that [business value/benefit].
```

**Good stories are INVEST:**
- **I**ndependent: Can be developed without depending on another story
- **N**egotiable: Details can be discussed, not a rigid contract
- **V**aluable: Delivers value to the user or business
- **E**stimable: Team can estimate the effort
- **S**mall: Fits within one iteration
- **T**estable: Has clear acceptance criteria

### Acceptance Criteria

Each story must have acceptance criteria written as:

```
Given [precondition/context],
When [action/trigger],
Then [expected outcome].
```

Example:
```
Given I am logged in as an underwriter,
When I approve a submission that passes all risk checks,
Then a new policy is created with status ACTIVE
And the applicant receives a confirmation notification.
```

### Story Splitting Techniques

When a story is too large:
- **By workflow step**: Split a multi-step process into one story per step
- **By role**: Different stories for different user roles
- **By data variation**: Handle the simple case first, edge cases as separate stories
- **By interface**: API first, then UI
- **By operation**: CRUD — Create, Read, Update, Delete as separate stories
- **Spike**: If uncertainty is high, create a time-boxed research spike first

## Backlog Prioritization

### Prioritization Frameworks

**MoSCoW:**
- **Must have**: System doesn't work without it (MVP)
- **Should have**: Important but not critical for launch
- **Could have**: Nice to have, include if time allows
- **Won't have (this time)**: Explicitly out of scope for this release

**RICE Score:**
- **R**each: How many users does this affect?
- **I**mpact: How much does it improve the experience? (3=massive, 2=high, 1=medium, 0.5=low, 0.25=minimal)
- **C**onfidence: How sure are we about reach and impact? (100%/80%/50%)
- **E**ffort: Person-months to implement

Score = (Reach × Impact × Confidence) / Effort

### MVP Definition

- List all Must-Have stories — this is your MVP
- Validate: Can a user complete the core workflow end-to-end with just these stories?
- If not, promote the missing stories to Must-Have
- If too large, negotiate scope with stakeholders (reduce Must-Haves, not quality)

## Iteration Planning

### Cadence

| Ceremony | Frequency | Duration | Purpose |
|---|---|---|---|
| Sprint Planning | Start of sprint | 1-2 hours | Select stories for the sprint, clarify acceptance criteria |
| Daily Standup | Daily | 15 min | Blockers, progress, coordination |
| Backlog Refinement | Mid-sprint | 1 hour | Groom upcoming stories, add acceptance criteria, estimate |
| Sprint Review | End of sprint | 1 hour | Demo completed work to stakeholders |
| Retrospective | End of sprint | 45 min | What went well, what to improve |

### Sprint Length

- 1 week: Fast feedback, good for early-stage or high-uncertainty projects
- 2 weeks: Most common, balances planning overhead with delivery cadence
- 3-4 weeks: Only for mature teams with stable requirements

### Definition of Done (DoD)

A story is "done" when ALL of the following are true:

- [ ] Code written and peer-reviewed
- [ ] Unit tests written and passing
- [ ] Integration test covering the happy path
- [ ] Acceptance criteria verified (manually or via E2E test)
- [ ] Documentation updated (if applicable)
- [ ] No critical/high bugs open
- [ ] Deployed to Dev environment and smoke-tested

### Definition of Ready (DoR)

A story is "ready" for development when:

- [ ] User story clearly written (role, action, benefit)
- [ ] Acceptance criteria defined (Given/When/Then)
- [ ] Dependencies identified and resolved (or planned)
- [ ] UX/UI mockups available (if applicable)
- [ ] Estimated by the team
- [ ] Small enough to complete in one sprint

## Backlog Iteration & Refinement

### Continuous Refinement

The backlog is a living document — not a one-time exercise:

- **Every sprint**: Refine stories for the next 1-2 sprints (add detail, split, re-prioritize)
- **Every release**: Re-evaluate priorities based on feedback, market changes, technical learnings
- **After each demo**: Incorporate stakeholder feedback into new/modified stories
- **After incidents**: Add stories for reliability improvements discovered in production

### Feedback Loops

```
Stakeholder Feedback ──▶ Backlog Update ──▶ Prioritize ──▶ Next Sprint
       ▲                                                        │
       └────────────────── Sprint Review ◀──────────────────────┘
```

### Velocity Tracking

- Track story points completed per sprint
- Use velocity to forecast: "At current pace, MVP will be done in N sprints"
- Don't game velocity — it's a planning tool, not a performance metric
- Velocity stabilizes after 3-4 sprints — don't trust early numbers

## Deliverables (Exit Criteria for Phase 0)

- [ ] Business requirements documented and stakeholder-approved
- [ ] User personas defined
- [ ] Product backlog created with prioritized user stories
- [ ] Acceptance criteria defined for all Must-Have stories
- [ ] MVP scope agreed and documented
- [ ] Non-functional requirements captured (performance, security, compliance, scalability)
- [ ] Iteration cadence decided (sprint length, ceremonies)
- [ ] Definition of Done and Definition of Ready agreed by team
- [ ] First sprint backlog ready (stories meet DoR)
