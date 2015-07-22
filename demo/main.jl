# load apm library
include("../apm.jl")

# Integrate model and return solution
z = apm_solve("demo",7)
