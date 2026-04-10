# QuantumCircuits.jl

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Documentation](https://img.shields.io/badge/docs-latest-blue.svg)](https://leeqy1996.github.io/QuantumCircuits.jl/)
[![Julia](https://img.shields.io/badge/Julia-1.6%2B-purple.svg)](https://julialang.org/)

A Julia package for defining and manipulating quantum computing operations, including quantum gates, channels, circuits, and Hamiltonians.

## Overview

QuantumCircuits.jl provides a comprehensive framework for representing and working with quantum operations in Julia. It implements:

- **Quantum gates**: Single-qubit, two-qubit, and three-qubit gates with parameter support
- **Quantum channels**: Common noise models and generic quantum maps
- **Quantum circuits**: Composition of operations with measurement and post-selection
- **Qubit Hamiltonians**: Algebraic representation of many-body Hamiltonians

The package is designed for researchers and developers working on quantum algorithms, quantum simulation, and quantum information processing.

## Features

### Gate Operations
- **Single-qubit gates**: X, Y, Z, H, S, T, sqrtX, sqrtY
- **Parametric single-qubit gates**: Rx, Ry, Rz, PHASE (with parameter management)
- **Two-qubit gates**: SWAP, iSWAP, CZ, CNOT, CONTROL
- **Parametric two-qubit gates**: CRx, CRy, CRz, CPHASE, FSIM (5-parameter)
- **Three-qubit gates**: TOFFOLI, FREDKIN, double-controlled gates
- **Generic gates**: `QuantumGate` for arbitrary unitary matrices
- **Differentiation**: Support for differentiating parametric gates

### Quantum Channels
- **Generic quantum maps**: `QuantumMap` with Kraus operator representation
- **Predefined channels**: Amplitude damping, Phase damping, Depolarizing
- **Properties**: Trace-preserving verification

### Quantum Circuits
- **Circuit composition**: `QCircuit` for sequential operations
- **Measurement**: `QMeasure` for projective measurement
- **Post-selection**: `QSelect` for conditional operations
- **Parameter management**: Activate/deactivate parameters for optimization

### Qubit Hamiltonians
- **Term representation**: `QubitsTerm` for individual Hamiltonian terms
- **Operator algebra**: `QubitsOperator` for sums of terms (addition, scalar multiplication)
- **Matrix generation**: Convert to sparse/dense matrix representation
- **Simplification**: Combine like terms

### Core Functionality
- **Position-based addressing**: Specify qubit positions for all operations
- **Tensor operations**: Support for reordering and contracting qubit indices
- **Abstract type hierarchy**: `QuantumOperation` → `Gate`, `AbstractQuantumMap`, `QuantumCircuit`

## Installation

To install QuantumCircuits.jl from GitHub:

```julia
using Pkg
Pkg.add(url="https://github.com/leeqy1996/QuantumCircuits.jl")
```

Or add it to your project's `Project.toml`:

```toml
[deps]
QuantumCircuits = "aefa5731-75ce-4e77-8b64-9dbb49b79a07"
```

## Quick Start

### Basic Gate Operations

```julia
using QuantumCircuits

# Create single-qubit gates
x_gate = XGate(1)          # X gate on qubit 1
h_gate = HGate(2)          # H gate on qubit 2
rz_gate = RzGate(3, θ=π/4, isparas=true)  # Parametric Rz gate

# Create two-qubit gates
cnot = CNOTGate(control=1, target=2)  # CNOT with control 1, target 2
cz = CZGate(1, 2)                     # CZ gate between qubits 1 and 2

# Create three-qubit gates
toffoli = TOFFOLIGate(control1=1, control2=2, target=3)
```

### Building Circuits

```julia
# Create an empty circuit
circuit = QCircuit()

# Add gates to the circuit
push!(circuit, XGate(1))
push!(circuit, HGate(2))
push!(circuit, CNOTGate(1, 2))

# Create a parametric circuit
parametric_circuit = QCircuit()
push!(parametric_circuit, RxGate(1, θ=0.5, isparas=true))
push!(parametric_circuit, CRzGate(1, 2, θ=0.3, isparas=true))

# Activate parameters for optimization
activate_parameters!(parametric_circuit)
```

### Quantum Channels

```julia
# Create amplitude damping channel with γ=0.1 on qubit 1
ad_channel = AmplitudeDamping(1, γ=0.1)

# Create depolarizing channel with p=0.05 on qubit 2
depol_channel = Depolarizing(2, p=0.05)
```

### Qubit Hamiltonians

```julia
# Create individual Hamiltonian terms
term1 = QubitsTerm(Dict(1=>"X", 2=>"Z"), coeff=0.5)  # 0.5 * X₁ ⊗ Z₂
term2 = QubitsTerm(Dict(2=>"Y", 3=>"X"), coeff=-0.3) # -0.3 * Y₂ ⊗ X₃

# Combine terms into an operator
hamiltonian = QubitsOperator([term1, term2])

# Generate matrix representation for 3-qubit system
matrix_repr = matrix(hamiltonian, n=3)  # 8×8 sparse matrix
```

### Parameter Management

```julia
# Create parametric gate
gate = RxGate(1, θ=0.5, isparas=true)

# Check parameters
params = parameters(gate)      # Get parameter values
nparams = nparameters(gate)    # Get number of parameters
active = active_parameters(gate) # Get active parameter indices

# Activate/deactivate parameters
activate_parameter!(gate, 1)
deactivate_parameters!(gate, [1])
reset_parameters!(gate)        # Reset to initial values
```

## Documentation

Full documentation is available at [https://leeqy1996.github.io/QuantumCircuits.jl/](https://leeqy1996.github.io/QuantumCircuits.jl/).

The documentation includes:
- API reference for all exported functions and types
- Tutorials and examples
- Theory background for quantum operations
- Development guide for contributors

## API Reference

### Main Modules

- **`QuantumCircuits`**: Main module exporting all functionality
- **`QuantumCircuits.Gates`**: Gate operations and types
- **`QuantumCircuits.Channels`**: Quantum channels and maps
- **`QuantumCircuits.QubitHamiltonians`**: Hamiltonian algebra

### Key Types

| Type | Description |
|------|-------------|
| `Gate` | Abstract type for all quantum gates |
| `QuantumGate` | Generic gate with arbitrary unitary matrix |
| `ParametricGate` | Gate with tunable parameters |
| `AbstractQuantumMap` | Abstract type for quantum channels |
| `QuantumMap` | Generic quantum map with Kraus operators |
| `QCircuit` | Sequence of quantum operations |
| `QubitsTerm` | Single term in a qubit Hamiltonian |
| `QubitsOperator` | Sum of qubit Hamiltonian terms |

### Core Functions

#### Gate Operations
- `nqubits(gate)`: Number of qubits the gate acts on
- `positions(gate)`: Qubit positions
- `mat(gate)`: Matrix representation
- `ordered_mat(gate)`: Matrix with canonical qubit ordering
- `differentiate(gate, param_index)`: Derivative with respect to parameter

#### Parameter Management
- `parameters(gate)`: Get parameter values
- `nparameters(gate)`: Number of parameters
- `activate_parameter!(gate, idx)`: Activate parameter for optimization
- `deactivate_parameter!(gate, idx)`: Deactivate parameter
- `reset_parameters!(gate)`: Reset parameters to initial values

#### Quantum Channels
- `ordered_supermat(channel)`: Superoperator matrix representation
- `kraus_matrices(channel)`: Kraus operator representation
- `is_tp(channel)`: Check if channel is trace-preserving

#### Circuits
- `push!(circuit, operation)`: Add operation to circuit
- `append!(circuit1, circuit2)`: Append circuits

#### Hamiltonians
- `matrix(operator, n)`: Generate matrix representation for n-qubit system
- `simplify(operator)`: Combine like terms in operator
- `oplist(term)`: Get operator list for term
- `coeff(term)`: Get coefficient of term

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Setup

```bash
git clone https://github.com/leeqy1996/QuantumCircuits.jl.git
cd QuantumCircuits.jl
julia --project=.
```

### Testing

Run the test suite:

```julia
using Pkg
Pkg.test("QuantumCircuits")
```

### Code Style

- Follow Julia style guide (https://docs.julialang.org/en/v1/manual/style-guide/)
- Use meaningful variable and function names
- Add docstrings for exported functions
- Include tests for new functionality

## License

QuantumCircuits.jl is licensed under the GNU General Public License v3.0 (GPL-3.0). See the [LICENSE](LICENSE) file for details.

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

## Acknowledgments

- Built with the Julia programming language
- Uses TensorOperations.jl for tensor contractions
- Inspired by quantum computing libraries such as Qiskit, Cirq, and ProjectQ

## Contact

For questions, issues, or feature requests:
- Open an issue on [GitHub](https://github.com/leeqy1996/QuantumCircuits.jl/issues)
- Contact the maintainer: Guo Chu <guochu604b@gmail.com>