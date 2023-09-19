module DifAutom

export Dual, dual, fun, der

# Definición de un tipo paramétrico Dual{T}, que representa números duales.
# Un número dual tiene dos partes: 'fun' para el valor de la función y 'der' para la derivada.

struct Dual{T<:Real}
    fun::T   # Valor de la función
    der::T   # Derivada
end

# Constructor genérico para crear un número dual a partir de dos valores.
# Toma dos argumentos 'a' y 'b' y promueve sus tipos al tipo común más alto.
# Luego crea un objeto Dual con esos valores.
function Dual(a, b)
    x, y = promote(a, b)
    return Dual(x, y)
end

# Constructor específico para crear un número dual a partir de dos enteros.
# Se asegura de que 'a' y 'b' sean enteros, y luego promueve su tipo al tipo común más alto.
function Dual(a::T, b::T) where {T<:Integer}
    x, y, _ = promote(a, b, 1.0)  # También promueve el tipo 1.0 si es necesario.
    return Dual(x, y)
end

# Función para obtener el valor de la función de un número dual.
function fun(S::Dual)
    return S.fun
end

# Función para obtener la derivada de un número dual.
function der(S::Dual)
    return S.der
end

# Constructor para crear un número dual a partir de un solo valor.
# La derivada se establece en 0 por defecto.
function Dual(a::T) where {T<:Number}
    return Dual(a, 0)
end

# Constructor para crear un número dual a partir de un solo valor.
# La derivada se establece en 1 por defecto.
function dual(a::T) where {T<:Number}
    return Dual(a, 1)
end




import Base: +, *, /, ==, -, sqrt, ^, exp, log, sin, cos, tan, asin, acos, atan, sinh, cosh, tanh, asinh, acosh, atanh, inv


# Sobrecarga del operador de resta para números duales.
-(a::Dual, b::Dual) = Dual(a.fun - b.fun, a.der - b.der)

# Sobrecarga del operador de resta para un número real y un número dual.
-(a::Real, b::Dual) = Dual(a - b.fun, b.der)

# Sobrecarga del operador de resta para un número dual y un número real.
-(a::Dual, b::Real) = Dual(a.fun - b, a.der)

# Sobrecarga del operador de negación para números duales.
-(a::Dual) = Dual(-a.fun, -a.der)

# Sobrecarga del operador de suma para números duales.
+(a::Dual, b::Dual) = Dual(a.fun + b.fun, a.der + b.der)

# Sobrecarga del operador de suma para un número real y un número dual.
+(a::Real, b::Dual) = Dual(a + b.fun, b.der)

+(a::Dual, b::Real) = b+a

+(a::Dual) = Dual(+a.fun, +a.der)


# Sobrecarga del operador de multiplicación para números duales.
*(a::Dual, b::Dual) = Dual(a.fun * b.fun, a.fun * b.der + a.der * b.fun)

# Sobrecarga del operador de multiplicación para un número real y un número dual.
*(a::Real, b::Dual) = Dual(a * b.fun, a * b.der)

*(a::Dual, b::Real) = b*a


# Sobrecarga del operador de división para números duales.
function /(a::Dual, b::Dual)
    if a.fun == b.fun && a.der == b.der
        return 1.0
    else
        return Dual(a.fun / b.fun, (a.der * b.fun - a.fun * b.der) / (b.fun^2))
    end
end

# Sobrecarga del operador de división para un número real y un número dual.
/(a::Real, b::Dual) = Dual(a) / b

# Sobrecarga del operador de división para un número dual y un número real.
/(a::Dual, b::Real) = Dual(a.fun / b, a.der / b)



# Sobrecarga de la función sqrt para números duales.
function sqrt(a::Dual)
    return Dual(sqrt(a.fun), a.der / (2 * sqrt(a.fun)))
end

# Sobrecarga del operador de igualdad para números duales.
==(a::Dual, b::Dual) = a.fun == b.fun && a.der == b.der

# Sobrecarga del operador de igualdad para un número y un número dual.
function ==(a::Number, b::Dual)
    if a isa Number && b.der == 0
        return a == b.fun
    else
        return false
    end
end

# Sobrecarga de la función de igualdad especializada para BigFloat.
function ==(a::Dual{BigFloat}, b::BigFloat)
    return a.fun == b
end




# Sobrecarga del operador de potencia para números duales.
^(a::Dual, n::Real) = Dual(a.fun^n, n * a.fun^(n - 1) * a.der)

# Sobrecarga de la función exponencial para números duales.
exp(a::Dual) = Dual(exp(a.fun), exp(a.fun) * a.der)

# Sobrecarga de la función logaritmo para números duales.
log(a::Dual) = Dual(log(a.fun), a.der / a.fun)

# Sobrecarga de la función seno para números duales.
sin(a::Dual) = Dual(sin(a.fun), cos(a.fun) * a.der)

# Sobrecarga de la función coseno para números duales.
cos(a::Dual) = Dual(cos(a.fun), -sin(a.fun) * a.der)

# Sobrecarga de la función tangente para números duales.
tan(a::Dual) = Dual(tan(a.fun), (sec(a.fun))^2 * a.der)

# Sobrecarga de la función arcoseno para números duales.
asin(a::Dual) = Dual(asin(a.fun), a.der / sqrt(1 - a.fun^2))


# Sobrecarga de la función arcocoseno para números duales.
acos(a::Dual) = Dual(acos(a.fun), -a.der / sqrt(1 - a.fun^2))

# Sobrecarga de la función arcotangente para números duales.
atan(a::Dual) = Dual(atan(a.fun), a.der / (1 + a.fun^2))

# Sobrecarga de la función seno hiperbólico para números duales.
sinh(a::Dual) = Dual(sinh(a.fun), cosh(a.fun) * a.der)

# Sobrecarga de la función coseno hiperbólico para números duales.
cosh(a::Dual) = Dual(cosh(a.fun), sinh(a.fun) * a.der)

# Sobrecarga de la función tangente hiperbólica para números duales.
tanh(a::Dual) = Dual(tanh(a.fun), (sech(a.fun))^2 * a.der)

# Sobrecarga de la función arcoseno hiperbólico para números duales.
asinh(a::Dual) = Dual(asinh(a.fun), a.der / sqrt(a.fun^2 + 1))

# Sobrecarga de la función arcocoseno hiperbólico para números duales.
acosh(a::Dual) = Dual(acosh(a.fun), a.der / sqrt(a.fun^2 - 1))

# Sobrecarga de la función arcotangente hiperbólica para números duales.
atanh(a::Dual) = Dual(atanh(a.fun), -a.der / (a.fun^2 - 1))


function inv(a::Dual)
    if a.fun == 0.0
        throw(ZeroDivisionError("No se puede calcular la inversa de un número dual con valor cero."))
    else
        return 1.0 / a
    end
end

end

