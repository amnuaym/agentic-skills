# Power User & Keyboard Support

Full keyboard operability serves two audiences at once: people who can't or don't use a mouse (a core accessibility requirement) and power users who are faster on a keyboard than reaching for one. Design for both with the same set of checks — there isn't a separate "accessible" keyboard experience and a separate "efficient" one.

## Tab Order

* Tab order should follow the logical/visual reading order (typically top-to-bottom, left-to-right) — the simplest way to guarantee this is to let it follow natural DOM order rather than fighting it
* Avoid positive `tabindex` values (`tabindex="2"`, `tabindex="3"`, etc.) — they override natural order, are brittle as the page changes, and are a common source of confusing, hard-to-maintain tab sequences
* Use `tabindex="0"` to insert a custom interactive element (e.g., a `div` acting as a button — though prefer a native `button` when possible) into the natural tab flow
* Use `tabindex="-1"` to make an element programmatically focusable (so it can receive focus via script) without placing it in the regular Tab sequence — useful for moving focus after an action without adding a stop nobody would tab to on their own

## Focus Management

* A visible focus indicator is present at all times — never remove the default focus outline (`outline: none`) without providing an equally or more visible replacement; WCAG 2.2's focus appearance criteria set a concrete minimum for how visible it must be
* Focus moves predictably after actions:
  * Closing a modal/dialog returns focus to the element that opened it
  * Deleting an item from a list moves focus to a sensible neighbor (the next item, or the list container), not to `body` where it effectively disappears
  * Submitting a form that reveals new content (e.g., a success message or the next step) moves focus to that new content so it isn't silently missed
* Modals and dialogs trap focus while open — Tab and Shift+Tab cycle only within the dialog's contents, and Esc closes it — a user must never be able to Tab "through" a modal into the page behind it

## No Keyboard Traps

* A user must always be able to both enter and exit any component using only the keyboard — a rich text editor, embedded widget, or custom control that catches focus and won't release it (other than an intentional, escapable modal trap) is a hard accessibility failure, not a minor bug

## Keyboard Shortcuts & Accelerators

* Follow established conventions before inventing new ones: Enter to submit/activate, Esc to cancel/close, Space to toggle a checkbox or activate a focused button, arrow keys to move within a composite widget (see below)
* Common power-user patterns: `Ctrl`/`Cmd`+`K` for a command palette, `/` for search focus, `Ctrl`/`Cmd`+`S` for save — reuse these rather than remapping them to something unexpected
* Make shortcuts discoverable without requiring them — show the shortcut next to its menu item or action, so a user learns it by seeing it used the normal way, rather than requiring a cheat sheet
* Avoid conflicts with browser, OS, and assistive-technology shortcuts (e.g., don't override `Ctrl`+`W`, screen-reader navigation keys, or browser tab-switching combinations)
* If the app is shortcut-heavy, provide a visible shortcut reference and, ideally, a way to see/resolve conflicts if shortcuts are customizable

## Composite Widget Patterns (Follow the ARIA Authoring Practices Guide)

Don't invent custom keyboard behavior for common widget types — users bring expectations from every other app they've used with the same pattern:

| Widget | Expected keyboard behavior |
|---|---|
| Tabs | Arrow keys move between tabs; Tab key moves focus out of the tab list into the panel |
| Menu / menu button | Arrow keys move between items; Enter/Space activates; Esc closes and returns focus to the trigger |
| Combobox / autocomplete | Arrow keys move through suggestions; Enter selects; Esc closes without selecting |
| Grid / data table with cell interaction | Arrow keys move between cells; Tab moves out of the grid entirely |
| Tree | Arrow keys expand/collapse and move between nodes |

## Skip Links

* Provide a "Skip to main content" link as the first focusable element on pages with substantial repeated navigation/header content, so keyboard and screen-reader users aren't forced to tab through the same header on every page

## Testing Approach

* Literally set the mouse aside and complete every core task using only the keyboard: Tab, Shift+Tab, Enter, Space, Esc, and arrow keys
* At each step, confirm: is focus visible right now? Did it move somewhere sensible after that action? Is there anywhere Tab can't reach, or can't leave?
* Test the composite widgets specifically against the table above — a custom dropdown that only supports Tab (no arrow keys) is a common near-miss that looks fine at a glance but fails real keyboard use

## Deliverables Checklist

- [ ] Tab order follows natural/logical reading order; no positive `tabindex` hacks
- [ ] Focus indicator is visible at all times, never suppressed without replacement
- [ ] Focus moves predictably after modal close, item deletion, and form submission
- [ ] Modals/dialogs trap focus correctly and restore it on close
- [ ] No component creates a keyboard trap
- [ ] Composite widgets (tabs, menus, comboboxes, grids) follow expected arrow-key behavior
- [ ] Shortcuts follow established conventions, are discoverable, and don't conflict with browser/OS/assistive-tech keys
- [ ] Skip link present on pages with substantial repeated navigation
- [ ] Every core task completed successfully using only the keyboard
