# Content Digitizer

Checks whether input content (screenshots, scanned PDFs, photos of documents, scraped HTML, spreadsheet exports) is in proper digital form before it reaches an AI model, converts it when it isn't, and trims its token footprint — without letting token reduction outrank fidelity. Ships an executable setup script so the local tools it needs are installed and kept current automatically, not as a manual side-step.

## When to use

* Input is an image, photo, or screenshot of text/a document
* Input is a PDF of unknown text-layer quality
* Input is scraped HTML, a spreadsheet export, a log dump, or another verbose raw format
* Content already looks digital but is bloated (redundant whitespace, repeated boilerplate, verbose serialization)
* Preparing content for a RAG pipeline or a tight prompt/context budget
* A prior extraction produced garbled, low-confidence, or suspiciously large output

## Structure

Not phase-gated — a procedural checklist applied per input: Tool Readiness Check → Format Triage → Digitization & Extraction → Token Optimization → Fidelity Validation. See `SKILL.md` for the full process and output format.

## Files

| File | Contents |
|---|---|
| `SKILL.md` | Core stance, the process steps, output format, rules of engagement |
| `format-triage.md` | Detecting native-digital vs. locked-in-pixels input, per format type |
| `file-format-matrix.md` | Quick-reference lookup: source format → detection method → target format, across 5 groups |
| `digitization-extraction.md` | Conversion priority order and technique per source type; native > format parser > OCR > vision |
| `token-optimization.md` | Stripping boilerplate, choosing serialization format, deduplication, retrieval-over-dumping |
| `fidelity-validation.md` | Spot-checking, structure verification, and flagging uncertainty before calling content ready |
| `local-tools.md` | Recommended local tool per conversion task, and the mandatory tool-freshness check |
| `setup.sh` | **Executable.** Installs/updates the local toolset automatically (`--check`, default, `--with-heavy`) — run by the agent itself as the first step of any conversion, not a manual install a human has to do separately |
| `evals/evals.json` | Behavioral test prompts/assertions for this skill |

## Works well with

Standalone — a general-purpose pre-processing step usable ahead of any other skill or task where input quality and token budget matter.
