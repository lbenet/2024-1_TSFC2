"
********************

    DifAutom

# Diferenciación automática

Este módulo sirve para hacer diferenciación automática usando números duales.

Los números duales son de la forma

x + ϵ*y

donde x e y son números reales. x es la parte real e y es la parte dual que está multiplicada por un número ϵ distinto de cero pero cumple que ϵ^2 = 0.

Los números duales se pueden sumar y multiplicar de la siguiente forma

(a + ϵ*b) + (c + ϵ*d) = (a + c) + ϵ*(b + d)

(a + ϵ*b)(c + ϵ*d) = (a*c) + ϵ*(a*d + b*c)

Y si se evalua en una función se cumple que

f(a + ϵ*b) = f(a) + ϵ*b*f'(a)

donde f'(a) es la derivada de f evaluada en a.

Puedes empezar definiendo un número dual con `Dual(x,y)`, `Dual(x)` o `dual(x)`. Para obtener la parte real se usa `fun( )` y `der( )`. Puedes revisar la respectiva documentación de cada uno.

Este módulo ya hace las operaciones aritméticas y booleanas necesarias entre duales así como su evaluación en funciones trascendentales no especiales.

********************
"
module DifAutom

export Dual, fun, der, dual

"""
********************

    Dual(x::T,y::T) where T<:Real

Es una estructura inmutable que representa un número dual de la forma `x + ϵ*y`.
"""
struct Dual{T<:Real}
    fun::T
    der::T
end

"""
********************

    Dual(x::Integer,y::Integer)

Para el caso donde ambas entradas sean números enteros se hace la promoción a flotantes.

## Ejemplos

    julia> Dual(1,2)
    Dual{Float64}(1.0, 2.0)

    julia> Dual(big(1),1)
    Dual{BigFloat}(1.0, 1.0)
"""
Dual(x::Integer,y::Integer)  = Dual(promote(x,y,1.0)[1:2]...)

"""
********************

    Dual(x::T,y::S) where {T<:Real,S<:Real}

Para casos donde las entradas no sean del mismo tipo se hace promoción entre ellas.

## Ejemplos

    julia> Dual(1//1,1)
    Dual{Rational{Int64}}(1//1, 1//1)

    julia> Dual(big(1//1),1)
    Dual{Rational{BigInt}}(1//1, 1//1)

    julia> Dual(1//1,1.0)
    Dual{FLoat64}(1.0,1.0)

    julia> Dual(1,1.0)
    Dual{Float64}(1.0,1.0)

    julia> Dual(big(1//1),1.0)
    Dual{BigFloat}(1.0, 1.0)

    julia> Dual(1.0,big(1.0))
    Dual{BigFloat}(1.0, 1.0)
"""
Dual(x,y) = Dual(promote(x,y)...)

"""
********************

    fun(a::Dual{T}) where T<:Real

Es una función que te devuelve la parte real del número dual `a`

## Ejemplos

    julia> fun(Dual(1.0,6.5))
    1.0
********************
"""
fun(a::Dual{T}) where T<:Real = a.fun

"""
********************

    der(a::Dual{T}) where T<:Real 

Es una función que te devuelve la parte dual del número dual `a`

## Ejemplos

    julia> der(Dual(1.0,6.5))
    6.5
********************
"""
der(a::Dual{T}) where T<:Real = a.der

"""
********************

    Dual(c::T) where T<:Real

Es un método de `Dual` donde `c` es la función constante y su parte dual es la derivada de la función constante `der = 0`.

## Ejemplos

    julia> Dual(2.5)
    Dual(2.5,0.0)
"""
Dual(c::T) where T<:Real = Dual(c,zero(T))

"""
********************

    dual(x::T) where T<:Real

Es la función identidad `f(x) = x` evaluada `Dual(x,1.0) = x + ϵ`, es decir, `f(Dual(x,1.0)) = f(x + ϵ) = x + ϵ = Dual(x,1.0)`

## Ejemplos

    julia> dual(2.5)
    Dual(2.5,1.0)
********************
"""
dual(x::T) where T<:Real = Dual(x,one(T))

import Base.==

==(x::Dual,y::Dual) = (x.fun == y.fun) && (x.der == y.der)
==(x::Real,y::Dual) = (x == y.fun) && (y.der == zero(y.der))
==(x::Dual,y::Real) = (x.fun == y) && (x.der == zero(x.der))

import Base.+

+(x::Dual) = x
+(x::Real,y::Dual) = Dual(x+y.fun,y.der)
+(x::Dual,y::Real) = Dual(x.fun+y,x.der)
+(x::Dual,y::Dual) = Dual(x.fun+y.fun,x.der+y.der)

import Base.-

-(x::Dual) = Dual(-x.fun,-x.der)
-(x::Real,y::Dual) = Dual(x-y.fun,y.der)
-(x::Dual,y::Real) = Dual(x.fun-y,x.der)
-(x::Dual,y::Dual) = Dual(x.fun-y.fun,x.der-y.der)

import Base.*

*(x::Real,y::Dual) = Dual(x*y.fun,x*y.der)
*(x::Dual,y::Real) = Dual(x.fun*y,x.der*y)        
*(x::Dual,y::Dual) = Dual(x.fun*y.fun,x.fun*y.der+y.fun*x.der)

import Base./

/(x::Real,y::Dual) = Dual(x/y.fun,-x*y.der/y.fun^2)
/(x::Dual,y::Real) = Dual(x.fun/y,x.der/y)
/(x::Dual,y::Dual) = Dual(x.fun/y.fun,(x.der*y.fun-y.der*x.fun)/y.fun^2)

import Base.^,Base.inv

^(x::Dual,y::Real) = Dual(x.fun^y,x.der*y*x.fun^(y-1))
^(x::Real,y::Dual) = Dual(x^y.fun,y.der*x^y.fun*log(x))
^(x::Dual,y::Dual) = Dual(x.fun^y.fun,x.der*y.fun*(x.fun^(y.fun-1.0))+y.der*(x.fun^y.fun)*log(x.fun))
inv(x::Dual) = 1/x

import Base.sqrt

sqrt(x::Dual) = x^0.5

import Base.exp

exp(x::Dual) = Dual(exp(x.fun),x.der*exp(x.fun))

import Base.log

log(x::Dual) = Dual(log(x.fun),x.der/x.fun)

import Base.sin, Base.cos, Base.tan

sin(x::Dual) = Dual(sin(x.fun),x.der*cos(x.fun))
cos(x::Dual) = Dual(cos(x.fun),-x.der*sin(x.fun))
tan(x::Dual) = Dual(tan(x.fun),x.der*sec(x.fun)^2)

import Base.asin, Base.acos, Base.atan

asin(x::Dual) = Dual(asin(x.fun),x.der/sqrt(1-x.fun^2))
acos(x::Dual) = Dual(acos(x.fun),-x.der/sqrt(1-x.fun^2))
atan(x::Dual) = Dual(atan(x.fun),x.der/(1+x.fun^2))

import Base.sinh, Base.cosh, Base.tanh

sinh(x::Dual) = Dual(sinh(x.fun), x.der*cosh(x.fun))
cosh(x::Dual) = Dual(cosh(x.fun), x.der*sinh(x.fun))
tanh(x::Dual) = Dual(tanh(x.fun), x.der*sech(x.fun)^2)

import Base.asinh, Base.acosh, Base.atanh

asinh(x::Dual) = Dual(asinh(x.fun),x.der/sqrt(x.fun^2 + 1))
acosh(x::Dual) = Dual(acosh(x.fun),x.der/(sqrt(x.fun-1)*sqrt(x.fun+1)))
atanh(x::Dual) = Dual(atanh(x.fun),x.der/(1-x.fun^2))


end