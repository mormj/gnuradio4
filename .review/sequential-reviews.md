# Sequential PR reviews

Use this workflow for an ordered or explicitly sequential batch, including PRs across GR4 repositories and batches mixing fresh reviews with replies to earlier reviews. The [shared methodology](REVIEW-GUIDELINES.md), selected profile and project guidance still apply to every PR; a batch does not lower their evidence standard.

## Queue and dependencies

Translate the request into an ordered queue of repository/PR/profile entries. Carry a batch-level profile across entries unless the user overrides it. Preserve the user's order and distinguish review order from required merge order: adjacent PRs are not automatically a stack or prerequisites.

Record explicit pairs, stack parents, cross-repository prerequisites and closure requests. Discover routine metadata and resolve comparisons normally. For a closure entry, read the posted review and replies, recover the old claim and regression route, and assess the current implementation; a reply alone does not close a finding. Keep historical findings out of unrelated fresh reviews.

Load shared framework references and discover the common environment once. Pin each PR's own head, destination, diff endpoints and dependency combination. Metadata retrieval may be batched; substantive PR investigation follows the queue. A later PR may reveal a dependency requiring a return to an earlier entry.

## Workspace and execution

Create a unique batch directory under `<superbuild>/.work/reviews/`, for example `batch-<UTC timestamp>-<suffix>`, and identify it to the user. Keep per-PR run directories with their contracts, ledgers and evidence using the usual [workspace layout](REVIEW-GUIDELINES.md#review-workspace-layout). The batch directory can link those runs; it does not replace their pinned records. Put shared disposable helpers under the batch's `work/` and retained shared evidence under its `evidence/`.

For each queue entry:

1. Establish its comparison, intended behavior, affected surfaces and bounded checks before forming conclusions.
2. Investigate the change, execute the selected checks and disprove serious candidates. Record the current disposition and remaining obligations before advancing. If access or execution is blocked, retain the specific limitation and continue independent entries rather than abandoning the batch.
3. Update the batch report with that PR's full review. Distinguish a supported defect from a pending prerequisite, an unperformed check or a setup failure. An unresolved candidate stays explicitly unresolved; advancing the queue does not resolve it.

Honor an explicit request for sequential work when choosing execution and delegation. Do not silently turn the batch into parallel PR investigations. Necessary paired integration can revisit already reviewed entries once their dependency snapshots are available; record it separately from the isolated-head checks.

Reuse build artifacts or test evidence only when their relevant source, dependency and configuration identities still match. A common SDK image is not proof that it contains a reviewed prerequisite. Rebuild changed runtime code with its headers, including externally instantiated conversions and shared layouts; a changed-header probe against an older library cannot establish that combination's runtime behavior. Preserve failed setup/mismatched-artifact attempts and explain why corrected runs are valid under the shared method.

When a later check exposes a defect fixed by another queued PR, record both the standalone-head result and the tested prerequisite combination. Make the resulting merge order explicit. A diagnostic correction demonstrates a cause; it does not mean the published PR already contains the fix.

## One complete batch report

The default user-facing deliverable is **`<superbuild>/.work/reviews/<batch-id>/REVIEW.md`**. References to `REVIEW.md` while working on this batch mean that report unless the user specifies another destination. Preserve an existing repository-root `REVIEW.md`; do not append the batch there by default.

Keep all review prose in the batch report, not just an index linking separate reports. Include:

- A short summary of required corrections and merge-order constraints.
- A table in review order with each PR, pinned head, technical assessment and material prerequisite or verification state.
- The full review for every PR: scope/comparison, supported findings with location and causal evidence, closure decisions, dependencies, checks actually executed and material limitations. Zero-finding entries still state what was assessed and validated.
- Shared environment/provenance and validation limits where they apply across the batch, with per-PR exceptions identified.

Per-PR reports may remain as supporting artifacts, but the user should be able to read the complete review in this one file. Link contracts, ledgers, probes and longer evidence instead of embedding internal ledgers or large logs. When consolidating reports, resolve relative links from the batch report's directory and preserve their targets. Avoid contradictory stale assessments when updating a section after further verification.

Before handoff, recheck all reviewed heads and material dependency states. Reassess affected entries if claiming a moved head; otherwise label the stale snapshot. Ensure every queued PR has a recorded assessment or an explicit setup limitation, reconcile shared findings without losing attribution, and apply the shared stopping rules. Summarize the actionable results in chat and link the batch report. Review authority still does not authorize publishing reviews, approving or merging.
