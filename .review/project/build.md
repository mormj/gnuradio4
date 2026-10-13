# GNU Radio 4 build and SDK recipes

Recipes run from the chosen **superbuild root**, normally the parent of `.review/`, or an isolated checkout of its pinned revision. Set recipe variables from actual metadata/configuration. They are transparent commands, not a command runner. Follow task/host authority and preserve user sources and installations.

## Review-local paths

For a framework review, allocate all temporary sources, worktrees, build directories, install prefixes, probes, and logs beneath `<superbuild>/.work/reviews/<run-id>/work/` as defined by the [review workspace layout](../REVIEW-GUIDELINES.md#review-workspace-layout). Do not create review build trees in `/tmp`, and do not reuse the superbuild's ordinary `build/` or `install/` trees unless the verified existing tree is deliberately part of the review environment. Record the resolved paths in the contract and ledger.

## Controlled environment

**Review requirement:** use the project-controlled GR4 SDK/build environment. Do not install another GNU Radio 4, replace dependencies, install arbitrary system packages just to make a test pass, or bypass the superbuild when doing so changes the validity of the test. Use the superbuild for components that must be rebuilt in context. Missing tools/packages/network/container access are recorded limitations; project-documented containers and approved dependency caches are the normal alternatives.

Set the cache option **`GR4_BUILD_PARALLEL_LEVEL=4` on every superbuild configure**. Also export `CMAKE_BUILD_PARALLEL_LEVEL=4` for auxiliary CMake builds. The first name is a CMake cache variable: exporting only an environment variable named `GR4_BUILD_PARALLEL_LEVEL` has no effect at this revision. Outer `-j`, `--parallel`, and preset `jobs` do not limit nested compilation. Node/npm tools manage their own internal concurrency. [CMakeLists.txt](../../CMakeLists.txt), [build guide](../../docs/building.md), [design](../../DESIGN.md).

The base stack needs CMake 3.27+, Ninja, Git and C++23 (GCC 14+; GCC 15+ or Clang 20+ recommended by the build guide). Full profiles additionally need Node.js 22 and npm. Activation exposes an SDK; it does **not** select a compiler. Match the intended toolchain, flags and target, especially for sanitizers or WebAssembly.

| Profile | Build type / prefix | Review use |
| --- | --- | --- |
| `dev` | RelWithAssert / `install/` | Normal base-stack development; enable applicable child tests explicitly below. |
| `debug` | Debug / `install/debug/` | Debugging; warnings-as-errors off. |
| `release` | Release / `install/release/` | Performance/install checks; tests disabled by preset. |
| `asan`, `ubsan` | Debug / `install/<profile>/` | Relevant sanitizer diagnostics. |
| `offline` | RelWithAssert / `install/offline/` | Already-provisioned system dependencies; FetchContent disabled. |
| `ci` | RelWithAssert / `install/ci/` | Base-stack CI configuration. |
| `full`, `full-ci` | RelWithAssert / `install/<profile>/` | Adds Incubator, Control Plane, Studio. |

Sources: [CMakePresets.json](../../CMakePresets.json), [building.md](../../docs/building.md). Preserve profile-specific arguments, including full's Incubator plugin/warning choices; they are not blanket waivers for other repositories. Optional machine-local presets and manifests can alter the effective configuration. For macOS, follow `CMakeUserPresets.json.mac.example` and the documented Homebrew LLVM profiles; do not infer every platform is supported from portable-looking source.

## Inspect-superbuild-state

Before choosing build paths, inspect the manifest, presets, optional local overrides, caches and source identities. Example for an existing dev tree:

```sh
git remote -v
git rev-parse HEAD
git status --short
cmake --list-presets
rg -n 'GR4_|CMAKE_(INSTALL_PREFIX|PREFIX_PATH|CXX_COMPILER|TOOLCHAIN_FILE|BUILD_TYPE)' build/dev/CMakeCache.txt
```

Absence of a cache is normal on a fresh checkout. For every participating source path, run `git -C "$GR4_COMPONENT_PATH" remote -v`, `git -C "$GR4_COMPONENT_PATH" rev-parse HEAD` and `git -C "$GR4_COMPONENT_PATH" status --short`. Record resolved source paths and inspect child caches for package origins, testing flags and compiler identity after configuring/building. Use [repository resolution](repositories.md#locate-and-pin-actual-sources).

## Obtain-sources

For a fresh workspace, the project-provided source target clones missing base-stack repositories without compiling:

```sh
export CMAKE_BUILD_PARALLEL_LEVEL=4
cmake --preset dev -DGR4_BUILD_PARALLEL_LEVEL=4
cmake --build --preset dev --target sources
```

Use `full` only if full-profile sources are needed. This initially follows manifest refs; it does not establish the reviewed combination. Fetch/pin the discovered PR, parent and dependency objects before building for review. On first clone, `-DGR4_CORE_REF=<resolved-commit>` and corresponding repository/ref keys can select known pins; these do not change an existing checkout. Fetch enough history to establish ancestry.

Prefer isolated worktrees/checkouts and distinct build/install prefixes for different review combinations. `GR4_SOURCE_ROOT` can point to a directory of pinned component worktrees. For example, after resolving a checkout and commit, `git -C "$GR4_COMPONENT_PATH" worktree add --detach "$GR4_REVIEW_SOURCE_PATH" "$GR4_REVISION"` preserves the original branch. Bind these paths beneath the current review run's `.work/reviews/<run-id>/work/` directory. Do not silently use the older neighboring workspace's sources or artifacts. [Source behavior](../../docs/building.md#source-ownership-and-incremental-builds), [extending guide](../../docs/extending.md).

## Configure-superbuild

The baseline configure is `cmake --preset dev -DGR4_BUILD_PARALLEL_LEVEL=4`. For a Blocks QA review, the actual per-component argument mechanism enables its tests:

```sh
export CMAKE_BUILD_PARALLEL_LEVEL=4
cmake --preset dev -DGR4_BUILD_PARALLEL_LEVEL=4 \
  -DGR4_BLOCKS_CMAKE_ARGS:STRING=-DENABLE_TESTING=ON
```

Add `-DGR4_CORE_CMAKE_ARGS:STRING=-DENABLE_TESTING=ON` or `-DGR4_LIBRARY_CMAKE_ARGS:STRING=-DENABLE_TESTING=ON` only when those suites are applicable. Compose multiple child options as one quoted semicolon list, preserving existing required arguments. Use corresponding `GR4_CONTROL_PLANE_CMAKE_ARGS`, `GR4_INCUBATOR_CMAKE_ARGS` or `GR4_STUDIO_BLOCKS_CMAKE_ARGS` for relevant full components. Check actual feature/test inventory rather than assuming the option alone supplies coverage.

At the recorded superbuild revision, first-party modules lack `TESTS`; consequently `GR4_BUILD_TESTING=ON` alone does not enable their QA. Later component arguments override the generated `-DENABLE_TESTING:BOOL=OFF`. They do not register those tests in outer `check`. [Testing details](testing.md#test-enablement).

An isolated superbuild checkout gives separate preset paths automatically. Alternatively, configure with `-B "$GR4_REVIEW_BUILD" -DCMAKE_INSTALL_PREFIX="$GR4_REVIEW_PREFIX" -DGR4_SOURCE_ROOT="$GR4_REVIEW_SOURCES"` and the same preset/options; then use `cmake --build "$GR4_REVIEW_BUILD"`, `ctest --test-dir "$GR4_REVIEW_BUILD/projects/<module>"`, and `source "$GR4_REVIEW_BUILD/activate.sh"`. Do not use `--build --preset dev` after overriding `-B`: the preset still points to `build/dev`.

## Build-component

Set `GR4_COMPONENT` to the affected module after configuration:

```sh
cmake --build --preset dev --target "$GR4_COMPONENT"
source build/dev/activate.sh
```

Base targets are `gnuradio4-core`, `gnuradio4-library`, and `gnuradio4-blocks`. Each builds/installs its upstream dependencies too. For full-only targets use the configured `full` preset: `gr4-incubator`, `gnuradio4-control-plane`, `gnuradio4-studio-blocks`, `gnuradio4-studio`. Core changes require rebuilding affected consumers as well; building Core alone does not test them.

## Build-superbuild and downstream consumers

For the whole base stack, or a Core/Library change affecting Blocks:

```sh
cmake --build --preset dev
source build/dev/activate.sh
```

`cmake --build --preset dev --target gnuradio4-blocks` is the explicit Core → Library → Blocks path. Add only relevant full consumers for affected contracts; `cmake --build --preset full` builds the selected full stack. Build from the contract's source combination and then run the relevant [tests](testing.md). Do not mistake a package already found in the prefix for a rebuilt prerequisite.

## Activate-sdk

In a fresh shell after a corresponding successful install:

```sh
export CMAKE_BUILD_PARALLEL_LEVEL=4
source build/dev/activate.sh
printf '%s\n' "$GR4_PREFIX" "$CMAKE_PREFIX_PATH" "$GNURADIO4_PLUGIN_DIRECTORIES"
```

For full, use **`source build/full/activate.sh`**, exposing **`install/full/`**. These scripts are generated in the build directory for the installed SDK; no separate script inside the install prefix was found in the earlier capture. On this fresh target they must first be generated by configuration and backed by the corresponding build/install. Do not invent an installed activation path.

Activation prepends executable, CMake, pkg-config, runtime library, Python and plugin paths. It does not remove old paths, so use a fresh shell for a different prefix and inspect effective package/library origins. [Activation template](../../cmake/activate.sh.in).

## Inspect-artifact-provenance

Record superbuild/component commits and deliberate dirty patches; actual compiler, build type, sanitizer/feature/target flags; effective `CMAKE_PREFIX_PATH`, `gnuradio4_DIR`, `gnuradio4Library_DIR`, `GnuRadioBlockLib_DIR`; build logs and installed file identities. For a runtime probe record executable/library/plugin paths and hashes tied to those builds. Package versions, activation success or timestamps alone do not establish correspondence.

If a reviewed Core change is absent from the installed Core, rebuild/install the pinned Core plus affected downstream consumers through the superbuild, or explicitly limit results obtained with the older SDK. Use clean review prefixes for install-layout or identity changes; incremental installs can retain stale artifacts. Do not delete a user's installation. Source identity and artifact identity are separate contract fields until evidence connects them.

Component CI forms an SDK chain: Core uses project `ghcr.io/gnuradio/ci` toolchain images; Library consumes `gnuradio4-core-sdk`; Blocks consumes `gnuradio4-library-sdk`. SDKs install into `/opt/gnuradio4`. Resolve profile tags from the reviewed workflows and pin image digests/OCI revision labels. Inside a Library SDK image inspect both:

```sh
cat /opt/gnuradio4/share/gnuradio4-core-sdk/manifest
cat /opt/gnuradio4/share/gnuradio4-library-sdk/manifest
```

Record `git_sha`, `base_image`/`core_sdk_image`, target, compiler/build flags and Emscripten version as applicable. A `main-*` tag is mutable. A manifest's parent-image tag is not an immutable parent digest; verify inherited Core provenance too. Core/Library `sdk-image.yml` publish on main pushes or manual dispatch, not every PR. A Core merge does not automatically rebuild Library's SDK; verify the required image rebuilds and downstream reruns before claiming CI tested the prerequisite combination. Fork workflows may use their own `github.repository_owner` image namespace. Sources: Core/Library `.github/docker/Dockerfile.sdk`, `.github/workflows/sdk-image.yml`; Library/Blocks `.github/workflows/ci.yml`.

## Project container alternative

Use the actual distribution toolchain stage from the [CI/container guide](../../docs/ci.md), for example:

```sh
docker build --target toolchain -f containers/debian-sid/Dockerfile -t gr4-toolchain:debian-sid .
docker run --rm -it -v "$PWD:/workspace" -w /workspace \
  -e CMAKE_BUILD_PARALLEL_LEVEL=4 --entrypoint /bin/bash gr4-toolchain:debian-sid
```

The shell entrypoint override lets the reviewer run the configure/build recipes above inside the project's toolchain image, including `-DGR4_BUILD_PARALLEL_LEVEL=4`. The default [verify-preset.sh](../../containers/scripts/verify-preset.sh) accepts a preset and immediately configures/builds; it does not accept arbitrary configure flags. Inspect the selected image/entrypoint and retain image/base digests. Podman is supported by the guide; use its documented ownership/SELinux mount options where needed. This is an alternative when the project's environment requires it, not a mandatory image rebuild for each PR. Do not publish images or dispatch remote workflows merely because a review recipe mentions them.
