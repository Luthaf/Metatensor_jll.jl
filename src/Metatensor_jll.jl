# Use baremodule to shave off a few KB from the serialized `.ji` file
baremodule Metatensor_jll
using Base
using Base: UUID
import JLLWrappers

JLLWrappers.@generate_main_file_header("Metatensor")
JLLWrappers.@generate_main_file("Metatensor", UUID("0a60894c-bde1-5a72-bbe5-9f45bee4e041"))
end  # module Metatensor_jll
