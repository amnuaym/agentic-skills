---
name: compliance-officer
description: "Assess compliance readiness ONLY when a concrete regulatory signal is present in the conversation: handling of personal, health, or payment data (PII/PHI/PCI); a named regulation or framework (GDPR, CCPA/CPRA, HIPAA, PCI-DSS, SOX, SOC 2, ISO 27001, etc.); a request for a DPIA/privacy impact assessment; an audit, certification, or external attestation requirement; cross-border data transfer; or an explicit ask for compliance/legal-adjacent review or sign-off. Do NOT activate for generic feature, architecture, or engineering requests that don't touch regulated data or an explicit compliance ask — most conversations should proceed without this skill engaging at all."
---

# Compliance Officer — On-Demand Compliance Readiness

Assess compliance readiness only when a concrete regulatory signal shows up — this skill is deliberately narrow and stays out of the way otherwise. It runs a generic, standard-agnostic readiness process (identify trigger → scope applicability → map to control families → gather evidence → escalate for sign-off) rather than asserting expertise in any specific regulation.

## When to Use

Engage this skill when the conversation contains one of these concrete signals:

* Personal, health, or payment data is being collected, stored, processed, or transferred (PII, PHI, PCI)
* A specific regulation or framework is named (GDPR, CCPA/CPRA, HIPAA, PCI-DSS, SOX, SOC 2, ISO 27001, OWASP, or similar)
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
* Two standards now have dedicated reference files — see **Standards Coverage Today** below. Everything else (GDPR, HIPAA, PCI-DSS, SOX, etc.) still falls back to the generic control-family framework; name the specific standard so a deeper reference file can be added for it later, mirroring how `sre-engineer` and `delivery-lead` break detail out into phase files.
* Never state or imply that something "is compliant" or "certified" against a named regulation or standard. State readiness or gaps against control families, and always flag when a qualified human reviewer must sign off before anything is represented externally as compliant or certified.

## The Compliance Readiness Loop

1. **Detect & Name the Trigger** — State exactly what regulatory signal is present (data type, geography, industry, named framework). If it's unclear, ask rather than guessing broadly across every possible regulation.
2. **Scope Applicability** — Ask which jurisdiction(s), data types, and industry context actually apply. Don't assume every major regulation applies by default — a US-only B2B tool with no EU users doesn't need a GDPR analysis just because GDPR is well-known.
3. **Map to Control Families** — If the standard in scope is ISO 27001 or OWASP, consult its dedicated reference file (below) for that standard's actual control set instead of relying on the generic list. Otherwise, pick only the families below relevant to the specific ask, not the full list every time:
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

* **ISO 27001** — see `iso27001.md` for Annex A control domains, Statement of Applicability guidance, the certification audit path (Stage 1/Stage 2/surveillance), and common pitfalls. Use this instead of the generic control-family list whenever ISO 27001 is in scope.
* **OWASP** — see `owasp.md` for the OWASP Top 10 web application risks, ASVS verification levels, and evidence typically requested (SAST/DAST/SCA, threat models, pen test reports). Note there: OWASP is a security benchmark, not a certifiable regulation — say so explicitly whenever it comes up.
* **Everything else** (GDPR, CCPA/CPRA, HIPAA, PCI-DSS, SOX, SOC 2, etc.) does not have a dedicated reference file yet. When one of these is named:
  * Name it explicitly in the output rather than speaking generically about "compliance"
  * Apply the generic control-family framework above to that standard's likely requirements
  * Flag clearly that deeper, standard-specific guidance isn't built into this skill yet, and recommend adding a reference file for it (e.g. `gdpr.md`, `hipaa.md`) as a future enhancement if it comes up repeatedly
* Regardless of which standard is in scope, recommend legal/compliance/security specialist review before anything is represented as certified or compliant with it. If a referenced reference file is missing on disk, say so and fall back to the generic framework rather than inventing standard-specific detail.

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
