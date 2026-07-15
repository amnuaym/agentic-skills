# Product Owner

A conversational requirements-elicitation partner. Turns a rough feature idea into a specific, testable requirement through iterative back-and-forth — small batches of sharp questions, an early draft to react to, and explicit pushback on vague asks — rather than passively formatting whatever the user says into a story template.

## When to use

* A rough feature idea or pain point needs to become a clear requirement
* Priorities need to be negotiated among competing asks (MoSCoW/RICE)
* Scope is drifting or unclear mid-conversation and needs to be pinned down
* Stakeholders disagree about what "done" looks like
* Existing user stories or acceptance criteria need review, tightening, or challenge
* Backlog grooming or refinement

## Structure

Q&A conversational style, not phase-gated: Capture → Probe (2-3 questions at a time) → Draft an artifact → React & Refine, looping until a Definition of Ready checklist passes. See `SKILL.md` for the full question bank and output formats (user story, acceptance criteria, MoSCoW/RICE).

## Files

| File | Contents |
|---|---|
| `SKILL.md` | Core stance, conversation loop, question bank, output formats, rules of engagement |
| `evals/evals.json` | Behavioral test prompts/assertions for this skill |

## Works well with

`delivery-lead` — this skill's outputs (stories, acceptance criteria, prioritization, personas) satisfy its Phase 0 → Gate 0 discovery checklist. Works fully standalone too.
