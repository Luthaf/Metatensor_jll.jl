# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder, Pkg

name = "Metatensor"
version = v"0.1.14"


# Collection of sources required to complete build
github_release = "https://github.com/lab-cosmo/metatensor/releases/download"
sources = [
    ArchiveSource(
        "$github_release/metatensor-core-v$version/metatensor-core-cxx-$version.tar.gz",
        "dc6cdd9cf0113e2f012ecf68b81cc7cfc71bef3d2020b41574de8fa403dba646"
    ),
]
# Bash recipe for building across all platforms
script = raw"""
cd ${WORKSPACE}/srcdir/metatensor-core-*/

export EXTRA_RUST_FLAGS=""
if [[ "$target" == *musl* ]]; then
    export RUSTFLAGS="-Ctarget-feature=-crt-static $RUSTFLAGS"
fi

mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=${prefix} \
      -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TARGET_TOOLCHAIN} \
      -DRUST_BUILD_TARGET=${CARGO_BUILD_TARGET} \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_SHARED_LIBS=ON \
      -DMETATENSOR_INSTALL_BOTH_STATIC_SHARED=OFF \
      ..
make -j${nproc}
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = []
for platform in supported_platforms()
    if Sys.iswindows(platform) && platform.tags["arch"] == "i686"
        # The code fails to link on 32-bit windows
        continue
    end

    if Sys.isfreebsd(platform) && platform.tags["arch"] == "aarch64"
        # Rust toolchain is not available on aarch64-unknown-freebsd
        continue
    end

    if platform.tags["arch"] == "riscv64"
        # Rust toolchain is not available on riscv64
        continue
    end

    push!(platforms, platform)
end

# The products that we will ensure are always built
products = [
    LibraryProduct(["libmetatensor", "metatensor"], :libmetatensor)
]

# Dependencies that must be installed before this package can be built
dependencies = Dependency[]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(
    ARGS, name, version, sources, script, platforms, products, dependencies;
    julia_compat="1.6",
    compilers=[:c, :rust],
)
