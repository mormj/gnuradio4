# Correctness and data semantics

## Purpose

Trace whether representations and transformations preserve the promised result. ID: `correctness-data`.

## Applicability signals

Changed calculations, indexing, filtering, ordering, framing, serialization, or input validation.

## Questions

- Do units, lengths, offsets, and capacities refer to the same representation, including headers and metadata?
- Can conversion, truncation, overflow, empty data, or a partial result change the meaning?
- Does aggregate accounting lose information about positions, ordering, duplicates, or special entries?

## Trace techniques

Follow one value from input through each representation to its consumer. Write the invariant and track intermediate sizes/units. Compare mixed sequences with homogeneous ones; inspect alternate entry points.

## Useful verification

Use a contract-derived oracle or independent reference result. Exercise empty, single, awkward-boundary, mixed-order, and partial inputs relevant to the change. Compare target and baseline with identical support code.

## Common false positives

An impossible input type, a range constrained upstream, intentional lossy conversion, or an ordering contract that differs from intuition.

## Disproof checks

Read caller constraints and downstream normalization. Verify the proposed input is constructible and reaches the operation. Check whether an accepted format/contract permits the result. Narrow an arithmetic concern to an actual supported range.

## Escalation triggers

Challenge changed size calculations, persisted encodings, mixed-entry accounting, or a shared transform with multiple consumers.

## Completion evidence

Record the affected invariant, reachable boundaries traced, oracle/check outcomes, and any unverified range. Passing ordinary values alone does not close a boundary-dependent claim.
