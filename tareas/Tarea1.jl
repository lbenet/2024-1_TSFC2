# # Tarea 1
#
# Fecha **final** de aceptación del PR: 18 de septiembre
#
# ---

# El objetivo de esta tarea es implementar un *módulo*, que se llamará
# `DifAutom`, cuo obejetivo es usar los
# duales para poder llevar a cabo diferenciación automática
# en funciones de una variable. El módulo deberá incluirse en el
# archivo `duales.jl`, y al usarlo deberán pasar todos los tests
# que se encuentran en la carpeta `tareas/tests/difautom.jl`.
# Todas las funciones que se definan deberán estar adecuadamente
# documentadas, idealmente usando *docstring* o en su defecto
# comentarios en el código.

#-
# ## 1:
#
# - Implementen una estructura paramétrica *inmutable* (`struct`) que
# se llamará `Dual` y que definirá los duales.
# La parte que identifica a $f_0$ será llamada `fun`, y la correspondiente
# a $f'_0$ será `der`; ambas deberán ser del mismo tipo `Float64`, por
# ahora.

# - Implementen dos funciones `fun` y `der` que al usarse con un `Dual`
# devuelven la parte de la función $f_0$ o la de su derivada $f'_0$,
# respectivamente.
#
# - Definan métodos especiales que den los resultados esperados al definirse
# `Dual`es con constantes numéricas, e.g., `Dual(c)`. Para
# definir la variable independiente de los duales usaremos
# la función `dual(x_0)`, cuyo resultado corresponderá al $(x_0, 1)$.

#-

# ## 2:
#
# - Implementen la comparación (equivalencia) entre duales, es decir,
# sobrecarguen `==`.
#
# - Implementen las operaciones aritméticas `+`, `-`, `*`, `/` y `^`
# siguiendo lo visto en clase.
# Estas operaciones deben incluir las operaciones aritméticas que
# involucran un número cualquiera (`a :: Real`) y un `Dual` (`b::Dual`),
# o dos duales.

#-

# ## 3:
#
# - Extiendan el uso de `Dual` a las funciones elementales: `sqrt`,
# `exp`, `log`, `sin`, `cos`, `tan`, `asin`, `acos`, `atan`,
# `sinh`, `cosh`, `tanh`, `asinh`, `acosh`, `atanh`.
#
