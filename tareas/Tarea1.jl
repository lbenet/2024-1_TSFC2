# # Tarea 1
#
# Fecha **final** de aceptación del PR: 18 de septiembre
#
# ---

# El objetivo de esta tarea es implementar un *módulo*, que se llamará
# `DifAutom`, cuyo objetivo es usar los números
# duales para llevar a cabo diferenciación automática
# en funciones de una variable. El módulo deberá incluirse en el
# archivo `duales.jl` (en su directorio de trabajo), y al usarlo deberán
# pasar todos los tests
# que se encuentran en `tareas/tests/difautom.jl`.
#
# Para verificar si su módulo pasa los tests, desde la
# carpeta en la que trabajan (subdirectorio en `tareas/`) y a partir de
# la línea de comandos, pueden usar la instrucción
# ```
# julia -E 'include("duales.jl"); include("../tests/difautom.jl")'
# ```
#
# Otra alternativa es, desde el REPL (iniciado en el directorio donde
# trabajan), usar los comandos que se usan arriba
# ```
# julia> include("duales.jl")              # carga su módulo
# julia> include("../tests/difautom.jl")   # corre los tests
# ```
#
# Todas las funciones que se definan deberán estar adecuadamente
# documentadas, idealmente usando *docstring* o en su defecto
# comentarios en el código.

#-
# ## 1:
#
# - Implementen una estructura *inmutable* (`struct`) que
# se llamará `Dual{T}` y que definirá los duales, donde `T`
# es el parámetro (`T<:Real`).
# La parte que identifica a $f_0$ será llamada `fun`, y la correspondiente
# a $f'_0$ será `der`; ambas deberán ser del mismo tipo `T` que es el
# parámetro de `Dual`.
#
# - Implementen métodos de `Dual` que haga
# [promociones](https://docs.julialang.org/en/v1/manual/conversion-and-promotion)
# adecuadamente, de tal manera que puedan usar la estructura con
# valores no homogéneos respecto al tipo, e.g., `Dual(1//2, 1.5)`. En el
# caso `Dual(1,2)`, que involucra enteros, la promoción debe hacerse a `Float64`.
#
# - Implementen dos funciones *de ayuda* `fun` y `der` que al usarse con un `Dual`
# devuelven la parte de la función $f_0$, o la de su derivada $f'_0$,
# respectivamente.
#

#-
# ## 2:
#
# - Implementen método(s) especiales que den los resultados esperados al
# usarse los `Dual`es con constantes numéricas, e.g., `Dual(c)`.
#
# - Implementen la función `dual(x)` que usaremos para
# definir la variable independiente en `x`.
#
# - Implementen la comparación (equivalencia) entre duales, es decir,
# sobrecarguen `==`.
#
# - Implementen las operaciones aritméticas `+`, `-`, `*`, `/`
# siguiendo lo visto en clase.
# Estas operaciones deben incluir las operaciones aritméticas que
# involucran un número cualquiera (`a :: Real`) y un `Dual` (`b::Dual`),
# o dos duales. Noten que todas estas operaciones en algún sentido
# involucran dos duales.

#-
# ## 3:
#
# - Extiendan el uso de `Dual` a las funciones elementales: `^`, `sqrt`,
# `exp`, `log`, `sin`, `cos`, `tan`, `asin`, `acos`, `atan`,
# `sinh`, `cosh`, `tanh`, `asinh`, `acosh`, `atanh`. Noten que la función `^`
# requiere de dos argumentos, aunque sólo uno es un `Dual`.
#
