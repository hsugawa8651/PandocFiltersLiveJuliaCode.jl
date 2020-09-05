using PandocFiltersLiveJuliaCode
using Documenter

makedocs(;
    modules=[PandocFiltersLiveJuliaCode],
    authors="Hiroharu Sugawara <hsugawa@gmail.com> and contributors",
    repo="https://github.com/hsugawa8651/PandocFiltersLiveJuliaCode.jl/blob/{commit}{path}#L{line}",
    sitename="PandocFiltersLiveJuliaCode.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://hsugawa8651.github.io/PandocFiltersLiveJuliaCode.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/hsugawa8651/PandocFiltersLiveJuliaCode.jl",
)
