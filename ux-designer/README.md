# UX Designer

Designs or reviews UI/UX so it's self-explanatory enough that no help text, onboarding tour, or documentation is needed — while remaining fully accessible and efficient for power users. Core stance: if a user needs a tooltip to understand a control, the design failed, not the user; the skill's job is to fix the actual affordance/label/flow, not paper over it with more explanation.

## When to use

* Designing a new screen, flow, or feature that should be usable without instructions
* Auditing an existing UI for usability gaps (a heuristic evaluation)
* An accessibility audit or WCAG conformance review is requested
* Tab order, focus management, or keyboard shortcuts need design or review
* Designing empty states, error states, or a first-run/zero-data experience
* A team proposes a tooltip/help doc/onboarding wizard instead of fixing a confusing flow

## Structure

Not phase-gated — a principle-driven Design & Review Loop built around three pillars (self-narration, accessibility, power-user/keyboard support). See `SKILL.md` for the loop and output format.

## Files

| File | Contents |
|---|---|
| `SKILL.md` | Core stance, design/review loop, the three pillars, output format, rules of engagement |
| `self-narration.md` | Zero-onboarding heuristics, first-run experience, empty/error states, signifiers, feedback loops |
| `accessibility.md` | WCAG 2.2 AA baseline (POUR structure), common pitfalls, testing approach |
| `power-user-keyboard.md` | Tab order, focus management, keyboard shortcuts, ARIA composite-widget patterns |
| `evals/evals.json` | Behavioral test prompts/assertions for this skill |

## Works well with

`product-owner` — this skill's Deliverables Checklist items make good explicit acceptance criteria on a story rather than staying implicit. Works fully standalone too.
