# Quantum Circuits

```@meta
CurrentModule = QuantumCircuits
```

Quantum circuits are sequences of quantum operations (gates and channels) that can include measurement and post-selection. QuantumCircuits.jl provides the `QCircuit` type for composing operations and managing circuit execution.

## Circuit Components

### QCircuit

The `QCircuit` type represents a sequence of quantum operations:

```julia
# Create an empty circuit
circuit = QCircuit()

# Add operations to the circuit
push!(circuit, XGate(1))
push!(circuit, HGate(2))
push!(circuit, CNOTGate(1, 2))
push!(circuit, AmplitudeDamping(1, γ=0.1))
```

### QMeasure

The `QMeasure` type represents projective measurement:

```julia
# Create a measurement operation
measurement = QMeasure([1, 3])  # Measure qubits 1 and 3
```

### QSelect

The `QSelect` type represents post-selection (conditional operations):

```julia
# Create a post-selection operation
# Applies XGate(2) if qubit 1 measures as |1⟩
post_select = QSelect(1, true, XGate(2))
```

## Basic Circuit Operations

### Creating Circuits

```julia
using QuantumCircuits

# Method 1: Create empty and add operations
circuit1 = QCircuit()
push!(circuit1, HGate(1))
push!(circuit1, CNOTGate(1, 2))

# Method 2: Create from array of operations
operations = [HGate(1), CNOTGate(1, 2), RzGate(2, θ=π/4, isparas=true)]
circuit2 = QCircuit(operations)

# Method 3: Create with measurement
circuit3 = QCircuit([HGate(1), CNOTGate(1, 2), QMeasure([1, 2])])
```

### Circuit Manipulation

```julia
# Add operations to existing circuit
push!(circuit, XGate(3))
push!(circuit, AmplitudeDamping(2, γ=0.05))

# Append another circuit
other_circuit = QCircuit([HGate(4), CZGate(3, 4)])
append!(circuit, other_circuit)

# Get circuit length (number of operations)
length(circuit)

# Iterate over operations
for op in circuit
    println(typeof(op))
end

# Access specific operation
first_op = circuit[1]
last_op = circuit[end]
```

### Circuit Properties

```julia
# Get all qubits involved in the circuit
all_qubits = Set{Int}()
for op in circuit
    if op isa Gate || op isa AbstractQuantumMap
        union!(all_qubits, positions(op))
    elseif op isa QMeasure
        union!(all_qubits, op.positions)
    elseif op isa QSelect
        # Handle QSelect qubits
    end
end

# Check if circuit contains measurements
has_measurements = any(op -> op isa QMeasure, circuit)

# Check if circuit contains parametric gates
has_parametric = any(op -> op isa ParametricGate, circuit)
```

## Parameter Management in Circuits

### Activating and Deactivating Parameters

```julia
# Create a parametric circuit
circuit = QCircuit([
    RxGate(1, θ=0.5, isparas=true),
    CRzGate(1, 2, θ=0.3, isparas=true),
    RzGate(2, θ=0.2, isparas=true)
])

# Activate all parameters in the circuit
activate_parameters!(circuit)

# Deactivate specific parameters
for op in circuit
    if op isa ParametricGate
        deactivate_parameter!(op, 1)  # Deactivate first parameter of each gate
    end
end

# Reset all parameters to initial values
reset_parameters!(circuit)
```

### Parameter Inspection

```julia
# Get all parameter values in circuit
all_params = Float64[]
for op in circuit
    if op isa ParametricGate
        append!(all_params, parameters(op))
    end
end

# Count total number of parameters
total_params = 0
for op in circuit
    if op isa ParametricGate
        total_params += nparameters(op)
    end
end

# Get active parameter indices
active_indices = Set{Tuple{Int, Int}}()  # (gate_index, param_index)
for (i, op) in enumerate(circuit)
    if op isa ParametricGate
        for idx in active_parameters(op)
            push!(active_indices, (i, idx))
        end
    end
end
```

## Measurement and Post-Selection

### Measurement Operations

```julia
# Create measurement on specific qubits
measure_all = QMeasure([1, 2, 3])  # Measure qubits 1, 2, 3
measure_single = QMeasure(1)       # Measure only qubit 1

# Add measurement to circuit
circuit = QCircuit([
    HGate(1),
    CNOTGate(1, 2),
    QMeasure([1, 2])  # Measure both qubits
])
```

### Post-Selection Operations

```julia
# Apply X gate on qubit 2 if qubit 1 measures as |1⟩
post_select1 = QSelect(1, true, XGate(2))

# Apply H gate on qubit 3 if qubit 2 measures as |0⟩
post_select2 = QSelect(2, false, HGate(3))

# Create circuit with post-selection
circuit = QCircuit([
    HGate(1),
    CNOTGate(1, 2),
    QSelect(1, true, XGate(3)),  # If qubit 1 is |1⟩, apply X to qubit 3
    QMeasure([1, 2, 3])
])
```

## Circuit Examples

### Bell State Preparation

```julia
function bell_state_circuit()
    circuit = QCircuit()
    push!(circuit, HGate(1))      # Hadamard on qubit 1
    push!(circuit, CNOTGate(1, 2)) # CNOT with control 1, target 2
    return circuit
end

# Creates: (|00⟩ + |11⟩)/√2
```

### GHZ State Preparation

```julia
function ghz_state_circuit(n::Int)
    circuit = QCircuit()
    push!(circuit, HGate(1))  # First qubit in superposition
    
    for i in 1:(n-1)
        push!(circuit, CNOTGate(i, i+1))  # Entangle with next qubit
    end
    
    return circuit
end

# Creates: (|0...0⟩ + |1...1⟩)/√2
```

### Parametric Quantum Circuit (Ansatz)

```julia
function hardware_efficient_ansatz(n_qubits::Int, depth::Int)
    circuit = QCircuit()
    
    for d in 1:depth
        # Layer of single-qubit rotations
        for q in 1:n_qubits
            push!(circuit, RzGate(q, θ=rand(), isparas=true))
            push!(circuit, RyGate(q, θ=rand(), isparas=true))
            push!(circuit, RzGate(q, θ=rand(), isparas=true))
        end
        
        # Layer of entangling gates
        for q in 1:(n_qubits-1)
            push!(circuit, CNOTGate(q, q+1))
        end
    end
    
    activate_parameters!(circuit)
    return circuit
end
```

### Noisy Quantum Circuit

```julia
function noisy_quantum_circuit()
    circuit = QCircuit()
    
    # Initialization
    push!(circuit, HGate(1))
    push!(circuit, HGate(2))
    
    # Noise after initialization
    push!(circuit, AmplitudeDamping(1, γ=0.05))
    push!(circuit, AmplitudeDamping(2, γ=0.05))
    
    # Entanglement with noise
    push!(circuit, CNOTGate(1, 2))
    push!(circuit, Depolarizing([1, 2], p=0.01))
    
    # Single-qubit gates with phase damping
    push!(circuit, RzGate(1, θ=π/4, isparas=true))
    push!(circuit, PhaseDamping(1, λ=0.1))
    
    # Measurement
    push!(circuit, QMeasure([1, 2]))
    
    return circuit
end
```

## Circuit Visualization

While QuantumCircuits.jl doesn't include built-in visualization, circuits can be represented textually:

```julia
function print_circuit(circuit::QCircuit)
    println("Quantum Circuit with $(length(circuit)) operations:")
    println("-"^40)
    
    for (i, op) in enumerate(circuit)
        if op isa Gate
            println("$i. $(typeof(op)) on qubits $(positions(op))")
        elseif op isa AbstractQuantumMap
            println("$i. $(typeof(op)) on qubits $(positions(op))")
        elseif op isa QMeasure
            println("$i. Measure qubits $(op.positions)")
        elseif op isa QSelect
            println("$i. Select: if qubit $(op.control_qubit) = $(op.target_value), apply $(typeof(op.operation))")
        end
    end
end
```

## API Reference

```@docs
QCircuit
QMeasure
QSelect
```

### Circuit Functions

```@docs
Base.push!(::QCircuit, ::QuantumOperation)
Base.append!(::QCircuit, ::QCircuit)
Base.length(::QCircuit)
Base.iterate(::QCircuit)
Base.getindex(::QCircuit, ::Int)
```

### Parameter Management in Circuits

```@docs
activate_parameters!(::QCircuit)
reset_parameters!(::QCircuit)
```