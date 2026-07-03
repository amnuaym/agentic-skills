# CCPA/CPRA — California Consumer Privacy Act / California Privacy Rights Act

CCPA/CPRA is a **binding California state law**, not a certifiable standard — there's no certification body, and (like GDPR) "compliance" means demonstrable adherence to statutory rights and obligations, enforced by a regulator, not an audit passed. CPRA (effective 2023) substantially amended and expanded CCPA rather than replacing it outright; when either is named, confirm which set of obligations the user actually means, since CPRA added meaningfully more (sensitive personal information category, risk assessments, a dedicated enforcement agency).

## Applicability Thresholds

Applies to for-profit entities doing business in California that meet at least one of:

* Annual gross revenue over $25 million, **or**
* Buy, sell, or share personal information of 100,000+ consumers/households annually, **or**
* Derive 50%+ of annual revenue from selling or sharing consumers' personal information

Check these thresholds explicitly before assuming CCPA/CPRA applies — plenty of companies handling California residents' data fall under the size thresholds and aren't in scope, unlike GDPR which has no revenue/volume floor.

## Consumer Rights

* Right to know what personal information is collected, used, disclosed, sold, or shared
* Right to delete
* Right to correct inaccurate personal information (added by CPRA)
* Right to opt out of the **sale** or **sharing** of personal information
* Right to limit use/disclosure of **sensitive personal information** (added by CPRA — SSNs, precise geolocation, health data, etc.)
* Right to non-discrimination for exercising these rights (can't charge a different price or provide a different quality of service purely for opting out)

## "Sale" and "Sharing" — Broader Than It Sounds

* "Sale" and "sharing" are defined broadly enough to capture some cross-context behavioral advertising arrangements, not just literal monetary transactions — a company that shares data with an ad-tech partner for targeted advertising may be "selling" or "sharing" under this law even if no money changes hands
* This is the single most common area where engineering teams underestimate scope — ask specifically about ad-tech/analytics integrations before concluding "we don't sell data"

## Opt-Out Mechanism Requirements

* "Do Not Sell or Share My Personal Information" link (or equivalent) required on the website if selling/sharing occurs
* Must honor the **Global Privacy Control (GPC)** browser signal as a valid opt-out request — this is a technical requirement, not just a policy one
* Contrast with GDPR: CCPA/CPRA is generally an **opt-out** model (process by default, let people opt out) rather than GDPR's **opt-in** consent model for many processing activities — don't assume the same consent mechanism satisfies both

## CPRA-Specific Additions

* Created the **California Privacy Protection Agency (CPPA)** as a dedicated enforcement and rulemaking body (previously enforcement sat with the state Attorney General)
* Introduced requirements for **risk assessments** and **cybersecurity audits** for certain high-risk processing, with details defined through CPPA rulemaking — check current CPPA regulations for specifics rather than assuming the requirement mirrors a GDPR DPIA exactly
* Added **sensitive personal information** as its own category with additional rights (right to limit use)

## Evidence Typically Required

* Privacy policy disclosing categories of data collected, purposes, and any sale/sharing
* Opt-out mechanism (link + GPC signal handling) implemented and tested
* Consumer rights request handling process and logs (know/delete/correct/opt-out requests)
* Data inventory identifying what qualifies as a "sale" or "sharing" across vendor/ad-tech integrations
* Service provider/contractor agreements with the required CCPA/CPRA contractual terms

## Guidance for This Skill When CCPA/CPRA Is In Scope

* Check the applicability thresholds explicitly before assuming the law applies — this is unlike GDPR, which has no size floor
* Probe ad-tech and analytics integrations specifically when asked "do we sell data" — the broad definition of sale/sharing is the most common blind spot
* Distinguish CCPA-era obligations from CPRA additions (sensitive personal information, correction right, risk assessments, CPPA rulemaking) since the user may mean either
* Confirm GPC signal handling is implemented, not just a manual opt-out link — this is a specific, checkable technical requirement
* Never assert "CCPA compliant" — state readiness/gaps against the rights and obligations above, and flag legal review before external claims, same as GDPR

## Deliverables Checklist

- [ ] Applicability thresholds checked and documented (revenue/volume/revenue-from-sale)
- [ ] Data inventory identifies any "sale" or "sharing" including ad-tech/analytics integrations
- [ ] Consumer rights request process defined and tested (know/delete/correct/opt-out)
- [ ] Opt-out link and GPC signal handling implemented
- [ ] Sensitive personal information identified with the "limit use" right supported
- [ ] Service provider/contractor agreements include required contractual terms
- [ ] Risk assessment completed for high-risk processing, if CPPA rulemaking requires it for this activity
