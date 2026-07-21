# Phase 4: Security Architecture Review & Maintenance

A security architecture that was correct on the day it was designed doesn't stay correct on its own — this phase closes the loop back to the Phase 0 threat model and keeps the design honest as the system changes.

## Architecture Review Against the Threat Model

* Walk every threat identified in Phase 0 and confirm it has a corresponding control somewhere in the Phase 1-3 design — an unaddressed threat found here should block sign-off, not just get noted for later
* Walk it the other direction too: every significant control should trace back to a threat or an explicit security NFR — a control with no traceable justification is either redundant effort or a sign a threat was identified informally but never properly documented in Phase 0
* This review works best as a second set of eyes — someone who wasn't the original designer is more likely to spot a gap the designer has become blind to

## Architecture Decision Records (ADRs)

* Document major security decisions with the reasoning behind them, not just the outcome: what was decided, what alternatives were considered, why this one was chosen, what trade-off was accepted
* ADRs matter most for decisions that will look arbitrary in hindsight without the context (e.g., "why RBAC and not ABAC," "why this key rotation interval and not shorter") — capture the reasoning while it's fresh, not months later when someone asks and nobody remembers

## Independent Validation

* Schedule a penetration test or independent security code review scoped to the system's actual trust boundaries and highest-risk areas from the threat model, not a generic checklist scan
* This skill's own assessment is not a substitute for independent validation — state this explicitly whenever a review is presented as complete without one, the same way `compliance-officer` never lets a self-assessment stand in for a qualified external reviewer's sign-off

## Re-Threat-Modeling Triggers

Define conditions that require revisiting Phase 0 outside the normal review cycle, rather than waiting for a scheduled annual review:

* A new trust boundary is introduced (new integration, new external-facing API, new third-party dependency)
* A new data type or classification tier enters the system (e.g., the product starts collecting health data for the first time)
* A significant security incident occurs, regardless of whether it was successfully contained
* A major architecture change alters an existing trust boundary (e.g., moving from a single-tenant to multi-tenant model)

An architecture that's technically still "reviewed" per the calendar but hasn't been re-examined after one of these triggers is a gap worth naming explicitly.

## Ongoing Maintenance Enforcement

* Confirm access recertification (Phase 1), key rotation, and secret rotation (Phase 2) are actually happening on their defined cadence, not just documented as a policy — ask for evidence of the last cycle, not just the existence of the policy document
* Track findings from any exercise, review, or incident to closure with named owners and due dates, the same discipline `sre-engineer` and `bcp-planner` apply to their own findings

## Sign-Off

* Formal sign-off from a named security lead/architect is the actual gate — a plan that's been reviewed informally in conversation but never formally approved is not yet a Gate 4 pass
* Record the sign-off, the date, and what was approved, so a later audit or incident review can confirm what was actually agreed to at the time

## Deliverables (Exit Criteria for Phase 4)

- [ ] Architecture reviewed against the Phase 0 threat model in both directions (every threat has a control; every control traces to a threat)
- [ ] ADRs written for major security decisions
- [ ] Penetration test or independent security code review scheduled and scoped
- [ ] Re-threat-modeling triggers defined
- [ ] Access recertification, key rotation, and secret rotation confirmed as actually enforced, with evidence
- [ ] Formal sign-off recorded from a named security lead/architect
