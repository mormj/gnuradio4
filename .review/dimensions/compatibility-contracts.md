# Compatibility and public contracts

## Purpose

Test changes against the compatibility actually promised to consumers. ID: `compatibility-contracts`.

## Applicability signals

Added or removed APIs, binary layouts, wire/stored formats, settings, names, defaults, CLI behavior, or admission rules.

## Questions

- Which source, binary, data, protocol, or deployment compatibility is promised, to whom and for how long?
- Can an old consumer be admitted and then misinterpret the new behavior?
- Do all creation/load/replace paths honor explicit versions and migration decisions?

## Trace techniques

Inventory the changed public surface, including additions and incidental exported helpers. Trace version selection, admission, interpretation, and teardown. Separate source compatibility from binary and behavioral compatibility.

## Useful verification

Use old/new consumer-provider pairs required by policy, with matched-version controls. Load prior stored data and inspect migration output. Test installed interfaces where in-tree builds hide exports or implicit dependencies.

## Common false positives

A deliberate accepted break, private implementation changes, unsupported historical versions, or assuming rebuilt-together tests prove compatibility with old artifacts.

## Disproof checks

Verify the public promise and actual supported versions. Inspect rejection guards and migration paths. Check that old test artifacts really contain the old interface and were not silently rebuilt or replaced.

## Escalation triggers

Challenge admission of old binaries/data, changed defaults with persistent effects, and separately deployed consumers.

## Completion evidence

Record the promise/source, affected consumers, tested version pairs and controls, and required migration decisions. A layout difference alone is not proof of a particular runtime crash.
