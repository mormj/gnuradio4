# Architecture and integration

## Purpose

Assess responsibility placement and the effects of changed contracts across components. ID: `architecture-integration`.

## Applicability signals

New dependencies, shared helpers, moved responsibilities, alternate implementation paths, or coordinated repository changes.

## Questions

- Which component owns the invariant, and can another path bypass it?
- Are producers and consumers updated under compatible deployment/version assumptions?
- Does a new dependency or duplicated rule create a concrete inconsistency or foreseeable maintenance failure?

## Trace techniques

Map changed entry points to immediate producers/consumers and relevant dependency versions. Follow one end-to-end operation. Compare alternate paths that implement the same guarantee; stop at the affected boundary.

## Useful verification

Exercise the actual cross-component operation or installed consumer. For coordinated changes, compare supported matched and skewed versions. Check an integration result separately from each isolated head.

## Common false positives

Disliking an abstraction, mistaking a deliberate migration for inconsistency, or assuming an unmerged dependency is present. A large diff alone is not an architectural defect.

## Disproof checks

Read ownership/design decisions and actual consumers. Establish whether the supposedly bypassing path is reachable. Check if a shared layer already enforces the invariant or if a coordinated deployment is explicitly required.

## Escalation triggers

Challenge cross-repository contracts, central helper changes, cyclic responsibilities, and new version skew. Use a Decision for a material unresolved policy choice.

## Completion evidence

Record the affected component map, version/deployment assumptions, traced integration path, and unresolved prerequisite. Maintainability claims need a concrete consequence, not a preferred pattern.
