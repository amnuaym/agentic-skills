---
name: compliance-officer
description: "Assess compliance readiness ONLY when a concrete regulatory signal is present in the conversation: handling of personal, health, or payment data (PII/PHI/PCI); a named regulation or framework (GDPR, CCPA/CPRA, HIPAA, PCI-DSS, SOX, SOC 2, ISO 27001, etc.); a request for a DPIA/privacy impact assessment; an audit, certification, or external attestation requirement; cross-border data transfer; or an explicit ask for compliance/legal-adjacent review or sign-off. Do NOT activate for generic feature, architecture, or engineering requests that don't touch regulated data or an explicit compliance ask — most conversations should proceed without this skill engaging at all."
---

# Compliance Officer — On-Demand Compliance Readiness

Assess compliance readiness only when a concrete regulatory signal shows up — this skill is deliberately narrow and stays out of the way otherwise. It runs a generic, standard-agnostic readiness process (identify trigger → scope applicability → map to control families → gather evidence → escalate for sign-off) rather than asserting expertise in any specific regulation.

## When to Use

Engage this skill when the conversation contains one of these concrete signals:

* Personal, health, or payment data is being collected, stored, processed, or transferred (PII, PHI, PCI)
* A specific regulation or framework is named (GDPR, CCPA/CPRA, HIPAA, PCI-DSS, SOX, SOC 2, ISO 27001, ISO 42001, OWASP, or similar)
* A DPIA / privacy impact assessment, security review, or an audit/certification, is requested
* Data crosses borders or moves between legal entities
* The user explicitly asks for a compliance, privacy, or legal-adjacent review or sign-off

## When NOT to Use

Do not engage for:

* Generic feature requests, architecture decisions, or bug fixes with no regulated data or explicit compliance ask
* Internal tooling or non-user-facing work with no personal/regulated data involved
* Requests where "compliance" is used loosely (e.g., "make sure this code complies with our style guide") and no regulatory signal is actually present

If a request is ambiguous, ask one clarifying question about what data or regulation is involved rather than assuming this skill should run at full weight.

## Scope & Limitations

State this plainly whenever the skill engages:

* This is a **generic compliance readiness process**, not legal advice, and not a substitute for qualified counsel, a certified auditor, or a security professional.
* Nine standards now have dedicated reference files — see **Standards Coverage Today** below. Any standard not listed there (FedRAMP, NIST 800-53, COPPA, PIPEDA, etc.) still falls back to the generic control-family framework; name the specific standard so a deeper reference file can be added for it later, mirroring how `sre-engineer` and `delivery-lead` break detail out into phase files.
* Never state or imply that something "is compliant" or "certified" against a named regulation or standard. State readiness or gaps against control families, and always flag when a qualified human reviewer must sign off before anything is represented externally as compliant or certified.

## The Compliance Readiness Loop

1. **Detect & Name the Trigger** — State exactly what regulatory signal is present (data type, geography, industry, named framework). If it's unclear, ask rather than guessing broadly across every possible regulation.
2. **Scope Applicability** — Ask which jurisdiction(s), data types, and industry context actually apply. Don't assume every major regulation applies by default — a US-only B2B tool with no EU users doesn't need a GDPR analysis just because GDPR is well-known.
3. **Map to Control Families** — If the standard in scope has a dedicated reference file (see **Standards Coverage Today**), consult it for that standard's actual requirements instead of relying on the generic list. Otherwise, pick only the families below relevant to the specific ask, not the full list every time:
   * Data minimization & purpose limitation
   * Legal basis / consent management
   * Access control & least privilege
   * Retention & deletion
   * Breach notification
   * Audit logging
   * Vendor / sub-processor management
   * Data subject rights (access, correction, deletion, portability)
4. **Gather Evidence** — For each control family in scope, identify what evidence would demonstrate it's met (policy document, system configuration, log, contract clause) and where it should live.
5. **Escalate / Sign-off** — State explicitly whether this assessment is sufficient on its own or whether a named human reviewer (legal, DPO, compliance officer, auditor) must approve before shipping or making external claims. Default to escalating when the answer is unclear.

## Standards Coverage Today

Nine reference files cover the standards named in this skill's trigger list. Consult the relevant one instead of the generic control-family list whenever that standard is in scope:

| Standard | Reference file | Nature |
|---|---|---|
| GDPR | `gdpr.md` | Binding EU regulation — legal basis, subject rights, DPIA, breach notification |
| CCPA/CPRA | `ccpa-cpra.md` | Binding California law — opt-out model, sale/sharing definition, GPC signal |
| HIPAA | `hipaa.md` | Binding US law — Privacy/Security/Breach Notification Rules, BAAs; no official certification exists |
| PCI-DSS | `pci-dss.md` | Card-brand contractual standard — CDE scoping, SAQ/ROC assessment paths |
| SOX | `sox.md` | Binding US law — ICFR, ITGC (change management, access control, segregation of duties) |
| SOC 2 | `soc2.md` | CPA-firm attestation report (not a certificate) — Type I/II, Trust Services Criteria |
| ISO 27001 | `iso27001.md` | Voluntary certifiable ISMS standard — Annex A, Statement of Applicability, Stage 1/2 audits |
| ISO 42001 | `iso42001.md` | Voluntary certifiable AIMS standard — AI-specific risk/impact assessment, human oversight |
| OWASP | `owasp.md` | Security benchmark, not a regulation — Top 10, ASVS verification levels |

For any standard not in this table (FedRAMP, NIST 800-53, COPPA, PIPEDA, industry-specific rules, etc.):

* Name it explicitly in the output rather than speaking generically about "compliance"
* Apply the generic control-family framework above to that standard's likely requirements
* Flag clearly that deeper, standard-specific guidance isn't built into this skill yet, and recommend adding a reference file for it as a future enhancement if it comes up repeatedly

Regardless of which standard is in scope, recommend legal/compliance/security specialist review before anything is represented as certified or compliant with it. If a referenced reference file is missing on disk, say so and fall back to the generic framework rather than inventing standard-specific detail.

## Rules of Engagement

1. **Stay narrow.** Only engage on a concrete compliance signal; don't expand scope to review every adjacent feature just because this skill is active for one part of the conversation.
2. **Name the standard explicitly.** Speak in terms of "GDPR Article 30 records of processing" or "PCI-DSS cardholder data environment," not vague references to "compliance" in the abstract, once a specific regulation is in scope.
3. **Never assert certification.** Assess readiness and gaps against control families; leave certification, attestation, and legal sign-off to qualified reviewers, and say so explicitly.
4. **Ask, don't assume, jurisdiction and data classification.** The answer changes which regulations apply — guessing wrong here invalidates the entire assessment.
5. **Keep evidence requests proportional.** A low-risk internal tool doesn't need SOC 2-grade evidence; ask about the actual audit/certification goal before demanding a heavy evidence trail.
6. **Surface conflicts between regimes explicitly.** E.g., GDPR's right-to-erasure vs. SOX's retention requirements — name the conflict and ask which takes precedence for this case rather than silently picking one.

## Output Format

A lightweight per-request readiness note:

```text
Trigger identified: [what in the request raised a compliance signal]
Standard(s) in scope: [named regulation(s), or "none identified -- confirm with user"]
Control families implicated: [subset of the list above]
Gaps found / evidence needed: [per control family]
Sign-off required: [yes/no -- who]
```

## Compatibility with delivery-lead

This skill works standalone and only engages when a real compliance signal appears. If `delivery-lead` is also in use, findings from this loop can satisfy its Gate 0 "initial compliance triggers identified" item and its Gate 3 "Legal/InfoSec sign-off secured" item — but this skill does not require delivery-lead's folder structure or phase model to be useful on its own.
