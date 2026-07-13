# Digitization & Extraction

Convert whatever Format Triage flagged as locked-in-pixels or awkwardly structured into clean, faithful digital text or structured data — always preferring the extraction method closest to the original source of truth.

## Priority Order

1. **Native text layer / structured source** — if it exists, use it directly. This is always more accurate and cheaper than re-deriving the same information through OCR or a vision model.
2. **Format-specific parser** — for structured binary formats (docx, xlsx, proprietary exports), use a parser built for that format rather than a generic text dump, so structure (headings, table boundaries, cell types) survives the conversion.
3. **OCR** — for scanned pages and image-only PDFs where the text is genuinely locked in pixels and no native source is available.
4. **Vision-based description** — for content where the meaning isn't textual (a diagram, a chart, a photo of a physical scene) — describe what it shows rather than forcing a literal transcription.

Don't reach for step 3 or 4 when step 1 or 2 is available — this is the single most common avoidable accuracy loss in digitization.

## OCR Guidance

* Set the correct language/locale for the document — a language mismatch degrades accuracy across the entire extraction, not just on a few words
* Use layout-aware OCR (one that preserves reading order and table structure) over plain character-recognition when the source has multi-column layout, tables, or forms — naive OCR often scrambles multi-column reading order
* Note the OCR engine's confidence signal where available, and treat low-confidence regions as suspect rather than trusting them at face value
* Re-run or manually verify small, high-stakes regions (amounts, dates, identifiers, names) even if the bulk of the document OCR'd cleanly — these are exactly the values where a single misread character causes the most damage

## HTML-to-Text / HTML-to-Markdown

* Strip navigation, ads, scripts, tracking attributes, and inline styling — none of it carries information relevant to almost any downstream task
* Preserve headings, lists, and table structure by converting to their markdown/plain-text equivalents rather than discarding all structure into an undifferentiated text blob
* For client-side-rendered pages, extract from the rendered DOM (post-JavaScript-execution) rather than the raw fetched HTML, which may be nearly empty

## Structured Format Extraction (docx, xlsx, proprietary exports)

* Use the format's own parser/library rather than converting to plain text first and re-parsing — this preserves table boundaries, cell types (numbers vs. text vs. dates), and document structure that a naive text dump loses
* For spreadsheets specifically, extract with awareness of what's actually tabular data versus formatting/styling metadata that has no informational value for the task

## Faithful Conversion Checklist

* Numbers, dates, and identifiers match the source exactly — these are the highest-cost places for a subtle extraction error to hide
* Structural elements (tables, headings, lists) are preserved in a form the model can still parse as structured, not flattened into prose that loses the relationships between values
* Nothing was silently dropped — if a region couldn't be extracted cleanly, that gap is noted explicitly rather than left as a silent omission

## Deliverables (Exit Criteria for This Step)

- [ ] Extraction method matches the priority order (native > format parser > OCR > vision description), not skipped ahead
- [ ] OCR run with correct language and layout awareness where used, with confidence noted
- [ ] High-stakes values (numbers, dates, identifiers) spot-checked against the source
- [ ] Structural elements (tables, headings, lists) preserved in a parseable form, not flattened
- [ ] Any region that couldn't be extracted cleanly is explicitly flagged, not silently omitted
