# Phase 1: Identity & Access Management (IAM)

This phase decides who can prove they are who they claim to be, and what they're allowed to do once they have. Both halves matter independently — strong authentication with sloppy authorization still leaves an over-privileged account able to do damage, and tight authorization behind weak authentication is only as strong as the login itself.

## Authentication

Select methods per actor type — a single approach rarely fits humans, admins, and machines equally well:

* **Human users** — password + MFA at minimum for anything beyond public/low-sensitivity access; consider SSO (OIDC/SAML) if the organization already has an identity provider, both for security consistency and to avoid yet another password
* **Administrators/privileged users** — MFA should be mandatory, not optional, given the elevated blast radius of a compromised admin account
* **Service-to-service/machine identities** — API keys, mTLS, or workload identity (cloud-native short-lived credentials) rather than long-lived shared secrets

## Session Management

* Define session timeout appropriate to sensitivity (shorter for admin sessions than for a low-sensitivity read-only view)
* Decide how concurrent sessions are handled (allowed, limited, or single-session-only, depending on the risk profile)
* Session tokens/cookies use secure attributes (HttpOnly, Secure, appropriate SameSite) and are invalidated on logout and password change, not just left to expire naturally

## Authorization Model

* Choose RBAC (role-based) or ABAC (attribute-based) — RBAC is simpler and sufficient for most applications; ABAC suits cases where access depends on dynamic attributes (e.g., "a manager can approve requests only for their own direct reports")
* Default to least privilege — a new role starts with nothing and gains only what's justified, rather than starting broad and trying to narrow later
* Map roles to actual job functions observed in the organization, not generic tiers like "user/admin" that force unrelated permissions into the same bucket
* Enforce separation of duties for sensitive actions identified in the Phase 0 threat model — the person who can initiate a sensitive action (e.g., a payment, a permission grant) should not also be the sole approver of the same action

## User Provisioning & Deprovisioning

* Define who approves a new account request and what evidence justifies the requested access level
* Define deprovisioning with an explicit SLA — how quickly access is actually revoked after termination or role change (a common, high-impact gap: an account still active weeks after someone left)
* Automate provisioning/deprovisioning where possible, tied to an authoritative source (HR system, identity provider) rather than relying on someone remembering to file a ticket

## Access Recertification

* Define a periodic cadence (e.g., quarterly for privileged access, annually for standard access) where each person's access is reviewed and reconfirmed as still necessary
* Recertification should be an active decision by the resource/role owner, not a rubber-stamp — flag "recertified" processes where the owner has never actually revoked anything as a sign the review isn't functioning

## Privileged Access Management

* Define a break-glass procedure for emergency access outside normal workflows — who can invoke it, what's logged when they do, and who reviews the usage afterward
* Consider just-in-time elevation (temporary, time-boxed privilege grants) over standing admin access wherever the workflow allows it
* Require an approval step for genuinely high-risk admin actions (e.g., a second approver for a production data deletion) rather than a single administrator having unilateral capability

## Service Accounts & Machine Identities

* Give service accounts their own lifecycle, distinct from human accounts — they shouldn't be provisioned/deprovisioned by the same ad hoc process as a person joining or leaving
* No shared credentials across multiple services or environments — each service identity should be individually attributable and independently revocable
* Rotate service credentials on a defined schedule, not "whenever someone remembers"

## Deliverables (Exit Criteria for Phase 1)

- [ ] Authentication method(s) selected per actor type
- [ ] Session management rules defined (timeout, concurrency, secure token attributes)
- [ ] Authorization model chosen (RBAC/ABAC) with least privilege as default
- [ ] Roles mapped to real job functions, with separation of duties for sensitive actions
- [ ] Provisioning process and deprovisioning SLA defined
- [ ] Access recertification cadence defined
- [ ] Privileged access procedure defined (break-glass, JIT elevation, approval workflow)
- [ ] Service account/machine identity lifecycle defined distinctly from human accounts
