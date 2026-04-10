# Quantum Gates

```@meta
CurrentModule = QuantumCircuits
```

Quantum gates are the fundamental building blocks of quantum circuits. QuantumCircuits.jl provides a comprehensive library of quantum gates with support for parameterization and differentiation.

## Gate Types

The package defines an abstract type hierarchy for gates:

```@raw html
<div class="mermaid">
graph TD
    A[QuantumOperation] --> B[Gate]
    B --> C[ParametricGate]
    B --> D[QuantumGate]
    B --> E[AdjointQuantumGate]
    
    C --> C1[RxGate]
    C --> C2[RyGate]
    C --> C3[RzGate]
    C --> C4[PHASEGate]
    C --> C5[CRxGate]
    C --> C6[CRyGate]
    C --> C7[CRzGate]
    C --> C8[CPHASEGate]
    C --> C9[FSIMGate]
    C --> C10[CCPHASEGate]
    
    F[Non-parametric gates] --> F1[XGate]
    F --> F2[YGate]
    F --> F3[ZGate]
    F --> F4[HGate]
    F --> F5[SGate]
    F --> F6[TGate]
    F --> F7[sqrtXGate]
    F --> F8[sqrtYGate]
    F --> F9[SWAPGate]
    F --> F10[iSWAPGate]
    F --> F11[CZGate]
    F --> F12[CNOTGate]
    F --> F13[CONTROLGate]
    F --> F14[TOFFOLIGate]
    F --> F15[FREDKINGate]
    F --> F16[CONTROLCONTROLGate]
</div>
```

## Single-Qubit Gates

### Pauli Gates

```julia
# Pauli gates
x_gate = XGate(1)      # X gate on qubit 1
y_gate = YGate(2)      # Y gate on qubit 2  
z_gate = ZGate(3)      # Z gate on qubit 3

# Get matrix representation
x_matrix = mat(x_gate)  # 2×2 matrix [[0, 1], [1, 0]]
```

### Clifford Gates

```julia
# Hadamard gate
h_gate = HGate(1)      # H gate on qubit 1

# Phase gates
s_gate = SGate(2)      # S gate on qubit 2 (π/4 phase)
t_gate = TGate(3)      # T gate on qubit 3 (π/8 phase)

# Square root gates
sqrtx_gate = sqrtXGate(1)  # √X gate
sqrty_gate = sqrtYGate(2)  # √Y gate
```

### Parametric Single-Qubit Gates

```julia
# Rotation gates
rx_gate = RxGate(1, θ=π/4, isparas=true)  # Rx(π/4)
ry_gate = RyGate(2, θ=π/2, isparas=true)  # Ry(π/2)
rz_gate = RzGate(3, θ=π, isparas=true)    # Rz(π)

# PHASE gate
phase_gate = PHASEGate(1, θ=π/3, isparas=true)  # PHASE(π/3)
```

## Two-Qubit Gates

### Standard Two-Qubit Gates

```julia
# SWAP gate
swap_gate = SWAPGate(1, 2)  # Swap qubits 1 and 2

# iSWAP gate
iswap_gate = iSWAPGate(1, 2)  # iSWAP gate

# Controlled gates
cz_gate = CZGate(control=1, target=2)      # CZ gate
cnot_gate = CNOTGate(control=1, target=2)  # CNOT gate
control_gate = CONTROLGate(control=1, target=2, gate=XGate(1))  # General controlled gate
```

### Parametric Two-Qubit Gates

```julia
# Controlled rotation gates
crx_gate = CRxGate(control=1, target=2, θ=π/4, isparas=true)  # CRx(π/4)
cry_gate = CRyGate(control=1, target=2, θ=π/2, isparas=true)  # CRy(π/2)
crz_gate = CRzGate(control=1, target=2, θ=π, isparas=true)    # CRz(π)

# Controlled phase gate
cphase_gate = CPHASEGate(control=1, target=2, θ=π/3, isparas=true)  # CPHASE(π/3)

# FSIM gate (5-parameter)
fsim_gate = FSIMGate(1, 2, θ=π/4, φ=π/6, Δ1=0.1, Δ2=0.2, Δ3=0.3, isparas=true)
```

## Three-Qubit Gates

```julia
# Toffoli gate (CCNOT)
toffoli_gate = TOFFOLIGate(control1=1, control2=2, target=3)

# Fredkin gate (CSWAP)
fredkin_gate = FREDKINGate(control=1, target1=2, target2=3)

# Double-controlled gate
cccontrol_gate = CONTROLCONTROLGate(control1=1, control2=2, target=3, gate=XGate(3))

# Double-controlled phase gate
ccphase_gate = CCPHASEGate(control1=1, control2=2, target=3, θ=π/4, isparas=true)
```

## Generic Gates

```julia
# Create a custom gate from an arbitrary unitary matrix
using LinearAlgebra
custom_unitary = [1 0; 0 exp(im*π/4)]
custom_gate = QuantumGate(custom_unitary, [1])  # Gate acting on qubit 1

# Adjoint of a gate
adj_gate = AdjointQuantumGate(x_gate)  # X† gate
```

## Gate Properties and Operations

### Basic Properties

```julia
# Get gate information
nq = nqubits(gate)          # Number of qubits
pos = positions(gate)       # Qubit positions
gate_matrix = mat(gate)     # Matrix representation

# Ordered matrix (canonical qubit ordering)
ordered_matrix = ordered_mat(gate)

# Change qubit positions
new_gate = change_positions(gate, [3, 4])  # Move gate to qubits 3 and 4

# Shift positions
shifted_gate = shift(gate, 2)  # Add 2 to all position indices
```

### Parameter Management

```julia
# For parametric gates only
params = parameters(gate)            # Get parameter values
nparams = nparameters(gate)          # Number of parameters
active_params = active_parameters(gate)  # Indices of active parameters

# Activate/deactivate parameters
activate_parameter!(gate, 1)               # Activate first parameter
activate_parameters!(gate, [1, 2])         # Activate multiple parameters
deactivate_parameter!(gate, 1)             # Deactivate first parameter
deactivate_parameters!(gate, [1, 2])       # Deactivate multiple parameters
reset_parameters!(gate)                    # Reset to initial values
```

### Differentiation

```julia
# Compute derivative with respect to a parameter
# Only works for parametric gates with active parameters
derivative = differentiate(gate, 1)  # Derivative w.r.t. first parameter
```

## API Reference

```@docs
Gate
ParametricGate
QuantumGate
AdjointQuantumGate
gate
nqubits
positions
mat
ordered_mat
change_positions
shift
differentiate
parameters
nparameters
active_parameters
activate_parameter!
activate_parameters!
deactivate_parameter!
deactivate_parameters!
reset_parameters!
```

### Concrete Gate Types

```@docs
XGate
YGate
ZGate
HGate
SGate
TGate
sqrtXGate
sqrtYGate
SWAPGate
iSWAPGate
CZGate
CNOTGate
CONTROLGate
TOFFOLIGate
FREDKINGate
CONTROLCONTROLGate
RxGate
RyGate
RzGate
PHASEGate
CRxGate
CRyGate
CRzGate
CPHASEGate
FSIMGate
CCPHASEGate
```