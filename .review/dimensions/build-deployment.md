# Build, packaging, and deployment

## Purpose

Assess effective build/install behavior in supported configurations. ID: `build-deployment`.

## Applicability signals

Dependency declarations, feature gates, build graph, exports, generated configuration, installation, loading, or platform support changes.

## Questions

- Do disabled features still require or export optional dependencies?
- Do generated commands/configuration honor caller overrides and select the intended headers/artifacts?
- Can an installed consumer build/load/run without accidental source-tree or environment dependencies?
- Are host tools confused with target tools, or isolated-head results presented as integrated validation?

## Trace techniques

Read supported recipes and inspect effective outputs, command ordering, exports, and artifact provenance. Follow configure → build → install → consumer use; identify where each guarantee is established.

## Useful verification

Test affected enabled/disabled settings and risk-selected supported matrix cells. Build a consumer from the installed output in a clean environment. Pin container/artifact identities where applicable.

## Common false positives

Unsupported platforms, unavailable tools, stale installed dependencies, moving image tags, or imposing a packaging policy the project never promised.

## Disproof checks

Verify support policy, dependency identity, feature gates, and effective flags. Compare baseline in the same environment. Trace the first actionable diagnostic before counting cascades as separate causes.

## Escalation triggers

Challenge package exports, toolchain/dependency changes, feature defaults, deployment paths, or multi-repository integration.

## Completion evidence

Record tested cells, actual stages completed, source/artifact identities, commands, and excluded/unavailable configurations. Configure success alone is not a build result.
