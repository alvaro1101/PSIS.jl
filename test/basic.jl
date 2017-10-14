@testset "Basic" begin
    srand(125)
    x = sort(randn(100))
    lw = x .- PSIS.logsumexp(x)
    lw_out, k = psislw(lw)
    # CAUTION: these numbers are empirical but reasonable
    @test isapprox(lw_out[50],-5.0,atol=0.1)
    @test isapprox(lw_out[95],-3.6,atol=0.1)
    @test isapprox(k,0.2,atol=0.1)
end
