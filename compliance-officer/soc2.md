# SOC 2 — AICPA System and Organization Controls Report

SOC 2 is not a regulation, and not an ISO-style certification either — it's an **attestation report** issued by a licensed CPA firm following AICPA standards. There is no "pass/fail certificate"; the deliverable is a report describing the auditor's opinion on the organization's controls. Frame it that way rather than as a badge to earn.

## Trust Services Criteria

An organization selects which criteria apply to the systems in scope:

| Criterion | Required? | Covers |
|---|---|---|
| Security | Always (the "Common Criteria") | Protection against unauthorized access, the baseline every SOC 2 report includes |
| Availability | Optional | System is available for operation/use as committed |
| Processing Integrity | Optional | System processing is complete, valid, accurate, timely, authorized |
| Confidentiality | Optional | Information designated confidential is protected |
| Privacy | Optional | Personal information is collected, used, retained, disclosed per the entity's privacy notice |

Ask which criteria beyond Security are actually relevant before assuming all five are in scope — most SaaS companies pursue Security + Availability at minimum, with Confidentiality added if handling sensitive customer data.

## Type I vs. Type II

* **Type I** — assesses whether controls are suitably designed **at a single point in time**. Faster and cheaper, but doesn't demonstrate the controls actually operated effectively.
* **Type II** — assesses whether controls **operated effectively over a period** (typically 6–12 months). This is what most enterprise customers actually expect when they ask for "your SOC 2 report" — confirm which one is being requested/pursued, since they imply very different levels of readiness and evidence.

## Common Criteria (CC1–CC9)

Loosely mapped to the COSO internal control framework:

* CC1 — Control environment (governance, tone at the top)
* CC2 — Communication and information
* CC3 — Risk assessment
* CC4 — Monitoring activities
* CC5 — Control activities
* CC6 — Logical and physical access controls
* CC7 — System operations (detection/response to security events)
* CC8 — Change management
* CC9 — Risk mitigation (vendor/business partner risk)

## Evidence Typically Required

* Policies (access control, incident response, change management, vendor management, etc.)
* Access review records (who has access to what, reviewed on a cadence)
* Change management logs (code review, approval, deployment records)
* Vendor/subprocessor risk assessments
* Incident response records, including any actual incidents during the audit period
* Security awareness training records
* For Type II specifically: evidence the above operated consistently across the entire audit period, not just a snapshot

## Audit Process

* Engage a licensed CPA firm (not a generic consultancy) to perform the audit
* Many organizations do a **readiness assessment / gap analysis** first (often with the same or a different firm) before the formal audit period begins, specifically to avoid finding gaps mid-audit-period that are hard to remediate retroactively for a Type II window
* Bridge letters are sometimes issued between audit periods to cover a gap while the next report is being finalized — relevant if a customer asks for current coverage between report dates

## Guidance for This Skill When SOC 2 Is In Scope

* Determine Type I vs. Type II and which Trust Services Criteria are targeted before assessing readiness — these change both scope and evidence depth substantially
* For Type II specifically, emphasize that evidence must span the entire audit period consistently, not just be true today — a control that was fixed last week doesn't yet have a period of evidence behind it
* Never assert the organization "is SOC 2 compliant" or "certified" — the correct framing is that a CPA firm issues an attestation report with an opinion (unqualified/qualified/adverse), and only that report and firm can make the claim
* Recommend a readiness assessment before committing to an audit period start date if significant gaps are likely

## Deliverables Checklist

- [ ] Trust Services Criteria in scope determined (Security + which optional criteria)
- [ ] Type I or Type II target determined, with audit period defined for Type II
- [ ] Policies covering access control, change management, incident response, and vendor management documented
- [ ] Access review cadence established and evidenced
- [ ] Change management evidence (review/approval/deployment) captured consistently
- [ ] Vendor/subprocessor risk assessments completed
- [ ] Readiness assessment/gap analysis completed before the formal audit engagement, if gaps are likely
