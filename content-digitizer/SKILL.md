---
name: content-digitizer
description: "Check whether input content (images/photos of documents, screenshots, scanned PDFs, scraped HTML, spreadsheet exports, raw dumps) is in proper digital form before it's passed to an AI model, convert it when it isn't, and reduce its token footprint without losing information the task depends on. Use this skill before feeding a scanned or photographed document, a screenshot, a PDF of unknown text-layer quality, scraped web content, or a bloated export/log dump into a model; when OCR or vision-based extraction is being considered; when a context/token budget is tight and content needs a token audit; or when a prior extraction produced garbled, low-confidence, or suspiciously large output. Also trigger for RAG ingestion pipelines and prompt-context preparation, even if the user does not say 'digitize' or 'tokens' explicitly."
---

# Content Digitizer — Digitization & Token-Efficiency Gatekeeper

A model works more accurately on genuinely digital content (native text, structured data) than on a lossy stand-in for it — a photo of a screen, a scanned page, a screenshot of a table. It's also cheaper: properly digitized content is inherently more token-efficient than the pixels or raw markup it came from. This skill's job is to catch content that isn't yet in proper digital form, convert it faithfully, and then strip everything that costs tokens without adding information the task needs — in that order, never the reverse.

## Core Stance

Digitization fidelity comes first; token reduction is bounded by it, not the other way around. A conversion that saves tokens by guessing at unclear OCR, flattening a table the model needs to reason over, or summarizing away a number the task depends on has failed at the actual goal — accuracy — even if it technically shipped fewer tokens. When a conversion is uncertain, say so explicitly rather than silently passing a guess through as fact.

## When to Use

Activate this skill when:

* Input is an image, photo, or screenshot of text/a document rather than machine-readable text
* Input is a PDF of unknown quality — it may have a real text layer, or it may be a scanned image requiring OCR
* Input is scraped HTML or a web page with heavy markup, navigation, ads, or boilerplate
* Input is a spreadsheet export, log dump, or other verbose raw format
* Content already looks digital but is bloated — redundant whitespace, repeated headers/footers, verbose serialization
* Preparing content for a RAG pipeline or a prompt where the context budget is tight
* A prior extraction produced output that looks garbled, suspiciously large, or otherwise untrustworthy

## The Process

Each step has its own reference file — consult it for the specific techniques rather than reasoning from general instinct alone:

0. **Tool Readiness Check** — see `local-tools.md`. Before invoking any local tool for a conversion, confirm it's installed and check its version against the latest available release; update it first if it's outdated, and flag explicitly if it can't be updated rather than silently falling back to a worse method.
1. **Format Triage** — see `format-triage.md`. Detect the input's actual form and decide whether it's already proper digital form or needs conversion. See `file-format-matrix.md` for a quick lookup across common file types.
2. **Digitization & Extraction** — see `digitization-extraction.md`. Convert non-digital or poorly-structured input into clean, faithful digital text/structured data, preferring native extraction over OCR/vision wherever a real text layer exists.
3. **Token Optimization** — see `token-optimization.md`. Strip what costs tokens without adding information — boilerplate, redundant markup, inefficient serialization — while preserving structure the model needs to reason correctly.
4. **Fidelity Validation** — see `fidelity-validation.md`. Confirm the conversion and optimization didn't drop or corrupt anything the task depends on before calling the content ready.

Don't skip straight to step 3 because token savings are the visible goal — a token-optimized version of a bad conversion is still a bad conversion, just a cheaper one. And don't skip step 0 because a tool "was working fine last time" — an outdated tool can silently degrade output with no error raised.

## Output Format

```text
Source format detected: [e.g. scanned PDF, screenshot, native PDF, scraped HTML, raw JSON dump]
Native digital?: yes / no
Tool(s) used: [tool name + version; confirmed current, or updated before use]
Conversion applied: [OCR / text-layer extraction / HTML-to-text / format-specific parser / none needed]
Confidence / fidelity notes: [low-confidence regions, ambiguous OCR, structure at risk of being lost]
Token reduction applied: [what was stripped/deduped/reformatted, rough before/after size if available]
Ready for model input: yes / needs review -- [specific item]
```

## Rules of Engagement

1. **Prefer native extraction over OCR or vision-based reading whenever a text layer or structured source already exists.** Never OCR a PDF that already has selectable text, and never re-derive from a screenshot when the original digital source is available instead.
2. **Token reduction never outranks fidelity.** If a technique would save tokens by risking dropped or corrupted information the task needs, don't apply it — or apply it only after confirming the task doesn't depend on what's being cut.
3. **Flag low-confidence conversions explicitly.** A guessed character, an ambiguous table cell, or an OCR region with low confidence gets called out by name, not silently passed through as if it were certain.
4. **Preserve structure that helps the model reason.** Tables, headings, and lists usually earn their token cost back in correctness — flattening everything into a minimal blob of prose can cost more in accuracy than it saves in tokens.
5. **Match serialization format to the task.** Prefer CSV/TSV over an HTML or verbose-JSON table for tabular data; prefer plain prose over JSON when the model doesn't need to programmatically parse fields. Don't default to a bulky format out of habit.
6. **Reserve compression for genuinely non-critical filler.** Repeated headers/footers, navigation chrome, and boilerplate legal text are fair game; content the task actually depends on is not — and whatever gets cut should be stated, not silently dropped.
7. **Retrieve the relevant part rather than dumping the whole document.** When only a section of a large source matters to the task, extract or retrieve that section instead of including everything "just in case."
8. **Report before/after, not just after.** A token-reduction claim without some sense of what was reduced and why isn't verifiable — say what was stripped, deduped, or reformatted.
9. **Never invoke a local tool without checking it's current.** Confirm the tool is installed and up to date before converting anything with it; update if stale, and say so explicitly if it can't be updated rather than quietly using a degraded fallback.
