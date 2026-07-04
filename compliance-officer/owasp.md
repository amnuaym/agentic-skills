# OWASP — Application Security Benchmark

Unlike GDPR, HIPAA, or ISO 27001, OWASP is **not a legal regulation or a certifiable standard with an external auditor**. It's a community-maintained application security benchmark. It shows up in compliance conversations because it's frequently referenced contractually (customer security questionnaires, vendor risk assessments) or folded into other frameworks (e.g., PCI-DSS's secure coding requirements are commonly assessed against OWASP guidance). Sign-off here typically means internal AppSec/security team review or a pen test, not a compliance certificate — say this explicitly whenever OWASP comes up.

## OWASP Top 10 (2021) — Web Application Security Risks

| Category | Focus | What to check for |
|---|---|---|
| A01 Broken Access Control | Authorization enforcement | Least privilege enforced server-side; deny-by-default; no client-side-only auth checks |
| A02 Cryptographic Failures | Data protection in transit/at rest | Data classified by sensitivity; TLS everywhere; strong, current algorithms; key management and rotation |
| A03 Injection | Untrusted input reaching interpreters | Parameterized queries/ORM use; input validation (allow-list over deny-list); output encoding |
| A04 Insecure Design | Missing security thinking upstream | Threat modeling done; secure design patterns used; abuse cases tested, not just happy paths |
| A05 Security Misconfiguration | Hardening gaps | Hardened defaults; no default credentials; error messages don't leak stack traces; security headers set |
| A06 Vulnerable and Outdated Components | Dependency risk | SCA/dependency scanning in CI; patch cadence defined; SBOM maintained |
| A07 Identification and Authentication Failures | Auth weaknesses | MFA available; no weak/default credentials; proper session management; rate limiting on auth endpoints |
| A08 Software and Data Integrity Failures | Supply-chain/pipeline trust | CI/CD pipeline integrity; signed artifacts; no untrusted deserialization |
| A09 Security Logging and Monitoring Failures | Detection gaps | Auth/security events logged; logs actively monitored and alerted on; no sensitive data logged in plaintext |
| A10 Server-Side Request Forgery (SSRF) | Outbound request abuse | Outbound requests validated/allow-listed; network segmentation between app and internal services |

Map the specific ask to the relevant category or two — running the full Top 10 against every small request is disproportionate.

## Verification Depth — OWASP ASVS

* **Level 1 (Opportunistic)** — verifiable largely by automated tooling; reasonable baseline for any app
* **Level 2 (Standard)** — recommended default for apps handling sensitive data, PII, or authentication
* **Level 3 (Advanced)** — high-value/high-risk apps: financial transactions, healthcare data, critical infrastructure

Ask which ASVS level is the actual target before scoping a review — auditing a low-risk internal tool at Level 3 depth wastes effort the risk doesn't justify, and the reverse under-protects a high-risk app.

## Evidence Typically Requested

* SAST/DAST/SCA scan results with remediation SLAs by severity
* Threat model or architecture risk assessment for the feature/system
* Penetration test report (expected at ASVS Level 2+ or when a customer requires it)
* Security headers configuration, dependency manifest/SBOM

## Guidance for This Skill When OWASP Is In Scope

* State plainly that this is a security-benchmark review, not a certifiable "compliance" status — no external body issues an "OWASP compliant" certificate
* Map the ask to the specific Top 10 categor(y/ies) actually implicated, not the full list by default
* Ask what's driving the request (customer security questionnaire, contractual requirement, pre-launch review, incident-driven) — this changes both scope and urgency
* Recommend the security/AppSec team, or a qualified external pen tester for higher-risk apps, as the sign-off authority — not a self-assessment alone
* If the ask overlaps with PCI-DSS (cardholder data environment) or SOC 2 (security trust criteria), note the overlap explicitly since evidence can often be reused across frameworks

## Deliverables Checklist

- [ ] Relevant OWASP Top 10 categories identified for the specific application/feature in scope
- [ ] Target ASVS verification level agreed
- [ ] Automated scanning (SAST/DAST/SCA) results reviewed against agreed severity thresholds
- [ ] Threat model exists for the feature/system, if ASVS Level 2+
- [ ] Sign-off owner named (internal AppSec, or external pen tester for high-risk apps)
