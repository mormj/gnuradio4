# Lifecycle, state, and progress

## Purpose

Follow legal transitions and progress through normal, stalled, and terminal operation. ID: `lifecycle-state-progress`.

## Applicability signals

Initialization, activation, queues, retries, streaming, backpressure, cancellation, EOS, stop/restart, or deferred publication.

## Questions

- What proves ready, executing, drained, stopped, or released—and are those distinct states?
- Are zero/partial progress bounded, and does resumption preserve pending data and accounting?
- Can repeat activation, cancellation, EOS, or retry lose, duplicate, reorder, or prematurely reset state?

## Trace techniques

Sketch relevant states/transitions and track pending versus published values. Follow blocked and empty-output paths as well as success. Derive shutdown ordering from the project invariant, not a universal sequence.

## Useful verification

Exercise start/use/stop, repeated transitions, error/retry, zero/partial/slow progress, and EOS while backpressured where relevant. Assert observable readiness and final accounting with bounded waits.

## Common false positives

Confusing events with value changes, assuming latest-wins semantics for a lossless queue, or treating connection/worker completion as application readiness.

## Disproof checks

Read transition guards, scheduler/caller guarantees, and event/coalescing contracts. Check alternate entry and initialization paths. Determine whether the harness stopped waiting for the wrong predicate.

## Escalation triggers

Challenge new terminal paths, recovery after partial progress, asynchronous release, and state shared between generations.

## Completion evidence

Record the transitions traced, readiness/completion predicates, sequence cases and results, and unverified terminal paths. A happy-path loop is not lifecycle coverage.
