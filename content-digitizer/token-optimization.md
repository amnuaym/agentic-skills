# Token Optimization

Once content is genuinely digital, reduce its token footprint — but only by removing what costs tokens without adding information the task needs. This step never overrides fidelity; it operates within the boundary Digitization & Extraction already established.

## Strip Boilerplate, Not Content

* Repeated headers/footers, navigation chrome, page numbers, and watermark text that recur across every page/section of a document carry no incremental information after the first occurrence — safe to strip or deduplicate
* Legal disclaimers, cookie notices, and marketing boilerplate are usually safe to drop unless the task specifically concerns them
* Anything that varies per section (a unique heading, a table's actual data, a paragraph's actual content) is not boilerplate, even if it looks structurally similar to boilerplate — check before assuming a repeated-looking pattern is safe to cut

## Choose the Right Serialization Format

* Tabular data: prefer CSV/TSV over an HTML `<table>` or a verbose JSON array of objects with repeated key names per row — the repeated keys in JSON cost real tokens for no added information over a header row
* Free text meant for the model to read and reason over: prefer plain prose or lightly-structured markdown over JSON, unless the consuming step needs to programmatically parse specific fields
* Structured fields the model or a downstream step needs to parse reliably: JSON/YAML with a minimal, flat schema — avoid deeply nested structures when a flat one would do
* Don't default to whatever format the source happened to use — actively choose the most token-efficient representation for what the task actually needs to do with the data

## Deduplicate

* Repeated content across multiple chunks/pages/sources (the same disclaimer, the same header, the same boilerplate paragraph) should appear once, not once per occurrence
* When combining multiple documents or pages into one context, check for overlap before concatenating everything as if each were entirely unique

## Compress Structural Noise

* Collapse redundant whitespace, blank lines, and formatting artifacts left over from conversion (common after OCR or HTML extraction) — these add tokens with zero informational value
* Simplify markup to the minimum needed for the model to parse structure — a heading marker and a list bullet are useful; excessive nested formatting for purely visual purposes usually is not

## Retrieve, Don't Dump

* When only part of a large source is relevant to the task, extract or retrieve that part rather than including the entire document "to be safe" — a targeted excerpt with clear context beats a full dump the model has to search through itself
* If retrieval scope is genuinely unclear, say so rather than defaulting to maximal inclusion — an explicit "I'm not sure how much context is needed here, here's my best guess at scope" is more useful than silently padding the input

## Summarization — Use Sparingly and Say So

* Summarization is a lossy operation — reserve it for content that is genuinely non-critical filler (background context, boilerplate explanation) rather than the substance the task depends on
* When a summarization pass is applied, state explicitly what was condensed and that it's a summary, not a verbatim representation — never let a summarized version pass silently as if it were the full source

## Deliverables (Exit Criteria for This Step)

- [ ] Boilerplate/repeated content stripped or deduplicated, with content mistaken for boilerplate checked first
- [ ] Serialization format chosen deliberately for the task, not inherited from the source by default
- [ ] Redundant whitespace/formatting artifacts from conversion cleaned up
- [ ] Only the relevant portion of large sources included, with scope uncertainty stated if present
- [ ] Any summarization applied is explicitly labeled as such, with what was condensed noted
