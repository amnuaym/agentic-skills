# Phase 1: Business Impact Analysis (BIA)

This is the core of the skill. A BIA is only as good as the specific answers gathered from the people who run each process. Interview one process at a time, in small question batches, and push back on vague answers until they're concrete enough to plan against.

## How to Run the Interview

* Work through the Question Bank below **3-5 questions per turn**, per process — not the whole bank at once. A process owner asked forty questions in one message will give shallow, rushed answers.
* Restate what you heard before moving to the next batch, so the owner can correct misunderstandings early rather than after the register is written.
* When an answer is vague ("it's pretty important," "we'd need it back fast"), ask a follow-up that forces a number or a concrete scenario rather than accepting the vague version into the register.
* One process owner may own several processes — repeat the cycle per process, don't average across them.

## Question Bank

### Business Process / Function

* What does this process actually do, in one or two sentences? Who are its customers — internal, external, or both?
* What triggers it — is it scheduled (daily/monthly/quarterly), event-driven, or continuous?
* Are there peak periods where disruption would be worse (month-end close, tax season, a sales event, open enrollment)? When?
* Who is the process owner, and who is the backup if that person is unavailable?

### Applications & Technology

* What systems/applications does this process depend on to run normally?
* For each system: is it hosted internally or by a third-party/SaaS vendor? Who's the technical owner?
* Is there a manual fallback if the system is unavailable, or does the process stop entirely?

### Dependencies

* What upstream processes or systems does this depend on (things that must work before this can run)?
* What downstream processes or teams depend on this one?
* What third parties or vendors are involved, and what happens if a given vendor is unreachable?
* Is there a single point of failure here — one person, one system, one vendor, or one facility that this entirely hinges on?

### People

* If systems were down, how many people, with what skills or access, would be needed to run this manually?
* Is there a trained backup for each critical role, or does knowledge sit with one person?
* Does running this manually require access/credentials that aren't provisioned to backup staff today?

### Facilities

* Which physical location(s) does this process run from?
* Could it run fully remote if the primary site were unavailable?
* Is there anything only available at one physical site — paper records, specialized equipment, a badge-access-only room — that would block recovery elsewhere?

### Impact Over Time

Ask this as a progression, not a single question — the answer at 4 hours is often very different from the answer at 1 week:

* What happens if this is down for **4 hours**? For **24 hours**? For **72 hours**? For **1 week**?
* At each interval, what's the impact across: financial (revenue loss, penalty costs), operational (what else breaks or backs up), legal/regulatory (any reporting deadline or compliance obligation missed), reputational (customer-visible, press-visible)?
* At what point does the impact become irreversible or existential for the business, as opposed to painful but recoverable?

### Recovery Targets

* Given the impact curve above, what Recovery Time Objective (RTO) is actually being requested? Push back if it doesn't match the impact curve (e.g., a process with mild impact even at 72 hours doesn't need a 1-hour RTO).
* What Recovery Point Objective (RPO) — how much data loss, measured in time, is tolerable? (RPO of 1 hour means backups/replication must not lose more than 1 hour of data.)
* Does the requested RTO reflect what the organization will actually fund, or is it an aspirational number nobody has costed? Flag the gap explicitly rather than recording an unfunded target as if it were agreed.

## Criticality Tiering

Rank every process using the impact-over-time answers, not a subjective label:

| Tier | Definition | Typical RTO range |
|---|---|---|
| Tier 1 — Critical | Severe impact within hours; legal, safety, or existential exposure | Minutes to a few hours |
| Tier 2 — Essential | Significant impact within 1-3 days | Hours to 1-2 days |
| Tier 3 — Important | Manageable impact for up to a week | Days |
| Tier 4 — Deferrable | Minimal impact even after a week | Best-effort |

## BIA Register Template

```text
| Process | Owner | Tier | RTO | RPO | MTPD | Supporting Systems | Key Dependencies | Peak Periods |
|---|---|---|---|---|---|---|---|---|
```

**MTPD (Maximum Tolerable Period of Disruption)** is the absolute ceiling — the point past which recovery no longer matters because the damage is done. RTO should always be set comfortably inside MTPD, never equal to or beyond it.

## Dependency Mapping

* For each Tier 1/2 process, diagram or list the full chain: process → supporting systems → those systems' own dependencies (data stores, network, identity/auth, third-party APIs) → people → facilities
* Mark single points of failure explicitly wherever the chain has no redundancy
* Cross-check for shared dependencies across multiple "critical" processes — a single vendor or system that underpins several Tier 1 processes is a bigger risk than its presence in any one process's chain suggests

## Deliverables (Exit Criteria for Phase 1)

- [ ] Critical processes inventoried across all in-scope units
- [ ] Each process mapped to systems, data, people, facilities, and vendor dependencies
- [ ] Impact-over-time assessed across financial/operational/legal/reputational dimensions
- [ ] RTO and RPO set per process/system
- [ ] MTPD determined per process
- [ ] Criticality tiers assigned
- [ ] Dependency map completed with single points of failure marked
