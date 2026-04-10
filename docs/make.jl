using Documenter
using QuantumCircuits

# Setup Documenter
makedocs(
    sitename = "QuantumCircuits.jl",
    authors = "Guo Chu and contributors",
    repo = "https://github.com/leeqy1996/QuantumCircuits.jl/blob/{commit}{path}#{line}",
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://leeqy1996.github.io/QuantumCircuits.jl",
        assets = ["assets/favicon.ico"],
        sidebar_sitename = false,
        collapselevel = 1,
    ),
    pages = [
        "Home" => "index.md",
        "Gates" => "gates.md",
        "Channels" => "channels.md",
        "Circuits" => "circuits.md",
        "Hamiltonians" => "hamiltonians.md",
        "API Reference" => "api.md",
    ],
    modules = [QuantumCircuits],
    strict = false,
    checkdocs = :none,
    linkcheck = false,
)

# Deploy documentation to GitHub pages
deploydocs(
    repo = "github.com/leeqy1996/QuantumCircuits.jl",
    devbranch = "master",
    push_preview = true,
)