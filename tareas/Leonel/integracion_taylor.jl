using TaylorSeries, Plots

function coefs_taylor(f,t,u,p)
    
    u_old = copy(u(t))
    u_new = u(t) + integrate(f(u_old,p,t))
    
    while u_new != u_old
        
        u_old = u_new
        u_new = u(t) + integrate(f(u_old,p,t))
        
    end
    
    return u_new
        
end

function paso_integracion(u,ϵ)
    N = (length(u) - 1):-1:1
    h = [0.0,0.0]
    j = 0
    for i in N
        if u[i] != 0 && j <= 2
            j += 1
            h[j] = ϵ /abs(u[i])^(1/i)
        end
        if j == 2
            break
        end
    end
    
    if h[1] < h[2]
        return h[1]
    else
        return h[2]
    end
end

function paso_taylor(f,t,u,p,ϵ)
    u_sol = coefs_taylor(f,t,u,p)
    return u_sol, paso_integracion(u_sol,ϵ)
end

function integracion_taylor(f, x0, t_ini, t_fin, orden, ϵ, p)
    
    u = Taylor1(x0,orden)
    t = Taylor1([t_ini,1],orden)
    u, h = paso_taylor(f,t,u,p,ϵ)
    t_min = minimum([t_ini,t_fin])
    t_max = maximum([t_ini,t_fin])
    Δt = t_max - t_min
    tt = t_ini
    T = [t_ini]
    X = [x0]
    
    if h < Δt/1000
        h = Δt/1000
    end
    
    hh = (-1)^(t_ini > t_fin) * h
    
    while t_min <= tt + hh <= t_max
    
        tt += hh
        u = Taylor1(u(hh),orden)
        t = Taylor1([tt,1],orden)
        u, h = paso_taylor(f,t,u,p,ϵ)
        push!(T,tt)
        push!(X,u(0))
        
        if h < Δt/1000
            h = Δt/1000
        end
        
        hh = (-1)^(t_ini > t_fin) * h
    
    end
        
    u = Taylor1(u(t_fin - tt),orden)
    t = Taylor1([t_fin,1],orden)
    u = coefs_taylor(f,t,u,p)
    push!(T,t_fin)
    push!(X,u(0))
    
    return T, X
    
end
