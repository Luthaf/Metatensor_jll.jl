# How to update the package

This needs to run from a linux machine with docker installed.

Edit build_tarballs.jl to update the version and shasum, then build everything
with `julia +1.7 build_tarballs.jl`.

Once everything works, commit & push, and then `julia +1.7 build_tarballs.jl
--skip-build --deploy=Luthaf/Metatensor_jll.jl` to update the jll package.
