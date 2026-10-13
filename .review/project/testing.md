# GNU Radio 4 checks and test recipes

Select checks from changed behavior, the chosen profile/depth, documented obligations and the actual CI/configuration. Start with the smallest discriminating test; broaden for shared mechanisms, affected consumers, new failures or required integration. Do not run full expensive matrices by default. Every recorded check needs actual execution evidence, a relevant oracle, identities and limitations under the [shared method](../REVIEW-GUIDELINES.md).

Run commands from the chosen superbuild root after the corresponding [build](build.md) and activation. Below, `GR4_COMPONENT` is an actual module target, and `GR4_TEST_REGEX` comes from affected test definitions and CTest inventory. Replace `dev` paths consistently for another configured profile or isolated build directory.

## Test-enablement

**Version-scoped engineering fact:** at superbuild `d91035446028b1c4a85a340d1560812c01fcf736`, first-party entries in [modules.cmake](../../modules.cmake) have no `TESTS`. [CMakeLists.txt](../../CMakeLists.txt) passes `ENABLE_TESTING=OFF` unless `TESTS` and `GR4_BUILD_TESTING` are both enabled. The later per-component `GR4_<KEY>_CMAKE_ARGS` can override that OFF value for component QA. See [configure-superbuild](build.md#configure-superbuild).

Enabling tests through that override does **not** register them in outer `check`; run the child CTest tree explicitly. The current `check` is an installed integration gate, with optional explicitly registered local-module tests. Some README/DESIGN wording describes broader QA than the current manifest supplies. Prefer effective generated commands and [testing.md](../../docs/testing.md)/[modules.md](../../docs/modules.md), and record scope accurately. `check` also does not depend on every selected full module: build the selected full stack separately when claiming full-stack build coverage.

At the preserved Blocks reference revision, audio, SDR and HTTP tests default OFF; ZeroMQ defaults ON. Enable affected optional families with the corresponding component arguments and verify their prerequisites and actual collection. Do not infer a feature was compiled just because configuration accepted an option. Sources: `gnuradio4-blocks:CMakeLists.txt`, `README.md`, `.github/workflows/ci.yml`.

## Focused-tests

After building the affected component with testing enabled:

```sh
ctest --test-dir "build/dev/projects/$GR4_COMPONENT" -N
ctest --test-dir "build/dev/projects/$GR4_COMPONENT" -R "$GR4_TEST_REGEX" --output-on-failure --no-tests=error -j1
```

Use the inventory to choose actual tests. Record executed/skipped counts and relevant assertions; `-N` only lists tests and a zero-test success never satisfies validation. Preserve CTest timeouts; for a hang probe use a justified bounded timeout rather than an indefinite wait. Core lifecycle-related tests are defined in `core/test/CMakeLists.txt`; names/options may change at a reviewed revision.

## Component-suite

Run the broader affected suite when warranted, after the same build prerequisites:

```sh
ctest --test-dir "build/dev/projects/$GR4_COMPONENT" --output-on-failure --no-tests=error -j1
```

Repeat for relevant consumers only after rebuilding them with the contract's dependency combination. Component CI sets `DISABLE_SENSITIVE_TESTS=1` in the preserved workflows. Set it when reproducing that CI configuration, and record which cases are omitted; it is not a blanket exemption for an affected sensitive path. Hardware/network/fixture restrictions are limitations, not proof of defects or inapplicability. Do not invent recurring baseline failures from historical review reports.

## Installed-sdk-check

For changed public headers, exports, package dependencies or installed-consumer behavior:

```sh
cmake --build --preset dev --target oot-smoke
```

This builds/installs the base stack, configures the external `tests/oot-smoke` consumer against the prefix, builds it, and runs `installed_sdk_consumer`. Verify actual package/compile/link paths to exclude source-tree or stale-prefix contamination. The smoke finds `gnuradio4`, `gnuradio4Library`, `gnuradio4Blocks` and links Core, algorithm and math targets. Extend with an affected installed consumer when those targets do not cover the changed API. [Smoke definition](../../tests/oot-smoke/CMakeLists.txt), [superbuild target](../../CMakeLists.txt).

## Core-registration-install-check

After building native Core with the intended toolchain, in a disposable review workspace/prefix:

```sh
bash src/gnuradio4-core/test_external/run_installed_sdk_smoke.sh "$PWD/build/dev/projects/gnuradio4-core" "$PWD/install"
```

Resolve the script under the effective source root if customized. It installs Core and builds/runs external shared/static, collision and named-registry consumers. This exercises generated registration paths beyond a header compile. Inspect the script and effective compiler/flags; for a nondefault compiler or sanitizer, reproduce the matching component CI consumer flags rather than accepting a mixed-toolchain smoke result. For Emscripten use the workflow's cross-build/Node variant. Source: `gnuradio4-core:test_external/run_installed_sdk_smoke.sh`, `.github/workflows/ci.yml`.

## Integration-check

```sh
cmake --build --preset dev --target check
```

This is the selected integration gate, not a replacement for explicit component tests at the recorded manifest revision. Record exactly which targets and CTest cases ran. Source: [CMakeLists.txt](../../CMakeLists.txt), [project testing guide](../../docs/testing.md).

## Full-runtime-check

For affected application integration, plugin discovery, catalog or full module-manifest behavior, pin relevant full-profile sources, ensure Node.js 22/npm and local loopback sockets are available, then:

```sh
export CMAKE_BUILD_PARALLEL_LEVEL=4
cmake --preset full -DGR4_BUILD_PARALLEL_LEVEL=4
cmake --build --preset full
cmake --build --preset full --target check
source build/full/activate.sh
```

The explicit build covers selected full modules; `check` covers installed consumers and Control Plane integration. For only the installed service/catalog check on an already configured matching full tree, `cmake --build --preset full --target control-plane-smoke` builds its dependencies and runs the smoke directly. The script starts the installed server on a temporary loopback port, checks `/healthz` and nonempty `/blocks`, and stops it. It does not verify every changed block ID; add the relevant catalog/instantiation check and confirm plugin/library origins for those changes. [Control Plane smoke](../../tests/control-plane-smoke.sh), [target environment](../../CMakeLists.txt).

For top-level CI parity use `full-ci` and its paths/prefix, matching compiler/environment from [.github/workflows/ci.yml](../../.github/workflows/ci.yml). Component QA, including Studio lint/Vitest, remains owned by component CI. If Studio scripts change, inspect its actual `package.json` scripts and owning workflow and run applicable checks with the installed prefix; full `check` alone does not run them at this revision.

## Applicable recurring checks

| Check ID | When applicable | Procedure / expected evidence |
| --- | --- | --- |
| `affected-behavior` | Executable behavior changes | Focused-tests; broaden to component-suite for shared mechanisms. Specific expected behavior actually asserted. |
| `package-and-api` | Public API, generator, exports/install, dependency or ABI changes | Build affected downstream components; installed-sdk-check and/or core-registration-install-check, plus promised compatibility pairs. |
| `runtime-integration` | Plugin discovery/catalog, Control Plane or shared application integration | Full-runtime-check or targeted service smoke and affected plugin IDs, with artifact origins. |
| `stack-and-images-ready` | Same/cross-repository prerequisites or CI consuming changed SDK layers | Pin parent/dependency states, verify required image publication and downstream reruns, test the relevant integration result separately. |
| `repository-ci` | Owning repository workflows and branch rules | Current required DCO, formatting and applicable matrix/check results, tied to exact tested SHA and image identity. |

Put selected checks and applicability/exemptions in the generated contract. These IDs describe recurring considerations, not a requirement to execute every recipe on every PR. Sources and authority: [policies.md](policies.md), [build provenance](build.md#inspect-artifact-provenance), owning component workflows and current protected-branch metadata.

## Supported configurations and honest limits

Use the reviewed component's `.github/workflows/ci.yml` and `ci-main.yml` for actual compiler/platform/sanitizer cells. The captured Core/Library/Blocks PR workflows cover Ubuntu 24.04 GCC 14 Release, Ubuntu 26.04 GCC Release, Fedora 44 Clang Debug with AddressSanitizer, and Emscripten Release; main-branch matrices are broader. These are version-scoped CI configurations, not an indefinite support promise. Native evidence does not cover WebAssembly.

The captured Blocks Emscripten CI uses its Library SDK, `emcmake`, `/opt/gnuradio4` as both package/root path, the system Node emulator, and disables audio, SDR, ZeroMQ and HTTP tests for that cell. It also validates `test_external/minimal_consumer` against an installed Blocks prefix plus the SDK. Those cell-specific exclusions are not a global ban on other features/platforms. Follow the exact reviewed workflow when applicable.

The superbuild container guide distinguishes Debian Trixie as the stable Debian target and Sid as a rolling canary, with Ubuntu/Fedora verification images and Docker/Podman support. Retain digests for rolling-image observations. Missing available hardware, denied sockets, absent caches or tools, and skipped tests must be named explicitly. No general required TSAN or full-matrix-per-PR policy was established. [CI guide](../../docs/ci.md); component workflows at the [reference revisions](repositories.md#source-scope-of-persistent-references).
