# # Derivadas superiores y series de Taylor

#-
# ## Motivación

#-
# Hasta ahora hemos visto que, usando las técnicas de diferenciación
# automática, podemos calcular la derivada de funciones de una variable
# esencialmente con un error del orden del epsilon de la máquina.
# La primer pregunta que abordaremos aquí, es qué hacer para poder
# calcular la segunda derivada.

#-
# Una posibilidad
# es extender el concepto del dual para incluir el campo que corresponde
# a la segunda derivada, es decir, definir una
# *terna* ordenada donde la primer componente es el valor de la
# función evaluada en $x_0$, i.e., $f(x_0)$, la segunda es el
# valor de la primer derivada $f'(x_0)$, y la tercer componente
# contiene el valor de la segunda derivada, $f^{(2)}(x_0) = f''(x_0)$.
# Denotaremos a esta terna ordenada por $\vec{f}$.

#-
# Procediendo como antes, las operaciones aritméticas vendrán dadas por:
# ```math
# \begin{align*}
# \vec{u} + \vec{v} & = (u + v, \quad u'+ v', \quad u''+v''),\\
# \vec{u} - \vec{v} & = (u - v, \quad u'- v', \quad u''-v''),\\
# \vec{u} \times \vec{v} & = (u v, \quad u v' + u' v, \quad u v'' + 2 u' v' + u'' v),\\
# \frac{\vec{u}}{\vec{v}} & = \Big( \frac{u}{v}, \quad \frac{u'-( u/v) v'}{v}, \quad \frac{u'' - 2 (u/v)' v' - (u/v)v'' }{v}\Big).\\
# \end{align*}
# ```

#-
# La extensión a funciones elementales se hace igual que antes. Por ejemplo,
# en el caso de la exponencial, tendremos
# ```math
# \exp(\vec{u}) = \big( \exp(u_0),\,
# \exp(u_0) u_0',\, \exp(u_0) u_0''+\exp(u_0) {u_0'}^2 \big).
# ```

#-
# Claramente, este proceso es muy ineficiente para calcular las
# segundas derivadas o las derivadas de orden aún más alto, dado que
# las expresiones se complican rápidamente, el proceso de extender su
# uso en funciones elementales se vuelve tedioso y es fácil cometer
# errores.


#-
# ## Series de Taylor

#-
# La manera de conseguir obtener las segundas derivadas, y de hecho las
# derivadas de orden superior en general, es usando las series de Taylor
# dado que las derivadas de orden superior
# de una función $f(x)$ en un punto $x_0$ están contenidas en el
# desarrollo de Taylor de la función alrededor de este punto.
# La suposición importante en esto es que $f(x)$ es suficientemente
# suave; por simplicidad supondremos que $f(x)$ es ${\cal C}^\infty$ y que
# estamos no tiene singularidades en $x_0$.

#-
# La serie de Taylor de $f(x)$ viene dada por

# ```math
# \begin{align*}
# f(x) & = f(x_0) + f^{(1)}(x_0) (x-x_0) + \frac{f^{(2)}(x_0)}{2!} (x-x_0)^2 + \dots\\
#      & \qquad + \frac{f^{(k)}(x_0)}{k!} (x-x_0)^k + \dots,\\
# & = f_{[0]}(x_0) + f_{[1]}(x_0) (x-x_0) + f_{[2]}(x_0) (x-x_0)^2 + \dots\\
#      & \qquad + f_{[k]}(x_0) (x-x_0)^k + \dots,\\
# \end{align*}
# ```

# donde los coeficientes *normalizados* de Taylor $f_{[k]}(x_0)$ que
# aparecen en la segunda línea de la ecuación anterior se definen como

# ```math
# f_{[k]}(x_0) = \frac{f^{(k)}(x_0)}{k!} =
# \frac{1}{k!}\frac{{\rm d}^k f}{{\rm d}x^k}(x_0).
# ```

#-
# Vale la pena **enfatizar** que la expresión anterior para la serie
# de Taylor es *exacta* en tanto que la serie **no** ha sido truncada.
# En el caso de que la serie sea truncada a orden $k$, el
# [teorema de Taylor](https://en.wikipedia.org/wiki/Taylor%27s_theorem)
# asegura que el residuo (error del truncamiento) se puede escribir como:
# ```math
# {\cal R_{k}} = \frac{f^{(k+1)}\,(\xi)}{(k+1)!} (x-x_0)^{k+1},
# ```
# donde $\xi$ es un punto que está entre $x_0$ y $x$.

#-
# Si la serie se trunca, la aproximación obtenida es un polinomio de orden
# $k$ (grado máximo es $k$) en $x-x_0$. Dado que los polinomios en una
# variable están definidos por $k+1$ coeficientes, entonces pueden
# ser mapeados a vectores en $\mathbb{R}^{k+1}$.

#-
# Considerando $f$ y $g$ a dos series de Taylor obtenidas al desarrollar
# las funciones $f(x)$ y $g(x)$ alrededor de $x_0$ respectivamente, o
# alternativamente, dos polinomios en la misma variable
# $x-x_0$ (para usar la misma notación de arriba), las operaciones
# aritméticas, en término de los coeficientes normalizados de orden $k$,
# vienen dadas por:

# ```math
# \begin{align*}
# (f+g)_{[k]} & = f_{[k]} + g_{[k]} ,\\
# (f-g)_{[k]} & = f_{[k]} - g_{[k]} ,\\
# (f \cdot g)_{[k]} & = \sum_{i=0}^k f_{[i]} \,g_{[k-i]} \, ,\\
# \Big(\frac{f}{g}\Big)_{[k]} & = \frac{1}{g_{[0]}}
# \Big( f_{[k]} - \sum_{i=0}^{k-1} \big(\frac{f}{g}\big)_{[i]} \, g_{[k-i]} \Big). \\
# \end{align*}
# ```

#-
# Estas expresiones pueden ser demostradas algebraicamente usando
# las reglas apropiadas para multiplicar dos polinomios. Vale la pena
# enfatizar que el uso de los coeficientes normalizados de Taylor es
# fundamental para obtenerlas.


#-
# ## Funciones de polinomios

#-
# Ahora abordaremos la cuestión de cómo definir y calcular funciones
# (elementales) de polinomios, e.g., $\exp(p(x))$.
# Como veremos a continuación
# (*spoiler alert*), esto se basará en plantear una ecuación diferencial
# apropiada para cada función, cuya solución es, precisamente, la
# expresión que estamos buscando.
# Este punto es de hecho *muy importante*, ya que muestra la
# conexión fundamental de estos polinomios con la solución de
# ecuaciones diferenciales.

#-
# ### Un ejemplo

#-
# Como ejemplo consideraremos la función
# ```math
# E(x) = \exp\big(g(x)\big),
# ```
# donde
# ```math
# g(x) = \sum_{k=0}^\infty g_{[k]} (x-x_0)^k
# ```
# es una función escrita como su serie de Taylor alrededor
# del punto $x_0$.

#-
# Empezaremos por escribir a $E(x)$ como una serie de Taylor alrededor
# de $x_0$, es decir,
# ```math
# E(x) = \sum_{k=0}^\infty E_{[k]} (x-x_0)^k.
# ```
# El objetivo es determinar los coeficientes  $E_{[k]}$ para *toda* $k$,
# que finalmente representan las derivadas de $E(x)$.

#-
# Escribimos la ecuación diferencial apropiada para $E(x)$.
# En este caso basta con escribir la derivada de $E(x)$ en
# términos de $g(x)$, y que viene dada por
# ```math
# \begin{align*}
# \frac{{\rm d} E(x)}{{\rm d}x} &= \exp\big(g(x)\big) \frac{{\rm d} g(x)}{{\rm d}x},\\
#  &= E(x) \frac{{\rm d} g(x)}{{\rm d}x},\\
# \end{align*}
# ```
# donde en la última igualdad aparece la derivada de $g(x)$ y también
# hemos usado la definición de $E(x)$.

#-
# La ecuación diferencial anterior requiere *aún* de una condición inicial
# para que la solución sea única. En este caso, de la definición de
# $E(x)$, evaluando en $x=x_0$ y usando la expresión de la serie de
# Taylor tenemos
# ```math
# E(x_0) = \exp(g(x_0)) = E_{[0]}.
# ```

#-
# Dado que $E(x)$ es un polinomio en $x$, su derivada la podemos escribir
# explícitamente
# ```math
# \frac{{\rm d} E(x)}{{\rm d}x} = \sum_{k=1}^\infty k E_{[k]}\, (x-x_0)^{k-1}.
# ```
# Esta expresión la utilizaremos en el lado izquierdo de la ecuación
# diferencial que define a $E(x)$.

#-
# Ya que $g(x)$ *también* está escrita en forma polinomial, su derivada es
# ```math
# \frac{{\rm d} g(x)}{{\rm d}x} = \sum_{k=1}^\infty k g_{[k]}\, (x-x_0)^{k-1} .
# ```

#-
# Con estas ecuaciones tenemos todo lo que requerimos para
# escribir el lado derecho de la ecuación diferencial, donde explotamos
# en particular el producto de polinomios. Paso a paso, tenemos
# ```math
# \begin{align*}
# E(x) \frac{{\rm d} g(x)}{{\rm d}x} & =
# \Big[ \sum_{k=0}^\infty E_{[k]} (x-x_0)^k \Big]
# \Big[ \sum_{j=1}^\infty j g_{[j]} (x-x_0)^{j-1}\Big] \\
#  & = \sum_{k=1}^\infty \Big[ \sum_{j=0}^k j
# g_{[j]} E_{[k-j]} \; \Big] (x-x_0)^{k-1} .\\
# \end{align*}
# ```

#-
# La segunda igualdad se obtiene reordenando los términos al fijar
# la potencia de $(x-x_0)$, esto es, $k+j$ se toma como un nuevo
# índice ($k$), y el nuevo índice $j$ describe el índice del
# producto de los polinomios. (La potencia se deja de la forma $k-1$
# ya que el lado izquierdo de la ecuación aparece así.)

#-
# Igualando con el lado izquierdo de la ecuación diferencial, que
# sólo involucra a la derivada de $E(x)$, tenemos que se debe cumplir
# ```math
# E_{[k]} = \frac{1}{k} \sum_{j=0}^k j g_{[j]} \, E_{[k-j]} =
# \frac{1}{k} \sum_{j=0}^{k} (k-j) g_{[k-j]} \, E_{[j]},
# ```
# válida para $k=1,2,\dots$, con *la condición inicial*
# ```math
# E_{[0]} = \exp\big(g(x_0)\big).
# ```
# Estas relaciones *de recurrencia* permiten calcular
# $\exp\big(g(x)\big)$, para *cualquier* polinomio (o serie de Taylor)
# $g(x)$.

#-
# Como ejemplo sencillo, consideraremos el caso concreto $g(x) = x$
# alrededor de $x_0=0$. En este caso tenemos $g_{[j]} = \delta_{j,1}$.
# Usando la expresión para la recurrencia obtenida arriba obtenemos
# ```math
# \begin{align*}
# E_{[0]} & = 1,\\
# E_{[k]} & = \frac{1}{k} E_{[k-1]} = \frac{1}{k(k-1)} E_{[k-2]} =
# \dots = \frac{1}{k!} E_{[0]} = \frac{1}{k!}\ .
# \end{align*}
# ```
# En cada igualdad hemos usado que todos los coeficientes de $g(x)$ son
# cero, excepto $g_{[1]}=1$. El resultado obtenido es bien conocido.


#-
# ### Reglas de recusión

#-
# De la misma manera que en el ejemplo con la exponencial, se pueden
# obtener las reglas de recursión para otras funciones elementales.
# La siguiente tabla (tomada de Haro et al,
# [The parameterization method for invariant manifolds](https://link.springer.com/book/10.1007/978-3-319-29662-3), 2016, p 60)
# incluye las reglas de recursión más importantes:

#-
# | Función elemental | Regla de recursión |
# |:-----------------:|:--------------:|
# | ``p(x) = f(x) g(x)`` | ``p_{[k]} = \sum_{j=0}^k f_{[j]} g_{[k-j]}`` |
# | ``d(x) = f(x) / g(x)`` | ``d_{[k]} = \frac{1}{g_{[0]}}\Big( f_{[k]} - \sum_{j=0}^{k-1} d_{[j]} g_{[k-j]}\Big)`` |
# | ``P(x) = f(x)^\alpha`` | ``P_{[k]} = \frac{1}{k f_{[0]}} \sum_{j=0}^{k-1} (\alpha(k-j)-j)f_{[k-j]}P_{[j]}`` |
# | ``P(x) = f(x)^2`` | ``P_{[k]} = \begin{cases} 2 \sum\limits_{j=0}^{(k-1)/2} f_{[j]}f_{[k-j]}, & \textrm{k impar}\\ (f_{[k/2]})^2+ 2 \sum\limits_{j=0}^{(k-2)/2} f_{[j]}f_{[k-j]}, & \textrm{k par}\end{cases}`` |
# | ``P(x) = f(x)^{1/2}`` | ``P_{[k]} = \begin{cases} \frac{1}{2 P_{[0]}} \Big( f_{[k]} - 2 \sum\limits_{j=0}^{(k-1)/2} P_{[j]}P_{[k-j]}\Big), & \textrm{k impar}\\ \frac{1}{2 P_{[0]}} \Big( f_{[k]} - (P_{[k/2]})^2 - 2 \sum\limits_{j=0}^{(k-2)/2} P_{[j]}P_{[k-j]}\Big), & \textrm{k par}\end{cases}`` |
# | ``E(x) = \exp(f(x))`` | ``E_{[k]} = \frac{1}{k} \sum_{j=0}^{k-1} (k-j) f_{[k-j]} E_{[j]}`` |
# | ``L(x) = \log(f(x))`` | ``L_{[k]} = \frac{1}{f_{[0]}} \Big( f_{[k]} - \frac{1}{k}\sum_{j=1}^{k-1} j f_{[k-j]} L_{[j]} \Big)`` |
# | $$ \begin{align*}S(x) &= \sin(f(x))\\ \\ \\ C(x) &= \cos(f(x)) \end{align*} $$ | $$ \begin{align*} S_{[k]} &= \frac{1}{k} \sum_{j=0}^{k-1} (k-j) f_{[k-j]} C_{[j]}\\ C_{[k]} &= -\frac{1}{k} \sum_{j=0}^{k-1} (k-j) f_{[k-j]} S_{[j]}\end{align*} $$ |
# | ```math \begin{align*}T(x) &= \tan(f(x))\\ P(x) &= {T(x)}^2 \end{align*} ``` | `` T_{[k]} = f_{[k]} + \frac{1}{k} \sum_{j=0}^{k-1} (k-j) f_{[k-j]} P_{[j]}`` |
# | ```math \begin{align*}A(x) &= \arcsin(f(x))\\ R(x) &= \sqrt{1-{f(x)}^2}\end{align*} ``` | `` A_{[k]} = \frac{1}{\sqrt{1-{f_{[0]}}^2}} \Big( f_{[k]} - \sum_{j=0}^{k-1} j R_{[k-j]} A_{[j]} \Big)`` |
# | ```math \begin{align*}A(x) &= \arctan(f(x))\\ R(x) &= 1+f(x)^2\end{align*} ``` | `` A_{[k]} = \frac{1}{1+{f_{[0]}}^2} \Big( f_{[k]} - \sum_{j=0}^{k-1} j R_{[k-j]} A_{[j]} \Big)`` |

