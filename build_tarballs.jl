# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder, Pkg

name = "Metatensor"
version = v"0.1.0"


# Collection of sources required to complete build
github_release = "https://github.com/lab-cosmo/metatensor/releases/download"
sources = [
    ArchiveSource(
        "$github_release/metatensor-core-v$version/metatensor-core-cxx-$version.tar.gz",
        "21fbc2f6b5b89fe57209ad5cd125aed674dcfab984a27e7afe0b12108997a93a"
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
    if Sys.iswindows(platform) # && platform.tags["arch"] == "i686"
        # Rust builds the code in `metatensor.dll` but CMake tries to find it
        # at `libmetatensor.dll`
        continue
    end
    push!(platforms, platform)
end

# The products that we will ensure are always built
products = [
    LibraryProduct("libmetatensor", :libmetatensor)
]

# Dependencies that must be installed before this package can be built
dependencies = Dependency[]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies; julia_compat="1.6", compilers=[:c, :rust])
