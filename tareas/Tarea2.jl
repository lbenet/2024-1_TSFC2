# # Tarea 2
#
# Fecha **final** de aceptación del PR: 31 de octubre
#
# ---

# El objetivo de esta tarea es implementar la integración de EDOs usando el
# método de Taylor. Nos basaremos en la paquetería `TaylorSeries.jl` para
# el álgebra de polinomios.
# Todas las funciones necesarias deberán encontrarse en
# el archivo `integracion_taylor.jl`.
# Su implementación deberá pasar los tests que están en
# `tests/integ_taylor.jl`, de manera similar a como lo hicimos en la Tarea 1.

# El integrador deberá hacer las operaciones necesarias para obtener
# los coeficientes $x_{[k]}$ de la serie de Taylor de la solución,
# *en cada paso de integración*, a partir
# de la condición inicial "local", o sea, al tiempo de interés.

#-
# ## 0:
#
# Familiarícense con la paquetería `TaylorSeries.jl`; para esto, lean
# su documentación, en particular
# [la guía del uso para una variable](https://juliadiff.org/TaylorSeries.jl/stable/userguide/#One-independent-variable).
# Muchos trucos que necesitarán están escondidos ahí.

#-
# ## 1:
#
# En este ejercicio implementarán dos métodos para calcular los coeficientes
# de Taylor de la o las variables dependientes en términos de la variable
# independiente, tales que dichas series de Taylor satisfagan la
# ecuación diferencial.
# - Caso escalar: Implementen la función `coefs_taylor(f, t, u, p)`
# que calculará los coeficientes ``u_{[k]}`` de la expansión de Taylor
# para la variable dependiente en términos de la independiente (``t``),
# y regresará el desarrollo de Taylor de la solución local (`::Taylor1`).
# Los argumentos de esta función son la función `f` que define
# a la ecuación diferencial, la variable independiente `t::Taylor1`, la variable
# dependiente `u::Taylor1`, y `p` que representa los parámetros necesarios
# que se requieran en la función `f` (y que pueden ser `nothing`).
# La convención para la definición de
# `f` en el *caso escalar* es que tenga la forma `f(u, p, t)`), con `p`
# los parámetros que sean necesarios.
# - Caso vectorial: Implementen la función `coefs_taylor!(f!, t, u, du, p)`,
# que usaremos cuando tenemos un *sistema* de ecuaciones diferenciales.
# Los argumentos son la función
# `f!` que define las ecuaciones diferenciales, la variable independiente
# `t::Taylor1`, el vector (de objetos `Taylor1`) con las variables
# dependientes `u`, el vector (de objetos `Taylor1`)
# con el lado izquierdo de las ecuaciones diferenciales `du`, y
# finalmente los parámetros necesarios representados por `p`.
# La función `f!`, en el caso vectorial, usará para su definición la
# convención `f!(du, u, p, t)`, y debe estar definida de tal manera que
# `du` (a la salida) corresponda al lado izquierdo de
# las ecuaciones diferenciales. Es decir, la `du` de entrada será modificada
# por la función de manera apropiada. La función `coefs_taylor!` debe
# estar implementada de tal
# manera que `u` y `du` *cambien* (se actualizen) de manera adecuada,
# es decir, esta función cambiará los valores de essos argumentos.
# (Es por eso que, en este caso, el nombre de la función incluye `!`.)

#-
# ## 3:
# Implementen la función `paso_integracion(u, epsilon)` con *dos métodos* (dependiendo si
# estamos con una ecuación diferencial escalar o vectorial), donde se obtenga el paso
# de integración $h$ a partir de los *dos últimos coeficientes* $x_{[k]}$ del desarrollo de
# Taylor para las variables dependientes, multiplicado por 0.5.
# (Para el caso vectorial, el paso de integración
# será el menor de los pasos de integración asociados a cada variable dependiente.)
# Esta función dependerá de la serie de Taylor para la variable dependiente `u`
# (o del vector correspondiente), y de la tolerancia absoluta `epsilon`.

#-
# ## 4:
# Combinen las funciones anteriores en dos funciones, `paso_taylor` para el caso escalar y
# `paso_taylor!` para el vectorial, que combine las funciones implementadas en los
# ejercicios 2 y 3 adecuadamente. Estas funciones dependerán de `f`, `t`, `u`, y
# `du` sólo para el caso vectorial, la tolerancia absoluta epsilon, y los parámetros `p`. Las
# funciones devolverán `u` y el paso de integración `h` en el caso escalar, y en el caso vectorial
# únicamente `h`, ya que el código debe ser escrito de tal manera que `u` y `du` deben
# ser actualizadas/modificadas por la función (dado que son vectores, y los vectores son mutables).
# Es decir, esta función deberá devolver la serie de Taylor de la solución y el paso de integración.

#-
# ## 5:
# Escriban la función `integracion_taylor` (con dos métodos al menos) donde,
# a partir de las condiciones iniciales `x0` se implementen todos los pasos necesarios
# para integrar desde `t_ini` hasta `t_fin` las ecuaciones diferenciales definidas por `f`.
# Los argumentos de esta función serán la función `f`, la condición inicial `x0` (escalar o
# vectorial), `t_ini`, `t_fin`, el orden para los desarrollos de Taylor, la tolerancia
# absoluta ϵ, y los parámetros `p` necesarios para las ecuaciones diferenciales.
# Noten que si `t_ini < t_fin` la integración es "hacia adelante" en el tiempo, mientras que si
# `t_ini > t_fin` la integración es "hacia atrás"; el integrador debe funcionar en ambos casos.
# La función deberá devolver un vector con los tiempos calculados a cada paso de integración,
# y un vector con la variable dependiente obtenida de la integración; noten que si estamos en
# el caso vectorial, la salida que corresponde a los valores obtenidos de la variable dependiente
# será un vector de vectores. Esta función debe ser exportada por el módulo `IntegTaylor`.
#
# Un punto importante a notar es que el integrador debe evitar situaciones donde se tenga ciclos
# infinitos, en particular, en el número de pasos de integración. Esto puede ocurrir
# dado que el paso de integración es demasiado pequeño (y el tiempo final no se alcanza).
# La manera de evitar esto puede ser imponiendo un número máximo de pasos de integración (que el
# usuario puede cambiar), o poniendo una cota ínfima para el paso de integración. La implementación
# concreta se las dejo a su criterio, pero los valores default deben permitir que
# el integrador pase los tests.

#-