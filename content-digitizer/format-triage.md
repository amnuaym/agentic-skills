# Format Triage

Before converting anything, identify what the input actually is. This determines every step downstream — the wrong triage call (treating a scanned PDF like a native one, or OCR-ing something that already has a text layer) wastes effort at best and introduces avoidable errors at worst.

## The Core Question

For any input, ask: **is the text already machine-readable, or is it locked inside pixels/a proprietary format?**

* Machine-readable (native digital) — plain text, markdown, CSV/TSV, JSON/XML, a PDF with a real text layer, HTML with text nodes, a native document format (docx, xlsx) opened with its proper parser
* Locked in pixels — a photo of a document, a screenshot, a scanned page saved as an image or as an image-only PDF, a chart/diagram where the meaning isn't in machine-readable text at all

## Detecting a Real Text Layer in a PDF

* Try extracting text directly first (most PDF libraries expose this) — if it returns coherent, complete text matching what's visually on the page, it has a real text layer and does not need OCR
* A PDF that returns empty, garbled, or drastically incomplete text on direct extraction is very likely a scanned image saved as a PDF and needs OCR instead
* Mixed PDFs exist — some pages native, some scanned (e.g., a native report with a scanned signature page appended) — check per page rather than assuming the whole document is one or the other

## Screenshots & Photos

* Always locked-in-pixels by definition — even a screenshot of a plain text file needs OCR or a vision-capable extraction step, because the screenshot itself carries no text layer
* Ask whether the original digital source is available instead of the screenshot — a screenshot of an email, a webpage, or a document is almost always inferior to the source it was captured from, and using the source instead skips OCR error entirely

## Scraped HTML / Web Pages

* Technically already machine-readable, but often bloated with navigation, ads, scripts, and styling that carry no informational value — this is a triage case for token optimization (see `token-optimization.md`) more than for conversion, but still worth flagging if the page is mostly boilerplate around a small amount of actual content
* Watch for content that's rendered client-side (JavaScript-populated) where the raw HTML source doesn't contain the visible text at all — this needs a rendered-DOM extraction, not a raw fetch of the HTML source

## Spreadsheets, Logs, and Structured Exports

* Native spreadsheet formats (xlsx, csv) are already machine-readable but may carry far more data than the task needs (every column, every historical row) — this is a token-optimization question, not a digitization one
* Log dumps and raw exports are machine-readable but often extremely verbose relative to their information density — same distinction: don't OCR them, but do consider whether the full dump or a filtered subset actually serves the task

## Diagrams, Charts, and Non-Textual Images

* Not everything in an image is text waiting to be OCR'd — a chart, diagram, or screenshot of a UI may need a description/caption of what it shows rather than a literal character-by-character extraction, since OCR-ing axis labels alone loses the chart's actual meaning
* Ask what the task needs from the image: the exact data behind a chart (look for a source dataset instead of extracting from the image), or a description of what it depicts (a vision-capable description is more appropriate than OCR)

## Deliverables (Exit Criteria for This Step)

- [ ] Source format identified per input (or per section/page, for mixed documents)
- [ ] Native-digital vs. locked-in-pixels determined, not assumed
- [ ] Original digital source checked for availability before falling back to OCR on a screenshot/photo
- [ ] Client-side-rendered content identified separately from raw HTML source, if applicable
- [ ] For chart/diagram images, decided whether the task needs the underlying data, a description, or literal text extraction
