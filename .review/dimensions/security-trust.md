# Security and trust

## Purpose

Connect actor-controlled input or actions to a reachable unsafe effect. ID: `security-trust`.

## Applicability signals

Inputs, parsers, identity/permissions, filesystem/network access, process execution, secrets, privilege, or dependencies change.

## Questions

- What can the actor control, under which authentication and authorization, and which asset is at risk?
- Can normalization, parsing, redirects, links, races, or alternate entry points bypass validation or confinement?
- Are size arithmetic, recursion, allocations, fan-out, and work bounded before expensive operations?
- Can secrets escape through logs/errors, or dependencies change privileges or exposed behavior?

## Trace techniques

Map actor → entry → guards → transformations → sink → asset. Follow authorization at the operation itself, not just a UI/caller. Identify deployment assumptions and effective permissions. For dependency claims, match exact versions, affected behavior, and actual reachability to authoritative evidence.

## Useful verification

Use bounded local malformed, oversized, unauthorized, path, or destination inputs with valid controls. Demonstrate the unsafe effect or complete static path without touching external targets or real secrets.

## Common false positives

An alarming API behind effective guards, unreachable dependencies, assumed attacker privileges, or treating every parser error as an exploit. Valid-input-only contracts do not excuse reachable malformed-input hazards at trust boundaries.

## Disproof checks

Inspect alternate guards, effective sandbox/permissions, normalization order, actor capability, supported configurations, and dependency provenance. Verify the alleged bypass reaches the sink and affects the asset. Narrow impact to what evidence establishes.

## Escalation triggers

Challenge new trust crossings, privilege changes, unsafe execution, unbounded input/work, and check/use races.

## Completion evidence

Record actor capability, guards, reachable path, unsafe consequence, controls, existing mitigations, and remaining exposure uncertainty.
