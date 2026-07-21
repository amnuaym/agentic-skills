# Delivery Lead

Guides software delivery through five gated phases — Discovery, Planning, Development, Deployment, and Hypercare — ensuring business requirements, non-functional requirements (security, FinOps, compliance), and phase-transition gate criteria are all satisfied before advancing.

## When to use

* Starting a new project or major feature that needs requirements gathering
* Building or refining a product backlog with user stories
* Reviewing readiness to move from design to development, or from development to production
* Conducting post-launch value realization and BAU handover
* Auditing non-functional requirements across the delivery lifecycle

## Structure

A 5-phase gate model (Phase 0 → Phase 4). Each phase has explicit entry/exit gate criteria checked against file evidence in a standard `/docs`, `/src`, `/tests`, `/infra`, `/scripts` folder structure — see `SKILL.md` for the full model.

## Files

| File | Contents |
|---|---|
| `SKILL.md` | Phase model, folder structure, gate criteria, agent workflow rules |
| `0discovery.md` | Phase 0 detail — business requirements, personas, backlog, MoSCoW prioritization, DoD/DoR |
| `1planning.md` | Phase 1 detail — architecture, API strategy, ADRs, SRE/security/FinOps/data-migration planning |
| `2development.md` | Phase 2 detail — service components, testing pyramid, migration dry-runs, IaC tagging |
| `3deployment.md` | Phase 3 detail — DevSecOps, CI/CD, production hardening, cutover, compliance sign-off |
| `4hypercare.md` | Phase 4 detail — value realization, support transition, post-implementation review |

## Works well with

`test-lead` (its Gate 2 evidence satisfies this skill's Phase 2 testing gate), `product-owner` (its outputs satisfy Phase 0's discovery gate), and `sre-engineer`/`security-architect` (their outputs satisfy the SRE/Security line items in Phase 1-3 gates). None of these are required — this skill works standalone too.
