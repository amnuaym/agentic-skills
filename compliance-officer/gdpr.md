# GDPR — EU General Data Protection Regulation

Unlike the ISO standards, GDPR is a **binding legal regulation**, not a voluntary certifiable management system. There is no equivalent of "ISO 27001 certified" for GDPR in ordinary practice — Article 42 certification mechanisms exist but are rarely used. "Compliance" here means demonstrable adherence to the regulation's principles and rights, enforced by supervisory authorities (e.g., a national Data Protection Authority), not an auditor issuing a certificate. Applies to processing personal data of individuals in the EU/EEA, regardless of where the processing organization is based.

## Core Principles (Article 5)

* Lawfulness, fairness, and transparency
* Purpose limitation — collected for specified, explicit, legitimate purposes only
* Data minimization — adequate, relevant, limited to what's necessary
* Accuracy — kept accurate and up to date
* Storage limitation — kept no longer than necessary
* Integrity and confidentiality — appropriate security
* Accountability — the organization must be able to demonstrate compliance with all of the above, not just assert it

## Legal Basis for Processing (Article 6)

Every processing activity needs one of: consent, contract necessity, legal obligation, vital interests, public task, or legitimate interests. "We need the data" is not itself a legal basis — ask which of these six actually applies, since the answer changes what rights and obligations attach.

## Data Subject Rights (Articles 12–23)

* Right of access, rectification, erasure ("right to be forgotten"), restriction of processing
* Right to data portability
* Right to object (including to direct marketing, absolutely)
* Rights related to automated decision-making and profiling (Article 22) — relevant for AI/ML-driven decisions with legal or similarly significant effect

## Key Obligations

* **Records of Processing Activities (Article 30)** — a register of what personal data is processed, why, and for how long
* **DPIA (Article 35)** — required before processing likely to result in high risk to individuals (large-scale sensitive data, systematic monitoring, new technology at scale); not required for every processing activity
* **Data Protection Officer (Article 37)** — mandatory for public authorities, large-scale systematic monitoring, or large-scale special-category data processing; ask whether the org's activity actually meets this threshold rather than assuming
* **Breach notification (Articles 33/34)** — to the supervisory authority within 72 hours of becoming aware, and to affected individuals without undue delay if the breach is likely to result in high risk to them
* **International transfers (Chapter V)** — transfers outside the EU/EEA need an adequacy decision, Standard Contractual Clauses (SCCs), Binding Corporate Rules, or another approved mechanism

## Evidence Typically Required

* Records of Processing Activities register
* Legal basis documented per processing activity
* DPIA documents for high-risk processing
* Data subject request handling process and logs
* Breach response procedure and any incident log
* Data Processing Agreements with vendors/processors
* Transfer mechanism documentation for any non-EU/EEA data flows

## Enforcement

* Fines up to €20 million or 4% of global annual turnover, whichever is higher, for the most serious infringements
* Enforced by national supervisory authorities, not a certification body — there is no "pass/fail audit" in the ISO sense; enforcement typically follows a complaint, breach, or investigation

## Guidance for This Skill When GDPR Is In Scope

* Confirm EU/EEA individuals are actually involved before running a full GDPR analysis — the regulation applies based on whose data it is, not where the company is headquartered
* Ask which legal basis applies per processing activity rather than assuming consent is always required (it's one of six options, and often not the best fit)
* Flag DPIA requirement only when the processing is plausibly high-risk — don't demand one for routine, low-risk processing
* Never state a system "is GDPR compliant" — assess against the principles/rights/obligations above and flag legal/DPO review before anything is represented as compliant externally
* If a DPO is legally required (see threshold above) and none is named, flag this as a gap explicitly

## Deliverables Checklist

- [ ] Legal basis identified and documented per processing activity
- [ ] Records of Processing Activities maintained
- [ ] Data subject rights request process defined and tested
- [ ] DPIA completed for high-risk processing, if applicable
- [ ] DPO designated, if the org meets the mandatory threshold
- [ ] Breach notification procedure defined with 72-hour authority notification path
- [ ] International transfer mechanism documented for any non-EU/EEA data flows
