module IntegTaylor

export integracion_taylor

using TaylorSeries

function coefs_taylor(f, t::Taylor1, u::Taylor1, p)
    order = length(u.coeffs)
    u₀ = u.coeffs[1]
    U = [u₀]

    f_taylor = f(Taylor1(U), p, t)

    for k in 1:order-1
        u.coeffs[k+1] = f_taylor.coeffs[k] / k
        push!(U, u.coeffs[k+1])

        # Recalculamos f_taylor usando la función f y la serie de Taylor de u actualizada
        f_taylor = f(Taylor1(U), p, t)
    end 

    return u
end


function coefs_taylor!(f!, t::Taylor1, u::Vector, du::Vector, p)
    # Asume que la longitud de u y du es la misma (representa el número de ecuaciones)
    num_eqs = length(u)
    order = length(u[1].coeffs) # Asume que todas las series de Taylor tienen el mismo orden
    
    # Inicializar du con ceros
    for i in 1:num_eqs
        du[i] = Taylor1(zeros(order))
    end

    # Iteración para calcular los coeficientes
    for k in 1:order-1
        # Calcula el lado izquierdo de las ecuaciones diferenciales para el orden k actual
        f!(du, u, p, t)

        for i in 1:num_eqs
            # Calcula el coeficiente k-ésimo para cada función dependiente
            u[i].coeffs[k+1] = du[i].coeffs[k] / k
        end
    end

    return nothing # Regresa nada porque estamos modificando u y du directamente
end


function paso_integracion(u::Taylor1, epsilon::Float64)
    k = length(u.coeffs)
    hk = (epsilon / abs(u.coeffs[k]))^(1/k)
    hk_minus_1 = (epsilon / abs(u.coeffs[k-1]))^(1/(k-1))
    return 0.5 * min(hk, hk_minus_1)
end

function paso_integracion(u::Vector, epsilon::Float64)
    hs = Float64[] # Vector para almacenar los pasos de integración estimados para cada componente
    for ui in u
        push!(hs, paso_integracion(ui, epsilon))
    end
    return minimum(hs)
end


# Caso escalar
function paso_taylor(f, t::Taylor1, u::Taylor1, epsilon::Float64, p)
    u = coefs_taylor(f, t, u, p)
    h = paso_integracion(u, epsilon)
    return u, h
end

# Caso vectorial
function paso_taylor!(f!, t::Taylor1, u::Vector, du::Vector, epsilon::Float64, p)
    coefs_taylor!(f!, t, u, du, p)
    h = paso_integracion(u, epsilon)
    return h
end






function integracion_taylor(f, x0::Real, t_ini::Real, t_fin::Real, orden::Int, ϵ::Float64, p; max_steps=1000, min_h=1e-15)
    # Inicialización
    t = Taylor1(orden)
    u = Taylor1([x0; zeros(orden-1)])
    times = [t_ini]
    results = [x0]
    delta = sign(t_fin - t_ini)

    step = 0
    while delta*t_ini < delta*t_fin && step < max_steps
        u, h = paso_taylor(f, t, u, ϵ, p)
        if h > abs(t_fin - t_ini)
            h = abs(t_fin - t_ini)
        end
        t_ini += h * delta
        x0 = evaluate(u, h * delta)
        push!(times, t_ini)
        push!(results, x0)
        
        u = Taylor1([x0; zeros(orden-1)])
        step += 1
        
        if abs(h) < min_h
            break
        end
    end
    
    return times, results
end

#function integracion_taylor(f!, x0::Vector{Real}, t_ini::Real, t_fin::Real, orden::Int, ϵ::Float64, p; max_steps=1000, min_h=1e-15)
function integracion_taylor(f!, x0::Vector, t_ini::Real, t_fin::Real, orden::Int, ϵ::Float64, p; max_steps=1000, min_h=1e-15)

    # Inicialización
    n = length(x0)
    t = Taylor1(orden)
    #u = Taylor1.(x0)
    u = [Taylor1([x0[i];zeros(orden-1)]) for i in 1:length(x0)]
    du = similar(u)
    times = [t_ini]
    results = [x0]
    delta = sign(t_fin - t_ini)

    step = 0
    while delta*t_ini < delta*t_fin && step < max_steps
        h = paso_taylor!(f!, t, u, du, ϵ, p)
        if h > abs(t_fin - t_ini)
            h = abs(t_fin - t_ini)
        end
        t_ini += h * delta
        new_vals = evaluate.(u, h * delta)
        push!(times, t_ini)
        push!(results, new_vals)
        
        #u = Taylor1.(new_vals)
        u = [Taylor1([new_vals[i];zeros(orden-1)]) for i in 1:length(new_vals)]
        step += 1
        
        if abs(h) < min_h
            break
        end
    end
    
    return times, results
end
end
