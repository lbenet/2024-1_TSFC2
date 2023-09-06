module DifAutom  

    import Base.==, Base.√, Base.exp, Base.log, Base.sin, Base.cos, Base.tan, Base.asin, Base.acos, Base.atan, Base.sinh, Base.cosh, Base.tanh, Base.asinh, Base.acosh, Base.atanh
    export Dual

    struct Dual{T <: Real}
        fun::T
        der::T
    end

    fun(D::Dual) = D.fun
    der(D::Dual) = D.der
    Dual(a,b) = Dual(promote(a,b)[1],promote(a,b)[2])
    Dual(c) = Dual(c,0.0)
    dual(x) = Dual(x,1.0)

    function Dual(a::T,b::S) where {T<:Integer,S<:Integer}
        if typeof(a)==BigInt || typeof(b)==BigInt
            return Dual(BigFloat(a),BigFloat(b))
        else
            return Dual(Float64(a),Float64(b))
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

    import Base.+, Base.-, Base.*, Base./, Base.^
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