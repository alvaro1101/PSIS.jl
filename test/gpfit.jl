function gprnd(n,k,s)
    if k==0
        x = -s*log.(rand(n))
    else
        x = (s/k)*(exp.(-k*log.(rand(n))) .- 1)
    end
    x
end

@testset "GPfit" begin
    srand(123)
    # Exponential distn. should match 0-power law
    n=10000
    x = randn(n).^2 + randn(n).^2
    k,σ = PSIS.gpdfitnew(x)
    @test isapprox(k, 0.0, atol=0.01)
    @test isapprox(σ, 2.0, atol=0.03)

    n=1000
    nsamp=10
    for s in [0.5,2.0]
        for k in 0:0.25:1.5
            samps=foldr(hcat,map(x->([x...]),
                                 [PSIS.gpdfitnew(gprnd(n,k,s)) for i in 1:nsamp]))
            kbar,sbar = mean(samps,2)
            kvar,svar = var(samps,2)
            krmse = sqrt(kvar + (kbar-k)^2)
            srmse = sqrt(svar + (sbar-s)^2)/s
            @test krmse < 0.1
            @test srmse < 0.1
        end
    end
end
