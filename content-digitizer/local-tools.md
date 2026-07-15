# Local Tools & Freshness Check

Conversion accuracy depends on the tool doing the converting, not just the technique. An outdated OCR engine, document converter, or parser can silently produce worse output — a misread character, a dropped table, an unsupported newer file variant falling back to a degraded path — without raising any error. Treat "the tool is installed" and "the tool is up to date" as two separate checks; passing the first never implies the second.

## Recommended Local Tools by Conversion Task

| Task | Typical local tool(s) | Notes |
|---|---|---|
| PDF text-layer extraction | `pdftotext` (poppler-utils), PyMuPDF (`fitz`), `pdfplumber` | Prefer layout-aware extraction (PyMuPDF/pdfplumber) when tables matter |
| Scanned PDF / image OCR | Tesseract OCR, `ocrmypdf` | Set the correct language pack and layout/page-segmentation mode for the document |
| Screenshot/photo OCR | Tesseract OCR, or a vision-capable model for descriptive extraction | Pair with the confidence handling in `fidelity-validation.md` |
| Word documents (.docx) | `pandoc`, `python-docx` | `pandoc` is generally preferred for direct, structure-preserving Markdown conversion |
| PowerPoint (.pptx) | `python-pptx`, `pandoc` | Extract per-slide text and speaker notes separately |
| Excel/CSV (.xlsx) | `openpyxl`, `pandas`, `xlsx2csv` | Use `pandas` to filter columns/rows before serializing to CSV |
| Legacy documents (.doc, .rtf, .wpd) | LibreOffice headless (`soffice --convert-to`), `pandoc` | LibreOffice covers the widest range of legacy formats |
| HTML to Markdown | `pandoc`, `trafilatura`/readability-style extractors (boilerplate stripping), a headless browser (Playwright/Puppeteer) for client-rendered pages | Reach for the headless browser only when raw HTML lacks the rendered text |
| Audio/video transcription | `ffmpeg` (audio extraction/normalization), Whisper (speech-to-text) | Extract and normalize audio with `ffmpeg` before handing it to transcription |
| Archives | `unzip`, `tar`, `7z` | Extract first, then triage each contained file individually |
| JSON/XML manipulation | `jq`, `xmllint` | Flatten/filter before including anything in a prompt |
| Database dumps | Native DB client (`psql`, `mysql`, `sqlite3`) | Query out only the relevant tables/rows — never load a raw dump wholesale |

This list covers common cases, not every possible tool — when a task needs something not listed here, apply the same readiness check below to whatever tool is actually used.

## Tool Readiness Check (Mandatory Before Any Conversion)

Run this before invoking any local tool, every time — not just the first time a tool is used in a session:

1. **Confirm it's installed.** Check for the binary/library on the system (e.g., `which tesseract`, `pip show pymupdf`, `pandoc --version`) rather than assuming it's present because it was used before or because it's commonly pre-installed.
2. **Check the installed version.** Run the tool's version command and compare it against the latest available release (package registry, project release page, or system package manager's available-update listing).
3. **If outdated, update before converting.** Use the appropriate package manager (`pip install --upgrade <package>`, `apt update && apt upgrade <package>`, `brew upgrade <package>`, `npm update`, etc.) to bring the tool current before running the conversion — don't proceed on a stale version and hope the output is still correct.
4. **If it can't be updated or installed, say so explicitly.** Flag the limitation rather than silently falling back to a degraded method (e.g., quietly switching from a real PDF parser to naive regex-based text scraping) without telling the user what changed and why.
5. **Re-check periodically, not just once per session.** A tool confirmed current at the start of a long working session may have a new release mid-session — re-verify before a new batch of conversions if meaningful time has passed, rather than trusting an earlier check indefinitely.

## Why Freshness Matters Per Tool Type

* **OCR engines** (Tesseract, etc.) — recognition models and language packs improve across versions; an old version can misread characters a current one would get right, especially for non-Latin scripts or degraded scans
* **Document converters** (`pandoc`, LibreOffice) — gain support for newer file format variants and fix structure-preservation bugs (tables, nested lists) over time
* **Parsing libraries** (PyMuPDF, `openpyxl`) — patch bugs in handling malformed or edge-case files that previously produced silently wrong output rather than an error

## Deliverables Checklist

- [ ] Local tool identified for the specific conversion task, matching the table above (or an equivalent for tasks not listed)
- [ ] Tool confirmed installed before use
- [ ] Installed version checked against the latest available release
- [ ] Tool updated before use if it was found outdated
- [ ] Any inability to update or install is flagged explicitly, not silently worked around with a degraded fallback
