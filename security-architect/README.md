# Security Architect

Designs the cross-cutting security mechanisms a product needs — authentication/authorization, user provisioning/deprovisioning, encryption and secrets management, and audit logging — through five gated phases. Fills the gap between `product-owner` (functional/business framing), `sre-engineer` (operational logging), and `compliance-officer` (regulatory gap-assessment on trigger only): none of those own the upfront design of these security NFRs.

## When to use

* Designing authentication or authorization (RBAC/ABAC) models
* Defining user provisioning, deprovisioning, or access recertification
* Planning encryption at rest/in transit, key management, or secrets management
* Designing audit logging — what security-relevant events must be captured, and how the log is protected from tampering
* Running a threat model for a new system, feature, or trust boundary
* Designing privileged access procedures (break-glass, just-in-time elevation)
* Conducting a security architecture review ahead of a build or go-live decision

## Structure

A 5-phase gate model (Phase 0 → Phase 4). Every control must trace back to a named threat — no "add MFA everywhere" without a reason. See `SKILL.md` for full gate criteria and the Division of Labor with `compliance-officer`/`sre-engineer`/`ux-designer`.

## Files

| File | Contents |
|---|---|
| `SKILL.md` | Phase model, folder structure, gate criteria, division of labor with other skills, agent workflow rules |
| `0threat-modeling.md` | Phase 0 detail — actors, trust boundaries, data classification, STRIDE threat modeling, security NFR baseline |
| `1identity-access-management.md` | Phase 1 detail — authentication methods, authorization models, provisioning/deprovisioning, privileged access |
| `2data-protection-secrets.md` | Phase 2 detail — encryption at rest/in transit, key management, secrets management |
| `3audit-logging.md` | Phase 3 detail — audit event taxonomy, required fields, tamper-evidence, retention |
| `4review-maintenance.md` | Phase 4 detail — architecture review against the threat model, ADRs, pen testing, re-threat-modeling triggers |
| `evals/evals.json` | Behavioral test prompts/assertions for this skill |

## Works well with

`compliance-officer` (checks this skill's output against a *named* regulation, on trigger only), `sre-engineer` (carries the operational logging pipeline that audit events flow through), `ux-designer` (checks the resulting login/access flows are usable). Works fully standalone too.
