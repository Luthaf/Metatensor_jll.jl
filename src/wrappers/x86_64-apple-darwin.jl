# Autogenerated wrapper script for Metatensor_jll for x86_64-apple-darwin
export libmetatensor

JLLWrappers.@generate_wrapper_header("Metatensor")
JLLWrappers.@declare_library_product(libmetatensor, "@rpath/libmetatensor.dylib")
function __init__()
    JLLWrappers.@generate_init_header()
    JLLWrappers.@init_library_product(
        libmetatensor,
        "lib/libmetatensor.dylib",
        RTLD_LAZY | RTLD_DEEPBIND,
    )

    JLLWrappers.@generate_init_footer()
end  # __init__()
