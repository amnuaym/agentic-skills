# Fidelity Validation

Before calling converted, optimized content ready for a model, confirm the pipeline didn't quietly drop or corrupt anything the task depends on. This is the check that keeps Token Optimization honest — a token-reduction pass without this step is unverified, not finished.

## Spot-Check High-Stakes Values

* Numbers, dates, identifiers, names, and amounts are the values most likely to carry a single-character error through undetected, and the most costly to get wrong
* Compare a sample of these against the original source directly, especially in any region flagged as low-confidence during extraction
* For OCR'd content specifically, prioritize spot-checks in regions with unusual fonts, handwriting, low image quality, or dense small text — these are where recognition errors concentrate

## Confirm Structure Survived

* If the source had tables, verify the converted version still represents rows/columns/relationships correctly — a table that got flattened into a run of unstructured numbers is a structural loss even if every individual value is technically present
* If headings and sections mattered for the task (e.g., distinguishing which section a value came from), confirm that association survived the conversion and any subsequent optimization

## Check What Optimization Cut

* Re-review the Token Optimization step's own log of what was stripped, deduplicated, or summarized — confirm none of it was actually task-relevant content mistaken for boilerplate
* If anything was summarized, confirm the summary retains what the task specifically needs, not just a generically "good enough" condensation

## Flag, Don't Guess

* Any region where confidence is genuinely uncertain (ambiguous OCR, a table that may have merged cells incorrectly, a summarized section) gets flagged explicitly in the output rather than presented as equally reliable as the rest of the content
* When in doubt about whether something was preserved correctly, say so rather than asserting fidelity that hasn't actually been checked

## Verify the Trade Wasn't Net-Negative

* A token reduction that requires the model to do extra inferential work to recover dropped structure, or that introduces a risk of misreading an ambiguous flattened value, can cost more in accuracy than it saved in tokens — weigh this explicitly rather than treating token count as the only success metric
* If a task later produces errors traceable to a digitization or optimization step, treat that as a signal to revisit this pipeline's choices for that source type, not just a one-off mistake to patch silently

## Final Sign-Off

Only mark content "ready for model input" once:

* Extraction fidelity has been spot-checked against the source
* Structure that matters to the task has been confirmed intact
* Everything cut during optimization has been reviewed as genuinely non-critical
* Any remaining uncertainty is flagged explicitly, not silently absorbed into the output

## Deliverables (Exit Criteria for This Step)

- [ ] High-stakes values spot-checked against the original source
- [ ] Table/structural integrity confirmed post-conversion and post-optimization
- [ ] Everything cut during token optimization reviewed as genuinely non-critical to the task
- [ ] Remaining uncertainty explicitly flagged in the output, not silently resolved
- [ ] Content only marked "ready for model input" after all of the above are checked, not by default
