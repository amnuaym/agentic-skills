# Self-Narration (Zero Onboarding)

The standard here is strict: a first-time user, with no help doc, no tooltip, and no one to ask, should be able to figure out what to do next just from what's on screen. This file reframes classic usability heuristics around that specific bar.

## The Ten Heuristics, Reframed for Zero Onboarding

1. **Visibility of system status** — the user always knows what's happening: loading states, progress indicators, save confirmations. Silence during a wait or after an action is the single most common cause of "did that work?" confusion.
2. **Match between system and the real world** — use the user's language and familiar metaphors, not internal jargon or database field names. An icon or label that means something different inside the team than to a new user will fail this test.
3. **User control and freedom** — every flow has a clear way out: cancel, back, undo. A user who enters a flow by mistake, or changes their mind, should never feel stuck.
4. **Consistency and standards** — follow platform/ecosystem conventions (a trash icon means delete, not archive; a gear means settings, not filters) so users transfer knowledge from elsewhere instead of learning your app's private dialect.
5. **Error prevention** — a constraint or confirmation that stops a mistake before it happens beats even a well-written error message after the fact. Prefer disabling an invalid action with a visible reason over letting the user fail and then explaining why.
6. **Recognition rather than recall** — options are visible, not hidden behind memorized commands or menu paths the user has to remember from a prior session.
7. **Flexibility and efficiency of use** — accelerators exist for repeat/expert users (see `power-user-keyboard.md`) without making the default path harder for first-time users; the same action should have a simple path and, optionally, a fast path.
8. **Aesthetic and minimalist design** — every extra element on screen competes for attention and dilutes which one matters. If removing an element doesn't lose necessary information, remove it.
9. **Help users recognize, diagnose, and recover from errors** — plain language, precise about what went wrong, and a concrete next step ("Card was declined — check the number and try again," not "Error 402").
10. **Help and documentation, only as a last resort** — if it's needed at all, it should be minimal, contextual to the exact task, and short enough to not be a barrier itself. Its necessity is a signal the design has a gap, not a feature to be proud of.

## First-Run Experience (Zero Prior Context)

* What does a brand-new user see with no data, no history, and no tour? This is the hardest and most revealing test of self-narration — most flows are designed and tested by people who already know how the app works.
* The primary action should be obvious without a tour: a single, clearly-labeled call to action beats a welcome screen full of options.
* If a "getting started" wizard feels necessary, ask first whether the underlying flow can be simplified instead — a wizard is often compensating for a screen that's trying to do too much at once.

## Empty States

* Every list, dashboard, or data view has a designed empty state — not just a blank area or a generic "No data" label.
* A good empty state explains, in the interface itself, why it's empty and what the user's next action is ("No projects yet — create your first one" with the create action right there), not just that it's empty.
* Distinguish "genuinely empty" (new user, nothing created yet) from "empty due to a filter/search" (different message: what to do to broaden the result) from "empty due to an error" (a real error state, not a silent blank).

## Error States

* State what happened, in plain language specific to the actual failure — not a generic "Something went wrong."
* State what the user can do about it — retry, check a specific field, contact support with a reference code — not just that something failed.
* Never expose raw technical detail (stack traces, internal error codes with no translation) to the end user as the primary message; technical detail can exist in an expandable "details" section for support purposes, but it isn't the message.

## Signifiers & Affordances

* Interactive elements look interactive — buttons look pressable, links look like links, and this visual signal is consistent across the whole app, not per-screen.
* Disabled controls look visibly disabled, and where feasible, communicate why (a disabled "Submit" button next to an incomplete required field, rather than a mysteriously inert button).
* Don't rely on hover-only affordances for anything essential — hover doesn't exist for touch or keyboard-only interaction (see `power-user-keyboard.md` and `accessibility.md`).

## Feedback Loops

* Every user action gets an immediate, perceivable response — a button press, a form submission, a drag — even if the underlying operation takes time (show a loading/pending state rather than leaving the interface looking unchanged).
* Confirmations for destructive or hard-to-reverse actions should state the specific consequence ("Delete 'Q3 Report'? This can't be undone") rather than a generic "Are you sure?"

## Deliverables Checklist

- [ ] Primary action on each screen is identifiable without a tour or help text
- [ ] Empty states are designed per context (new/filtered/error), not left as a blank default
- [ ] Error messages are specific, in plain language, and state a next step
- [ ] Interactive vs. disabled affordances are visually distinct and consistent app-wide
- [ ] Every user action produces immediate, visible feedback
- [ ] Destructive actions have consequence-specific confirmation, not a generic "are you sure"
