# GNU Radio 4 repositories

The GNU Radio 4 superbuild containing `.review/SKILL.md` is the framework home. On this deployment it is `/home/josh/gnuradio/gnuradio4-review`. Its verified upstream identity is `https://github.com/gnuradio/gnuradio4`. Derive paths from that root, not from the old standalone framework or a neighboring SDK installation.

## Repository map

All first-party repositories below are under `https://github.com/gnuradio/`. Default locations in the table are relative to the superbuild. Relative `SOURCE_DIR` entries in the manifest resolve under the effective `GR4_SOURCE_ROOT`, which defaults to `<superbuild>/src`. The manifest, local overrides and effective CMake cache decide the actual path and clone URL; verify each checkout's remotes before using it.

| Repository | Default location | Responsibility and dependency direction |
| --- | --- | --- |
| `gnuradio4` | Superbuild root | ExternalProject orchestration, profiles, shared install prefixes, integration tests, CI and containers. |
| `gnuradio4-core` | `src/gnuradio4-core` | Runtime, graph/block model, schedulers, registries, plugins, installed SDK and registration generator. |
| `gnuradio4-library` | `src/gnuradio4-library` | Reusable DSP algorithms/support libraries; consumes installed Core. |
| `gnuradio4-blocks` | `src/gnuradio4-blocks` | Standard DSP/utility blocks; directly requires installed Core, Library and Core's `GnuRadioBlockLib` package. |
| `gr4-incubator` | `src/gr4-incubator` | Experimental blocks, schedulers and utilities; built after Blocks and its upstream stack in full profiles. |
| `gnuradio4-control-plane` | `src/gnuradio4-control-plane` | Runtime/HTTP service; compiles against Core. Scheduled after Blocks for the runtime plugin catalog. |
| `gnuradio4-studio` | `src/gnuradio4-studio` | One checkout supplies `gnuradio4-studio-blocks` from `blocks/` and the Node browser/desktop application. Studio blocks follow Blocks; the application follows its source provider and optionally Control Plane, with HTTP/WebSocket integration. |

Sources: [modules.cmake](../../modules.cmake), [DESIGN.md](../../DESIGN.md), [module configuration](../../docs/modules.md); `gnuradio4-library:CMakeLists.txt`, `gnuradio4-blocks:CMakeLists.txt`, `gnuradio4-control-plane:CMakeLists.txt`. Component source citations throughout `project/` use `repository:path`, resolved through this table and the revision scope below.

Additional OOT repositories participate only when named by the task, a prerequisite or the actual `projects.local.cmake`/`GR4_EXTRA_PROJECTS` configuration. Inspect their registered ownership/dependencies; do not add unrelated sibling checkouts to a review. The extra-project shortcut builds after Blocks but does not register tests. [Extending guide](../../docs/extending.md).

## Locate and pin actual sources

Inspect `modules.cmake`, optional `projects.local.cmake`, `CMakeUserPresets.json`, and `build/<profile>/CMakeCache.txt` when present. Record effective `GR4_SOURCE_ROOT`, module selection and `GR4_<KEY>_REPOSITORY/REF` overrides. Keys include `CORE`, `LIBRARY`, `BLOCKS`, `INCUBATOR`, `CONTROL_PLANE`, and `STUDIO`; Studio's CMake options key is `STUDIO_BLOCKS`.

Missing repositories are cloned at configured refs (normally `main` in the verified manifest) by the source targets. Existing checkouts are never fetched, switched or reset by reconfiguration/build. A configured `REF` is therefore not proof of the revision in use. Record `git rev-parse HEAD`, remote identity and `git status --short` for every participating checkout; capture patch/untracked content digests if deliberately included. Prefer isolated review checkouts to incorporating user edits. See [inspect-superbuild-state](build.md#inspect-superbuild-state) and [obtain-sources](build.md#obtain-sources).

The first-clone script uses a depth-one fetch and detached checkout. A review needing history must fetch the relevant refs/history, including unshallowing when necessary; incomplete local ancestry is not evidence that a parent is absent. The superbuild is not a submodule lockfile. Source: [CloneIfMissing.cmake](../../cmake/CloneIfMissing.cmake), [CMakeLists.txt](../../CMakeLists.txt).

## Resolve review snapshot

Set `GR4_COMPONENT` from the requested repository and `GR4_PR` from the request. For first-party upstream PRs, the owner is `gnuradio`; respect an explicitly supplied fork/namespace. Read-only examples, using `gh` if available:

```sh
gh api "repos/gnuradio/$GR4_COMPONENT/pulls/$GR4_PR"
gh api --paginate "repos/gnuradio/$GR4_COMPONENT/issues/$GR4_PR/comments"
gh api --paginate "repos/gnuradio/$GR4_COMPONENT/pulls/$GR4_PR/reviews"
```

Equivalent available hosting connectors or GitHub REST reads are sufficient; do not install a CLI just to use these snippets. For example, public metadata is at `https://api.github.com/repos/gnuradio/<component>/pulls/<number>`. Check response status and pagination and retain source/time. Fetch head/base objects from the returned repository URLs/refs, verify their SHAs, and work in isolated refs/worktrees without overwriting user branches. A failed or rate-limited API call is a limitation, not a reason to fabricate metadata. Do not request routine metadata from the user if another normal access path works.

## Stacks and cross-repository prerequisites

**Documented coordination:** open component PRs first, link them from the workspace PR, describe the required branch/commit combination, and test that combination. Manual superbuild CI accepts repository/ref overrides on fresh sources. Sources: [CONTRIBUTING.md](../../CONTRIBUTING.md), [CI guide](../../docs/ci.md), [integration workflow](../../.github/workflows/ci.yml).

**Review inference procedure:** no universal stacked-branch naming rule was established. Read intended-parent/prerequisite links, relevant maintainer clarifications, ancestry and commit correspondence. Use `git merge-base`, `git log` and, for rewritten parents, `git range-diff`. Shared ancestry alone is insufficient. Keep four distinct facts:

| Fact | Contract location |
| --- | --- |
| Reviewed increment and actual diff endpoints | `target`, `base`, `comparison_strategy` |
| Declared base, evidenced parent and inherited behavior | `comparison_strategy.details.declared_base`, `intended_parent`, `inherited_changes` |
| Ultimate destination and actual integration result/state | `comparison_strategy.details.ultimate_destination`, `integration_result`, `integration_state` |
| Cross-repository prerequisite PRs, source pins and artifacts | `related_repositories`, with URLs and required merge/artifact state |

Choose contribution, stack increment, direct endpoints, integration result or closure according to the [shared comparison rules](../REVIEW-GUIDELINES.md). Parent-versus-child and destination-plus-child answer different questions. Conflict simulation is not compiled integration. Test parent and child with the same dependency environment when that distinguishes attribution; add version combinations only for applicable contracts or discriminating controls, not a Cartesian matrix by default.

Inspect prerequisite merge state, destination conflicts, required checks and [SDK publication](build.md#inspect-artifact-provenance) separately. A technically sound child can still need to wait. Recheck moving refs before handoff; results remain tied to their pinned snapshot.

## Source scope of persistent references

Verified superbuild files on 2026-09-10: `d91035446028b1c4a85a340d1560812c01fcf736` in this target. Component facts were preserved from the earlier source-backed capture at these revisions; their objects are available in the original workspace. These are reference scopes, **not pins for future reviews**:

| Repository | Reference revision |
| --- | --- |
| Core | `19e91f459707da227625f783b32c89b31122a4b4` |
| Library | `3e4d2211f495d205ecac4f8137ecf528f34a489d` |
| Blocks | `db49cd2e0690f33264a7807bdcf1048ae8fc7729` |
| Incubator | `dd31b1ade39b74d5703d04d94c4cc196a86a44b0` |
| Control Plane | `9d45d33c08feed0d49c9a8d5ede3e68277732b45` |
| Studio | `a8944dcf91eaf2900cb601a8892dea6bc40bcaa8` |

Revalidate relevant files at actual review revisions. Historical review conclusions are not sources of project policy. At migration the target had no `src/`, `build/`, `install/` or previous `.review/`. The earlier capture observed an SDK at `/home/josh/gnuradio/gnuradio4/install/full`, activated by that workspace's `build/full/activate.sh`, with unverified source/artifact correspondence. This is a dated environment observation, not the SDK selected for this deployment. Tool availability, including `gh`, must be checked per session.

## Short-request walkthrough

For `Review PR #27 in gnuradio4-blocks as a maintainer.`, a session using [SKILL.md](../SKILL.md) anchors at this superbuild, maps Blocks through the manifest/source root, obtains missing sources and PR metadata, pins the head, and resolves the comparison using the stack procedure above. It reads the controlled build/SDK and testing references, retains `GR4_BUILD_PARALLEL_LEVEL=4`, selects applicable checks, creates a unique `.work/reviews/<run-id>/` directory for the contract, ledger, report, evidence, and review-local work, then begins the maintainer method. No lookup or review of that PR is part of this walkthrough.

Remaining per-review discoveries are head/base SHAs and metadata, parent/inherited/destination relationships, prerequisite source revisions and merge state, actual local modifications/configuration/tool availability, installed/CI artifact provenance, applicable checks and protected-branch state, integration results, and execution or policy limitations. Routine details are retrieved, not turned into a user questionnaire.
