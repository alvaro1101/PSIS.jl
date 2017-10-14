@testset "Array" begin
    # check that psislw works on a 2D array
    # and gives reasonable stats for a prototypical set of weights
    nn = 1000
    x = randn(nn,50)
    m,n = size(x)
    z = similar(x)
    for i=1:n
        z[:,i] = x[:,i] .- PSIS.logsumexp(x[:,i])
    end
    y = x .- PSIS.logsumexp(x,1)
    # check that logsumexp works on matrix, returning row vector
    @test norm(y-z) < 1e-10
    y,k = psislw(y)
    ys = log(nn)+sort(y,1)
    lw5=ys[round(Int,0.05*m),:]
    lw50=ys[round(Int,0.5*m),:]
    lw95=ys[round(Int,0.95*m),:]
    # CAUTION: test values are empirical but reasonable
    @test isapprox(mean(lw50),-0.5,atol=0.03)
    @test isapprox(mean(lw95),1.14,atol=0.03)
    @test std(lw50) < 2 / sqrt(nn)
    @test std(lw95) < 2 / sqrt(nn)
    @test isapprox(mean(k),0.28,atol=0.02)
    @test std(k) < 0.1
end
