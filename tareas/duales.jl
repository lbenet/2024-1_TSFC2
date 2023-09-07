module DifAutom  

    import Base.==, Base.+, Base.-, Base.*, Base./, Base.^, Base.√, Base.exp, Base.log, Base.sin, Base.cos, Base.tan, Base.asin, Base.acos, Base.atan, Base.sinh, Base.cosh, Base.tanh, Base.asinh, Base.acosh, Base.atanh
    export Dual

    #=
    Definimos la estructura de los Duales con su valor real y su respectiva derivada, ambas dadas por el parametro T que es un número Real
    =#
    struct Dual{T <: Real}
        fun::T
        der::T
    end

    #=
    Las funciones "fun" y "der" nos dan la parte real y la derivada del dual respctivamente. Por otro lado, la función Dual(x,y) hace genera un Dual haciendo
    una promoción de los dos valores que se ingresen. Finalmente la función Dual(c) y la función dual(x) generan un dual correspondiente a una constante (con 
    derivada cero) y un dual para la variable independiente (con derivada uno) respectivamente.
    =#
    fun(D::Dual) = D.fun
    der(D::Dual) = D.der
    Dual(a,b) = Dual(promote(a,b)[1],promote(a,b)[2])
    Dual(c) = Dual(c,0.0)
    dual(x) = Dual(x,1.0)

    #=
    Generamos un metodo para el caso en el que el Dual recibe enteros. En el caso de que alguno de los dos sea BigFloat simplemente se promueve como en el resto
    de los casos, pero si ninguno lo es simplemente se transforman ambos valores a Float64
    =#
    function Dual(a::T,b::S) where {T<:Integer,S<:Integer}
        if typeof(a)==BigInt || typeof(b)==BigInt
            return Dual(BigFloat(a),BigFloat(b))
        else
            return Dual(Float64(a),Float64(b))
        end
    end

    #=
    A continuación se dan las reglas de igualdad entre duales y entre dual y números reales. En el caso de los duales se debe cumplir la igualdad tanto en la
    parte real como en su derivada y para los números reales se debe cumplir que la derivada es cero.
    =#
    function ==(D_1::Dual, D_2::Dual)
        if fun(D_1)==fun(D_2) && der(D_1)==der(D_2)
            return true
        else
            return false
        end
    end

    function ==(a::Real, D_2::Dual)
        if a==fun(D_2) && der(D_2)==0
            return true
        else
            return false
        end
    end

    function ==(D_1::Dual, a::Real)
        if a==fun(D_1) && der(D_1)==0
            return true
        else
            return false
        end
    end


    #=
    Se definen las reglas para las operaciones basicas entre duales y duales con reales. En cada caso, para la parte real las operaciones se comportan
    como con cualquier número, pero para la derivada se comportan según las diferentes reglas conocidas del calculo.
    =#
    +(D_1::Dual) = D_1
    +(D_1::Dual, D_2::Dual) = Dual(fun(D_1)+fun(D_2), der(D_1) + der(D_2))
    +(D_1::Dual, a::Number) = Dual(fun(D_1)+a, der(D_1))
    +(a::Number, D_1::Dual) = Dual(fun(D_1)+a, der(D_1))
    -(D_1::Dual) = Dual(-fun(D_1), -der(D_1))
    -(D_1::Dual, D_2::Dual) = Dual(fun(D_1)-fun(D_2), der(D_1) - der(D_2))
    -(D_1::Dual, a::Number) = Dual(fun(D_1)-a, der(D_1))
    -(a::Number, D_1::Dual) = Dual(-fun(D_1)+a, -der(D_1))
    *(D_1::Dual, D_2::Dual) = Dual(fun(D_1)*fun(D_2), der(D_1)*fun(D_2)+fun(D_1)*der(D_2))
    *(D_1::Dual, a::Number) = Dual(a*fun(D_1), a*der(D_1))
    *(a::Number, D_1::Dual) = Dual(a*fun(D_1), a*der(D_1))
    /(D_1::Dual, D_2::Dual) = Dual(fun(D_1)/fun(D_2), (der(D_1)*fun(D_2)-der(D_2)*fun(D_1))/fun(D_2)^2)
    /(D_1::Dual, a::Number) = Dual(fun(D_1)/a, der(D_1)/a)
    /(a::Number, D_1::Dual) = Dual(a/fun(D_1), -a*der(D_1)/fun(D_1)^2)
    inv(D_1::Dual) = /(1, D_1::Dual)
    ^(D_1::Dual, n::Int) = Dual(fun(D_1)^n, n*fun(D_1)^(n-1)*der(D_1))
    ^(D_1::Dual, a::Real) = Dual(fun(D_1)^a, a*fun(D_1)^(a-1)*der(D_1))

    #=
    Analogo al caso de las operaciones basicas, se definen las operaciones de exp, sin, cos, tan, asin, acos, atan, sinh, cosh, tanh, asinh, acosh y atanh
    con sus respectivas reglas de derivación.
    =#
    √(D_1::Dual) = Dual(√(fun(D_1)), 1/(2*fun(D_1))*der(D_1))
    exp(D_1::Dual) = Dual(exp(fun(D_1)), exp(fun(D_1))*der(D_1))
    log(D_1::Dual) = Dual(log(fun(D_1)), 1/(fun(D_1))*der(D_1))
    sin(D_1::Dual) = Dual(sin(fun(D_1)), cos(fun(D_1))*der(D_1))
    cos(D_1::Dual) = Dual(cos(fun(D_1)), -sin(fun(D_1))*der(D_1))
    tan(D_1::Dual) = Dual(tan(fun(D_1)), sec(fun(D_1))^2*der(D_1))
    asin(D_1::Dual) = Dual(asin(fun(D_1)), 1/√(1 - fun(d_1)^2)*der(D_1))
    acos(D_1::Dual) = Dual(acos(fun(D_1)), -1/√(1 - fun(d_1)^2)*der(D_1))
    atan(D_1::Dual) = Dual(atan(fun(D_1)), 1/(1 + fun(d_1)^2)*der(D_1))
    sinh(D_1::Dual) = Dual(sinh(fun(D_1)), cosh(fun(D_1))*der(D_1))
    cosh(D_1::Dual) = Dual(cosh(fun(D_1)), sinh(fun(D_1))*der(D_1))
    tanh(D_1::Dual) = Dual(tanh(fun(D_1)), sech(fun(D_1))^2*der(D_1))
    asinh(D_1::Dual) = Dual(asinh(fun(D_1)), 1/√(1 + fun(d_1)^2)*der(D_1))
    acosh(D_1::Dual) = Dual(acosh(fun(D_1)), 1/(√(1 - fun(d_1))*√(1 + fun(d_1)))*der(D_1))
    atanh(D_1::Dual) = Dual(atanh(fun(D_1)), 1/(1 - fun(d_1)^2)*der(D_1))

end