# GNU Radio 4 review boundaries

These references describe the revisions in [repositories.md](repositories.md#source-scope-of-persistent-references). Recheck changed boundaries at review time. Engineering behavior is not automatically a permanent compatibility policy; [policies.md](policies.md) distinguishes the two.

## Superbuild and installed packages

The superbuild uses CMake `ExternalProject`, with separate component caches in `build/<profile>/projects/<module>` and one shared install prefix for the selected profile. `BUILD_ALWAYS` invokes inner builds on each outer build; Ninja still builds incrementally. Component configure/build/install steps use the terminal pool. This preserves the installed package boundaries used by standalone consumers and CI. [DESIGN.md](../../DESIGN.md), [CMakeLists.txt](../../CMakeLists.txt).

The installed dependency direction is Core → Library → Blocks, with a direct Core → Blocks dependency too. Library finds `gnuradio4`; Blocks finds `gnuradio4`, `gnuradio4Library`, and `GnuRadioBlockLib`. Installed configurations must propagate dependencies and expose the expected `gnuradio4::` targets. Core owns the registration generator used by downstream block libraries. Component `CMakeLists.txt` and `cmake/*Config.cmake.in`; [external smoke consumer](../../tests/oot-smoke/CMakeLists.txt).

Incubator and Studio blocks follow the base stack. Control Plane compiles against Core but is scheduled after Blocks so its normal runtime catalog can discover plugins. Studio's Node application and its CMake blocks share one repository and have separate superbuild targets; Control Plane communicates through HTTP/WebSocket interfaces rather than linking the application to every block library. [Manifest](../../modules.cmake), [design](../../DESIGN.md).

## Installed and source behavior

Public headers, package exports, transitive dependencies and host registration tools must work for external installed consumers. An in-tree build can conceal missing exports, include paths or dependencies. The workspace OOT smoke finds all three packages and links `gnuradio4::gnuradio-core`, `gnuradio4::gnuradio-algorithm` and `gnuradio4::gr-math`. Core's own installed smoke exercises shared/static, collision and named-registry consumers. [Testing recipes](testing.md#installed-sdk-check); `gnuradio4-core:test_external/run_installed_sdk_smoke.sh`.

The install prefix is mutable: removing or renaming a source-installed file can leave a stale file behind. Separate review build/install trees when identities or layouts differ. Never count an old installed Core as testing a new Core revision, even when package versions match. [DESIGN.md](../../DESIGN.md), [artifact provenance](build.md#inspect-artifact-provenance).

## Plugin discovery and lifecycle

**Discovered engineering invariant — runtime-discovery:** the native Core loader reads `GNURADIO4_PLUGIN_DIRECTORIES`. The superbuild activation script supplies `<prefix>/<libdir>/gnuradio-4/plugins` and `<prefix>/<libdir>`, with `lib` the default. The loader resolves plugin entry points and rejects a plugin whose ABI version differs from `GR_PLUGIN_CURRENT_ABI_VERSION`. This check is a mechanism, not proof of a frozen ABI or safety for arbitrary native code. Source: [activation template](../../cmake/activate.sh.in); `gnuradio4-core:core/src/PluginLoader.cpp`, `core/include/gnuradio-4.0/PluginLoader.hpp`, `core/include/gnuradio-4.0/Plugin.hpp`.

For runtime registration/catalog changes, verify actual plugin paths, library origins and affected block IDs in the installed environment. A header consumer or a nonempty catalog does not establish that the changed plugin is discoverable. [Runtime check](testing.md#full-runtime-check).

**Discovered engineering invariant — lifecycle-transitions:** Core's `lifecycle::isValidTransition` defines admissible states and `StateMachine::changeStateTo` invokes lifecycle callbacks. `REQUESTED_STOP` and `STOPPED` are distinct. Consult those implementations and the relevant scheduler/drain/destruction tests before asserting shutdown, pause, reset or progress requirements. Do not substitute a universal teardown order for the actual state/ownership contract. Source: `gnuradio4-core:core/include/gnuradio-4.0/LifeCycle.hpp`, `core/test/CMakeLists.txt`.

## GR4 trust surfaces

When security analysis is in scope, use the [security dimension](../dimensions/security-trust.md) and actual reachable actors/guards. Skip this analysis for the maintainer profile unless explicitly requested. The following are starting points, not claims of defects or exposure in every configuration:

| Surface | Boundary to establish for the reviewed change |
| --- | --- |
| HTTP/network blocks and Control Plane | Which remote/local actor can reach a configured endpoint; input/control parsing, authorization where present, work limits, and destination/file effects. |
| Native plugins and runtime search roots | Who can choose or write a loaded library; discovery path, dynamic loading and process privileges. ABI checks do not sandbox plugin execution. |
| File I/O, YAML flowgraphs and serialized control/data | Who supplies paths, lengths, nested structures or IDs; parsing through allocation, registry lookup and runtime action. |
| Scheduler and streaming resources | Input-driven buffering/work, stalled progress, cancellation and reachable resource exhaustion. |
| Build dependencies and external processes | Exact dependency/artifact identity, host/target tools, build/generator input, and command/process arguments where a changed path uses them. |

Sources: `gnuradio4-blocks:README.md`, `blocks/http`, `blocks/fileio`, `blocks/zeromq`; `gnuradio4-control-plane:README.md`, `CMakeLists.txt`; `gnuradio4-core:core/src/PluginLoader.cpp`, `core/include/gnuradio-4.0/LifeCycle.hpp`, `core/test/CMakeLists.txt`; [Node adapter/build commands](../../CMakeLists.txt). Trace actor → entry → guards → transformations → sink → asset. Do not force web authentication, browser or network checks onto code with no corresponding reachable surface. Keep probes bounded and local; review does not authorize attacks on external services.
