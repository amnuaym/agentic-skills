# Phase 3: Audit & Security Logging

An audit log answers one question: who did what, to what, when, from where, and did it succeed — for accountability, forensics, and (often) regulatory evidence. This is a different purpose from operational logging (which exists to debug and monitor system behavior), and the two should be designed and protected differently even if they sometimes share underlying infrastructure.

## Audit Logging vs. Operational Logging

| | Audit logging | Operational logging (see `sre-engineer`) |
|---|---|---|
| Purpose | Accountability, forensics, compliance evidence | Debugging, reliability, performance monitoring |
| Audience | Security team, auditors, investigators | Engineers, on-call responders |
| Protection | Tamper-evident, restricted even from most admins | Standard operational access controls |
| Retention driver | Regulatory/legal requirement, incident investigation window | Debugging usefulness, cost |

Don't let these collapse into one undifferentiated stream — an audit event buried in verbose debug logs is effectively unfindable, and operational logs with lighter access control shouldn't be where accountability-critical events live.

## Audit Event Taxonomy

At minimum, capture:

* **Authentication events** — login success, login failure, account lockout, password reset, MFA enrollment/change
* **Authorization decisions** — especially denials (an access attempt that was blocked is often more security-relevant than one that succeeded)
* **Administrative/configuration changes** — role/permission changes, security setting changes, feature flag changes affecting access control
* **Access to sensitive/regulated data** — who viewed or exported data classified as Confidential or Restricted in Phase 0, not just who modified it
* **Privileged actions** — anything performed via break-glass access or elevated/just-in-time privilege from Phase 1
* **Security-relevant lifecycle events** — key rotation, secret rotation, certificate renewal, security tool configuration changes

Scope this to what the Phase 0 threat model and security NFR baseline actually call for — an exhaustive log of every field read across the entire application is not more secure, just harder to search when it matters.

## Required Fields Per Event

Every audit event should answer, at minimum:

```text
Who:      actor identity (a real, attributable identity -- never "system" or a shared account)
When:     timestamp (consistent time zone/format across the whole system)
What:     the action taken
On what:  the specific resource/target affected
From where: source IP/device/session context
Outcome:  success or failure, and why, for failures
```

An audit entry missing the "who" field in a way that's traceable to a real individual defeats the purpose of the log — flag this as a hard gap, not a minor formatting issue.

## Tamper-Evidence

* Write audit events to an append-only or write-once store, or use hash-chaining so any retroactive alteration is detectable
* Prefer a dedicated audit logging service or sink separate from stores the application itself can freely write/delete from — if the same credentials that can perform an action can also erase the record of having performed it, the control is circular and doesn't actually provide accountability
* Access to alter or delete audit records should be restricted to a very small, explicitly named set of people (or nobody at all, if the store is genuinely append-only) — this includes most administrators, not just ordinary users

## Access Control on the Audit Log Itself

* Reading the audit log is itself a sensitive action (it may reveal who accessed what, which can itself be confidential) — define who can read it, separate from who generates entries in it
* Log this access too, where feasible — access to the audit log is exactly the kind of privileged action Phase 1's audit taxonomy should already require capturing

## Retention

* Set retention per the security NFR baseline and any applicable regulation — check `compliance-officer`'s relevant reference file when a named regulation sets a specific floor (e.g. financial records, healthcare access logs)
* Retention for audit logs is often longer than for operational logs, since forensic investigations can look back much further than a typical debugging window

## Correlation with Operational Logging

* Use a shared trace/correlation ID so a security event can be cross-referenced with the operational context around it (what else was happening in the system at that moment) without merging the two streams
* `sre-engineer`'s observability infrastructure can carry both types of events through the same pipeline, but keep them logically distinct with different retention and access-control profiles

## Deliverables (Exit Criteria for Phase 3)

- [ ] Audit event taxonomy defined, scoped to the Phase 0 threat model and NFR baseline
- [ ] Required fields (actor, timestamp, action, target, source, outcome) defined per event
- [ ] Tamper-evidence mechanism defined for the audit log store
- [ ] Access to alter/delete the audit log restricted to a small, explicitly named set (or genuinely append-only)
- [ ] Access to read the audit log defined and itself treated as a sensitive, logged action
- [ ] Retention period set, consistent with applicable regulatory requirements
- [ ] Correlation with operational logging defined via shared trace/correlation ID, without conflating the two streams
