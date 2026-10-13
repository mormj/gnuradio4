# Concurrency and coordination

## Purpose

Establish whether reachable overlapping actions preserve ordering and shared invariants. ID: `concurrency-coordination`.

## Applicability signals

Shared state, async callbacks, locks, task dispatch, atomic operations, cancellation, or coordination between processes/services.

## Questions

- Which actors access the same object, and what ordering is actually guaranteed?
- Does protection span acquisition, reservation, use, publication, and final release?
- Can reentrancy, lock ordering, or completion callbacks cause a forbidden overlap or deadlock?

## Trace techniques

Write a short event sequence for each actor and mark synchronization edges. Follow references beyond lock scopes and callbacks beyond scheduling. Identify the exact missing ordering and forbidden result.

## Useful verification

Use bounded barrier-controlled overlap or fault injection representing a feasible schedule. Capture the invariant failure. Use available race/deadlock instrumentation as supporting evidence, with recorded environment and outcomes.

## Common false positives

An object is confined to one actor, an external lock covers the operation, ownership prevents overlap, or work is queued but not executing. Missing race tooling is not evidence of a race.

## Disproof checks

Inspect callers, scheduler guarantees, ownership transfer, and lock ordering beyond the snippet. Prove that the proposed schedule is executable. Check whether instrumentation created the overlap rather than exposed it.

## Escalation triggers

Challenge changed lifetime/synchronization, callbacks under locks, resource replacement, or cross-service ordering assumptions.

## Completion evidence

Record actors, object lifetime, ordering guarantees, feasible schedule or static proof, forbidden outcome, and probe limits. Finite passing stress runs do not prove race freedom.
