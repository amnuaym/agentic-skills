# Accessibility (WCAG)

Treat WCAG 2.2 Level AA as the practical baseline — it's what most legal frameworks reference (ADA case law, Section 508, EN 301 549) and is achievable without the sometimes-impractical constraints of AAA. Structure checks around the four POUR principles rather than a flat feature list, so gaps are easy to categorize and prioritize.

## Perceivable

* **Text alternatives** — every meaningful image has descriptive alt text; purely decorative images have empty alt text (`alt=""`) so screen readers skip them rather than reading a filename
* **Captions/transcripts** for video and audio content
* **Color contrast** — minimum 4.5:1 for normal text, 3:1 for large text (18pt+/14pt+ bold) and for meaningful UI component boundaries/states (WCAG 2.2's Non-text Contrast)
* **Don't rely on color alone** — status, required fields, and errors need a second signal (icon, text label, pattern), not just a red/green color difference
* **Resizable text** — content and layout still work at 200% browser zoom without loss of content or function

## Operable

* **Full keyboard operability** — every interactive element reachable and usable via keyboard alone (detailed in `power-user-keyboard.md`); this is a WCAG requirement, not just a power-user nicety
* **Enough time** — adjustable or extendable timeouts for anything time-limited (session expiry, form completion); don't silently discard user input on timeout
* **No seizure-inducing content** — nothing flashes more than 3 times per second
* **Navigable** — skip links for repeated navigation blocks, meaningful page/view titles, logical focus order, link text that makes sense out of context (not bare "click here"), clear heading structure
* **Input modalities** — touch targets sized adequately (WCAG 2.2 recommends at least 24x24 CSS px, more for primary actions), and any gesture-based interaction (swipe, pinch) has a simple-tap or button alternative

## Understandable

* **Readable** — plain language appropriate to the audience; define unavoidable jargon on first use
* **Predictable** — navigation and component behavior stay consistent across the app; focus or input changes never trigger an unexpected context change (e.g., selecting a dropdown option shouldn't itself submit a form or navigate away without warning)
* **Input assistance** — every form field has a visible, programmatically-associated label (not just a placeholder — placeholders disappear on input and often fail contrast); errors are identified in text, tied to the specific field, and suggest a fix; confirmation step for legal, financial, or otherwise consequential submissions

## Robust

* **Valid, semantic markup** — use native HTML elements (`button`, `nav`, `label`, `table`) over generic `div`/`span` wherever the native element exists; assistive tech relies on this semantic layer to expose name/role/value
* **Custom components** expose correct ARIA name, role, and state (e.g., a custom dropdown announces as a listbox/combobox with its expanded/collapsed state, not silently as a plain div)
* **Status messages** (form validation results, a "saved" confirmation, search result counts) are announced to screen reader users without requiring them to have focus there — typically via an `aria-live` region — not just displayed visually

## Common Pitfalls to Check For

* Color-only status indicators (a red/green dot with no icon or text)
* Custom dropdowns, modals, or tooltips built from `div`/`span` with click handlers but no keyboard support or ARIA roles
* Interactive elements built on non-interactive tags (`div onclick=...`) missing `role`, `tabindex`, and keyboard event handling that a native `button` would provide for free
* Form fields with placeholder text standing in for a real label
* Modals that don't trap focus (Tab escapes to the page behind it) or don't return focus to the trigger element on close
* Images marked purely decorative that actually carry meaning (e.g., an icon-only status indicator with `alt=""` and no other signal)
* Auto-advancing carousels/content with no pause control

## Testing Approach

* Automated tools (axe, Lighthouse, WAVE) catch roughly a third of real issues — necessary but not sufficient; a clean automated scan does not mean the interface is accessible
* Manual keyboard-only walkthrough (see `power-user-keyboard.md`) catches most of what automated tools miss
* Screen reader spot-checks (VoiceOver, NVDA, or JAWS) on the core flows, not just the homepage — pay attention to whether announcements make sense in the order they're read, not just whether something is announced at all

## Deliverables Checklist

- [ ] Text alternatives present for meaningful images; decorative images marked empty
- [ ] Color contrast meets 4.5:1 (normal text) / 3:1 (large text, UI components)
- [ ] No information conveyed by color alone
- [ ] Every interactive element keyboard-operable (cross-check with `power-user-keyboard.md`)
- [ ] Form fields have real, associated labels — not placeholder-only
- [ ] Errors identified in text, tied to the specific field, with a suggested fix
- [ ] Custom components expose correct ARIA name/role/state
- [ ] Status/confirmation messages announced via `aria-live` or equivalent
- [ ] Automated scan run AND manual keyboard/screen-reader spot-check completed
