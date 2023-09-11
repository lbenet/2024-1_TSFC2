struct Dual{T<:Real} <:Number
    fun::T
    der::T
end

Dual(x::T,y::S) where {T<:Real,S<:Real}  = Dual(convert(Float64,x),convert(Float64,y))
Dual(x::T,y::T) where T<:Rational  = Dual(convert(Float64,x),convert(Float64,y))
Dual(x::T,y::T) where T<:Integer  = Dual(convert(Float64,x),convert(Float64,y))

# print("Test: \n Dual(1,1) => $(Dual(1,1)) \n Dual(1.0,1) => $(Dual(1.0,1)) \n Dual(1.0,3//2) => $(Dual(1.0,3//2)) \n Dual(3//2,1//2) => $(Dual(3//2,1//2))")

fun(dual::Dual{T}) where T<:Real = dual.fun
der(dual::Dual{T}) where T<:Real = dual.der

Dual(c::T) where T<:Real = Dual(c,zero(T))

dual(x::T) where T<:Real = Dual(x,one(T))

import Base.==

function ==(dual1::Dual,dual2::Dual)
    if dual1.fun == dual2.fun && dual1.der == dual2.der
        return true
    else
        return false
    end
end

import Base.+

+(x::Real,y::Dual) = Dual(+(promote(x,y.fun)...) , y.der)
+(x::Dual,y::Real) = Dual(+(promote(x.fun,y)...) , x.der)
+(x::Dual,y::Dual) = Dual(+(promote(x.fun,y.fun)...) , +(promote(x.der,y.der)...))

import Base.-

-(x::Real,y::Dual) = Dual(-(promote(x,y.fun)...) , y.der)
-(x::Dual,y::Real) = Dual(-(promote(x.fun,y)...), x.der)
-(x::Dual,y::Dual) = Dual(-(promote(x.fun,y.fun)...) , -(promote(x.der,y.der)...))

import Base.*

*(x::Real,y::Dual) = Dual(*(promote(x,y.fun)...) , *(promote(x,y.der)...))
*(x::Dual,y::Real) = Dual(*(promote(x.fun,y)...) , *(promote(x.der,y)...))
        
function *(x::Dual,y::Dual)
    fun = *(promote(x.fun,y.fun)...)
    der = +(promote(*(promote(x.fun,y.der)...), *(promote(y.fun,x.der)...))...)
    return Dual(fun,der)
end

import Base./

function /(x::Real,y::Dual)
    fun = /(promote(x,y.fun)...)
    der = *(promote(-1.0,/(promote(*(promote(x,y.der)...),*(promote(y.fun,y.fun)...))...))...)
    return Dual(fun,der)
end

/(x::Dual,y::Real) = Dual(/(promote(x.fun,y)...) , /(promote(x.der,y)...))
        
function /(x::Dual,y::Dual)
    fun = /(promote(x.fun,y.fun)...)
    der = /(promote(-(promote(*(promote(x.der,y.fun)...), *(promote(y.der,x.fun)...))...),*(promote(x.fun,x.fun)...))...)
    return Dual(fun,der)
end


#println("Test suma:\n 5+Dual(1,4) = $(5+Dual(1,4)) \n Dual(1,8//2)+5 = $(Dual(1,8//2)+5) \n Dual(1.0,2)+Dual(9//3,4//2) = $(Dual(1.0,2)+Dual(9//3,4//2)) ")

#println("Test resta:\n 5-Dual(1,4) = $(5-Dual(1,4)) \n Dual(1,8//2)-5 = $(Dual(1,8//2)-5) \n Dual(1.0,2)-Dual(9//3,4//2) = $(Dual(1.0,2)-Dual(9//3,4//2)) ")

#println("Test producto:\n 5*Dual(1,4) = $(5*Dual(1,4)) \n Dual(1,8//2)*5 = $(Dual(1,8//2)*5) \n Dual(1.0,2)*Dual(9//3,4//2) = $(Dual(1.0,2)*Dual(9//3,4//2)) ")

#println("Test cociente:\n 5/Dual(1,4) = $(5/Dual(1,4)) \n Dual(1,8//2)/5 = $(Dual(1,8//2)/5) \n Dual(1.0,2)/Dual(9//3,4//2) = $(Dual(1.0,2)/Dual(9//3,4//2)) ")

import Base.^, Base.sqrt, Base.exp, Base.log, Base.sin, Base.cos, Base.tan, Base.asin, Base.acos, Base.atan, Base.sinh, Base.cosh, Base.tanh, Base.asinh, Base.acosh, Base.atanh

import Base.^
function ^(x::Dual,y::Real)
    fun = ^(promote(x.fun,y)...)
    der = *(promote(*(promote(x.der,y)...), ^(promote(x.fun,-(promote(y,1)...))...))...)
    return Dual(fun,der)
end

Dual(3.0,7.0)^2

1//2 * 5.0

*(promote(*(promote(2,3.0)...), ^(promote(4//7,-(promote(3.0,1)...))...))...)
