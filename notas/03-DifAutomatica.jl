# # Diferenciación automática (o algorítmica)

#-
# ## Motivación

# En la clase anterior, vimos diferentes formas de implementar
# numéricamente la derivada de una función $f(x)$ en un punto $x_0$, y
# que el error depende de un parámetro $h$, que es la separación entre
# puntos cercanos.
# Obtuvimos que el error absoluto en términos de $h$ (cuando
# $h\to 0$) tiene un comportamiento distinto según la definición
# que uno utiliza, y que de hecho éste puede ser *contaminado* por errores
# numéricos de precisión finita (cancelación catastrófica).

#-
# Concretamente, obtuvimos que:
# - El error absoluto de la "derivada derecha" es lineal respecto a $h$. Sin embargo,
# para valores suficientemente pequeños de $h$, el valor obtenido de la derivada
# deja de tener sentido ya que se pierde exactitud.
# - El error absoluto de la "derivada simétrica" es cuadrático respecto a $h$. Al igual
# que la derivada derecha, para $h$ suficientemente pequeña los
# [*errores de cancelación*](https://en.wikipedia.org/wiki/Loss_of_significance)
# debidos a las diferencias que hay en la definición, hacen que el resultado pierda sentido.
# - Finalmente, vimos que el error absoluto de la "derivada de paso complejo"
# también es cuadrático en $h$. A diferencia de las dos definiciones anteriores,
# la derivada de paso complejo no
# exhibe problemas al considerar valores de $h$ muy pequeños. Esto se
# debe a que no involucra restas de números muy cercanos, que darían
# lugar a errores de cancelación.

#-

# Los puntos anteriores muestran que al implementar un algoritmo
# numéricamente (usando números de punto flotante u otros con
# *precisión finita*) es importante la manera en que se hace la implementación,
# por cuestiones de convergencia y manejo de errores
# numéricos. En este sentido, la "derivada compleja" da el resultado
# que (numéricamente) más se acerca al exacto, incluso para valores
# muy pequeños de $h$.

#-

# La pregunta es si podemos obtener el valor exacto,
# en un sentido numérico, usando números de punto flotante,
# y en la medida de lo posible hacer esto de forma independiente de $h$.
# Esto es, obtener como resultado el valor que más se acerca al valor
# que se obtendría usando números reales, excepto quizás por cuestiones
# inevitables de redondeo. Las técnicas que introduciremos se conocen como
# *diferenciación automática* o *algorítmica*.

#-
# Citando a [wikipedia](https://en.wikipedia.org/wiki/Automatic_differentiation):
# > Automatic differentiation (AD), also called algorithmic
# > differentiation or computational differentiation [...], is a set of
# > techniques to numerically evaluate the derivative of a function
# > specified by a computer program.
#
# Diferenciación automática **no es** diferenciación numérica. Está
# basada en cálculos numéricos (evaluación de funciones en la computadora
# con números de precisión finita),
# pero **no** usa ninguna de las definiciones basadas en diferencias
# finitas, como las que vimos la clase anterior. Tampoco es diferenciación
# simbólica. La implementación que describiremos se basa en definir estructuras
# adecuadas que permiten obtener los resultados que buscamos.

#-

# ## Una analogía: los números complejos

# Para ilustrar cómo funcionan los *números duales*, que introduciremos más adelante,
# empezaremos usando
# el ejemplo de los números complejos: $z = a + \mathrm{i} b$, donde $a$
# representa la parte real de $z$ y $b$ es su parte imaginaria.
#
# Uno puede definir todas las operaciones aritméticas de *manera
# natural* (a partir de los números reales), manteniendo las expresiones
# con $\mathrm{i}$ factorizada. En el caso de la multiplicación (y la
# división) debemos explotar el hecho que $\mathrm{i}^2=-1$, que es la propiedad que *define*
# al número imaginario $\mathrm{i}$; este punto será clave más adelante cuando extendamos este
# tipo de análisis a los números duales.

#-
# De esta manera, para $z = a + \mathrm{i} b$ y $w = c + \mathrm{i} d$,
# tenemos que,
#
# ```math
# \begin{align*}
# z + w & = (a + \mathrm{i} b) + (c + \mathrm{i} d) = (a + c) + \mathrm{i}(b + d),\\
# z \cdot w & = (a + \mathrm{i} b)\cdot (c + \mathrm{i} d)
#   = ac + \mathrm{i} (ad+bc) + \mathrm{i}^2 b d\\
#  & = (ac - b d) + \mathrm{i} (ad+bc).\\
# \end{align*}
# ```

#-
# Por último, vale la pena recordar que $\mathbb{C}$ es
# *isomorfo* a $\mathbb{R}^2$, esto es, uno puede asociar un punto
# en $\mathbb{C}$ con uno en $\mathbb{R}^2$ de manera unívoca, y
# visceversa.

#-

# ## Números duales

# De manera análoga a los números complejos, introduciremos un par
# ordenado que llamaremos *números duales*, donde la primer componente
# es el valor de una función $f(x)$ evaluada en $x_0$, y la segunda es
# el valor de su derivada evaluada en el mismo punto. Esto es, definimos
# a los *duales* como:
#
# ```math
# \mathbb{D}_{x_0}f = \big( f(x_0), f'(x_0) \big) = \big( f_0, f'_0 \big) =
# f_0 + \epsilon\, f'_0.
# ```
#
# Aquí $f_0 = f(x_0)$ y $f'_0=\frac{d f}{d x}(x_0)$ y, en la última
# igualdad, $\epsilon$ sirve para indicar la segunda componente del
# par ordenado. En un sentido que se precisará más adelante, $\epsilon$
# se comporta de una manera análoga a $\mathrm{i}$ para los números
# complejos, con diferencias en el resultado.

#-
# En particular, para la función constante $f(x)=c$ se debe cumplir
# que el dual asociado sea
# ```math
# \mathbb{D}_{x_0}c = (c, 0) = c,
# ```
# y para la función
# identidad $f(x)=x$ tendremos
# ```math
# \mathbb{D}_{x_0} x =(x_0,1) = x_0 + \epsilon.
# ```
# Vale la pena notar que la variable independiente respecto a la que estamos
# derivando es la que define a la función identidad.

#-
# ### Aritmética de duales

# De la definición anterior para $\mathbb{D}_{x_0} u = (u_0, u^\prime_0)$ y
# $\mathbb{D}_{x_0} w = (w_0, w^\prime_0)$, y *definiendo* $\epsilon^2=0$, tenemos que
# las operaciones aritméticas quedan definidas por:
#
# ```math
# \begin{align*}
#    \pm \mathbb{D}_{x_0} u & = \big(\pm u_0, \pm u'_0 \big), \\
# \mathbb{D}_{x_0} (u\pm w) & = \mathbb{D}_{x_0} u \pm \mathbb{D}_{x_0} w =
#     \big( u_0 \pm w_0, \, u'_0\pm w'_0 \big),\\
# \mathbb{D}_{x_0} (u \cdot w) & = \mathbb{D}_{x_0} u \cdot \mathbb{D}_{x_0} w =
#     \big( u_0 w_0,\, u_0 w'_0 +  w_0 u'_0 \big),\\
# \mathbb{D}_{x_0} \frac{u}{w} & = \frac{\mathbb{D}_{x_0} u}{\mathbb{D}_{x_0} w} =
#     \big( \frac{u_0}{w_0},\, \frac{ u'_0 - (u_0/w_0)w'_0}{w_0}\big),\\
# {\mathbb{D}_{x_0} u}^\alpha & = \big( u_0^\alpha,\, \alpha u_0^{\alpha-1} u'_0 \big).\\
# \end{align*}
# ```

#-
# Claramente, en las expresiones anteriores la segunda componente corresponde a la derivada
# de la operación aritmética involucrada. Finalmente, vale la pena también notar que, en las operaciones
# aritméticas todos los duales están definidos en el mismo punto $x_0$.
#

#-
# ### Un ejemplo de cálculo con duales

# A fin de desarrollar un ejemplo que utiliza las operaciones que hemos definido entre duales,
# evaluaremos la función $f(x) = (3x^2-8x+5)/(7x^3-1)$ en el dual $u = 2 + \epsilon$. Notemos
# que este dual corresponde a la variable *independiente* $x$ evaluada en 2, es decir, la función identidad
# evaluada en 2, $u = {\mathbb{D}_{2} x}$, resaltando que se trata de la variable independiente
# ya que su derivada (en cualquier punto) es 1. Si todo lo que hemos hecho es consistente,
# la primer componente del resultado deberá corresponder a evaluar
# [$f(2)=1/55$](https://www.wolframalpha.com/input?i=evaluate+%283x%5E2-8x%2B5%29%2F%287x%5E3-1%29+at+x+%3D+2),
# y la segunda componente corresponderá a la derivada
# [$f^\prime(2)=136/3025$](https://www.wolframalpha.com/input?i=derivative%28%283x%5E2-8x%2B5%29%2F%287x%5E3-1%29%2C+x%2C+2%29).

#-
# ```math
# \begin{align*}
# f(u) = & \frac{3u^2-8u+5}{7u^3-1} =
#             \frac{3*2^2-8*2^1+5 +\epsilon(2*3*2^1-8)}{7*2^3-1 + \epsilon(3*7*2^2)} \\
#         = & \frac{1+4\epsilon}{55+84\epsilon} =
#             \frac{1}{55} + \epsilon \frac{4-\frac{1}{55}(84)}{55}
#             = \frac{1}{55} + \epsilon \frac{4*55-84}{3025}
#             = \frac{1}{55} + \epsilon \frac{136}{3025}.\\
# \end{align*}
# ```

#-
# Los resultados claramente corresponden con la interpretación que queremos.

#-
# ### Funciones definidas sobre los duales

# La regla de la cadena es fundamental para el cálculo de las derivadas, y por lo mismo,
# se aplicará para definir funciones sobre duales. Definiremos la aplicación de funciones en
# duales, buscando que la interpretación del dual sea preservada: la primer componente del par
# ordenado debe corresponder a la composición de las funciones, y la segunda a su derivada.
# Es decir, si el dual es de la forma $u = {\mathbb{D}_{x_0} x}$, $u$ corresponde a la
# variable independiente evaluada en $x_0$, entonces
# $f(u)$, que es un dual, tiene como primer componente $f(x_0)$ y como segunda a
# $f^\prime(x_0)$.

#-
# Entonces, dado que
# ```math
# \frac{\textrm{d}\exp(f(x))}{\textrm{d}x}(x_0) = \exp(f(x_0)) f^\prime(x_0),
# ```
# para ${\mathbb{D}_{x_0} u}=u_0+\epsilon u_0^\prime$ podemos escribir
# ```math
# \exp({\mathbb{D}_{x_0} u}) = \exp(u) = \exp(u_0+\epsilon u_0^\prime)
#     = \exp(u_0)+ \epsilon \exp(u_0) u_0^\prime.
# ```

#-
# De manera similar podemos obtener
# ```math
# \begin{align*}
# \exp({\mathbb{D}_{x_0} u}) & = \exp(u_0) + \epsilon \exp(u_0) u_0^\prime,\\
# \log({\mathbb{D}_{x_0} u}) & = \log(u_0) + \epsilon \frac{u_0^\prime}{u_0},\\
# \sin({\mathbb{D}_{x_0} u}) & = \sin(u_0) + \epsilon \cos(u_0) u_0^\prime,\\
# \cos({\mathbb{D}_{x_0} u}) & = \cos(u_0) - \epsilon \sin(u_0) u_0^\prime,\\
# \tan({\mathbb{D}_{x_0} u}) & = \tan(u_0) + \epsilon \sec^2(u_0) u_0^\prime,\\
# \sinh({\mathbb{D}_{x_0} u}) & = \sinh(u_0) + \epsilon \cosh(u_0) u_0^\prime,\\
# \dots
# \end{align*}
# ```

#-
# Al igual que antes, lo importante de estas expresiones es que si $u = {\mathbb{D}_{x_0} x}$
# es la variable independiente evaluada en $x_0$, por lo que la derivada de $u$ es 1, entonces
# la segunda componente de $f(u)$ corresponderá a $f^\prime(x_0)$. Las reglas anteriores
# garantizan que la composición de funciones se puede usar con duales de manera más o menos
# sencilla.
