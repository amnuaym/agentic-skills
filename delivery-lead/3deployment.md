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

* **Branch protection**: production branches require review approval and passing CI before merge; deploys to Prod require an explicit approval step, not just a green pipeline.

### Production Hardening Checklist

A catch-all pass for the things that don't fit neatly into the sections above but still get exploited if missed:

* No debug mode, verbose stack traces, or default/test accounts reachable in production.
* Admin/internal endpoints are not publicly exposed (network-restricted or behind auth).
* Service accounts and IAM roles follow least privilege — no service running with broader permissions than it needs.
* Unused ports and services are closed.
* Resource limits/quotas are set so one runaway process can't take down the host or cluster.
* Dependency versions are pinned (no floating `latest`/`*` in production manifests).

### Incident Response Runbooks

Write these before go-live, not during the first incident:

* One runbook per critical failure mode (e.g., "database unreachable," "checkout failing," "auth provider down") with detection signal, first response steps, and escalation path.
* Keep runbooks next to the code they cover and reference them from the on-call/alerting tooling so responders find them without searching.

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

* \[ \] Branch protection and deployment approvals enabled for Prod

* \[ \] Container images scanned and secrets rotated

* \[ \] Production hardening checklist completed

* \[ \] Incident response runbooks written

* \[ \] **FinOps**: Billing alerts and budget thresholds configured

* \[ \] **Compliance**: Formal Legal/InfoSec sign-off secured (e.g., DPIA)

* \[ \] **Change Mgmt**: User training complete and comms sent

* \[ \] **Change Mgmt**: Helpdesk/Support handover complete

* \[ \] **Cutover**: Minute-by-minute Go-Live runbook approved and Go/No-Go secured
