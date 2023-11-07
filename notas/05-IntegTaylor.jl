# # Integración con el método de Taylor

#-
# Aquí describiremos el método de Taylor para la integración de ecuaciones
# diferenciales ordinarias con una condición inicial, o problemas de valor inicial.
# El método de Taylor es equivalente al método de Picard. Usaremos inicialmente un ejemplo concreto
# sencillo para ilustrar el método, y luego generalizaremos los pasos que se describen.

#-
# ## Teorema de existencia y unicidad (Picard-Lindelöf)

#-
# El punto de partida, y que es *absolutamente importante* en todo lo que sigue, es el
# [Teorema Fundamental de las Ecuaciones Diferenciales
# Ordinarias](https://en.wikipedia.org/wiki/Picard%E2%80%93Lindel%C3%B6f_theorem), (o
# teorema de existencia y unicidad de las EDOs):

# > #### Teorema (Picard-Lindelöf)
# > Consideren el problema de valores iniciales:
# > ```math
# > y'(t)=f(t,y(t)),\ y(t_0)=y_0.
# > ```
# > Suponemos que $f(t,y)$ es *Lipschitz uniformemente continua* respecto a $y$ (lo que
# > significa que hay una constante, independiente de $t$, que acota $f$ para todo valor
# > en el intervalo de su dominio), y continua en $t$.
# >
# > Entonces, para algún valor $\varepsilon > 0$ *existe*
# > una solución *única* $y(t)$ al problema de valor inicial en el intervalo
# > $[t_0-\varepsilon, t_0+\varepsilon]$.

#-
# Es importante **enfatizar** que el teorema establece la existencia y unicidad de la solución
# *solamente* para un intervalo de $t$ (la variable independiente) en torno al tiempo *inicial*
# $t_0$, que es el que define a la condición inicial.
# Es decir, sólo se garantiza la existencia y unicidad de
# la solución en un entorno de $t_0$, y no necesariamente
# para todo tiempo $t>t_0$.

#-
# ## Un ejemplo sencillo

#-
# El método de Taylor lo describiremos a través de un ejemplo. Concretamente, ilustraremos
# cómo integrar la ecuación diferencial
#
# ```math
# \dot{x} = f(x) = x^2,
# ```
#
# con la condición inicial $x(0) = x_0 = 3$.

#-
# Antes de describir el método de Taylor, vale la pena notar que esta ecuación la podemos
# resolver analíticamente. La solución, como se puede comprobar rápidamente, es
# ```math
# x(t) = \frac{3}{1-3t}.
# ```
# Esta solución *diverge* cuando $t\to 1/3$; entonces, este es un ejemplo de que la
# solución $x(t)$ **no necesariamente existe** para $t>1/3$, si la condición
# inicial es $x(0)=3$.

#-
# El comentario anterior implica que,
# si hiciéramos una integración "larga" usando `Float64` y un *paso de integración constante*
# (o sea, a partir de $x(t_k)$ obtenemos $x(t_{k+1})$, con
# $t_{k+1} = t_0 + (k+1)\delta t = t_k + \delta t$, siendo $\delta t$ un valor constante),
# independientemente del método de integración,
# el método continuará más allá de $t=1/3$, que es el valor más grande de $t$ donde la
# solución tiene sentido. (Si tenemos la buena fortuna de caer exactamente en $t_n=1/3$
# que es un valor *no exactamente representable* por números de punto flotante en base 2,
# la solución en ese punto será `Inf`).
# Esto es una *advertencia* de que uno debe ser extremandamente cuidadoso si considera
# pasos de integración constantes. Sin embargo, si tenemos un método de integración con
# paso adaptativo, hay esperanza de que este problema no ocurra.
#
# Esto es una *advertencia* de que uno debe ser extremandamente cuidadoso si considera
# pasos de integración constantes. Sin embargo, si tenemos un método de integración con
# paso adaptativo, hay esperanza de que este problema no ocurra.

#-
# La idea del método de Taylor es *construir* una solución *local* en $t$, que aproxime muy
# bien la solución de la ecuación diferencial en alguna vecindad del punto inicial $t_0$.
# En particular, escribimos la solución como un polinomio (de Taylor) en torno a $t_0$ con la
# siguiente forma:
# ```math
# x(t) = \sum_{k=0}^\infty x_{[k]} (t-t_0)^k,
# ```
# donde $x_{[k]} = x_{[k]}(t_0)$ es el coeficiente de Taylor normalizado de orden $k$
# evaluado en $t_0$ que, como hemos visto, está relacionado con la $k$-ésima derivada de $x(t)$.
# Esta solución claramente cumple la condición inicial al imponer que $x_{[0]}(t_0) = x_0$.
# Excepto por $x_{[0]}(t_0)$, el resto de los coeficientes del desarrollo están
# aún por determinar, cosa que haremos iterativamente.

#-
# Una manera alternativa de escribir $x(t)$ es a través del uso del incremento en el tiempo,
# $\delta_t = t-t_0$, o lo que es lo mismo, $t = t_0 + \delta_t$. Entonces, podemos escribir
# $x(t)=x(t_0+\delta_t)$, donde la serie de Taylor anterior será escrita en términos de
# $\delta_t$ como variable independiente, y que consideraremos como una *cantidad pequeña*.

#-
# Empezaremos considerando que $x(t_0+\delta_t)$ es un polinomio infinito, o sea, construiremos la
# solución analítica; después entraremos en las sutilezas de tener aproximaciones de
# orden finito.

#-
# ### Solución a primer orden

#-
# Empezamos escribiendo, la aproximación de primer orden a la solución
# ```math
# x(t) = x(t_0+\delta_t) = x_0 + x_{[1]} \delta_t + \mathcal{O}(\delta_t^2).
# ```
# La idea es obtener el valor de $x_{[1]}(t_0)$ de tal manera que se satisfaga la ecuación
# diferencial. Derivando ambos lados respecto a $t$ (o $\delta_t$, que *de facto* es la variable
# independiente), tenemos que $\dot{x} = x_{[1]}+ \mathcal{O}(\delta_t)$ y,
# sustituyendo en la ecuación diferencial original obtenemos
# ```math
# \begin{align*}
# x_{[1]} + \mathcal{O}(\delta_t) = & \, \big[x_0 + x_{[1]} \delta_t + \mathcal{O}(\delta_t^2)\big]^2 \\
# = & \, x_0^2 + \mathcal{O}(\delta_t).
# \end{align*}
# ```
# De aquí concluimos que $x_{[1]}(t_0)=x_0^2$.

#-
# Es importante notar que **no** necesitamos hacer el cálculo explícito del cuadrado
# de todo el polinomio; en este caso, *únicamente* calculamos (y usamos) el término de
# orden cero en el lado derecho de la ecuación.

#-
# ### Solución a segundo orden y órdenes mayores

#-
# Siguiendo como antes, para la aproximación a segundo orden escribimos
# ```math
# x(t_0+\delta_t) = x_0 + x_0^2 \delta_t + x_{[2]}\delta_t^2+\mathcal{O}(\delta_t^3),
# ```
# donde hemos substituido que $x_{[1]}=x_0^2$, y queremos obtener $x_{[2]}(t_0)$.
# Nuevamente derivamos; en este caso, la derivada es
# ```math
# \dot{x} = x_0^2 + 2 x_{[2]}\delta_t + \mathcal{O}(\delta_t^2),
# ```
# y sustituyendo nuevamente en la ecuación diferencial obtenemos
# ```math
# \begin{align*}
# x_0^2 + 2 x_{[2]}\delta_t + \mathcal{O}(\delta_t^2) = & \,
# \big[x_0 + x_0^2 \delta_t + x_{[2]}\delta_t^2+\mathcal{O}(\delta_t^3)\big]^2 \\
# = & \, x_0^2 + 2 x_0^3 \delta_t + \mathcal{O}(\delta_t^2).
# \end{align*}
# ```
#
# De aquí obtenemos $x_{[2]}(t_0) = x_0^3$. Nuevamente, vale la pena notar que para el
# lado derecho de la ecuación sólo hemos calculado hasta primer orden para obtener $x_{[2]}$.

#-
# Para órdenes más altos, uno continua el mismo procedimiento:
# ```math
# x(t_0+\delta_t) = x_0 + x_0^2 \delta_t + x_0^3 \delta_t^2+ x_{[3]}\delta_t^3+\mathcal{O}(\delta_t^4),
# ```
# y al derivar y substituir en $x^2$, se obtiene $x_{[3]}=x_0^4$. Y así se continua sucesivamente.

#-
# Finalmente, hemos obtenido
# ```math
# \begin{align*}
# x(t_0+\delta_t) = & \, x_0 + x_0^2 \delta_t + x_0^3 \delta_t^2 + x_0^4 \delta_t^3 + \dots \\
#      = & \, x_0 \big(1 + x_0 \delta_t + x_0^2 \delta_t^2 + \dots\big) \\
#      = & \, \frac{x_0}{1-x_0\delta_t},\\
# \end{align*}
# ```
# donde en la segundo igualdad hemos factorizado $x_0$, y la tercer igualdad se sigue
# de reconocer a la serie como la serie geométrica. El resultado es idéntico al que obtuvimos
# analíticamente.

#-
# Es importante notar que para que la serie (geométrica) converja absolutamente se requiere que los
# términos sucesivos satisfagan
# ```math
# \Big | \frac{x_{[n+1]} \delta_t^{n+1}}{ x_{[n]} \delta_t^n }\Big| = |x_0 \delta_t| < 1,
# ```
#
# lo que define el radio de convergencia de la serie. En otras palabras, el máximo valor que
# puede tener $\delta_t$.

#-
# ## El método de Taylor

#-
# ### Relaciones de recurrencia de los coeficientes de Taylor
#
# Consideremos ahora el caso general, para una ecuación diferencial $\dot{x} = f\big(x(t)\big)$
# con $x_0=x(t_0)$. Haciendo lo mismo que arriba, derivando la serie, por un lado, y desarrollando
# en series de Taylor *respecto a * $\delta_t$ alrededor de cero el lado derecho, es decir,
# $f\big(x(t_0+\delta_t), \delta_t\big)$, se puede demostrar
# que los coeficientes $x_{[k]}$ de la solución están dados por
# ```math
# x_{[k+1]} = \frac{f_{[k]}}{k+1}.
# ```
# Aquí, los coeficientes $f_{[k]}$ son los coeficientes del desarrollo en serie de
# Taylor en $t-t_0$ de $f\big(x(t), t\big)$. La demostración consiste simplemente en escribir los
# polinomios para $x(t)$ y para $f(x(t))$, ambos en términos de la variable independiente
# $\delta_t = t - t_0$, e igualar términos afines de ambos lados de la igualdad según el grado en $t$.

#-
# La ecuación anterior es una relación de recurrencia para los coeficientes $x_{[k]}$. Es claro que,
# dado que el lado derecho de la ecuación anterior involucra los coeficientes $f_{[k]}$,
# uno debe implementar funciones que permitan calcular dichos coeficientes. Eso se
# obtiene desarrollando el álgebra de polinomios.

#-
# ### Paso de integración

#-
# La implementación de un método como el método de Taylor en la computadora impone
# truncar el polinomio de Taylor en un grado $p$ finito. Formalmente, escribimos
# ```math
# x(t_0+\delta_t) = \sum_{k=0}^p x_{[k]} \delta_t^k + \mathcal{R}_{p} ,
# ```
# donde el *residuo* $\mathcal{R}_{p}$ está dado por
# ```math
# \mathcal{R}_{p} = x_{[p+1]}(\xi) \delta_t^{p+1},
# ```
# donde $\xi$ es algún valor desconocido en el intervalo $[t_0, t_0+\delta_t]$.

#-
# Queremos, entonces, truncar la serie en un $p$ *suficientemente grande* (finito) de tal
# manera que el residuo sea pequeño.

#-
# ¿Dónde truncamos? En general esto sólo lo podemos contestar si podemos conocer el
# residuo (en términos de $p$), cosa que no es sencilla.
#
# Es por esto que uno *usa* las propiedades de convergencia de la serie de Taylor para
# $x(t)$, para $p$ *suficientemente* grande. Si $p$ es suficientemente grande, en el
# sentido de que estamos en la cola convergente de la serie, entonces
# las correcciones sucesivas serán cada vez menores, ya que la serie converge. Esto
# proviene del teorema de existencia y unicidad de las ecuaciones diferenciales.

#-
# En particular, para $p$ suficientemente grande tendremos
#
# ```math
# \big | x_{[p]} \delta_t^p \big | \leq \epsilon,
# ```
#
# donde $\epsilon$ es una cota, *suficientemente pequeña*, para *todos* los términos sucesivos.

#-
# De aquí obtenemos una cota para el paso de integración $\delta_t=t-t_0$,
# ```math
# \delta_t = t-t_0 \leq \Big(\frac{\epsilon}{\big| x_{[p]}(t_0)\big|}\Big)^{1/p}.
# ```
# La idea es, entonces, elegir $\epsilon$ para que sea mucho menor que el valor del redondeo
# de la máquina.
#
# El paso de integración debe ser menor que el valor que aparece en el lado derecho de la
# desigualdad. Al valor que elijamos lo llamaremos $h$, y depende de $t_0$. Por esto,
# al calcular la evolución
# temporal, distintos pasos de integración se irán obteniendo, por lo que el paso de
# integración en general no será constante.

#-
# En la práctica, y dado que normalmente uno lidia con ecuaciones de segundo orden, uno
# considera el menor de los pasos de integración obtenidos usando los dos
# últimos términos de la serie de Taylor.
#
# Es *importante* enfatizar que este procedimiento sólo funciona cuando el orden $p$
# es suficientemente grande, de tal manera que estamos dentro de la "cola convergente"
# de la serie.

#-
# ### Sumando la serie

#-
# Una vez que tenemos el paso de integración $h$ queremos sumar la serie para obtener
# la nueva condición inicial $x(t_1)$ con $t_1 = t_0+h$. Para esto, simplemente
# debemos sumar la serie
#
# ```math
# x(t_1) = x(t_0+h) = \sum_{k=0}^p x_{[k]}(t_0)\, h^k.
# ```
#
# Numéricamente, la mejor manera de hacer esto es usando [el método de
# Horner](https://en.wikipedia.org/wiki/Horner%27s_method). El método de Horner
# consiste en factorizar de manera apropiada el polinomio, el cual sólo se evalúa a
# través de productos y sumas (¡sin potencias!). Esto permite, por un lado, minimizar
# el número de operaciones, y en el caso de series de Taylor de orden suficientemente
# grande (a fin de estar en la cola convergente), considerar correctamente los términos
# pequeños.

#-

# Ilustraremos el método reescribiendo la serie de la siguiente manera
# ```math
# \begin{align*}
# x(t_1) = & \, x_0 + x_{[1]} \, h + \dots + x_{[p-1]} \,h^{p-1} + x_{[p]} \, h^p\\
# = & \, x_0 + x_{[1]} \, h + \dots + h^{p-1} ( x_{[p-1]} + h x_{[p]} )\\
# = & \, x_0 + x_{[1]} \, h + \dots + h^{p-2} ( x_{[p-2]} + h ( x_{[p-1]} + h x_{[p]} ) )\\
# = & \, x_0 + h\big( x_{[1]} + h(... + h ( x_{[p-1]} + h x_{[p]} )...\big).
# \end{align*}
# ```

#-
# Entonces, para hacer la suma consideramos primero el término $x_{[p-1]}$ y $x_{[p]}$, a partir
# de los cuales construimos $\tilde{x}_{p-1} = x_{[p-1]} + h x_{[p]}$. Usando
# $\tilde{x}_{p-1}$ y $\tilde{x}_{[p-2]}$ obtenemos
# $\tilde{x}_{p-2} = x_{[p-2]} + h \tilde{x}_{p-1}$, y así
# sucesivamente hasta tener $\tilde{x}_0=x(t_1)$, que es el resultado buscado.

#-
# Una vez que hemos obtenido $x(t_1)$, uno utiliza este valor como la nueva condición inicial,
# y simplemente se iteran los pasos anteriores hasta obtener $x(t_2)$, y así sucesivamente.
#

#-
