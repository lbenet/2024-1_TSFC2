
struct Dual{T<:Real}
    fun::T
    der::T
end

function Dual(a, b)
    x, y = promote(a, b)
    return Dual(x, y)
end

function Dual(a::T, b::T) where {T<:Integer}
    x, y, _ = promote(a, b, 1.0)
    return Dual(x, y)
end


function fun(S::Dual)
    return S.fun
end

function der(S::Dual)
    return S.der
end



function Dual(a::T) where {T<:Number}
    return Dual(a, 0)
end

Dual(8)

function dual(a::T) where {T<:Number}
    return Dual(a, 1)
end




import Base: +, *, /, ==, -, sqrt, ^, exp, log, sin, cos, tan, asin, acos, atan, sinh, cosh, tanh, asinh, acosh, atanh, inv

promote(big(1), 1.0)

-(a::Dual, b::Dual) = Dual(a.fun - b.fun, a.der - b.der)

-(a::Real, b::Dual) = Dual(a-b.fun, b.der)

-(a::Dual, b::Real) = Dual(a.fun-b, a.der)

-(a::Dual) = Dual(-a.fun, -a.der)


+(a::Dual, b::Dual) = Dual(a.fun + b.fun, a.der + b.der)

+(a::Real, b::Dual) = Dual(a+b.fun, b.der)

function +(a::Dual, b::Real)
    return b+a
end

+(a::Dual) = Dual(+a.fun, +a.der)

*(a::Dual, b::Dual) = Dual(a.fun * b.fun, a.fun*b.der + a.der*b.fun)

# *(a::Real, b::Dual) = Dual(Dual(a).fun * b.fun, Dual(a).fun*b.der + Dual(a).der*b.fun)



*(a::Real, b::Dual) = Dual(a * b.fun, a*b.der) 

*(a::Dual, b::Real) = b*a




function /(a::Dual, b::Dual)

    (a.fun == b.fun)&&(a.der == b.der) ? 1.0 : Dual(a.fun/b.fun, (a.der*b.fun - a.fun*b.der)/b.fun^2)
    # Dual(a.fun/b.fun, (a.der*b.fun - a.fun*b.der)/b.fun^2)
end

    
/(a::Real, b::Dual) = Dual(a)/b #Dual(Dual(a).fun/b.fun, (Dual(a).der*b.fun - Dual(a).fun*b.der)/b.fun^2)

/(a::Dual, b::Real) = Dual(a.fun/b, a.der/b)



sqrt(a::Dual) = Dual(sqrt(a.fun), a.der/(2*sqrt(a.fun))) 

==(a::Dual, b::Dual) = a.fun == b.fun && a.der == b.der

==(a::Number, b::Dual) = a == b.fun && b.der == 0

# ==(a::Dual{BigFloat}, b::BigFloat) = a.fun == b

function ==(a::Dual{BigFloat}, b::BigFloat)
    return a.fun == b
end



^(a::Dual, n::Real) = Dual(a.fun^n, n*a.fun^(n-1)*a.der)

exp(a::Dual) = Dual(exp(a.fun), exp(a.fun)*a.der)

log(a::Dual) = Dual(log(a.fun), a.der/a.fun)

sin(a::Dual) = Dual(sin(a.fun), cos(a.fun)*a.der)

cos(a::Dual) = Dual(cos(a.fun), -sin(a.fun)*a.der)

tan(a::Dual) = Dual(tan(a.fun), (sec(a.fun))^2*a.der)

asin(a::Dual) = Dual(asin(a.fun), a.der/(sqrt(1 - a.fun^2)))

acos(a::Dual) = Dual(acos(a.fun), -a.der/(sqrt(1 - a.fun^2)))

atan(a::Dual) = Dual(atan(a.fun), a.der/(1 + a.fun^2))

sinh(a::Dual) = Dual(sinh(a.fun), cosh(a.fun)*a.der)

cosh(a::Dual) = Dual(cosh(a.fun), sinh(a.fun)*a.der)

tanh(a::Dual) = Dual(tanh(a.fun), (sech(a.fun))^2*a.der)

asinh(a::Dual) = Dual(asinh(a.fun), a.der/(sqrt(a.fun^2 + 1)))

acosh(a::Dual) = Dual(acosh(a.fun), a.der/(sqrt(a.fun^2 - 1)))

atanh(a::Dual) = Dual(atanh(a.fun), -a.der/(a.fun^2 - 1))


inv(a::Dual) = 1/a


u = dual(0.5)

atanh(u) == Dual(atanh(fun(u)), der(u)/(1-(fun(u))^2)) == Dual(0.5493061443340549, 1.3333333333333333)


atanh(u)