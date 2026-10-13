# Errors and recovery

## Purpose

Assess whether failures preserve contracts and recover without unsafe partial effects. ID: `errors-recovery`.

## Applicability signals

Return/error handling, exceptions, rollback, retries, fallback, timeouts, destructors, or cleanup changes.

## Questions

- Can an error become silent success or cross a boundary that cannot accept it?
- What side effects remain after partial failure, and is retry safe or duplicate-producing?
- Are retry limits, progress resets, fallbacks, and error attribution consistent across paths?

## Trace techniques

Follow each changed failure from origin through caller handling and cleanup. Track committed versus pending effects. Inspect recovery after both early and late failure, including cleanup itself failing.

## Useful verification

Inject failures at meaningful operation boundaries. Check the specific error, retained state, bounded retries, and subsequent operation. Use an oracle that distinguishes the intended failure from unrelated setup errors.

## Common false positives

Errors deliberately handled at a higher layer, idempotent effects mistaken for duplicates, or a test entering any error state for the wrong reason.

## Disproof checks

Inspect outer handlers and rollback guarantees. Compare baseline environment failures. Verify the same operation is retried, the side effect is observable, and the recovery contract requires different behavior.

## Escalation triggers

Challenge partial commits, cleanup during unwinding, retry loops, and fallback across security or version boundaries.

## Completion evidence

Record reachable failure paths, side effects, caller-visible result, recovery limits, and targeted failure/control outcomes.
