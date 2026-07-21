# Phase 0: Threat Modeling & Security Requirements

Every downstream phase depends on this one. Skipping it leads to controls chosen by habit or fashion ("everyone encrypts everything now") rather than controls chosen because a specific threat, against a specific asset, was actually identified.

## Actors & Trust Boundaries

* Identify every distinct actor type that interacts with the system: external end users, internal staff, administrators, service-to-service callers, third-party integrations/vendors
* Draw trust boundaries — the points where data or control crosses from one actor's control to another's (e.g., internet → application, application → database, application → third-party API)
* Each trust boundary is where a threat actor could plausibly interfere; boundaries with no meaningful separation (e.g., an internal service calling another with no authentication at all) are worth flagging even before formal threat modeling starts

## Data Classification

Classify data by sensitivity before deciding any control — the classification drives every later encryption, access, and retention decision:

| Tier | Definition | Example |
|---|---|---|
| Public | No harm if disclosed | Marketing site content |
| Internal | Some harm if disclosed outside the org | Internal roadmaps, non-sensitive business metrics |
| Confidential | Meaningful harm to the business or individuals if disclosed | Customer contracts, employee records |
| Restricted/Regulated | Legal, safety, or severe harm if disclosed; often has a named regulation attached | PII, PHI, PCI cardholder data, credentials |

If a Restricted/Regulated tier is identified, flag it as a likely trigger for `compliance-officer` — this skill still designs the mechanism, but the specific regulation may set requirements (retention periods, specific control families) that should be checked there.

## Threat Modeling (STRIDE or Equivalent)

For each trust boundary and significant data flow, walk through:

* **S**poofing — can an actor convincingly pretend to be someone/something else?
* **T**ampering — can data or code be modified without authorization, in transit or at rest?
* **R**epudiation — can an actor deny having performed an action, with no way to prove otherwise?
* **I**nformation Disclosure — can data be exposed to someone who shouldn't see it?
* **D**enial of Service — can the system or a component be made unavailable?
* **E**levation of Privilege — can an actor gain access or capability beyond what they were granted?

Don't run the full STRIDE checklist generically against everything — apply it at each identified trust boundary and ask which of the six actually apply there, given the actors and data involved.

## Abuse & Misuse Cases

* Alongside the normal use cases (what the system is meant to do), define abuse cases — what a malicious or careless actor could do with the same access
* Ask specifically: what would an insider with legitimate but excessive access do? What would happen if a single credential were compromised? What's the blast radius?

## Security NFR Baseline

Turn the threat model into concrete, checkable statements, not vague goals:

```text
Bad:  "The system should be secure."
Good: "All administrative actions must be attributable to a named individual account,
       never a shared credential."
Good: "Customer PII must be encrypted at rest and unreadable to anyone without an
       explicit, logged access grant."
```

These statements become the requirements Phases 1-3 are designed against.

## Risk Acceptance Process

* Not every identified threat gets a control immediately — some risks are accepted as a business decision
* Define who has the authority to accept a residual risk (and at what severity) versus who must escalate it further (security lead, executive sponsor, in some cases a board-level risk committee for severe/regulated risk)
* Record accepted risks explicitly rather than letting them disappear silently — an accepted risk that's forgotten stops being a decision and becomes an unmanaged gap

## Deliverables (Exit Criteria for Phase 0)

- [ ] Actors and trust boundaries identified and diagrammed
- [ ] Data classified by sensitivity, including regulated categories
- [ ] Threat model completed per trust boundary/data flow
- [ ] Abuse/misuse cases considered alongside normal use cases
- [ ] Security NFR baseline documented as concrete, checkable statements
- [ ] Risk acceptance process defined with named authority levels
