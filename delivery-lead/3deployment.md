# Phase 3: Deployment & Operations

This phase ensures the system is secure, observable, reliably deployable, and most importantly, that the business is ready to use it.

## DevSecOps & Compliance

### Security Controls (OWASP)

* Enforce RBAC, JWT validation, and parameterized queries.

* **Headers**: Enforce CSP, HSTS, X-Frame-Options, and nosniff at the proxy.

* **Rate Limiting**: Apply to all public-facing endpoints.

* **Encryption**: TLS 1.2+ in transit, column/disk level at rest.

### Compliance & Privacy Sign-off

Software cannot go live if legal/compliance risks are unresolved.

* **DPIA Approval**: If PII is processed, the Data Privacy Impact Assessment must be formally signed off by the Privacy/Legal team.

* **Audit Trails**: Verify that all state-changing operations log the who, when, and what (immutable and queryable).

### CI/CD & Image Security

* Pipeline must block on test failure (< 90%) or security vulnerabilities.

* Pin base image versions; scan images in CI.

* Require PR approvals for production branches.

## FinOps Operations

* **Billing Alerts**: Configure cloud budget alerts (e.g., alert at 50%, 80%, 100% of monthly budget).

* **Anomaly Detection**: Enable cost anomaly detection to catch runaway processes early.

## Change Management & Business Readiness

Perfect code fails if users don't know how to use it.

* **User Training**: End-users must be trained on the new system. Workarounds for missing edge-cases must be communicated.

* **Communications**: "Go-Live" communications drafted and scheduled.

* **Support Handover**: Tier 1 and Tier 2 Helpdesk teams must be trained, granted appropriate system access, and given the Incident Response Runbooks.

## Cutover Strategy (The Go-Live)

### The Cutover Runbook

A precise, minute-by-minute plan for launch day.

* **Pre-flight**: Verifying backups of legacy systems.

* **The Switch**: DNS cutovers, traffic routing (Blue-Green or Canary).

* **Data Execution**: Running the final production legacy data migration.

* **Verification**: Manual smoke testing by QA in production before opening to users.

### Go/No-Go Meeting

* Hold a formal meeting with all stakeholders (Engineering, Product, Business, Support).

* Confirm all Gate 3 criteria are met.

* Secure explicit verbal or written approval to execute the Cutover Runbook.

* **Rollback Plan**: Define the exact conditions under which you will abort the launch and roll back to the old system.

## Deliverables (Exit Criteria for Phase 3)

* \[ \] OWASP Top 10 audit passed and security headers verified

* \[ \] CI/CD pipeline complete with all stages

* \[ \] Container images scanned and secrets rotated

* \[ \] **FinOps**: Billing alerts and budget thresholds configured

* \[ \] **Compliance**: Formal Legal/InfoSec sign-off secured (e.g., DPIA)

* \[ \] **Change Mgmt**: User training complete and comms sent

* \[ \] **Change Mgmt**: Helpdesk/Support handover complete

* \[ \] **Cutover**: Minute-by-minute Go-Live runbook approved and Go/No-Go secured
