# Autogenerated wrapper script for Metatensor_jll for x86_64-linux-gnu
export libmetatensor

JLLWrappers.@generate_wrapper_header("Metatensor")
JLLWrappers.@declare_library_product(libmetatensor, "libmetatensor.so")
function __init__()
    JLLWrappers.@generate_init_header()
    JLLWrappers.@init_library_product(
        libmetatensor,
        "lib/libmetatensor.so",
        RTLD_LAZY | RTLD_DEEPBIND,
    )

    JLLWrappers.@generate_init_footer()
end  # __init__()
