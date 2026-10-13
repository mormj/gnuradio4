<!-- Reviewer writes this concise user-facing artifact as REVIEW.md in the unique <superbuild>/.work/reviews/<run-id>/ directory. -->
# Review — {change / pinned snapshot}

Profile/mode: {profile / mode}. Reviewed {repository and target revision} against {base revision}, using {comparison kind and actual endpoints}. Scope: {affected behavior and material exclusions}. Contract/ledger: {artifact references}.

Assessment: {technical conclusion and rationale}. For merge reviews, state integration/dependency readiness and policy/verification obligations separately. Recommendation: {merge / request changes / wait / inconclusive, only if assessed}. Review completion: {stopping state}.

## Findings

### {C1} — {Blocker or Significant}: {behavioral title}

{Location/change and expected contract/source}. When {admissible trigger}, {path} causes {mechanism}, resulting in {observable consequence}. {Key evidence and why the material alternative explanation was ruled out}.

Verification: {executed result/control or static proof; reproduction/regression route and limits}. Impact: {level and rationale}. Confidence: {level and rationale}. Merge consequence/action: {required correction or why non-blocking}.

## Decisions, follow-ups, and dependencies

{Only meaningful items: ID/category, contract or concrete work, alternatives/next step, authority/prerequisite, and merge consequence. No speculative defects disguised as decisions.}

## Validation and limitations

{Meaningful checks actually run, selected configurations, execution counts/skip facts where relevant, and evidence links. State material unavailable/not-run checks, unresolved risks, stale-snapshot limits, and how each limits the conclusion. Name the next useful verification step.}

<!-- Editing instructions: remove these instructions, unused sections, and placeholder content.
For zero findings, replace Findings with one sentence such as "No supported findings within the reviewed scope."
Do not imply overall correctness or merge readiness beyond the checks and scope.
Omit disproven/duplicate candidates, generic checklists, unsolicited nits, and large logs.
Keep enough causal evidence in each finding to understand it without reconstructing the ledger.
-->
