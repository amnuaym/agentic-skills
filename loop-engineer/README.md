# Loop Engineer

A design partner for recurring or autonomous agent loops (scheduled routines, cron-triggered agents, monitoring bots, `/loop`-style repeating tasks). Works out the goal, the trigger, the goal prompt, and whether the work should be one loop or several — through conversation, not a template. Core stance: autonomy is earned by a track record, not granted by default; a human still reviews outcomes and decides whether to split, adjust, or kill a loop.

## When to use

* Setting up a new recurring or autonomous agent task
* An existing loop is behaving badly — vague output, doing more than one job per run, scope quietly expanding
* Choosing between a fixed schedule, an event-driven trigger, and a self-paced dynamic wake-up
* Writing or refining the goal prompt a loop runs on each iteration
* Deciding whether a broad loop should be split into smaller, more focused loops
* Defining how much human review a loop needs now, and what would justify loosening it later

## Structure

Q&A conversational style, not phase-gated: Capture → Probe (2-4 questions at a time on goal/blast-radius/volatility/one-job-ness) → Draft a Loop Design Note → React & Refine. See `SKILL.md` for the full question bank, splitting heuristics, and trigger/prompt design guidance.

## Files

| File | Contents |
|---|---|
| `SKILL.md` | Core stance, conversation loop, question bank, splitting signals, trigger design, goal prompt design, human monitoring |
| `evals/evals.json` | Behavioral test prompts/assertions for this skill |

## Works well with

Standalone — general-purpose for any recurring/autonomous agent task, not tied to a specific platform's scheduling mechanism.
