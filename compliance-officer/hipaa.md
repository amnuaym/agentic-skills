# HIPAA — Health Insurance Portability and Accountability Act (US)

HIPAA is a **binding US federal law**, not a certifiable standard — there is no official "HIPAA certified" credential for an organization or product, despite how often vendors market themselves that way. Flag this misconception explicitly whenever it comes up, the same way OWASP certification claims get corrected. Applies to **covered entities** (health plans, healthcare clearinghouses, most healthcare providers) and their **business associates** (any vendor that creates, receives, maintains, or transmits PHI on a covered entity's behalf).

## Who's Actually Covered

* Ask whether the organization is a covered entity, a business associate, or neither before assuming HIPAA applies — a health-adjacent product isn't automatically in scope if it never touches PHI on behalf of a covered entity.
* PHI = individually identifiable health information. De-identified data (per the Safe Harbor or Expert Determination method) falls outside HIPAA's scope.

## Privacy Rule

* Governs use and disclosure of PHI
* **Minimum necessary standard** — use/disclose only the minimum PHI needed for the purpose, not the full record by default
* Patient rights: access to their own records, right to request amendment, right to an accounting of disclosures, right to request restrictions

## Security Rule

Requires administrative, physical, and technical safeguards for electronic PHI (ePHI):

| Safeguard type | Examples |
|---|---|
| Administrative | Risk analysis, workforce training, access management, contingency planning |
| Physical | Facility access controls, workstation security, device/media disposal |
| Technical | Access control (unique user IDs), audit controls/logging, integrity controls, transmission security (encryption in transit) |

A HIPAA risk analysis (required, not optional) is the foundational deliverable most orgs skip — ask whether one exists before assessing anything else.

## Breach Notification Rule

* Notify affected individuals without unreasonable delay, no later than 60 days after discovery
* Breaches affecting 500+ individuals: notify HHS immediately and issue a media notice; under 500: HHS notified annually
* "Breach" has a specific definition with a risk-assessment exception (low probability of compromise) — not every incident is a reportable breach

## Business Associate Agreements (BAAs)

* Required with any vendor/subprocessor that touches PHI on the covered entity's behalf — this is the mechanism that extends HIPAA obligations down the vendor chain
* No BAA in place with a vendor handling PHI is one of the most common and most consequential gaps to check for

## Evidence Typically Required

* HIPAA risk analysis and risk management plan
* Workforce training records
* Access control and audit logging configuration for systems holding ePHI
* Business Associate Agreements with all relevant vendors
* Breach response procedure and incident log
* Encryption configuration for ePHI in transit and at rest

## Enforcement

* Enforced by HHS Office for Civil Rights (OCR), with tiered penalties based on culpability (unknowing, reasonable cause, willful neglect corrected, willful neglect not corrected)
* Penalties range from roughly $100 to $50,000+ per violation per tier, with annual caps that adjust for inflation

## Guidance for This Skill When HIPAA Is In Scope

* Confirm covered-entity/business-associate status before running a full analysis — this determines whether HIPAA applies at all
* Correct any claim of being "HIPAA certified" — no such official certification exists; the accurate framing is "HIPAA compliant" backed by a documented risk analysis and safeguards
* Ask whether a risk analysis exists before assessing anything downstream — it's the Security Rule's required starting point
* Check for BAAs with any vendor in the data flow that touches PHI
* Never assert compliance outright — state readiness/gaps against the Privacy and Security Rule requirements above and recommend legal/compliance review before external claims

## Deliverables Checklist

- [ ] Covered-entity/business-associate status determined
- [ ] HIPAA risk analysis completed and risk management plan in place
- [ ] Administrative, physical, and technical safeguards documented per the Security Rule
- [ ] Minimum necessary standard applied to PHI use/disclosure
- [ ] Business Associate Agreements in place with all relevant vendors
- [ ] Breach notification procedure defined with the correct notification timeline and thresholds
- [ ] Workforce HIPAA training completed and recorded
