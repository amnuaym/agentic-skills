# Release Candidate Test Summary Report — Portfolio App

**Report Date:** 2026-07-02
**Prepared by:** QA / Test Lead
**Release Target:** Tomorrow (2026-07-03), ahead of earnings season

---

## 1. Executive Summary

**Recommendation: DO NOT SHIP as-is. Conditional GO only if the 2 open Critical defects in cost-basis/returns calculation are resolved and re-verified before release.**

Testing is otherwise in good shape (140 cases executed, 91% clean pass rate on defects found), but the two open Critical defects sit directly in the cost-basis and returns calculation engine — the core of what a portfolio app promises to get right, and the exact numbers users will be scrutinizing hardest during earnings season when they're checking portfolio performance against market-moving news. Shipping known-incorrect financial calculations carries disproportionate risk (user trust, financial/compliance exposure, support volume) relative to the one-day schedule gain.

---

## 2. Test Execution Overview

| Metric | Value |
|---|---|
| Total test cases executed | 140 |
| Total defects found | 12 |
| Defects by severity | 2 Critical (open), remaining 10 at lower severity / resolved status (assumed — see note) |
| Open Critical defects | 2 |
| Area of open Critical defects | Cost-basis calculation, Returns calculation |
| Pass rate (cases without a blocking defect) | ~91% (128/140 cases not tied to an open Critical) |

> **Note on assumptions:** The prompt specifies 12 total defects and 2 open Criticals, but doesn't break down the severity of the remaining 10. This report assumes the other 10 are Medium/Low or already resolved/verified, since they weren't flagged as release blockers. If any of the 10 are also Critical/High and still open, the risk position below is even more conservative — please confirm and I'll revise the counts.

---

## 3. Defect Summary

| Severity | Count | Status |
|---|---|---|
| Critical | 2 | **Open** — cost-basis & returns calculation logic |
| High/Medium/Low (combined) | 10 | Assumed resolved or accepted (unconfirmed — verify before sign-off) |
| **Total** | **12** | |

### Open Critical Defects — Detail

| ID | Area | Description (assumed placeholder — replace with actuals) | Impact | Status |
|---|---|---|---|---|
| CRIT-1 | Cost-basis calculation | Cost basis computed incorrectly under [specific condition, e.g., partial sells / lot selection / corporate actions] | Directly misstates gains/losses and tax-relevant figures shown to users | Open |
| CRIT-2 | Returns calculation | Returns (e.g., time-weighted or money-weighted return) diverge from expected values under [specific condition] | Misleads users on portfolio performance, especially visible during high-traffic earnings-driven check-ins | Open |

*(Fill in the bracketed specifics from your actual defect tickets — root cause, reproduction steps, affected account/asset types, and whether the error is systematic or edge-case.)*

---

## 4. Risk Assessment

### Why these two defects matter more than their count suggests

1. **Core value proposition**: Cost-basis and returns are the primary numbers users trust the app to get right. Errors here aren't cosmetic — they're the product.
2. **Timing amplifies exposure**: Earnings season means higher-than-normal traffic and scrutiny — users will be actively comparing displayed returns against market moves and news. Incorrect numbers surfaced at this moment are more likely to be noticed, screenshotted, and escalated (support tickets, social media, possibly regulatory/compliance questions if cost-basis figures feed tax reporting).
3. **Trust is asymmetric**: A financial app that shows a visibly wrong number once often loses user confidence permanently, even after a fix ships. This is harder to recover from than a one-day schedule slip.
4. **Unknown blast radius**: Without confirmation of *how* these defects manifest (all users vs. edge case; visually obvious vs. silently wrong), it's difficult to bound the risk. A silent, systematic miscalculation is far worse than an edge-case error with an obvious visual glitch.

### Severity-based release gate (standard industry practice)

Most release gating models (including typical Critical/Blocker definitions) treat **open Critical defects in core financial calculations as automatic release blockers** regardless of overall pass rate. 128/140 clean is a strong number, but pass-rate percentage does not offset an open Critical in the calculation engine — severity, not volume, drives the ship/no-ship call here.

---

## 5. Options Going Forward

| Option | Description | Recommendation |
|---|---|---|
| **A. Fix + hotfix cycle, slip 24–48h** | Fix both Criticals, run targeted regression on cost-basis/returns + smoke test on adjacent areas, ship when clean | **Preferred** — protects trust during the highest-visibility window of the year |
| **B. Ship with feature flag / kill switch** | Ship other changes, but flag off or roll back the specific calculation path affected by the 2 Criticals if isolable | Viable **only if** the buggy logic can be cleanly toggled without disabling core functionality |
| **C. Ship as-is with known-issue banner** | Ship tomorrow, disclose a known issue, patch ASAP | **Not recommended** — a visible disclaimer on cost-basis/returns accuracy is reputationally worse than a short delay, especially timed with earnings season |
| **D. Ship as-is, silent** | Ship without disclosure, patch later | **Strongly not recommended** — highest risk option; erodes trust and may create compliance exposure if discovered |

---

## 6. Recommended Immediate Actions

1. **Today**: Get root cause + fix estimate from engineering for both Critical defects. Determine if they share a root cause (faster fix) or are independent.
2. **Today**: Determine blast radius — does this affect all accounts/users or a specific subset (e.g., specific asset types, corporate action histories, multi-lot positions)? This changes urgency and whether Option B (flag off) is feasible.
3. **Today/tonight**: If fixes land, run a focused regression pass on cost-basis and returns calculations (not just the two failing cases — adjacent scenarios: partial sells, dividends/splits, multi-currency if applicable, date-boundary cases) plus a smoke pass on the rest of the app.
4. **Before any ship decision**: Get explicit written sign-off from Product/Business acknowledging the known Critical defects if Option C/D is chosen — do not let this be an implicit/undocumented decision.
5. **Communicate now, not after**: Flag this to Product today (not day-of-ship) with this report so there's runway to make an informed call rather than a rushed one tomorrow morning.

---

## 7. Bottom Line

- **140 cases executed, 12 defects, 2 open Critical** — solid coverage, but the 2 open Criticals sit in the app's core financial calculation logic.
- **Not ready to ship as-is.** The risk isn't the defect count, it's *where* the defects are and *when* they'd ship — incorrect cost-basis/returns numbers going out right before earnings season is a high-visibility, high-trust-cost scenario.
- **Recommend a short fix-and-verify cycle** (even 24–48 hours) over shipping known-wrong financial calculations. If the business overrides this and ships anyway, that should be a documented, explicit Product/Business risk acceptance — not a default outcome.

---

*This report was generated based on the summary metrics provided (140 executed, 12 defects, 2 open Critical in cost-basis/returns). Defect IDs, root causes, and severity breakdown of the remaining 10 defects are placeholders — replace with actual defect-tracker data before distributing.*
