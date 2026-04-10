# API Reference

```@meta
CurrentModule = QuantumCircuits
```

Complete API reference for QuantumCircuits.jl. This page documents all exported functions and types.

## Exports

### Modules

```@docs
QuantumCircuits
QuantumCircuits.Gates
QuantumCircuits.Channels
```

## Type Hierarchy

### Abstract Types

```@docs
QuantumOperation
Gate
ParametricGate
AbstractQuantumMap
```

### Concrete Types

#### Gates

```@docs
QuantumGate
AdjointQuantumGate
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

#### Channels

```@docs
QuantumMap
AmplitudeDamping
PhaseDamping
Depolarizing
```

#### Circuits

```@docs
QCircuit
QMeasure
QSelect
```

#### Hamiltonians

```@docs
QubitsTerm
QubitsOperator
```

## Gate Functions

### Basic Properties

```@docs
nqubits
positions
mat
ordered_mat
change_positions
shift
```

### Parameter Management

```@docs
parameters
nparameters
active_parameters
activate_parameter!
activate_parameters!
deactivate_parameter!
deactivate_parameters!
reset_parameters!
```

### Differentiation

```@docs
differentiate
```

## Channel Functions

```@docs
ordered_supermat
kraus_matrices
is_tp
```

## Circuit Functions

### Circuit Operations

```@docs
Base.push!(::QCircuit, ::QuantumOperation)
Base.append!(::QCircuit, ::QCircuit)
Base.length(::QCircuit)
Base.iterate(::QCircuit)
Base.getindex(::QCircuit, ::Int)
```

### Parameter Management

```@docs
activate_parameters!(::QCircuit)
reset_parameters!(::QCircuit)
```

## Hamiltonian Functions

### Term Operations

```@docs
oplist
coeff
```

### Operator Operations

```@docs
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

## Index

```@index
```