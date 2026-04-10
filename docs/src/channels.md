# Quantum Channels

```@meta
CurrentModule = QuantumCircuits
```

Quantum channels (also known as quantum operations or completely positive trace-preserving maps) represent general quantum evolution, including noise and decoherence. QuantumCircuits.jl provides both generic quantum maps and specific noise models.

## Channel Types

The package defines an abstract type hierarchy for quantum channels:

```@raw html
<div class="mermaid">
graph TD
    A[AbstractQuantumMap] --> B[QuantumMap]
    A --> C[AmplitudeDamping]
    A --> D[PhaseDamping]
    A --> E[Depolarizing]
</div>
```

## Generic Quantum Maps

### Creating Generic Channels

```julia
# Create a generic quantum map from Kraus operators
using LinearAlgebra

# Example: Bit flip channel with probability p
p = 0.1
k1 = sqrt(1-p) * [1 0; 0 1]  # √(1-p) * I
k2 = sqrt(p) * [0 1; 1 0]    # √p * X

kraus_ops = [k1, k2]
generic_channel = QuantumMap(kraus_ops, [1])  # Channel acting on qubit 1
```

### Channel Properties

```julia
# Check if channel is trace-preserving
is_tp_result = is_tp(channel)  # Should return true for valid channels

# Get Kraus operator representation
kraus_matrices = kraus_matrices(channel)

# Get superoperator matrix representation
supermat = ordered_supermat(channel)  # Column-stacked representation
```

## Predefined Noise Models

### Amplitude Damping Channel

Models energy dissipation (e.g., spontaneous emission).

```julia
# Create amplitude damping channel with damping rate γ
γ = 0.1  # Damping rate (0 ≤ γ ≤ 1)
ad_channel = AmplitudeDamping(1, γ=γ)  # Acting on qubit 1

# The channel has Kraus operators:
# K₀ = |0⟩⟨0| + √(1-γ)|1⟩⟨1|
# K₁ = √γ|0⟩⟨1|
```

### Phase Damping Channel

Models loss of quantum coherence without energy loss (dephasing).

```julia
# Create phase damping channel with parameter λ
λ = 0.2  # Dephasing rate (0 ≤ λ ≤ 1)
pd_channel = PhaseDamping(1, λ=λ)  # Acting on qubit 1

# The channel has Kraus operators:
# K₀ = √(1-λ/2)I
# K₁ = √(λ/2)Z
```

### Depolarizing Channel

Models isotropic noise that randomizes the quantum state.

```julia
# Create depolarizing channel with error probability p
p = 0.05  # Error probability (0 ≤ p ≤ 1)
depol_channel = Depolarizing(1, p=p)  # Acting on qubit 1

# The channel applies:
# ρ → (1-p)ρ + p/3 (XρX + YρY + ZρZ)
```

## Channel Operations

### Composition

Channels can be composed with gates and other channels in circuits:

```julia
using QuantumCircuits

# Create a circuit with gates and channels
circuit = QCircuit()
push!(circuit, XGate(1))
push!(circuit, AmplitudeDamping(1, γ=0.1))
push!(circuit, CNOTGate(1, 2))
push!(circuit, Depolarizing(2, p=0.05))
```

### Multi-Qubit Channels

Channels can act on multiple qubits by specifying position arrays:

```julia
# Create a two-qubit depolarizing channel
depol_2q = Depolarizing([1, 2], p=0.01)  # Acts on qubits 1 and 2

# Create amplitude damping on multiple qubits
ad_multi = AmplitudeDamping([1, 3], γ=[0.1, 0.2])  # Different γ for each qubit
```

## Mathematical Background

### Kraus Representation

A quantum channel Φ can be represented by Kraus operators {Kᵢ}:

```
Φ(ρ) = Σᵢ Kᵢ ρ Kᵢ†
```

where Σᵢ Kᵢ† Kᵢ = I (trace-preserving condition).

### Superoperator Representation

A quantum channel can also be represented as a superoperator matrix S:

```
vec(Φ(ρ)) = S · vec(ρ)
```

where vec(·) stacks matrix columns into a vector.

## Examples

### Simulating Noise in a Quantum Circuit

```julia
using QuantumCircuits

function noisy_circuit()
    circuit = QCircuit()
    
    # Initial Hadamard
    push!(circuit, HGate(1))
    
    # Amplitude damping after preparation
    push!(circuit, AmplitudeDamping(1, γ=0.05))
    
    # CNOT with depolarizing noise
    push!(circuit, CNOTGate(1, 2))
    push!(circuit, Depolarizing([1, 2], p=0.01))
    
    # Phase damping before measurement
    push!(circuit, PhaseDamping(1, λ=0.1))
    push!(circuit, PhaseDamping(2, λ=0.1))
    
    return circuit
end
```

### Custom Channel Construction

```julia
using LinearAlgebra

function create_phase_flip_channel(p::Real, qubit::Int)
    # Phase flip channel with probability p
    # Kraus operators: √(1-p)I, √p)Z
    
    I_mat = Matrix{ComplexF64}(I, 2, 2)
    Z_mat = Matrix{ComplexF64}([1 0; 0 -1])
    
    kraus_ops = [sqrt(1-p) * I_mat, sqrt(p) * Z_mat]
    return QuantumMap(kraus_ops, [qubit])
end

# Usage
phase_flip = create_phase_flip_channel(0.1, 1)
```

## API Reference

```@docs
AbstractQuantumMap
QuantumMap
ordered_supermat
kraus_matrices
is_tp
```

### Predefined Channels

```@docs
AmplitudeDamping
PhaseDamping
Depolarizing
```