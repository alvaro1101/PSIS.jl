using PSIS
using Base.Test

tests = ["basic","gpfit","array"]

if length(ARGS) > 0
    tests = ARGS
end

for f in tests
    fname = f*".jl"
    include(fname)
end

