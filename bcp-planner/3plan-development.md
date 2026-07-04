# Phase 3: Plan Development (BCP & DR Plan)

This phase writes the two documents down. Keep them distinct: the **BCP** is how the business keeps operating — people, process, communication, alternate ways of working. The **DR Plan** is how the technology comes back — systems, data, infrastructure, in the priority order the BIA established. A request that blends the two into one document usually loses the thing that makes each useful: the BCP needs to be readable by non-technical crisis-team members mid-disruption, and the DR Plan needs to be precise enough for an engineer to execute under pressure.

## Business Continuity Plan (BCP) Template

```text
## Purpose & Scope
What this plan covers (business units, processes, sites) and what triggers its use.

## Activation Criteria & Authority
What event(s) trigger activation, and who has the authority to declare it.

## Crisis Management Team
Roles (not just names — roles survive personnel turnover): Incident Lead, Communications Lead,
Operations Lead, IT Liaison, HR/People Lead. Named individual + backup per role.

## Communication Plan
Call tree / notification sequence: who notifies whom, in what order, via what channel
(primary + backup, e.g. phone tree + mass notification tool). Templates for:
- Internal staff notification
- Customer/external notification (if applicable)
- Regulatory notification (if a legal obligation applies)

## Critical Process Continuity Procedures
Per Tier 1/2 process from the BIA:
- Manual workaround (if systems are unavailable)
- Minimum staffing and skills required
- Alternate location or remote-work procedure
- Point at which the workaround itself becomes unsustainable (ties back to MTPD)

## Alternate Site / Remote Work Procedures
How staff access systems and records if the primary site is unavailable; equipment,
access, and connectivity assumptions.

## Plan Owner & Review Cadence
Who owns this document and when it's next reviewed.
```

## Disaster Recovery (DR) Plan Template

```text
## Purpose & Scope
Which systems/applications this plan covers.

## Recovery Priority Order
Systems in the order they must be restored, matching BIA criticality tiers —
Tier 1 systems first, with named RTO/RPO per system carried over from the BIA.

## Per-System Recovery Procedures
For each system:
- Backup/replication method and frequency (does actual RPO match the BIA target?)
- Step-by-step recovery procedure (specific enough for someone other than the
  usual owner to execute under pressure)
- Dependencies that must be recovered first (from the BIA dependency map)
- Responsible team/person + backup

## Failover / Failback Procedures
How to fail over to the recovery environment, and — separately — how to fail back
to primary once it's restored, including data reconciliation if the two diverged.

## Infrastructure Recovery Sequence
Network, identity/auth, and shared infrastructure that multiple systems depend on,
recovered in the order that unblocks the most downstream systems.

## Plan Owner & Review Cadence
Who owns this document and when it's next reviewed.
```

## Cross-Referencing the BIA

* Before either document is considered done, check every Tier 1/2/3 process and system from the Phase 1 BIA register against both plans — each one needs to appear somewhere, in the BCP if it's about people/process, in the DR Plan if it's about systems/data, or both if it spans both
* A process that was flagged critical in the BIA but has no corresponding section in either plan is a gap, not an oversight to note later — resolve it before Gate 3 passes
* Conversely, don't let scope creep in — a process that was tiered low/deferrable in the BIA doesn't need detailed manual procedures written for it now

## Review & Approval

* Circulate both documents to the named owners (Crisis Management Team roles for the BCP, system owners for the DR Plan) for review before considering them final
* Approval should be explicit and recorded, not inferred from silence

## Deliverables (Exit Criteria for Phase 3)

- [ ] BCP document written covering activation, crisis team roles, communication plan, and continuity procedures per critical process
- [ ] DR Plan document written covering recovery priority order and per-system recovery procedures
- [ ] Every critical process/system from the BIA is covered in the BCP and/or DR Plan
- [ ] Both plans reviewed and approved by named owners
