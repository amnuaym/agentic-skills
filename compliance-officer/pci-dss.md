# PCI-DSS — Payment Card Industry Data Security Standard

PCI-DSS is an **industry-mandated contractual standard**, not a government regulation — it's enforced through agreements between merchants/service providers and the payment card brands (Visa, Mastercard, etc.) and their acquiring banks, not by a government body. It applies to any organization that stores, processes, or transmits cardholder data, regardless of transaction volume, though the assessment rigor scales with volume.

## Scoping First

* The **Cardholder Data Environment (CDE)** is the scope boundary — people, processes, and technology that store, process, or transmit cardholder data, plus anything connected to or that could impact the CDE's security
* The single highest-leverage move for most orgs is reducing CDE scope (tokenization, using a PCI-compliant payment processor/hosted fields so raw card data never touches internal systems) rather than trying to secure a large CDE — ask whether scope reduction has been considered before assuming the full standard applies to the whole environment

## The 12 Requirements (6 Goals)

| Goal | Requirements |
|---|---|
| Build and maintain a secure network | Firewall configuration; no vendor-default passwords/security parameters |
| Protect cardholder data | Protect stored cardholder data; encrypt transmission over open/public networks |
| Maintain a vulnerability management program | Anti-malware; secure systems and applications |
| Implement strong access control | Restrict access by business need-to-know; unique IDs for each person with access; restrict physical access |
| Regularly monitor and test networks | Track/monitor all access to network resources and cardholder data; regularly test security systems and processes |
| Maintain an information security policy | Maintain a policy addressing information security for personnel |

## Assessment Path — Depends on Merchant Level

* **SAQ (Self-Assessment Questionnaire)** — for lower-volume merchants; multiple SAQ types (A, A-EP, B, C, D) depending on how card data is handled (e.g., fully outsourced vs. card data touching internal systems) — the type matters, don't assume SAQ D (the most extensive) applies by default
* **ROC (Report on Compliance)** — required for Level 1 merchants (typically >6M transactions/year) and some service providers, performed by a **Qualified Security Assessor (QSA)**
* **Internal Security Assessor (ISA)** — some large organizations train internal staff to perform assessments, still requires QSA involvement periodically depending on card brand rules

## Version Note

PCI DSS 4.0 is the current version (superseding 3.2.1), with a transition period during which some 4.0 requirements became mandatory later than the base publication date — confirm which version and which requirement effective dates apply before assessing against a specific control.

## Compensating Controls

If a specific requirement can't be met exactly as written due to a legitimate technical/business constraint, a documented compensating control (meeting the intent and rigor of the original requirement) can be used — this requires formal documentation and typically QSA sign-off, not an informal workaround.

## Evidence Typically Required

* Network diagram showing CDE boundaries and data flows
* Cardholder data flow diagram
* Vulnerability scan results (quarterly, by an Approved Scanning Vendor for external scans)
* Penetration test results (at least annually and after significant changes)
* Access control lists and evidence of least-privilege enforcement
* Encryption/tokenization configuration for stored and transmitted cardholder data
* Security policy and incident response plan

## Guidance for This Skill When PCI-DSS Is In Scope

* Ask about CDE scope and whether scope-reduction options (tokenization, hosted payment fields) have been considered before assessing the full 12 requirements against everything
* Determine merchant/service provider level and the correct SAQ type or ROC requirement rather than assuming the most stringent path applies
* Never assert "PCI-DSS compliant" — state readiness/gaps against the 12 requirements, and flag that formal attestation requires a QSA (for ROC-level orgs) or a properly completed SAQ signed by an authorized officer
* Distinguish stored cardholder data risk (encryption, retention limits, no storage of prohibited data like full magnetic stripe/CVV after authorization) from transmission risk (TLS, network segmentation) — they call for different controls

## Deliverables Checklist

- [ ] CDE scope defined, with scope-reduction options considered
- [ ] Merchant/service provider level and required assessment type (SAQ type or ROC) determined
- [ ] Cardholder data flow diagram maintained
- [ ] Encryption/tokenization in place for stored and transmitted cardholder data
- [ ] Quarterly vulnerability scans and annual penetration test scheduled
- [ ] Access control restricted by business need-to-know with unique IDs per person
- [ ] Incident response plan covers cardholder data breach scenarios specifically
