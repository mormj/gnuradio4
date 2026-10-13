# Documentation and migration

## Purpose

Assess whether consumers can understand and carry out required behavior changes. ID: `documentation-migration`.

## Applicability signals

Public behavior, defaults, deployment requirements, compatibility commitments, or migration steps change.

## Questions

- Which user/operator action now differs, and do instructions describe that difference accurately?
- Are migration prerequisites, version order, persisted-data effects, and supported rollback stated where needed?
- Does an example or public promise contradict the effective implementation?

## Trace techniques

Follow one affected user task from documented input through current behavior. Map each breaking change to an accepted decision and a migration path. Distinguish essential instruction gaps from wording preferences.

## Useful verification

Walk the documented procedure using a disposable supported configuration where practical. Check example inputs/outputs and version boundaries; verify safety of rollback claims before relying on them.

## Common false positives

Undocumented private details, intentional accepted breaks, duplicate documentation already maintained elsewhere, or stylistic preferences framed as engineering risks.

## Disproof checks

Search the relevant public documentation and accepted migration record. Verify the reader population and affected action. Check whether a linked procedure supplies the missing prerequisite and still applies to this revision.

## Escalation triggers

Challenge irreversible format migrations, ordered multi-component upgrades, changed security defaults, or inaccurate recovery instructions.

## Completion evidence

Record the affected user task, contract/decision source, instruction mismatch or verified procedure, and remaining migration questions.
