module IntegTaylor 

    using TaylorSeries
    export integracion_taylor

    function coefs_taylor(f,t,u,p)
        x = u
        n = x.order
        for k ∈ 1:n
            dx = f(x,p,t)
            x[k] = dx[k-1]/k
        end
        return x
    end

    function coefs_taylor!(f!,t,u,du,p)
        n = u[1].order
        k = length(du)
        for i ∈ 1:n
            for j ∈ 1:k
                f!(du,u,p,t)
                u[j][i] = du[j][i-1]/i
            end
        end
    end

    function paso_integracion(u::Taylor1,ϵ)
        p₁ = findall(x-> x!=0, u.coeffs)[end]
        p₂ = findall(x-> x!=0, u.coeffs)[end-1]
        u₁, u₂ = u.coeffs[p₁], u.coeffs[p₂]
        h = min((ϵ/abs(u₁))^(1/(p₁-1)),(ϵ/abs(u₂))^(1/(p₂-1)))
        h = h*0.5
        return h
    end

    function paso_integracion(u::Vector{Taylor1},ϵ)
        pasos = []
        for x ∈ u
            h = paso_integracion(x,ϵ)
            push!(pasos, h)
        end
        h = minimum(pasos)
        return h
    end

    function paso_taylor(f,t,u,p,ϵ)
        x = coefs_taylor(f,t,u,p)
        h = paso_integracion(x,ϵ)
        return x, h
    end

    function paso_taylor!(f!,t,u,du,p,ϵ)
        coefs_taylor!(f!,t,u,du,p)
        h = paso_integracion(u,ϵ)
        return h
    end


    function integracion_taylor(f,x₀,t₀,tₙ,orden,ϵ,p)
        t = t₀ + Taylor1(orden)
        u = x₀ + Taylor1(orden)
        tiempos = [t₀]
        posiciones = [x₀]
        i = 0
        if(t₀<tₙ)
            while(i<=100)
                t = tiempos[end] + Taylor1(orden)
                u = posiciones[end] + Taylor1(orden)
                u, h = paso_taylor(f,t,u,p,ϵ)
                t₁ = tiempos[end]+h
                x₁ = evaluate(u,h)
                push!(tiempos,t₁)
                push!(posiciones,x₁)
                i += 1
                if(t₁>tₙ)
                    break
                end
            end
        else
            while(i<=100)
                t = tiempos[end] + Taylor1(orden)
                u = posiciones[end] + Taylor1(orden)
                u, h = paso_taylor(f,t,u,p,ϵ)
                t₁ = tiempos[end]-h
                x₁ = evaluate(u,-h)
                push!(tiempos,t₁)
                push!(posiciones,x₁)
                i += 1
                if(t₁<tₙ)
                    break
                end
            end
        end
        pop!(tiempos)
        pop!(posiciones)
        h_final = tₙ - tiempos[end]
        x₁ = evaluate(u,h_final)
        push!(posiciones, x₁)
        push!(tiempos, tₙ)
        return tiempos, posiciones
    end
end