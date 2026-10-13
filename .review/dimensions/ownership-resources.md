# Ownership and resources

## Purpose

Trace resource validity and release through every affected use. ID: `ownership-resources`.

## Applicability signals

Buffers, memory, files, sockets, tasks, registrations, borrowed objects, replacement, or deferred cleanup changes.

## Questions

- Who owns the resource before and after handoff, and can a reference escape that lifetime?
- Does every reachable failure/cancellation path release or transfer ownership exactly as required?
- Is release synchronous, and can immediate replacement/reuse conflict with unfinished cleanup?

## Trace techniques

Track acquisition → borrow/use → transfer/publication → final release. Include hidden reservations, callbacks, registries, and cleanup failures. Separate source identity from reused handle/address identity.

## Useful verification

Force relevant failures after acquisition and partial initialization. Probe replacement and cancellation with outstanding users. Measure live resources or use available lifetime tooling, recording the expected ownership invariant.

## Common false positives

Intentional bounded caching, externally owned resources, deferred-but-guaranteed cleanup, or alignment/type constraints that exclude a proposed object.

## Disproof checks

Inspect owner lifetime, escape constraints, cleanup completion semantics, and all transfer paths. Confirm a leak persists beyond intentional retention and affects a supported workload. Verify the proposed object is admissible.

## Escalation triggers

Challenge borrowed references across async boundaries, shared replacement, partially constructed owners, or unbounded retention.

## Completion evidence

Record ownership transitions, outstanding users at release, cleanup guarantees, and probes or static traces covering relevant exits.
