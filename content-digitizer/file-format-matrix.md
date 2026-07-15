# File Format Matrix

A quick-reference lookup for common input formats: how to detect them, and what to convert them into. Use this to skip straight to the right conversion path instead of re-deriving it per input — but still run the source through `format-triage.md`'s core question (native digital vs. locked-in-pixels) when a format isn't listed here or behaves unexpectedly.

## Group 1 — Already Digital (no OCR; clean up and pick the right serialization)

| Source format | How to detect | Convert to |
|---|---|---|
| Plain text (.txt) | Already text | Use as-is |
| Markdown (.md) | Already text | Use as-is; strip front-matter/metadata not needed for the task |
| PDF with a real text layer | Direct text extraction returns complete, coherent text | Extract text directly → Markdown/plain text, preserving headings/lists/tables |
| HTML (server-rendered) | Text nodes present in the raw source | Strip nav/ads/scripts/styling → Markdown/plain text |
| HTML (client-rendered SPA) | Raw fetched HTML is empty/near-empty; content is JS-populated | Render the DOM first, then convert as server-rendered HTML |
| Word (.docx) | File extension + structure | Format-specific parser → Markdown/plain text, preserving headings/tables |
| PowerPoint (.pptx) | File extension + structure | Per-slide extraction (title + bullets + speaker notes) → structured text labeled by slide number |
| Excel/CSV (.xlsx, .csv) | Already tabular | Native parser → CSV/TSV, filtered to the columns/rows the task needs |
| JSON/XML dumps | Already structured, often deeply nested/verbose | Flatten schema, drop irrelevant fields → compact flat JSON (or CSV if genuinely tabular) |
| Log files (.log) | Plain text, high verbosity relative to information density | Filter by severity/time range, dedupe repeated stack traces → structured text (timestamp, level, message) |
| Email (.eml, .msg) | Has headers + body | Keep key headers (From/To/Subject/Date) + body; strip repeated quoted-reply chains/signatures → plain text |
| Source code (.py, .js, etc.) | Already text; structure matters | Keep as-is; optionally strip license headers/boilerplate comments not relevant to the task |

## Group 2 — Locked in Pixels (needs OCR)

| Source format | How to detect | Convert to |
|---|---|---|
| Scanned PDF / image-only PDF | Direct text extraction returns empty or garbled text | Layout-aware OCR → Markdown/plain text, preserving table structure where present |
| Screenshot of a document/text | Image by definition, no text layer | Check for the original digital source first; OCR only if no source is available → plain text |
| Photo of a physical document | Image, variable quality | OCR with confidence noted; spot-check numbers/dates/names → plain text with low-confidence regions flagged |
| Handwritten notes | Image, non-standard character shapes | Handwriting recognition (expect lower confidence) → plain text, explicitly flagged as lower-confidence |
| Screenshot of a table | Image with tabular layout | OCR with table-structure detection → CSV or Markdown table |

## Group 3 — Non-Textual Images (meaning isn't in the pixels-as-characters)

| Source format | How to detect | Convert to |
|---|---|---|
| Chart/graph image | Meaning is in shape/position, not characters | Look for the underlying dataset first; otherwise a vision-based description of what the chart shows — not literal OCR of axis labels |
| Diagram/architecture image | Structural/relational content | Vision-based description of components and relationships → text summary |
| Infographic (mixed text + graphics) | Combination of both | OCR the textual portions + vision description of the graphical portions → combined text |

## Group 4 — Audio & Video

| Source format | How to detect | Convert to |
|---|---|---|
| Audio recording (.mp3, .wav, etc.) | Audio file | Speech-to-text transcription → plain text transcript, with timestamps/speaker labels only if the task needs them |
| Video (.mp4, etc.) | Has audio + visual track | Extract and transcribe audio; if on-screen text matters (e.g., slides in a recorded talk), OCR only the frames that carry it → transcript + on-screen text notes |

## Group 5 — Archives, Databases, Legacy Formats

| Source format | How to detect | Convert to |
|---|---|---|
| Archive (.zip, .tar, etc.) | Compressed container | Extract first, then triage each contained file individually per the groups above |
| Database dump (.sql, .bak) | Full database export, usually far larger than needed | Query out only the relevant tables/rows → CSV/structured text; never load a raw dump wholesale |
| Fixed-width / EDI text (e.g., X12, mainframe extracts) | Plain text with no self-describing field labels | Parse against the field spec → CSV/JSON with explicit field labels |
| Legacy documents (.doc, .rtf, .wpd) | Older/proprietary format | Format-specific converter → Markdown/plain text |

## Target-Format Cheat Sheet

* **Prose the model needs to read and reason over** → plain text / Markdown, preserving headings and lists
* **Tabular data** → CSV/TSV (far more token-efficient than an HTML table or a JSON array of repeated-key objects)
* **Fields a downstream step must parse programmatically** → flat JSON/YAML, avoiding deep nesting
* **Non-textual images** → a text description from vision, not a literal OCR transcription
* **Audio/video** → a plain text transcript

## Deliverables Checklist

- [ ] Source format matched against this matrix, or triaged via `format-triage.md` if not listed
- [ ] Conversion path follows the priority order in `digitization-extraction.md` (native > format parser > OCR > vision description)
- [ ] Target format chosen from the cheat sheet above, not inherited from the source by default
- [ ] Any format-specific caveat (e.g., mixed native/scanned PDF, client-rendered HTML) checked explicitly rather than assumed away
