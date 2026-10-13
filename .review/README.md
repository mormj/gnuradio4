# GNU Radio 4 Agentic Code Review

From the GNU Radio 4 superbuild workspace, using [SKILL.md](SKILL.md):

```text
Review PR #27 in gnuradio4-blocks as a maintainer.
```

Also supported:

```text
Review PR #17 in gnuradio4-core as a developer.
Perform a security review of PR #42 in gnuradio4-library.
```

The reviewer knows the GNU Radio 4 project family from this framework. It resolves the component, retrieves PR metadata, pins the intended comparison and dependencies, chooses checks, and generates its review contract. Users normally supply only the change, profile and unusual constraints.

**Simplify what the user has to provide, not what the reviewer has to establish.**

| Profile | Question |
| --- | --- |
| [Maintainer](profiles/maintainer.yaml) | Should this change merge? |
| [Developer](profiles/developer.yaml) | Does the implementation behave correctly under realistic and edge conditions? |
| [Security](profiles/security.yaml) | Can reachable untrusted input or control cause unsafe behavior? |
| [Thorough](profiles/thorough.yaml) | What survives the combined assessment and relevant integration checks? |

Maintainer reviews cover merge concerns and exclude cybersecurity review by default. They still check ordinary correctness, input validation, resources, and reliability. Request security analysis explicitly, or use the security or thorough profile, to include cybersecurity coverage.

All four follow [one methodology](REVIEW-GUIDELINES.md) and the same evidence standard. [Dimensions](dimensions/index.yaml) organize investigation at Screen, Trace and Challenge depth. Every serious candidate requires a disproof pass, regardless of profile or depth. Unsupported suspicions remain in the ledger; the report contains supported findings and material decisions or limitations. Zero-finding reviews are explicitly valid.

Persistent GNU Radio knowledge lives in:

- [repositories.md](project/repositories.md): identities, source locations, dependency direction, stack discovery and source provenance.
- [architecture.md](project/architecture.md): installed package boundaries, lifecycle and GR4 trust surfaces.
- [build.md](project/build.md): controlled SDK, activation, superbuild recipes, artifact identity and the four-job limit.
- [testing.md](project/testing.md): focused/component/integration checks, installed consumers and runtime discovery.
- [policies.md](project/policies.md): documented policy, discovered engineering invariants and per-review state.

The reviewer generates `review-contract.yaml`, `candidate-ledger.md` and `REVIEW.md` in a unique `<superbuild>/.work/reviews/<run-id>/` directory. Detailed evidence stays alongside them, while temporary sources, worktrees, build trees, install prefixes, probes, and logs stay below that run's `work/` directory instead of `/tmp`. The repository ignores `.work/`; review artifacts are not committed automatically. Review completion, technical assessment, integration readiness and pending obligations remain separate.

The canonical deployment is `/home/josh/gnuradio/gnuradio4-review/.review/`. The directory is self-contained; keep its relative layout intact. In a session that has not loaded the skill, the one-time entry instruction is:

```text
Read .review/SKILL.md and use it for GNU Radio 4 reviews in this session.
```

No installer or automatic skill registration is provided. Once the session uses that entry point, the short request above is complete. Missing component checkouts can be obtained from the manifest; a fresh superbuild checkout need not already contain `src/` or an SDK. The [build guide](project/build.md) explains that first-use case.

For an explicit snapshot or closure review, the user may supply a saved contract, exact comparison, output path or budget. Those are optional overrides. The reviewer still verifies identities and records limitations.

The [contract schema](schemas/review-contract.schema.json) is GR4 v0.2. It removes the old `project_overlay` field; `framework_revision` now identifies the complete methodology and persistent project references. It can validate YAML parsed with an existing JSON Schema draft 2020-12 validator. Validation checks structure, not ancestry or causality. Profiles and the dimension catalog retain their v0.1 data format; profiles may specify `excluded_dimensions` as described in the shared method.

Migration retained the methodology, four profiles, twelve dimensions and three artifact templates. The former project facts and recipes became `project/`; operational adapter guidance was folded into the method and repository/build references. No overlay schema, configuration, generic examples or composition step is used. `ARCHITECTURE.md`, `DISCOVERY.md`, `inputs/`, the original overlay and teaching examples remain preserved in the old `gnuradio4-code-review` checkout as historical material; this deployment does not depend on or load them.

For the dry invocation walkthrough, see [repositories.md](project/repositories.md#short-request-walkthrough). No PR was retrieved or reviewed during this migration.
