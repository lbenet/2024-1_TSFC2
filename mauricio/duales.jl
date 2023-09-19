module DifAutom

    # Exporta todas las funciones del módulo.
    export Dual, fun, der, dual, +, -, *, /, ^, ==, inv, sqrt, sin, cos, tan, asin, acos, atan, sinh, cosh, tanh, asinh, acosh, atanh, exp, log
    ### 1

    struct Dual{T <: Real} # Define un objeto Dual con dos partes que corresponden a una función y su derivada.
        fun :: T
        der :: T
    end
    
    """
        Dual(x::T,y::S) where {T<:Real, S<:Real}
    
    Devuelve un objeto tipo Dual promoviendo los tipos de variable
    de x e y.
    """
    function Dual(x::T,y::S) where {T<:Real, S<:Real}
        return Dual(promote(x,y)...)
    end
    
    """
        Dual(x::T,y::S) where {T<:Integer, S<:Integer}
    
    Crea un objeto tipo Dual promoviendo ambos números enteros a flotantes.
    """
    function Dual(x::T,y::S) where {T<:Integer, S<:Integer}
        x, y, _ = promote(x,y,1.0)
        return Dual(x,y)
    end
    
    
    """
        fun(x::Dual)
    
    Devuelve el valor del dual que corresponde a la función.
    """
    function fun(x::Dual)
        return x.fun
    end
    
    """
        der(x::Dual)
    
    Devuelve el valor del dual que corresponde a la derivada.
    """
    function der(x::Dual)
        return x.der
    end

    ### 2

    """
        Dual(c::Real)
    
    Devuelve el dual (c,0) que corresponde a la constante numérica c.
    """
    function Dual(c::Real)
        return Dual(c,0)
    end
    
    """
        dual(x::Real)
    
    Devuelve el dual (x,1) que corresponde a la función identidad.
    """
    function dual(x::Real)
        return Dual(x,1)
    end
    
    import Base.:+, Base.:-, Base.:*, Base.:/, Base.==, Base.:inv
    
    """
        +(x::Dual,y::Dual)
    
    Devuelve la suma de duales.
    """
    function +(x::Dual,y::Dual)
        return Dual(x.fun+y.fun,x.der+y.der)
    end
    
    """
        +(x::Dual)
    
    Define el resultado de la expresión +x para el caso de duales.
    """
    function +(x::Dual)
        return x
    end
    
    """
        -(x::Dual,y::Dual)
    Devuelve la diferencia de duales.
    """
    function -(x::Dual,y::Dual)
        return Dual(x.fun-y.fun,x.der-y.der)
    end
    
    """
        -(x::Dual)
    
    Define el resultado de la expresión -x para el caso de duales.
    """
    function -(x::Dual)
        return Dual(-x.fun,-x.der)
    end
    
    """
        *(x::Dual,y::Dual)
    Devuelve el producto de duales.
    """
    function *(x::Dual,y::Dual)
        return Dual(x.fun*y.fun,x.fun*y.der+x.der*y.fun)
    end
    
    """
        /(x::Dual,y::Dual)
    Devuelve el cociente entre duales.
    """
    function /(x::Dual,y::Dual)
        return Dual(x.fun/y.fun,(y.fun*x.der-x.fun*y.der)/y.fun^2)
    end
    
    """
        ==(x::Dual,y::Dual)
    
    Define la igualdad entre duales.
    """
    function ==(x::Dual,y::Dual)
        return (x.fun == y.fun) && (x.der == y.der)
    end
    
    """
        +(x::Real,y::Dual)
    
    Devuelve la suma de duales tratando a x como una constante.
    """
    function +(x::Real,y::Dual)
        return Dual(x+y.fun,y.der)
    end
    
    """
        -(x::Real,y::Dual)
    
    Devuelve la diferencia de duales tratando a x como una constante.
    """
    function -(x::Real,y::Dual)
        return Dual(x-y.fun,-y.der)
    end
    
    """
        *(x::Real,y::Dual)
    
    Devuelve el producto de duales tratando a x como constante.
    """
    function *(x::Real,y::Dual)
        return Dual(x*y.fun,x*y.der)
    end
    
    """
        /(x::Real,y::Dual)
    
    Devuelve el cociente entre duales tratando a x como constante.
    """
    function /(x::Real,y::Dual)
        return Dual(x/y.fun,(-x*y.der)/y.fun^2)
    end
    
    """
        ==(x::Real,y::Dual)
    
    Define la igualdad entre duales tratando a x como constante.
    """
    function ==(x::Real,y::Dual)
        return Dual(x) == y
    end
    
    """
        +(x::Dual,y::Real)
    
    Devuelve la suma de duales tratando a y como una constante.
    """
    function +(x::Dual,y::Real)
        return Dual(x.fun+y,x.der)
    end
    
    """
        -(x::Dual,y::Real)
    
    Devuelve la diferencia entre duales tratando a y como una constante.
    """
    function -(x::Dual,y::Real)
        return Dual(x.fun-y,x.der)
    end
    
    """
        *(x::Dual,y::Real)
    
    Devuelve el producto entre duales tratando a y como una constante.
    """
    function *(x::Dual,y::Real)
        return y*x
    end
    
    """
        /(x::Dual,y::Real)
    
    Devuelve el cociente entre duales tratando a y como una constante.
    """
    function /(x::Dual,y::Real)
        return Dual(x.fun/y,(y*x.der)/y^2)
    end
    
    """
        ==(x::Dual,y::Real)
    
    Define la igualdad entre duales tratando a y como constante.
    """
    function ==(x::Dual,y::Real)
        return x == Dual(y)
    end
    
    """
        inv(x::Dual)
    
    Devuelve el dual correspondiente a 1/x.
    """
    function inv(x::Dual)
       return Dual(1/x.fun,-x.der/x.fun^2)
    end

    ### 3

    import Base.Math.:^ # Importa la función ^ para añadir un nuevo método.
    
    """
        ^(x::Dual,y::Real)
    
    Implementación de la elevación de un dual x a un exponente constante y.
    """
    function ^(x::Dual,y::Real)
        return Dual(x.fun^y,y*x.fun^(y-1)*x.der)
    end
    
    import Base.Math.:sqrt # Importa la función sqrt para añadir un nuevo método.
    
    """
        sqrt(x::Dual)
    
    Implementación de la raíz cuadrada de un dual.
    """
    function sqrt(x::Dual)
        return Dual(sqrt(x.fun),x.der*1/(2*sqrt(x.fun)))
    end
    
    import Base.Math.:sin # Importa la función sin para añadir un nuevo método.
    
    """
        sin(x::Dual)
    
    Implementación del seno de un dual.
    """
    function sin(x::Dual)
        return Dual(sin(x.fun),x.der*cos(x.fun))
    end
    
    import Base.Math.:cos # Importa la función cos para añadir un nuevo método.
    
    """
        cos(x::Dual)
    
    Implementación del coseno de un dual.
    """
    function cos(x::Dual)
        return Dual(cos(x.fun),-x.der*sin(x.fun))
    end
    
    import Base.Math.:tan # Importa la función tan para añadir un nuevo método.
    
    """
        tan(x::Dual)
    
    Implementación de la tangente de un dual.
    """
    function tan(x::Dual)
        return Dual(tan(x.fun),x.der*sec(x.fun)^2)
    end
    
    import Base.Math.:asin # Importa la función asin para añadir un nuevo método.
    
    """
        asin(x::Dual)
    
    Implementación del arcoseno de un dual.
    """
    function asin(x::Dual)
        return Dual(asin(x.fun),x.der*1/sqrt(1-x.fun^2))
    end
    
    import Base.Math.:acos # Importa la función acos para añadir un nuevo método.
    
    """
        acos(x::Dual)
    
    Implementación del arcocoseno de un dual.
    """
    function acos(x::Dual)
        return Dual(acos(x.fun),-x.der*1/sqrt(1-x.fun^2))
    end
    
    import Base.Math.:atan # Importa la función atan para añadir un nuevo método.
    
    """
        atan(x::Dual)
    
    Implementación de la arcotangente de un dual.
    """
    function atan(x::Dual)
        return Dual(atan(x.fun),x.der*1/(1+x.fun^2))
    end
    
    import Base.Math.:sinh # Importa la función sinh para añadir un nuevo método.
    
    """
        sinh(x::Dual)
    
    Implementación del seno hiperbólico de un dual.
    """
    function sinh(x::Dual)
        return Dual(sinh(x.fun),x.der*cosh(x.fun))
    end
    
    import Base.Math.:cosh # Importa la función cosh para añadir un nuevo método.
    
    """
        cosh(x::Dual)
    
    Implementación del coseno hiperbólico de un dual.
    """
    function cosh(x::Dual)
        return Dual(cosh(x.fun),x.der*sinh(x.fun))
    end
    
    import Base.Math.:tanh # Importa la función tanh para añadir un nuevo método.
    
    """
        tanh(x::Dual)
    
    Implementación de la tangente hiperbólica de un dual.
    """
    function tanh(x::Dual)
        return Dual(tanh(x.fun),x.der*sech(x.fun)^2)
    end
    
    import Base.Math.:asinh # Importa la función asinh para añadir un nuevo método.
    
    """
        asinh(x::Dual)
    
    Implementación del arcoseno hiperbólico de un dual.
    """
    function asinh(x::Dual)
        return Dual(asinh(x.fun),x.der/cosh(asinh(x.fun)))
    end
    
    import Base.Math.:acosh # Importa la función acosh para añadir un nuevo método.
    
    """
        acosh(x::Dual)
    
    Implementación del arcocoseno hiperbólico de un dual.
    """
    function acosh(x::Dual)
        return Dual(acosh(x.fun),x.der/sinh(acosh(x.fun)))
    end
    
    import Base.Math.:atanh # Importa la función atanh para añadir un nuevo método.
    
    """
        atanh(x::Dual)
    
    Implementación de la arcotangente hiperbólica de un dual.
    """
    function atanh(x::Dual)
        return Dual(atanh(x.fun),x.der*cosh(atanh(x.fun))^2)
    end
    
    import Base.Math.:exp # Importa la función exp para añadir un nuevo método.
    
    """
        exp(x::Dual)
    
    Implementación de la exponencial de un dual.
    """
    function exp(x::Dual)
        return Dual(exp(x.fun),x.der*exp(x.fun))
    end
    
    import Base.Math.:log # Importa la función log para añadir un nuevo método.
    
    """
        log(x::Dual)
    
    Implementación del logaritmo de un dual.
    """
    function log(x::Dual)
        return Dual(log(x.fun),x.der/x.fun)
    end

end

using .DifAutom