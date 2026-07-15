# Compliance Officer

Assesses compliance readiness — but **only** when a concrete regulatory signal actually shows up (a named regulation, PII/PHI/PCI, a DPIA/audit request). Deliberately narrow: it stays out of the way for ordinary engineering work, and runs a generic, standard-agnostic readiness process (trigger → scope → control families → evidence → sign-off) rather than asserting compliance or certification on its own.

## When to use

* Personal, health, or payment data is being collected, stored, processed, or transferred
* A specific regulation or framework is named (GDPR, CCPA/CPRA, HIPAA, PCI-DSS, SOX, SOC 2, ISO 27001, ISO 42001, OWASP)
* A DPIA, security review, audit, or certification is requested
* Data crosses borders or moves between legal entities

**Not** for generic feature/architecture work with no regulated data or explicit compliance ask — see `SKILL.md`'s "When NOT to Use."

## Structure

Not phase-gated: a five-step readiness loop (Detect Trigger → Scope Applicability → Map to Control Families → Gather Evidence → Escalate/Sign-off), with a per-standard reference file consulted instead of the generic control-family list whenever that standard is named.

## Files

| File | Contents |
|---|---|
| `SKILL.md` | Trigger conditions, readiness loop, standards coverage table, rules of engagement |
| `gdpr.md` | Binding EU regulation — legal basis, subject rights, DPIA, breach notification |
| `ccpa-cpra.md` | Binding California law — opt-out model, sale/sharing definition, GPC signal |
| `hipaa.md` | Binding US law — Privacy/Security/Breach Notification Rules, BAAs (no official certification exists) |
| `pci-dss.md` | Card-brand contractual standard — CDE scoping, SAQ/ROC assessment paths |
| `sox.md` | Binding US law — ICFR, ITGC (change management, access control, segregation of duties) |
| `soc2.md` | CPA-firm attestation report (not a certificate) — Type I/II, Trust Services Criteria |
| `iso27001.md` | Voluntary certifiable ISMS standard — Annex A, Statement of Applicability, Stage 1/2 audits |
| `iso42001.md` | Voluntary certifiable AI Management System standard — AI risk/impact assessment, human oversight |
| `owasp.md` | Security benchmark, not a regulation — Top 10, ASVS verification levels |
| `evals/evals.json` | Behavioral test prompts/assertions for this skill |

## Works well with

`delivery-lead` — findings satisfy its Gate 0 "compliance triggers identified" and Gate 3 "Legal/InfoSec sign-off" items. `security-architect` — when this skill finds a gap against a named regulation, the actual mechanism fix (IAM design, encryption, audit logging) belongs there. Works fully standalone too.
