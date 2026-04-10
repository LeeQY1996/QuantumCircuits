# Qubit Hamiltonians

```@meta
CurrentModule = QuantumCircuits
```

Qubit Hamiltonians represent physical systems in quantum mechanics as sums of local operators. QuantumCircuits.jl provides algebraic tools for working with qubit Hamiltonians through the `QubitsTerm` and `QubitsOperator` types.

## Hamiltonian Representation

### QubitsTerm

A `QubitsTerm` represents a single term in a Hamiltonian:

```
c * σ₁ ⊗ σ₂ ⊗ ... ⊗ σₙ
```

where `c` is a coefficient and each `σᵢ` is a Pauli operator (I, X, Y, Z).

```julia
# Create a single term: 0.5 * X₁ ⊗ Z₂
term1 = QubitsTerm(Dict(1=>"X", 2=>"Z"), coeff=0.5)

# Another term: -0.3 * Y₂ ⊗ X₃
term2 = QubitsTerm(Dict(2=>"Y", 3=>"X"), coeff=-0.3)

# Identity term: 1.0 * I (on all qubits implicitly)
identity_term = QubitsTerm(Dict{Int,String}(), coeff=1.0)
```

### QubitsOperator

A `QubitsOperator` represents a sum of `QubitsTerm` objects:

```julia
# Create operator from individual terms
operator = QubitsOperator([term1, term2])

# Create operator directly
operator2 = QubitsOperator([
    (Dict(1=>"X", 2=>"Z"), 0.5),
    (Dict(2=>"Y", 3=>"X"), -0.3)
])
```

## Basic Operations

### Term Inspection

```julia
# Get coefficient
c = coeff(term)  # Returns 0.5 for term1

# Get operator list
ops = oplist(term)  # Returns Dict(1=>"X", 2=>"Z")

# Get qubits involved in term
qubits = collect(keys(oplist(term)))  # [1, 2]

# Get Pauli string representation
function pauli_string(term::QubitsTerm, n::Int)
    str = ""
    for q in 1:n
        if haskey(term.oplist, q)
            str *= term.oplist[q]
        else
            str *= "I"
        end
    end
    return str
end
```

### Algebraic Operations

```julia
# Addition
term_a = QubitsTerm(Dict(1=>"X"), coeff=0.5)
term_b = QubitsTerm(Dict(1=>"X"), coeff=0.3)
operator_sum = QubitsOperator([term_a]) + QubitsOperator([term_b])
# Result: 0.8 * X₁

# Scalar multiplication
operator = QubitsOperator([QubitsTerm(Dict(1=>"Z"), coeff=1.0)])
scaled = 2.5 * operator  # 2.5 * Z₁

# Adjoint (complex conjugate)
term_complex = QubitsTerm(Dict(1=>"Y"), coeff=1.0+2.0im)
adjoint_term = adjoint(term_complex)  # (1.0-2.0im) * Y₁

# Operator addition and subtraction
op1 = QubitsOperator([QubitsTerm(Dict(1=>"X"), coeff=1.0)])
op2 = QubitsOperator([QubitsTerm(Dict(2=>"Z"), coeff=2.0)])
op_sum = op1 + op2  # X₁ + 2Z₂
op_diff = op1 - op2  # X₁ - 2Z₂
```

## Matrix Representation

### Generating Matrices

```julia
# Generate matrix for a single term
term = QubitsTerm(Dict(1=>"X", 2=>"Z"), coeff=0.5)
term_matrix = matrix(term, n=3)  # 8×8 sparse matrix for 3-qubit system

# Generate matrix for an operator
operator = QubitsOperator([
    QubitsTerm(Dict(1=>"X"), coeff=1.0),
    QubitsTerm(Dict(2=>"Z"), coeff=2.0)
])
operator_matrix = matrix(operator, n=3)  # X₁ + 2Z₂ on 3-qubit system

# Using dense matrices (for small systems)
dense_matrix = Matrix(matrix(operator, n=3))
```

### Matrix Properties

```julia
using LinearAlgebra

# Check if Hamiltonian is Hermitian
H = matrix(operator, n=3)
is_hermitian = isapprox(H, H')  # Should be true for physical Hamiltonians

# Compute eigenvalues (for small systems)
eigvals_H = eigen(Matrix(H)).values

# Check trace
trace_H = tr(Matrix(H))
```

## Hamiltonian Simplification

### Combining Like Terms

```julia
# Create operator with duplicate terms
operator = QubitsOperator([
    QubitsTerm(Dict(1=>"X", 2=>"Z"), coeff=0.5),
    QubitsTerm(Dict(1=>"X", 2=>"Z"), coeff=0.3),
    QubitsTerm(Dict(2=>"Y"), coeff=1.0),
    QubitsTerm(Dict(2=>"Y"), coeff=-0.5)
])

# Simplify combines like terms
simplified = simplify(operator)
# Result: 0.8 * X₁Z₂ + 0.5 * Y₂
```

### Commutation Relations

```julia
# Check if two terms commute
function commutes(term1::QubitsTerm, term2::QubitsTerm)
    # Two Pauli terms commute if they have an even number of
    # non-commuting pairs at the same qubit positions
    non_commuting_pairs = 0
    
    for (q, op1) in term1.oplist
        if haskey(term2.oplist, q)
            op2 = term2.oplist[q]
            # Check if ops at same qubit commute
            if (op1 == "X" && op2 == "Y") || (op1 == "Y" && op2 == "Z") ||
               (op1 == "Z" && op2 == "X") || (op1 == "Y" && op2 == "X") ||
               (op1 == "Z" && op2 == "Y") || (op1 == "X" && op2 == "Z")
                non_commuting_pairs += 1
            end
        end
    end
    
    return iseven(non_commuting_pairs)
end
```

## Common Hamiltonian Models

### Transverse Field Ising Model

```julia
function transverse_field_ising(n::Int, J::Real, h::Real)
    terms = QubitsTerm[]
    
    # ZZ interactions
    for i in 1:(n-1)
        push!(terms, QubitsTerm(Dict(i=>"Z", i+1=>"Z"), coeff=J))
    end
    
    # Transverse field (X)
    for i in 1:n
        push!(terms, QubitsTerm(Dict(i=>"X"), coeff=h))
    end
    
    return QubitsOperator(terms)
end

# Example: 4-qubit TFIM
tfim = transverse_field_ising(4, 1.0, 0.5)
```

### Heisenberg Model

```julia
function heisenberg_model(n::Int, Jx::Real, Jy::Real, Jz::Real)
    terms = QubitsTerm[]
    
    for i in 1:(n-1)
        # XX interaction
        if Jx != 0
            push!(terms, QubitsTerm(Dict(i=>"X", i+1=>"X"), coeff=Jx))
        end
        
        # YY interaction
        if Jy != 0
            push!(terms, QubitsTerm(Dict(i=>"Y", i+1=>"Y"), coeff=Jy))
        end
        
        # ZZ interaction
        if Jz != 0
            push!(terms, QubitsTerm(Dict(i=>"Z", i+1=>"Z"), coeff=Jz))
        end
    end
    
    return QubitsOperator(terms)
end

# Example: XXX model (Jx = Jy = Jz = 1.0)
heisenberg = heisenberg_model(4, 1.0, 1.0, 1.0)
```

### Hubbard Model (in qubit representation)

```julia
function hubbard_model(n_sites::Int, t::Real, U::Real)
    # Simplified qubit representation (Jordan-Wigner transformed)
    terms = QubitsTerm[]
    
    # Hopping terms (simplified representation)
    for i in 1:(n_sites-1)
        # Spin-up hopping
        push!(terms, QubitsTerm(Dict(i=>"X", i+1=>"X"), coeff=-t))
        push!(terms, QubitsTerm(Dict(i=>"Y", i+1=>"Y"), coeff=-t))
        
        # Spin-down hopping (offset by n_sites)
        push!(terms, QubitsTerm(Dict(i+n_sites=>"X", i+1+n_sites=>"X"), coeff=-t))
        push!(terms, QubitsTerm(Dict(i+n_sites=>"Y", i+1+n_sites=>"Y"), coeff=-t))
    end
    
    # On-site interaction
    for i in 1:n_sites
        # n_up * n_down ≈ Z_i Z_{i+n_sites} term (simplified)
        push!(terms, QubitsTerm(Dict(i=>"Z", i+n_sites=>"Z"), coeff=U/4))
    end
    
    return QubitsOperator(terms)
end

# Example: 2-site Hubbard model
hubbard = hubbard_model(2, 1.0, 4.0)
```

## Hamiltonian Analysis

### Expectation Values

```julia
function expectation_value(operator::QubitsOperator, state::Vector{ComplexF64}, n::Int)
    # Compute ⟨ψ|H|ψ⟩
    H = matrix(operator, n=n)
    return dot(state, H * state)
end

# Example usage
n_qubits = 3
H = transverse_field_ising(n_qubits, 1.0, 0.5)
ψ = randn(ComplexF64, 2^n_qubits)
ψ /= norm(ψ)
energy = expectation_value(H, ψ, n_qubits)
```

### Ground State Approximation

```julia
using LinearAlgebra

function ground_state_energy(operator::QubitsOperator, n::Int; k::Int=1)
    # Compute k smallest eigenvalues
    H = Matrix(matrix(operator, n=n))
    eigvals = eigen(H).values
    return eigvals[1:k]
end

# Example: Find ground state of TFIM
tfim = transverse_field_ising(4, 1.0, 0.5)
gs_energies = ground_state_energy(tfim, 4, k=3)
println("Ground state energy: ", gs_energies[1])
println("First excited state: ", gs_energies[2])
```

## API Reference

```@docs
QubitsTerm
QubitsOperator
oplist
coeff
matrix
simplify
```

### Algebraic Operations

```@docs
Base.:+(::QubitsOperator, ::QubitsOperator)
Base.:-(::QubitsOperator, ::QubitsOperator)
Base.:*(::Real, ::QubitsOperator)
Base.:*(::Complex, ::QubitsOperator)
Base.adjoint(::QubitsTerm)
Base.adjoint(::QubitsOperator)
```