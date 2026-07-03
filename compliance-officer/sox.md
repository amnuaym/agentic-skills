# SOX — Sarbanes-Oxley Act (US)

SOX is a **binding US federal law** governing financial reporting integrity for publicly traded companies (and companies preparing to go public). Unlike GDPR/HIPAA, its primary audience within engineering is narrower — it mainly concerns systems that touch financial reporting — but the controls it demands (change management, access control, segregation of duties) are ones engineering teams directly implement and get audited on.

## Who's In Scope

* Applies to US-listed public companies (and, in practice, often expected by acquirers/investors ahead of an IPO)
* Within engineering, scope is typically **systems that materially affect financial statements** — the general ledger, billing/revenue recognition systems, payroll, and any system feeding numbers into the 10-K/10-Q — not the entire company's tech stack by default. Ask which systems are actually in scope before assuming everything needs SOX-level controls.

## Key Sections Relevant to Engineering

* **Section 302** — CEO/CFO must personally certify the accuracy of financial reports and the effectiveness of disclosure controls
* **Section 404(a)** — management must assess and report on the effectiveness of Internal Control over Financial Reporting (ICFR)
* **Section 404(b)** — external auditor must independently attest to that assessment (smaller reporting companies are often exempt from 404(b), but not from 404(a) — confirm company size/status rather than assuming exemption)
* **Section 802** — criminal penalties for destroying/altering records intended to be used in an investigation — relevant to log retention and audit trail integrity

## IT General Controls (ITGC) — The Engineering-Facing Core

| Control area | What it means in practice |
|---|---|
| Change management | Code/config changes to in-scope financial systems are reviewed, approved, and tracked before deployment — no direct production changes bypassing the process |
| Access control | Access to financial systems and their underlying data is restricted, reviewed periodically, and revoked promptly on role change/termination |
| Segregation of duties | The person who can initiate a financial transaction/change cannot also be the sole approver — no single person controls an entire process end-to-end |
| Backup & recovery | Financial data can be recovered accurately after a failure; recovery is tested, not just assumed to work |
| Job scheduling/batch processing | Automated financial processes (e.g., month-end close jobs) run reliably and failures are detected and remediated |

## Audit Trail Requirements

* Financial system logs need to be tamper-evident and retained per the company's records retention policy (often intersecting with the 7-year figure commonly cited for financial records)
* This is a frequent source of tension with other regimes' deletion rights (e.g., GDPR erasure requests against financial transaction records) — flag the conflict rather than resolving it unilaterally when it comes up

## Evidence Typically Required

* ICFR narrative/process documentation for in-scope financial systems
* Change management records (tickets, approvals, deployment logs) for those systems
* Access review records — periodic recertification of who has access and why
* Segregation-of-duties matrix showing no toxic combinations of access
* Evidence of backup/recovery testing
* External auditor's attestation report (for 404(b)-applicable companies)

## Guidance for This Skill When SOX Is In Scope

* Confirm the specific system is actually in-scope for financial reporting before applying ITGC rigor to it — not every internal tool needs SOX-level change management
* Distinguish 404(a) (management self-assessment, required for essentially all public companies) from 404(b) (external auditor attestation, exemptions possible for smaller reporting companies) — ask which applies
* Flag segregation-of-duties violations concretely (e.g., "this engineer can both deploy the billing change and approve their own PR") rather than describing the concept abstractly
* Never assert "SOX compliant" on your own — ICFR effectiveness is ultimately an external auditor's opinion (for 404(b) companies) or management's formal assessment; this skill can only identify control gaps ahead of that assessment
* Flag retention-vs-deletion conflicts with other regimes explicitly (see `gdpr.md`) rather than picking a side

## Deliverables Checklist

- [ ] In-scope financial systems identified (not assumed to be the entire stack)
- [ ] Change management process documented and evidenced for in-scope systems
- [ ] Access control and periodic access review process in place
- [ ] Segregation-of-duties matrix reviewed for toxic combinations
- [ ] Backup/recovery tested for financial data
- [ ] Audit trail/log retention meets the records retention policy and is tamper-evident
- [ ] 404(a) vs. 404(b) applicability determined for the company
