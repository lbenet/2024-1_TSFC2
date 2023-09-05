struct Dual{T<:Real}
    fun::T
    der::T
end

import Base: promote_rule, promote_type

# Define una función promote_rule personalizada para especificar cómo se debe realizar la promoción.
promote_rule(::Type{Dual}, ::Type{<:Real}) = Float64 # Promoción de MiNumero a otros números.

# Define una función promote_type personalizada para especificar el tipo promocionado.
# promote_type(::Type{MiNumero}, ::Type{<:Number}) = MiNumero  # Tipo promocionado de MiNumero a otros números.

promote(Dual(12, 1))

? promote_rule




