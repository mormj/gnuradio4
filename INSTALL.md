# GNU Radio 4 - Installation Guide

At the moment GNU Radio 4 is not yet packaged and has to be installed from source.
This document describes the necessary steps and prerequisites to build, test and install the GR4 core SDK for runtime usage and block-library development.

As the installation and packaging matures, these instructions are expected to be extended.

## Requirements

- CMake ≥ 3.28
- C++23 compatible compiler
  - GCC ≥ 14.2 (Linux)
- Git
- pkg-config
- Boost.UT development package or installed headers (tests only)
- cpp-httplib development package (tests only)
- vir-simd headers
- Python 3 (optional)

Verify tool versions:

cmake --version
g++ --version

## Clone Repository

git clone https://github.com/gnuradio/gnuradio4-core.git
cd gnuradio4-core

## Build

GNU Radio 4 uses an out-of-source CMake build.

cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DENABLE_TESTING=OFF
cmake --build build

## Run Tests

cmake -S . -B build-tests -DCMAKE_BUILD_TYPE=Release -DENABLE_TESTING=ON
cmake --build build-tests
ctest --test-dir build-tests --output-on-failure

## Ubuntu 24.04 (Dependencies)

sudo apt update
sudo apt install -y cmake g++ git libcpp-httplib-dev pkg-config python3 python3-dev

Ubuntu 24.04 does not package all native dependencies used by the default core build. Install Boost.UT and vir-simd
from source or use the GNU Radio CI builder image. For an explicit online fallback, configure with
`-DGR_USE_FETCHCONTENT_DEPS=ON`.

## MacOS via Homebrew

MacOS builds are supported by using `llvm@20` from the [Homebrew package manager](https://brew.sh/):

## Platform Notes

- Linux: Expected to work with a modern toolchain
- Windows: See Windows setup instructions:
  https://github.com/gnuradio/gnuradio4-core/blob/main/DEVELOPMENT.md#win32-development-environment---msys2
- macOS: supported using llvm@20 from homebrew

## Troubleshooting

- Ensure CMake ≥ 3.28
- Ensure compiler supports C++23
- Check logs:
  - CMakeFiles/CMakeError.log
  - CMakeFiles/CMakeOutput.log

For a reproducible setup, see Docker workflow:
https://github.com/gnuradio/gnuradio4-core/blob/main/DEVELOPMENT.md#docker-cli
