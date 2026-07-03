# Phase 4: Testing, Training & Maintenance

A plan that has never been tested is a hypothesis, not a capability. This phase is where the BCP and DR Plan either prove they work or reveal the gaps that Phase 1-3 assumptions missed.

## Exercise Types

Increasing in realism and cost — most programs progress through these over time rather than starting at full-scale:

| Type | Description | Good for |
|---|---|---|
| Tabletop | Discussion-based walkthrough of a scenario, no systems touched | Validating roles, communication plan, and decision logic cheaply |
| Walkthrough | Step-by-step review of the actual plan document with the people who'd execute it | Catching missing/outdated steps before a live test |
| Simulation | Realistic scenario run in a test environment, systems involved but production untouched | Validating technical DR procedures without production risk |
| Full interruption test | Actual failover of production systems/processes | Ground-truth validation of RTO/RPO — highest cost and risk, use deliberately |

A first exercise for a newly written plan should be at minimum a tabletop — don't jump straight to a full interruption test on an unvalidated plan.

## Running a Tabletop (Minimum Bar)

* Pick a plausible scenario from the Phase 2 threat assessment, not a generic "the building burns down" if that's not actually the top risk
* Walk the Crisis Management Team through their roles as the scenario unfolds — ask "what do you do now" at each stage rather than reading the plan aloud
* Note every point where someone hesitates, doesn't know a step, or the plan's instructions don't match reality — these are findings, not failures of the exercise itself

## Finding Tracking

* Every exercise finding needs a named owner and a due date — an ungoverned list of "things we noticed" doesn't fix anything
* Findings that reveal a BIA assumption was wrong (e.g., actual manual recovery takes much longer than the RTO assumed) should trigger a note back to Phase 1, not just a plan-document edit — the register itself may need updating
* Track to closure; re-verify fixed findings in the next exercise rather than assuming a documented fix actually works

## Ongoing Test Cadence

* Define how often each exercise type runs (e.g., tabletop annually for all Tier 1/2 processes, full interruption test every 2-3 years for Tier 1 systems, more frequently if the risk or regulatory context demands it)
* Vary scenarios across cycles — repeating the same scenario every year stops finding new gaps once the team has memorized the response

## Plan Maintenance

* Define a baseline review cadence (commonly annual) independent of any exercise
* Define **change triggers** that require an out-of-cycle review regardless of the annual schedule:
  * A new critical system or process goes live
  * A merger, acquisition, or org restructure changes ownership or scope
  * A facility change (new office, data center migration, vendor change)
  * A prior exercise or real incident revealed a significant gap
* An out-of-date plan that technically exists is a false sense of security — flag staleness against these triggers explicitly, not just against the calendar date

## Training & Awareness

* Crisis Management Team: role-specific training, not just having read the document — they should be able to execute their role from memory under pressure
* General staff: lighter-weight awareness (how to receive notifications, where to find guidance, who to contact) — most staff don't need the full plan, just to know it exists and how they'll be informed

## Deliverables (Exit Criteria for Phase 4)

- [ ] At least one exercise conducted (tabletop minimum) validating plan assumptions
- [ ] Findings documented with named owners and due dates, tracked to closure
- [ ] Ongoing test cadence and exercise types defined
- [ ] Plan maintenance/review cadence defined
- [ ] Change triggers defined for out-of-cycle reviews
- [ ] Training/awareness plan defined for Crisis Management Team and general staff
