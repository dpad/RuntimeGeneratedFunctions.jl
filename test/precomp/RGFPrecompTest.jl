module RGFPrecompTest
    using RuntimeGeneratedFunctions
    RuntimeGeneratedFunctions.init(@__MODULE__)
    
    z = 100

    # Both f and f2 should be kept in the current module's cache
    f = @RuntimeGeneratedFunction(:((x,y)->x+y+z))
    f2 = @RuntimeGeneratedFunction(@__MODULE__, :((x,y)->x-y+z))

    function build_RGF(ex, mod=@__MODULE__)
        # This function is used to test out a consumer module (e.g. a
        # user-defined module that calls this module's function).
        # See the RGFPrecompConsumerTest.
        @RuntimeGeneratedFunction(mod, ex)
    end

    module Submodule
        using RuntimeGeneratedFunctions
        RuntimeGeneratedFunctions.init(@__MODULE__)

        z = 200

        # f should exist in the submodule's cache.
        f = @RuntimeGeneratedFunction(:((x,y)->x*y+z))

        # f2 should exist in the parent module (i.e. using the parent module's "z")
        f2 = @RuntimeGeneratedFunction(parentmodule(@__MODULE__), :((x,y)->x/y+z))  
    end
end
