# Review work ledger

Contract: `review-contract.yaml` · Reviewed snapshot: {identity} · Framework/profile: {identity}

Internal work artifact. Follow the shared method; keep observations separate from inference. Duplicate the small records below only when useful. Delete starter rows/text rather than carrying empty boilerplate. No candidate count is required.

## Change, coverage, and plan

Intended before/after behavior: {summary and contract sources}

Affected surfaces/dependencies: {bounded map, including public boundaries and trust boundaries when security analysis is in scope}

| Dimension / surface | Depth or scope status | Reason | Completion / evidence |
| --- | --- | --- | --- |
| {ID / surface} | {screen / trace / challenge / not_applicable / out_of_scope} | {risk or exclusion} | {pending / complete_for_scope / limited; references; no completion obligation for out_of_scope} |

Next discriminating checks and budget: {purpose, prerequisites, oracle, bounded repetitions if relevant}

## Check V1 — {purpose}

- Source/dependency/environment identities; working directory: {facts or contract references}
- Command/procedure: {exact invocation, relevant redacted flags/environment}
- Expected result and execution oracle: {cases/property/control}
- Status: {passed / failed / skipped / blocked_environment / not_run}
- Actual result, exit status, executed/skipped counts or equivalent evidence: {observation}
- Controls/repetitions: {all outcomes, seeds/schedules, differences, or not applicable}
- Evidence: {small excerpt and artifact reference}; limitations: {what this does not establish}

## Candidate C1 — {suspected behavior}

- Status: investigating
- Location/change and attribution: {repository/revision/path/symbol; introduced / newly_exposed_or_worsened / incomplete_fix / inherited / unknown}
- Expected contract/invariant: {statement and source}
- Admissible trigger: {input/state/configuration/actor; reachability}
- Path and mechanism hypothesis: {ordered operations and failed guarantee}
- Observable consequence: {expected versus actual; affected users/assets}
- Evidence: {source traces, V IDs, artifacts; distinguish inference}
- Counterevidence: {facts that weaken or contradict the hypothesis}
- Disproof attempts: {decisive caller/guard/lifetime/contract/environment/dependency/control checks and results; irrelevant alternatives and why}
- Verification: {executed or proposed reproduction/regression, specific oracle and controls; reason if no execution}
- Confidence: {high / medium / low, supported scope and uncertainty}
- Root cause / duplicate: {primary dimension, other tags, related candidate IDs}
- Final disposition: {supported / disproven / unresolved / duplicate, why; category, impact, merge consequence and action if published}

## Decisions, prerequisites, closure, and limits

Record only material items with IDs: {question/alternatives/authority; prerequisite state; prior finding closure evidence; unknown and next verification step}. A disproven candidate stays in this ledger, not the report. Accepted intentional behavior can disprove the alleged violation even when the behavior itself was observed.

## Handoff

Stopping state and reason: {complete_for_scope / complete_with_limitations / blocked_at_setup}

Freshness: {last checked refs/dependencies and whether they still match the contract}

Diagnostic artifacts/modifications: {retained evidence locations and disposition of review-owned edits; preserve user changes}
