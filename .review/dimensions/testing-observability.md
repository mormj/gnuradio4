# Testing and observability

## Purpose

Determine what tests and diagnostics actually establish about the changed behavior. ID: `testing-observability`.

## Applicability signals

Behavior, tests, assertions, waits, fixtures, diagnostic output, metrics, or test configuration changes.

## Questions

- Did the intended cases execute, with prerequisites enabled and meaningful assertions?
- Does a negative test prove the intended mechanism or merely any failure?
- Does a wait observe application readiness, and can a timeout confuse completion with success?
- Do diagnostics distinguish relevant failures without leaking sensitive data?

## Trace techniques

Follow test setup, path activation, observation, assertion, and cleanup. Inspect collection/skips and effective configuration. Map each relevant assertion to the behavior it can actually falsify.

## Useful verification

Run the narrow selected cases and capture execution/skip counts. Where feasible, show the oracle fails on the bad behavior and passes on the fixed/control behavior. Record all results of bounded timing runs.

## Common false positives

Missing tests presented as proof of a production bug, zero-test command success, skipped interoperability, or assuming unit tests cover deployment/version skew.

## Disproof checks

Check fixtures, feature gates, permissions, specific failure reason, and baseline behavior. Verify that a supposed regression test did not pass because it bypassed the changed code or weakened its oracle.

## Escalation triggers

Challenge changed negative tests, shared wait helpers, coverage claims across version boundaries, or removal of a required oracle.

## Completion evidence

Record actual executed cases, supported property, oracle strength, limitations, and any demonstrable test-policy violation separately from runtime defects.
