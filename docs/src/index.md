# QuantumCircuits.jl Documentation

```@meta
CurrentModule = QuantumCircuits
```

Welcome to the documentation for QuantumCircuits.jl, a Julia package for defining and manipulating quantum computing operations.

## Overview

QuantumCircuits.jl provides a comprehensive framework for representing quantum operations including:

- **Quantum gates** (single-qubit, two-qubit, three-qubit, parametric)
- **Quantum channels** (noise models, generic quantum maps)
- **Quantum circuits** (composition, measurement, post-selection)
- **Qubit Hamiltonians** (algebraic representation, matrix generation)

The package is designed for researchers and developers working on quantum algorithms, quantum simulation, and quantum information processing.

## Quick Links

- [Gates](@ref) - Quantum gate operations
- [Channels](@ref) - Quantum channels and noise models
- [Circuits](@ref) - Circuit composition and measurement
- [Hamiltonians](@ref) - Qubit Hamiltonian algebra
- [API Reference](@ref) - Complete API documentation

## Installation

```julia
using Pkg
Pkg.add(url="https://github.com/leeqy1996/QuantumCircuits.jl")
```

## Quick Example

```julia
using QuantumCircuits

# Create a simple circuit
circuit = QCircuit()
push!(circuit, XGate(1))
push!(circuit, HGate(2))
push!(circuit, CNOTGate(1, 2))

# Create a Hamiltonian term
term = QubitsTerm(Dict(1=>"X", 2=>"Z"), coeff=0.5)

# Create a quantum channel
channel = AmplitudeDamping(1, γ=0.1)
```

## Package Structure

```@raw html
<div class="mermaid">
graph TD
    A[QuantumCircuits.jl] --> B[Gates]
    A --> C[Channels]
    A --> D[Circuits]
    A --> E[Hamiltonians]
    
    B --> B1[Single-qubit gates]
    B --> B2[Two-qubit gates]
    B --> B3[Three-qubit gates]
    B --> B4[Parametric gates]
    
    C --> C1[AmplitudeDamping]
    C --> C2[PhaseDamping]
    C --> C3[Depolarizing]
    C --> C4[Generic QuantumMap]
    
    D --> D1[QCircuit]
    D --> D2[QMeasure]
    D --> D3[QSelect]
    
    E --> E1[QubitsTerm]
    E --> E2[QubitsOperator]
</div>
```

## Key Features

### 1. Comprehensive Gate Library
- Standard gates (X, Y, Z, H, S, T, CNOT, CZ, SWAP, TOFFOLI, etc.)
- Parametric gates (Rx, Ry, Rz, CRx, CRy, CRz, CPHASE, FSIM)
- Generic gates with arbitrary unitary matrices
- Differentiation support for parametric gates

### 2. Quantum Channels
- Common noise models (amplitude damping, phase damping, depolarizing)
- Generic quantum maps with Kraus operator representation
- Trace-preserving verification

### 3. Circuit Operations
- Sequential composition of gates and channels
- Measurement and post-selection operations
- Parameter management for optimization

### 4. Hamiltonian Algebra
- Algebraic representation of many-body Hamiltonians
- Matrix generation for given system size
- Term simplification and combination

## Getting Help

- **GitHub Issues**: [Report bugs or request features](https://github.com/leeqy1996/QuantumCircuits.jl/issues)
- **Source Code**: [View on GitHub](https://github.com/leeqy1996/QuantumCircuits.jl)

## Contributing

Contributions are welcome! See the [GitHub repository](https://github.com/leeqy1996/QuantumCircuits.jl) for contribution guidelines.

## License

QuantumCircuits.jl is licensed under the GNU General Public License v3.0 (GPL-3.0).

## Citation

If you use QuantumCircuits.jl in your research, please cite:

```bibtex
@software{QuantumCircuits_jl,
  author = {Guo Chu and contributors},
  title = {QuantumCircuits.jl: A Julia package for quantum computing operations},
  year = {2024},
  url = {https://github.com/leeqy1996/QuantumCircuits.jl}
}
```