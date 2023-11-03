"
********************

    IntegTaylor

# Integración mediante polinomios de Taylor

Este módulo sirve para integrar numéricamente ecuaciones difenciales ordinarias (ODE's) de primer orden escalares o vectoriales usando polinomios de taylor permitiendo al usuario escoger el error de tolerancia que necesite.

Para implementar este módulo entra en la información de ayuda con el comando `?` de la funcion `integracion_taylor`.

********************
"
module IntegTaylor

export integracion_taylor

using TaylorSeries

function coefs_taylor(f,t,u,p)

    u_old = copy(u(t))
    u_new = u(t) + integrate(f(u_old,p,t))

    while u_new != u_old

        u_old = u_new
        u_new = u(t) + integrate(f(u_old,p,t))

    end

    return u_new

end

function coefs_taylor!(f!,t,du,u,p)
    
    u_old = copy(u(t))
        
    f!(du,u_old,p,t)
    
    u_new = u(t) + integrate.(du)
    
    i = 0
    n = maximum(length.(u))
    m = length(u)

    while u_new != u_old
        
        f!(du,u_new,p,t)

        u_old = u_new
        u_new = u(t) + integrate.(du)
        
        i+=1
        
        if i == n*m
            
            throw(ArgumentError("La iteración de Picard excedió los límites esperados. Verifica tu ecuación diferencial."))
        
        end

    end
    
    #println(i)

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

function paso_integracion(u,ϵ)
    N = (minimum(length.(u)) - 1):-1:1
    H = [[0.0,0.0] for i in 1:length(u)]
    for j in 1:length(u)
        k = 0
        for i in N
            if u[j][i] != 0 && k < 2
                k += 1
                H[j][k] = (ϵ /abs(u[j][i]))^(1/i)
            end
            if k == 2
                break
            end
        end
    end

    return minimum(minimum.(H))
    
end

function paso_taylor(f,t,u,p,ϵ)
    u_sol = coefs_taylor(f,t,u,p)
    return u_sol, paso_integracion(u_sol,ϵ)
end

function paso_taylor!(f!,t,du,u,p,ϵ)
    u = coefs_taylor!(f!,t,du,u,p)
    return u, paso_integracion(u,ϵ)
end


"
    integracion_taylor(f, x0, t_ini, t_fin, orden, ϵ, p)

Este método integra en el caso escalar ecuaciones diferenciales ordinarias de primer orden (ODE's). 

`f(x,p,t)` es la función que define la ecuación de la forma `dx/dt = f(x::Taylor1,p,t::Taylor1)`. `x` y `t` son un objeto `Taylor1` que se define automáticamente dentro de la función `integracion_taylor`.

`x0::Float64` es la condición inicial de `x` al tiempo `t_ini`, es decir, `x(t=t_ini) = x0`.

`t_ini::Float64` es el tiempo inicial de integración, no es necesariamente menor a `t_fin`.

`t_fin::Float64` es el tiempo final de integración, no es necesariamente mayor a `t_ini`.

`orden::Int64` es el orden máximo del polinomio de Taylor de `x(t)`. 

`ϵ::Float64` es la tolerancia de error en `x(t)`.

`p::Any` son los parámetros necesarios en la ecuación diferencial `f`.

### Ejemplo

Para definir la ecuación diferencial `dx/dt = 2.0*x`

    julia> f(x,p,t) = p*x
    f (generic function with 1 method)

    julia> p = 2.0
    2.0
"
function integracion_taylor(f, x0, t_ini, t_fin, orden, ϵ, p)

    u = Taylor1(x0,orden)
    t = Taylor1([t_ini,1],orden)
    u, h = paso_taylor(f,t,u,p,ϵ)
    t_min = minimum([t_ini,t_fin])
    t_max = maximum([t_ini,t_fin])
    Δt = t_max - t_min
    tt = t_ini
    T = Real[t_ini]
    X = Real[x0]

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

function integracion_taylor(f!, x0, t_ini, t_fin, orden, ϵ, p)

    u = Taylor1.(x0,orden)
    
    t = Taylor1([t_ini,1],orden)
    
    du = Taylor1.(zero(x0),orden)

    f!(du,u,p,t)
    
    u, h = paso_taylor!(f!,t,du,copy(u),p,ϵ)
    
    t_min = minimum([t_ini,t_fin])
    
    t_max = maximum([t_ini,t_fin])
    
    Δt = t_max - t_min
    
    tt = t_ini
    
    T = Real[tt]
    
    X = Vector{Real}[x0]

    if h < Δt/1000
        h = Δt/1000
    end

    hh = (-1)^(t_ini > t_fin) * h

    while t_min <= tt + hh <= t_max

        tt += hh
        
        u = Taylor1.(copy(u(hh)),orden)
        
        t = Taylor1([tt,1],orden)
        
        u, h = paso_taylor!(f!,t,du,copy(u),p,ϵ)
        
        push!(T,tt)
        
        push!(X,u(0))

        if h < Δt/1000
            
            h = Δt/1000
            
        end

        hh = (-1)^(t_ini > t_fin) * h

    end

    u = Taylor1.(copy(u(t_fin - tt)),orden)
    
    t = Taylor1([t_fin,1],orden)
    
    u = coefs_taylor!(f!,t,du,copy(u),p)
    
    push!(T,t_fin)
    
    push!(X,u(0))

    return T, X

end

end
